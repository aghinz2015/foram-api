class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Token

  protected

  def authenticate_user!
    token, options = token_and_options(request)

    user_email = options.present? ? options[:email] : nil
    user = User.where(email: user_email).first

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
