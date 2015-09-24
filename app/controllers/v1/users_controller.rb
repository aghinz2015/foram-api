module V1
  class UsersController < ApplicationController
    before_action :authenticate_user!, except: :create

    def create
      user = User.new(user_params)
      if user.save
        render json: user, serializer: Users::SessionSerializer, status: :created
      else
        render json: user.errors, status: :unprocessable_entity
      end
    end

    def update
      if current_user.update(user_params)
        render json: current_user
      else
        render json: current_user.errors, status: :unprocessable_entity
      end
    end

    def destroy
      if current_user.authenticate(params[:password])
        current_user.destroy
        head :no_content
      else
        head :forbidden
      end
    end

    private

    def user_params
      params.require(:user).permit(:email, :username, :password,
                                   :password_confirmation)
    end
  end
end
