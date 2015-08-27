class Sessions::UserSerializer < ActiveModel::Serializer
  attributes :email, :username, :authentication_token
end
