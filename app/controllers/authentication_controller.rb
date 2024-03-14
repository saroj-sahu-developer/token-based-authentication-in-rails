class AuthenticationController < ApplicationController
  skip_before_action :authorize_request

  def register
    @user = User.new(user_params)
    if @user.save
      token = JsonWebToken.encode(user_id: @user.id)
      time = Time.now + 24.hours.to_i
      render json:  {
                      message: "User logged in successfully",
                      token: token,
                      valid_till: time.strftime("%m-%d-%Y %H:%M"),
                    },
                    status: :ok
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def login
    @user = User.find_by_email(params[:email])
    if @user&.authenticate(params[:password])
      token = JsonWebToken.encode(user_id: @user.id)
      time = Time.now + 24.hours.to_i
      render json:  {
                      message: "User logged in successfully",
                      token: token,
                      valid_till: time.strftime("%m-%d-%Y %H:%M"),
                    },
                    status: :ok
    else
      render json: { error: 'unauthorized' }, status: :unauthorized
    end
  end

  private
  def user_params
    params.permit(:name, :email, :password, :password_confirmation)
  end
end
