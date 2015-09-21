module UserHelpers
  module LoggingIn
    def login(user = nil, password = "ala123")
      user ||= Fabricate(:user)
      user.password = password
      user.save!

      post("/user/login", user: { email: user.email, password: password })
      token_data = JSON.parse(response.body)["user"]

      @token_header = "Token token=\"#{token_data["authentication_token"]}\", email=\"#{token_data["email"]}\""
    end
  end
end
