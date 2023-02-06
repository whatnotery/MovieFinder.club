require "rails_helper"

describe '.get_latest_film_id' do
  it 'returns the id of the latest film' do
    allow(HTTP).to receive(:get).and_return(double(status: 200, parse: { 'id' => 123 }))
    expect(Film.get_latest_film_id).to eq(123)
  end

  it 'returns nil if the response status is not 200' do
    allow(HTTP).to receive(:get).and_return(double(status: 500, parse: {}))
    expect(Film.get_latest_film_id).to be_nil
  end
end

describe '.get_random_film' do
  let(:response) { double(status: 200, parse: { 'id' => 123, "adult" => false,
    "title" => "The Shawshank Redemption",
    "poster_path" => "/9O7gLzmreU0nGkIB6K3BsJbzvNv.jpg",
    "overview" => "Two imprisoned men bond over a number of years, finding solace and eventual redemption through acts of common decency.",
    "imdb_id" => "tt0111161" }) }

  before do
    allow(Film).to receive(:get_latest_film_id).and_return(456)
    allow(HTTP).to receive(:get).and_return(response)
  end

  it 'returns a random film' do
    allow(Film).to receive(:rand).with(456).and_return(123)
    expect(Film.get_random_film).to eq({ 'id' => 123, "adult" => false,
      "title" => "The Shawshank Redemption",
      "poster_path" => "/9O7gLzmreU0nGkIB6K3BsJbzvNv.jpg",
      "overview" => "Two imprisoned men bond over a number of years, finding solace and eventual redemption through acts of common decency.",
      "imdb_id" => "tt0111161" })
  end

  it 'retries the request if the response is nil' do
    allow(HTTP).to receive(:get).and_return(double(status: 200, parse: nil))
    expect(Film).to receive(:get_random_film)
    Film.get_random_film
  end

  it 'retries the request if the film is invalid' do
    allow(Film).to receive(:movie_valid?).and_return(false)
    expect(Film).to receive(:get_random_film)
    Film.get_random_film
  end

  it 'retries the request if the genre is invalid' do
    allow(Film).to receive(:genre_valid?).and_return(false)
    expect(Film).to receive(:get_random_film)
    Film.get_random_film('Action')
  end
end

describe ".movie_valid?" do
    context "with valid movie data" do
      let(:valid_movie_data) do
        {
          "adult" => false,
          "title" => "The Shawshank Redemption",
          "poster_path" => "/9O7gLzmreU0nGkIB6K3BsJbzvNv.jpg",
          "overview" => "Two imprisoned men bond over a number of years, finding solace and eventual redemption through acts of common decency.",
          "imdb_id" => "tt0111161"
        }
      end
  
      it "returns true" do
        expect(Film.movie_valid?(valid_movie_data)).to be true
      end
    end
  
    context "with invalid movie data" do
      let(:invalid_movie_data) do
        {
          "adult" => true,
          "title" => "",
          "poster_path" => "",
          "overview" => "",
          "imdb_id" => ""
        }
      end
  
      it "returns false" do
        expect(Film.movie_valid?(invalid_movie_data)).to be false
      end
    end
  end
  
  describe ".genre_valid?" do
    context "with valid genre data" do
      let(:valid_genre_data) do
        {
          "genres" => [
            { "name" => "Drama" }
          ]
        }
      end
  
      it "returns true when genre is not specified" do
        expect(Film.genre_valid?(valid_genre_data)).to be true
      end
  
      it "returns true when genre is specified and matches" do
        expect(Film.genre_valid?(valid_genre_data, "Drama")).to be true
      end
    end
  
    context "with invalid genre data" do
      let(:invalid_genre_data) do
        {
          "genres" => []
        }
      end
  
      it "returns false when genre data is missing" do
        expect(Film.genre_valid?(invalid_genre_data, "Action")).to be false
      end
  
      it "returns false when genre does not match" do
        expect(Film.genre_valid?(invalid_genre_data, "Action")).to be false
      end
    end
  end

  describe '.twiml' do
    context 'when params are nil' do
      it 'returns a Twilio::TwiML::MessagingResponse object with random film data' do
        allow(Film).to receive(:get_random_film).and_return({
          'title' => 'Test Film',
          'release_date' => '2022-01-01',
          'genres' => [{ 'name' => 'Action' }],
          'overview' => 'Test film overview',
          'poster_path' => 'test/poster.jpg',
          'imdb_id' => 'tt1234567'
        })

        twiml = Film.twiml

        expect(twiml).to be_a(Twilio::TwiML::MessagingResponse)
        expect(twiml.to_s).to include('Test Film (2022) ["Action"]')
        expect(twiml.to_s).to include('Test film overview')
        expect(twiml.to_s).to include('https://www.imdb.com/title/tt1234567')
      end
    end

    context 'when params are present' do
      it 'returns a Twilio::TwiML::MessagingResponse object with random film data from the specified genre' do
        allow(Film).to receive(:genre_param_valid?).with('Action').and_return(true)
        allow(Film).to receive(:get_random_film).with('Action').and_return({
          'title' => 'Test Film',
          'release_date' => '2022-01-01',
          'genres' => [{ 'name' => 'Action' }],
          'overview' => 'Test film overview',
          'poster_path' => 'test/poster.jpg',
          'imdb_id' => 'tt1234567'
        })

        twiml = Film.twiml('Action')

        expect(twiml).to be_a(Twilio::TwiML::MessagingResponse)
        expect(twiml.to_s).to include('Test Film (2022) ["Action"]')
        expect(twiml.to_s).to include('Test film overview')
        expect(twiml.to_s).to include('https://www.imdb.com/title/tt1234567')
      end
    end
  end