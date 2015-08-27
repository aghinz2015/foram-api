module V1::Users
  class SessionsController < ApplicationController
    before_action :authenticate_user!, except: :create

    def create
      user = User.find_by(email: create_params[:email])

      if user && user.authenticate(create_params[:password])
        @current_user = user #TODO think about changing to self.current_user
        render json: user, serializer: Sessions::UserSerializer, status: :created
      else
        head :forbidden
      end
    end

    def destroy
      @current_user.generate_authentication_token
      remove_instance_variable(:@current_user) if @current_user

      head :ok
    end

    private

    def create_params
      params.require(:user).permit(:email, :password)
    end
  end
end
