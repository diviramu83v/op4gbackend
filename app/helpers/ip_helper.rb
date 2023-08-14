# frozen_string_literal: true

# View helpers for IP addresses.
module IpHelper
  def ip_category_badge(ip)
    tag.span(ip_category_text(ip),
             class: "badge badge-#{ip_category_class(ip)}")
  end

  def ip_category_text(ip)
    case ip.category
    when 'deny-manual' then 'blocked: employee'
    when 'deny-auto' then 'blocked: fraud detection'
    when 'allow' then 'allowed'
    else 'unknown'
    end
  end

  def ip_category_class(ip)
    case ip.category
    when 'deny-manual' || 'deny-auto' then 'danger'
    when 'allow' then 'success'
    else 'warning'
    end
  end
end
