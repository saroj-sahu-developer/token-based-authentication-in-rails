class ApplicationController < ActionController::API
  before_action :authenticate_user

  protected
  def current_user
    token = request.headers['Authorization']&.split(' ')&.last
    user = User.find_by(authentication_token: token)
  end

  private
  def authenticate_user
    token = request.headers['Authorization']&.split(' ')&.last
    user = User.find_by(authentication_token: token)
    unless user
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end
end
