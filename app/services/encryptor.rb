class Encryptor
  KEY = Rails.application.secrets.cipher_key
  IV  = Rails.application.secrets.cipher_iv

  def encrypt(value)
    cipher = create_cipher :encrypt

    encrypted = cipher.update value
    encrypted << cipher.final

    Base64.encode64(encrypted).encode('utf-8')
  end

  def decrypt(value)
    decoded = Base64.decode64 value.encode('ascii-8bit')
    cipher = create_cipher :decrypt

    decrypted = cipher.update decoded
    decrypted << cipher.final
    decrypted.force_encoding('utf-8')
  end

  private

  def create_cipher(type)
    cipher = OpenSSL::Cipher.new 'aes-256-cbc'
    cipher.send type
    cipher.key = KEY
    cipher.iv = IV
    cipher
  end
end
