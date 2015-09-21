class MongoSessionSerializer < ActiveModel::Serializer
  attributes :id, :name, :database, :hosts, :username

  def id
    object.id.to_s
  end
end
