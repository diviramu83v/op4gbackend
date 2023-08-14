# frozen_string_literal: true

# View helpers for products.
module ProductHelper
  def product_abbreviation(product_name)
    case product_name
    when 'sample_only' then 'SO'
    when 'full_service' then 'FS'
    when 'wholesale' then 'W'
    else '?'
    end
  end
end
