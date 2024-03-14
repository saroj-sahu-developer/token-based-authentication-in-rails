class HomeController < ApplicationController
  def index
    render json: {message: "Hi, #{current_user.email}, You are inside the application."}
  end
end
