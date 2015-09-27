class MongoSessionSerializer < ActiveModel::Serializer
  attributes :id, :name, :database, :hosts, :username, :active

  def id
    object.id.to_s
  end
end
