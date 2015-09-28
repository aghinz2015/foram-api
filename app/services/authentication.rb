class Authentication
  STORE_PERIOD = 30.minutes

  attr_reader :email, :token

  def initialize(email, token)
    @email = email
    @token = token
  end

  def user_authenticated?
    user_token = Rails.cache.fetch(email, expires_in: STORE_PERIOD) do
      User.where(email: email).first.authentication_token
    end

    ActiveSupport::SecurityUtils.secure_compare(user_token, token)
  end

  def cache_token
    Rails.cache.write(email, token, expires_in: STORE_PERIOD)
  end

  def invalidate_token_cache
    Rails.cache.delete(email)
  end
end
