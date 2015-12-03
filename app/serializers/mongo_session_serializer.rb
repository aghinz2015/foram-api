class MongoSessionSerializer < ActiveModel::Serializer
  attributes :id, :name, :database, :hosts, :username, :active, :foram_collection

  def id
    object.id.to_s
  end
end
