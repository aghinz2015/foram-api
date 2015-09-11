class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Token

  protected

  def authenticate_user!
    token_and_options = token_and_options(request)
    return unauthenticated! if token_and_options.nil?

    token, options = token_and_options
    user = User.where(email: options[:email]).first

    if user && ActiveSupport::SecurityUtils.secure_compare(user.authentication_token, token)
      @current_user = user
    else
      return unauthenticated!
    end
  end

  def unauthenticated!
    response.headers['WWW-Authenticate'] = 'Token realm=Application'
    render json: { error: 'Bad credentials' }, status: 401
  end
end
