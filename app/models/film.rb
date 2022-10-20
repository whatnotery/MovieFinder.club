class Film < ApplicationRecord
    require 'http'

    def self.get_latest_film_id
        response = HTTP.get('https://api.themoviedb.org/3/movie/latest', :params => {:api_key => ENV['MOVIE_DB_API_KEY']
            })
        response.parse['id'] if response.status == 200
    end

    def self.get_random_film(*genre)
        movie_id = rand(get_latest_film_id);
        response = HTTP.get("https://api.themoviedb.org/3/movie/#{movie_id}", :params => {:api_key => ENV['MOVIE_DB_API_KEY']})
        data = response.parse if response.status == 200
        if !genre.empty?
            if !data['genres'].empty? and data['genres'][0]['name'] == genre[0].capitalize and data["adult"] == false or !data['title'].blank? or !data['poster_path'].blank? or !data['overview'].blank? or !data['tagline'].blank?  
                data
            else
                get_random_film(genre[0].capitalize) 
            end
        else
            get_random_film()
        end
    end
end
