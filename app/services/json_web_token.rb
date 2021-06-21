class JsonWebToken
  ALGORITHM = 'HS256'.freeze
  EXP_LEEWAY = ENV.fetch('EXP_LEEWAY', 30).to_i

  class << self
    def encode(user:)
      JWT.encode(payload(user), secret, ALGORITHM)
    end

    def decode(token:)
      decoded_token = JWT.decode(token, secret, true, decode_options)
      HashWithIndifferentAccess.new(decoded_token[0])
    rescue JWT::DecodeError => e
      Rails.logger.error("Error: #{e.inspect}\nBacktrace: #{e.backtrace.join("\n \t")}")
      nil
    end

    private

    def payload(user)
      {
        id: user.id,
        first_name: user.first_name,
        last_name: user.last_name,
        email: user.email,
        iss: issuer,
        iat: issued_at,
        jti: jwt_id,
        exp: expiration
      }
    end

    def decode_options
      {
        iss: issuer,
        exp_leeway: EXP_LEEWAY,
        verify_iss: true,
        verify_jti: true,
        verify_iat: true,
        algorithm: ALGORITHM
      }
    end

    def issuer
      ENV.fetch('API_URL')
    end

    def issued_at
      Time.current.to_i
    end

    def jwt_id
      jti_raw = [secret, issued_at].join(':').to_s
      Digest::MD5.hexdigest(jti_raw)
    end

    def expiration
      (Time.current + ENV.fetch('JWT_TOKEN_LIFE_TIME', 30).to_i.minutes).to_i
    end

    def secret
      Rails.application.credentials.secret_key_base
    end
  end
end
