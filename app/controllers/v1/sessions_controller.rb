module V1
  class SessionsController < ApplicationController
    before_action :authenticate_user!, except: :create

    def create
      user = User.where(email: create_params[:email]).first

      if user && user.authenticate(create_params[:password])
        render json: user, serializer: Users::SessionSerializer, status: :created
      else
        render json: { error: 'Email or password is incorrect' }, status: :forbidden
      end
    end

    def destroy
      @current_user.change_authentication_token
      @current_user = nil

      head :ok
    end

    private

    def create_params
      params.require(:user).permit(:email, :password)
    end
  end
end
