class JwtDenylist < ApplicationRecord
  include Devise::JWT::RevocationStrategies::Denylist

  self.table_name = 'jwt_denylist'

  def self.jwt_revoked?(payload, _user)
    exists?(jti: payload['jti'])
  end

  # @see Warden::JWTAuth::Interfaces::RevocationStrategy#revoke_jwt
  def self.revoke_jwt(payload, _user)
    find_or_create_by!(jti: payload['jti'],
                       exp: Time.at(payload['exp'].to_i))
  end
end