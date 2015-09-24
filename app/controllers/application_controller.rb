class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Token

  protected

  def authenticate_user!
    token_and_options = token_and_options(request)
    return unauthenticated! if token_and_options.nil?

    token, options = token_and_options
    email = options[:email]

    user_token = Rails.cache.fetch(email, expires_in: 30.minutes) do
      User.where(email: email).first.authentication_token
    end

    if ActiveSupport::SecurityUtils.secure_compare(user_token, token)
      @current_user_email = email
    else
      return unauthenticated!
    end
  end

  def unauthenticated!
    response.headers['WWW-Authenticate'] = 'Token realm=Application'
    render json: { error: 'Bad credentials' }, status: 401
  end

  def current_user
    @current_user ||= User.where(email: @current_user_email).first
  end
end
