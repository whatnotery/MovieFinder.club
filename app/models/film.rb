class Film < ApplicationRecord
    has_many :reviews
    has_many :likes
    has_many :liked_by_users, through: :likes, source: :user

    validates :mdb_id, uniqueness: true

    def self.get_random_film(genre = nil, year = nil)
        query = {
            sort_by: "popularity.desc",
            include_adult: false,
            include_video: false,
            page: rand(500)
        }
        query[:primary_release_year] = year if year
        query[:with_genres] = genre_id_lookup(genre) if genre
        
        film_results = Tmdb::Discover.movie(query).results.sample
        unless film_results.present? && movie_valid?(film_results)
            get_random_film(genre, year)
        else
            film_json = film_results.as_json["table"]
            find_or_create_film(film_json)
        end
    end

    def self.search(query)
        if Film.where(title: query.titleize).present?
           Film.where(title: query.titleize).map { |film| with_providers_and_trailer(film) } 
        else
            Tmdb::Search.movie(query.titleize).table[:results].map{ |film| find_or_create_film(film.table.as_json) if movie_valid?(film.table.as_json)}.compact
        end
    end

    def self.find_or_create_film(film_json)
        unless Film.find_by(mdb_id: film_json["id"])
            film = Film.create(
                mdb_id: film_json["id"],
                title: film_json["title"].titleize, 
                year: film_json["release_date"].slice(0, 4), 
                plot: film_json["overview"],
                poster: film_json["poster_path"],
                genres: film_json["genre_ids"]
                )
        else
            film = Film.find_by(mdb_id: film_json["id"])
        end
        with_providers_and_trailer(film)
    end


    def self.get_watch_providers(movie_id, country_code = "US")
    api_key = ENV['MOVIE_DB_API_KEY'] # replace with your own TMDb API key
    base_url = "https://api.themoviedb.org/3/movie/#{movie_id}/watch/providers"

    # Build the query parameters
    query_params = {
        api_key: api_key,
        country: country_code
    }

    # Make the API request and parse the response JSON
    response = HTTP.get(base_url, params: query_params)
    response_body = response.parse if response.status == 200
    # Get the results for the specified country code
    country_results = response_body["results"][country_code] unless response_body["results"].blank?
    # Extract the available providers from the results
    if country_results
        providers = {}
        providers["streaming_providers"] = country_results["flatrate"].map { |provider| provider["provider_name"] } unless country_results["flatrate"].nil?
        providers["rental_providers"] = country_results["buy"].map { |provider| provider["provider_name"] } unless  country_results["buy"].nil?

    else
        providers = nil
    end
         providers
    end 

    def self.parse_providers(providers)
        return  "Not available to stream or rent in your region." unless providers["streaming_providers"].present? || providers["rental_providers"].present?
        parse_array = []
        parse_array << "Available to stream on the following services: " + providers["streaming_providers"].each(&:to_s).join(", ") + "." if providers["streaming_providers"].present?
        parse_array << "Available to rent/buy on the following services: " + providers["rental_providers"].each(&:to_s).join(", ") + "." if providers["rental_providers"].present?
        parse_array.join(" ")
    end

   def self.with_providers_and_trailer(film)
        film = film.as_json
        youtube_link = {"youtube_link": "https://www.youtube.com/results?search_query=#{film['title'].split(' ').join('+')}+#{film["year"]}+trailer"}.as_json
        watch_providers = get_watch_providers(film["mdb_id"] || film["id"])
        if watch_providers
            film.merge(youtube_link).merge(watch_providers) 
        else
            film.merge(youtube_link)
        end
   end

    def self.movie_valid?(film)
        film["title"].present? && film["poster_path"].present? &&
        film["overview"].present? && film["release_date"].present?
    end

    def self.genre_param_valid?(genre)
        genre_list = [
            'Action', 
            'Adventure', 
            'Animation', 
            'Comedy', 
            'Crime', 
            'Documentary', 
            'Drama', 
            'Family', 
            'Fantasy', 
            'History', 
            'Horror', 
            'Music', 
            'Mystery', 
            'Romance', 
            'Science Fiction', 
            'Thriller', 
            'War', 
            'Western'
        ]
        genre_list.include?(genre.try(:titleize)) || genre == nil
    end

    def self.year_param_valid?(year)
        (1900..Date.today.year).to_a.include?(year.to_i) || year == nil
    end
    
    def self.param_array(body)
        body.downcase.split(/\s|:/)
    end

    def self.get_random_film_args(param_array)
        hash = {}
        param_array.include?('year') ? hash['year'] = param_array[param_array.index('year') + 1] : hash['year'] = nil;
        param_array.include?('genre') ? hash['genre'] = param_array[param_array.index('genre') + 1] : hash['genre'] = nil;
        hash
    end

    def self.genre_array_to_list(array)
        array.map{ |genre_id| genre_from_id_lookup(genre_id)}.compact
    end

    def self.genre_id_lookup(genre_name) 
        genre_lookup = {
            "Action": 28,
            "Adventure": 12,
            "Animation": 16,
            "Comedy": 35,
            "Crime": 80,
            "Documentary": 99,
            "Drama": 18,
            "Family": 10751,
            "Fantasy": 14,
            "History": 36,
            "Horror": 27,
            "Music": 10402,
            "Mystery": 9648,
            "Romance": 10749,
            "Science Fiction": 878,
            "Thriller": 53,
            "War": 10752,
            "Western": 37
        }
        genre_lookup[:"#{genre_name.titleize}"]
    end

    def self.genre_from_id_lookup(id)
        id_lookup = {
            "12": "Adventure",
            "14": "Fantasy",
            "16": "Animation",
            "18": "Drama",
            "27": "Horror",
            "28": "Action",
            "35": "Comedy",
            "36": "History",
            "37": "Western",
            "53": "Thriller",
            "80": "Crime",
            "99": "Documentary",
            "878": "Science Fiction",
            "9648": "Mystery",
            "10402": "Music",
            "10749": "Romance",
            "10751": "Family",
            "10752": "War"
        }
        id_lookup[:"#{id.to_s}"]
    end

    def self.twiml(films)
        twiml = Twilio::TwiML::MessagingResponse.new do |r|
            films.each do |film|
                r.message body: "#{film['title']} (#{film['year']}) #{film['genres'].any? ? genre_array_to_list(film['genres']) : ''} \n -------- \n #{film['plot']}"
                r.message body: "#{film['youtube_link']}"
                (r.message body: "#{parse_providers({"streaming_providers": film["streaming_providers"], "rental_providers": film["rental_providers"]}.as_json)}") if (film["rental_providers"] || film["streaming_providers"])
            end
        end
    end

    def self.twiml_error()
        twiml = Twilio::TwiML::MessagingResponse.new do |r|
            r.message body: 'Welcome to movie.sms'
            r.message body: "use the syntax 'Movie' for a completely random film \n use 'Movie Genre:Action' for a random film from a selected genre \n use 'Movie Year:1999' for a random film from a selected year \n use'Movie Genre:Horror Year:1982' for a film from that year and genre \n Allowable genres are Action, Adventure, Animation, Comedy, Crime, Documentary, Drama, Family, Fantasy, History, Horror, Music, Mystery, Romance, Thriller, War, and Western"
        end
    end
end

