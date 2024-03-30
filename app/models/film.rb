class Film < ApplicationRecord
    require 'http'
    require 'twilio-ruby'

    def self.get_random_film(genre = nil, year = nil)
        query = {
            sort_by: "popularity.desc",
            include_adult: false,
            include_video: false,
            page: rand(500)
        }
        query[:primary_release_year] = year if year
        query[:with_genres] = genre_id_lookup(genre) if genre
        
        film = Tmdb::Discover.movie(query).results.sample
        unless film.present? && movie_valid?(film)
            get_random_film(genre, year)
        else
            film_json = film.as_json["table"]
            youtube_link = {"youtube_link": "https://www.youtube.com/results?search_query=#{film_json['title'].split(' ').join('+')}+#{film_json['release_date'].slice(0, 4)}+trailer"}.as_json
            watch_providers = get_watch_providers(film_json["id"])
            film_json.merge(youtube_link)
            film_json.merge(youtube_link).merge(watch_providers) if watch_providers
        end
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
    country_results = response_body["results"][country_code] unless response_body["results"].nil?
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
        return  "Not available to stream or rent in your region." if providers.nil?
        parse_array = []
        parse_array << "Available to stream on the following services: " + providers["streaming_providers"].each(&:to_s).join(", ") + "." if providers["streaming_providers"].present?
        parse_array << "Available to rent/buy on the following services: " + providers["rental_providers"].each(&:to_s).join(", ") + "." if providers["rental_providers"].present?
        parse_array.join(" ")
    end

    def self.movie_valid?(film)
        film.title.present? && film.poster_path.present? &&
        film.overview.present? && film.release_date.present?
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

    def self.twiml(genre = nil, year = nil, country = nil)
        if genre.nil? && year.nil?
            data = get_random_film()
        elsif genre_param_valid?(genre) && year.nil?
            data = get_random_film(genre)
        elsif genre.nil? && !year.nil? 
            data = get_random_film(genre, year)
        elsif !genre.nil? && !year.nil?
            data = get_random_film(genre, year)
        end
        provider_message = parse_providers(get_watch_providers(data["id"]))

        twiml = Twilio::TwiML::MessagingResponse.new do |r|
            r.message body: "#{data['title']} (#{data['release_date'].slice(0, 4)}) #{genre ? [genre] : ''} \n -------- \n #{data['overview']}"
            r.message body: "https://www.youtube.com/results?search_query=#{data['title'].gsub!(/[^0-9A-Za-z]/, ' ').split(' ').join('+')}+#{data['release_date'].slice(0, 4)}+trailer"
            r.message body: "#{provider_message}"
        end
    end

    def self.twiml_error()
        twiml = Twilio::TwiML::MessagingResponse.new do |r|
            r.message body: 'Welcome to movie.sms'
            r.message body: "use the syntax 'Movie' for a completely random film \n use 'Movie Genre:Action' for a random film from a selected genre \n use 'Movie Year:1999' for a random film from a selected year \n use'Movie Genre:Horror Year:1982' for a film from that year and genre \n Allowable genres are Action, Adventure, Animation, Comedy, Crime, Documentary, Drama, Family, Fantasy, History, Horror, Music, Mystery, Romance, Thriller, War, and Western"
        end
    end
end

