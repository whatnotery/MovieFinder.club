class StaticController < ApplicationController
    def home
      render inertia: "pages/Home", props: {name: "jos"}

    end
  end