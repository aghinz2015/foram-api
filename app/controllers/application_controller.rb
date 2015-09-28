class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Token

  protected

  def authenticate_user!
    token, options = token_and_options(request)
    return unauthenticated! unless token && options

    auth = Authentication.new(options[:email], token)

    if auth.user_authenticated?
      @current_user_email = options[:email]
    else
      unauthenticated! and return
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
