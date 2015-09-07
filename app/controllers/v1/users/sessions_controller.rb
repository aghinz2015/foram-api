module V1::Users
  class SessionsController < ApplicationController
    before_action :authenticate_user!, except: :create

    def create
      user = User.find_by(email: create_params[:email])

      if user && user.authenticate(create_params[:password])
        render json: user, serializer: Sessions::UserSerializer, status: :created
      else
        head :forbidden
      end
    end

    def destroy
      @current_user.generate_authentication_token
      @current_user = nil

      head :ok
    end

    private

    def create_params
      params.require(:user).permit(:email, :password)
    end
  end
end
