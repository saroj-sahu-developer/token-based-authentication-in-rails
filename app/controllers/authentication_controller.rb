class AuthenticationController < ApplicationController
  skip_before_action :authenticate_user, except: [:logout]

  def register
    user = User.new(user_params)

    # Generate a authentication token
    authentication_token = SecureRandom.hex
    while User.exists?(authentication_token: authentication_token)
      authentication_token = SecureRandom.hex
    end

    user.authentication_token = authentication_token

    if user.save
      render json:  {
                      message: 'User registered successfully',
                      token: user.authentication_token
                    },
                    status: :created
    else
      render json: { error: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def login
    user = User.find_by(email: params[:email])
    if user&.authenticate(params[:password])
      # Generate a authentication token
      authentication_token = SecureRandom.hex
      while User.exists?(authentication_token: authentication_token)
        authentication_token = SecureRandom.hex
      end

      user.update!(authentication_token: authentication_token)
      # Only one login allowed for a single user

      render json:  {
                      message: 'User logged in successfully',
                      token: authentication_token
                    },
                    status: :ok
    else
      render json: { error: 'Invalid email or password' }, status: :unauthorized
    end
  end

  def logout
    current_user.update!(authentication_token: nil)
    render json: { message: 'Logged out successfully' }
  end

  private
  def user_params
    params.permit(:name, :email, :password, :password_confirmation)
  end
end
