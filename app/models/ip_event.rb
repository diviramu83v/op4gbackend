# frozen_string_literal: true

# Tracks important things specific to one IP address.
class IpEvent < ApplicationRecord
  belongs_to :ip, class_name: 'IpAddress', foreign_key: :ip_address_id, inverse_of: :events

  validates :message, presence: true
end
