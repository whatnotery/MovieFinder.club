class FilmsController < ApplicationController
    require 'http'
    
    def get_latest_film_id
        response = HTTP.get('https://api.themoviedb.org/3/movie/latest', :params => {:api_key => 'b07d3efad9e75e49c88e831539462c48'})
        response.parse['id'] if response.status == 200
    end

    def index
        movie_id = rand(get_latest_film_id);
        response = HTTP.get("https://api.themoviedb.org/3/movie/#{movie_id}", :params => {:api_key => 'b07d3efad9e75e49c88e831539462c48'})
        data = response.parse if response.status == 200
        if data["adult"] == true || !data['title'] || !data['poster_path'] || !data['overview']
            index
        else
            render data.to_json
        end
    end
end