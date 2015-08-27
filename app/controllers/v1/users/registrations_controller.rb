module V1::Users
  class RegistrationsController < ApplicationController
    before_action :authenticate_user!, except: :create

    def create
      user = User.new(create_params)

      if user.save
        @current_user = user
        render json: user, serializer: Sessions::UserSerializer, status: :created
      else
        render json: user.errors, status: :unprocesable_entity
      end
    end

    def destroy
      if @current_user.authenticate(params[:password])
        @current_user.destroy
        head :no_content
      else
        head :forbidden
      end
    end

    private

    def create_params
      params.require(:user).permit(:email, :username, :password,
                                   :password_confirmation)
    end
  end
end
