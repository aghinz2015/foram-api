class User
  include Mongoid::Document
  include ActiveModel::SecurePassword

  EMAIL_REGEXP = /\A([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})\z/i

  before_create :generate_authentication_token

  field :email,                   type: String
  field :username,                type: String
  field :password_digest,         type: String
  field :authentication_token,    type: String

  embeds_many :mongo_sessions

  has_secure_password

  validates :email, :username, presence: true,
                               uniqueness: { case_sensitive: false },
                               length: { maximum: 255 }
  validates :email, format: { with: EMAIL_REGEXP }
  validates :password, length: { minimum: 6 }, allow_nil: true

  has_many :foram_filters

  def change_authentication_token
    generate_authentication_token
    save
  end

  private

  def generate_authentication_token
    loop do
      self.authentication_token = SecureRandom.base64(64)
      break unless User.where(authentication_token: authentication_token).present?
    end
  end
end
