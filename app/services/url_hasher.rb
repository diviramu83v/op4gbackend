# frozen_string_literal: true

# Sometimes we need to hash URLs and send with a new parameter to increase
#   security. This class handles doing this on vendor-by-vendor basis.
class UrlHasher
  def initialize(url:, vendor:)
    raise 'url parameter must not be nil' if url.nil?
    raise 'vendor parameter must not be nil' if vendor.nil?

    @url = url
    @vendor = vendor
  end

  def url_hashed_if_needed
    return @url if @vendor.hash_key.nil?

    if @vendor.include_hashing_param_in_hash_data?
      url_with_hashing_param + hash(url_with_hashing_param)
    else
      url_with_hashing_param + hash(@url)
    end
  end

  private

  def url_with_hashing_param
    @url + "&#{@vendor.hashing_param}="
  end

  def hash(data)
    OpenSSL::HMAC.hexdigest('sha1', @vendor.hash_key, data)
  end
end
