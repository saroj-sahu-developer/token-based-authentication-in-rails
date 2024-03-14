class ApplicationController < ActionController::API
  before_action :authenticate_user

  private
  def authenticate_user
    token = request.headers['Authorization']&.split(' ')&.last
    if token.nil?
      return render json: { error: 'Unauthorized' }, status: :unauthorized
    end

    @current_user = User.find_by(authentication_token: token)

    unless current_user
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end
end
