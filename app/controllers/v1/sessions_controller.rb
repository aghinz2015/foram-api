module V1
  class SessionsController < ApplicationController
    skip_before_action :authenticate_user!, only: :create

    def create
      user = User.where(email: create_params[:email]).first

      if user && user.authenticate(create_params[:password])
        Authentication.new(user.email, user.authentication_token).cache_token
        render json: user, serializer: Users::SessionSerializer, status: :created
      else
        render json: { error: 'Email or password is incorrect' }, status: :forbidden
      end
    end

    def destroy
      current_user.change_authentication_token
      Authentication.new(current_user.email, current_user.authentication_token)
                    .invalidate_token_cache
      @current_user_email = nil

      head :ok
    end

    private

    def create_params
      params.require(:user).permit(:email, :password)
    end
  end
end
