class Users::SessionSerializer < ActiveModel::Serializer
  attributes :email, :username, :authentication_token
  root :user
end
