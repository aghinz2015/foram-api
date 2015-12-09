class MongoSession
  include Mongoid::Document

  embedded_in :user

  field :name,               type: String
  field :database,           type: String
  field :hosts,              type: Array
  field :username,           type: String
  field :encrypted_password, type: String
  field :active,             type: Boolean
  field :foram_collection,   type: String
  attr_writer :password

  validates :name, :database, :hosts, :foram_collection, presence: true
  validates :encrypted_password, presence: true, if: ->(record) { record.username.present? }
  validates :name, uniqueness: { scope: :user }

  after_save :deactivate_other_sessions, if: ->(session) { session.active && session.active_changed? }
  scope :active, -> { where(active: true) }

  def password=(value)
    self.encrypted_password = Encryptor.new.encrypt(value)
  end

  def connect
    Mongoid::Config.sessions[config_name] = session_configuration
  end

  def config_name
    @config_name ||= ([user.username, name].join('_')).to_sym
  end

  private

  def session_configuration
    {
      database: database,
      hosts: hosts,
      username: username,
      password: Encryptor.new.decrypt(encrypted_password),
      foram_collection: foram_collection
    }
  end

  def deactivate_other_sessions
    user.mongo_sessions.active.where(:id.ne => id).update_all(active: false)
  end
end
