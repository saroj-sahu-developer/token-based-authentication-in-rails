class HomeController < ApplicationController
  def index
    render json: {message: "You are inside the application."}
  end
end
