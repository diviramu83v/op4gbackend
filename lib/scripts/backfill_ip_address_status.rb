# frozen_string_literal: true

IpAddress.where(status: nil).find_each do |ip_address|
  if ip_address.category == 'allow'
    ip_address.allowed!
  else
    ip_address.flagged!
  end
end
