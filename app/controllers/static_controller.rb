class StaticController < ApplicationController
  before_action :authenticate_user!, only: [:random_film]

  def home
    render inertia: "pages/Home"
  end

  def random_film
    render inertia: "pages/Film", props: {filmData: Film.get_random_film, user: current_user}
  end
end
