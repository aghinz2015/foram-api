class MongoSession
  include Mongoid::Document

  embedded_in :user

  field :name,               type: String
  field :database,           type: String
  field :hosts,              type: Array
  field :username,           type: String
  field :encrypted_password, type: String
  attr_writer :password

  validates :name, :database, :hosts, :username, :encrypted_password, presence: true
  validates :name, uniqueness: { scope: :user }

  def password=(value)
    self.encrypted_password = Encryptor.new.encrypt(value)
  end

  def connect
    Mongoid::Config.sessions[config_name] = session_configuration
  end

  private

  def config_name
    @config_name ||= ([user.username, name].join('_')).to_sym
  end

  def session_configuration
    {
      database: database,
      hosts: hosts,
      username: username,
      password: Encryptor.new.decrypt(encrypted_password)
    }
  end
end
