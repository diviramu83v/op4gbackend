# frozen_string_literal: true

IpAddress.where.not(category: 'allow').where(block_category: nil).find_each do |ip_address|
  if ip_address.category == 'deny-manual'
    ip_address.manual!
  else
    ip_address.auto!
  end
end
