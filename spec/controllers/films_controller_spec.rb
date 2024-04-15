require "rails_helper"

RSpec.describe FilmsController, type: :controller do
  describe "GET #index" do
    context "with no genre specified" do
      it "returns a random film" do
        get :index

        expect(response).to have_http_status(200)
        expect(response.content_type).to eq("application/json; charset=utf-8")
        expect(response.body.to_s).to include("title")
        expect(response.body.to_s).to include("overview")
        expect(response.body.to_s).to include("poster_path")
        expect(response.body.to_s).to include("imdb_id")
        expect(response.body.to_s).to include('"adult":false')
      end
    end

    context "with genre specified" do
      it "returns a random film of the specified genre" do
        get :index, params: {genre: "Action"}

        expect(response).to have_http_status(200)
        expect(response.content_type).to eq("application/json; charset=utf-8")
        expect(response.body.to_s).to include("title")
        expect(response.body.to_s).to include("overview")
        expect(response.body.to_s).to include("poster_path")
        expect(response.body.to_s).to include("imdb_id")
        expect(response.body.to_s).to include('"adult":false')
        expect(response.body.to_s).to include('"genres":[{"id":28,"name":"Action"}')
      end
    end
  end

  describe "GET #twilio" do
    context "with valid 'Movie' request" do
      it "returns a TwiML response with a random film" do
        get :twilio, params: {"Body" => "Movie"}

        expect(response).to have_http_status(200)
        expect(response.content_type).to eq("application/xml; charset=utf-8")
      end
    end

    context "with valid 'Movie:Genre' request" do
      it "returns a TwiML response with a random film of the specified genre" do
        get :twilio, params: {"Body" => "Movie:Action"}

        expect(response).to have_http_status(200)
        expect(response.content_type).to eq("application/xml; charset=utf-8")
        expect(response.body.to_s).to include('["Action"]')
      end
    end

    context "with invalid request" do
      it "returns a TwiML error response" do
        get :twilio, params: {"Body" => "invalid request"}

        expect(response).to have_http_status(200)
        expect(response.content_type).to eq("application/xml; charset=utf-8")
        expect(response.body.to_s).to include("Please use the syntax 'Movie'")
      end
    end
  end
end
