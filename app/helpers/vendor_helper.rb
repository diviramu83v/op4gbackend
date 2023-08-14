# frozen_string_literal: true

# View helpers for vendors.
module VendorHelper
  def vendor_name_with_abbreviation(vendor)
    result = vendor.name
    result += " (#{vendor.abbreviation})" unless vendor.abbreviation == vendor.name
    result
  end
end
