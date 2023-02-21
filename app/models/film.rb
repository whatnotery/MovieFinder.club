class Film < ApplicationRecord
    require 'http'
    require 'twilio-ruby'

    def self.get_random_film(genre = nil, year = nil)
        api_key = ENV['MOVIE_DB_API_KEY'] # replace with your own TMDb API key
        base_url = "https://api.themoviedb.org/3/discover/movie"
        random_page_number = rand(100)
        # Build the query parameters based on the optional arguments
        query_params = {
            api_key: api_key,
            sort_by: "popularity.desc",
            include_adult: false,
            include_video: false,
            page: random_page_number
        }
        query_params[:primary_release_year] = year if year
        query_params[:with_genres] = genre_id_lookup(genre) if genre
        # Make the API request and parse the response JSON
        response = HTTP.get(base_url, params: query_params)
        response_body = response.parse if response.status == 200
        # Get a random film from the results
        films = response_body["results"]
        random_film = films.sample
        # Return the random film as a hash with relevant details
        if random_film.nil? or !movie_valid?(random_film)
            get_random_film(genre, year)
        else
            random_film
        end
    end

    def self.get_watch_providers(movie_id, country_code)
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
    byebug
    # Get the results for the specified country code
    country_results = response_body["results"][country_code] if !response_body["results"].nil?

    # Extract the available providers from the results
    if country_results && country_results["flatrate"]
        providers = country_results["flatrate"].map { |provider| provider["provider_name"] }
    else
        providers = nil
    end

    # Return the list of available providers
    return providers
    end 

    def self.movie_valid?(data) 
        !data["title"].blank? and
        !data['poster_path'].blank? and
        !data['overview'].blank? and
        !data['release_date'].blank?
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
        genre_list.include?(genre.try(:titleize)) or genre == nil
    end

    def self.year_param_valid?(year)
        (1900..Date.today.year).to_a.include?(year.to_i) or year == nil
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

    def self.twiml(genre = nil, year = nil)
        if genre.nil? && year.nil?
            data = get_random_film()
        elsif genre_param_valid?(genre) && year.nil?
            data = get_random_film(genre)
        elsif genre.nil? && !year.nil? 
            data = get_random_film(genre, year)
        elsif !genre.nil? && !year.nil?
            data = get_random_film(genre, year)
        end
        twiml = Twilio::TwiML::MessagingResponse.new do |r|
            r.message body: "#{data['title']} (#{data['release_date'].slice(0, 4)}) #{genre ? [genre] : ''} \n -------- \n #{data['overview']}"

        end
    end

    def self.twiml_error()
        twiml = Twilio::TwiML::MessagingResponse.new do |r|
            r.message body: "use the syntax 'Movie' for a completely random film \n
            use 'Movie Genre:Action' for a random film from a selected genre \n
            use 'Movie Year:1999' for a random film from a selected year \n
            use'Movie Genre:Horror Year:1982' for a film from that year and genre \n
            Allowable genres are Action, Adventure, Animation, Comedy, Crime, Documentary, Drama, Family, Fantasy, History, Horror, Music, Mystery, Romance, Thriller, War, and Western"
        end
    end
end

