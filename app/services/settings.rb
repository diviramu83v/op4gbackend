# frozen_string_literal: true

# This class encapsulates our ENV vars. Trying to encapsulate our configuration
#   and prevent issues due to missing vars in staging/production environments.
class Settings
  class << self
    def disqo_username
      env_value_or_error('DISQO_USERNAME')
    end

    def disqo_password
      env_value_or_error('DISQO_PASSWORD')
    end

    def disqo_feasibility_username
      env_value_or_error('DISQO_FEASIBILITY_USERNAME')
    end

    def disqo_feasibility_password
      env_value_or_error('DISQO_FEASIBILITY_PASSWORD')
    end

    def disqo_hash_key
      env_value_or_error('DISQO_HASH_KEY')
    end

    def disqo_api_url
      env_value_or_error('DISQO_API_URL')
    end

    def disqo_api_feasibility_url
      env_value_or_error('DISQO_API_FEASIBILITY_URL')
    end

    def disqo_redirect_url
      env_value_or_error('DISQO_REDIRECT_URL')
    end

    def cint_api_key
      env_value_or_error('CINT_API_KEY')
    end

    def cint_api_url
      env_value_or_error('CINT_API_URL')
    end

    def cint_redirect_url
      env_value_or_error('CINT_REDIRECT_URL')
    end

    def tango_api_url
      env_value_or_error('TANGO_API_URL')
    end

    def clean_id_api_url
      env_value_or_error('CLEAN_ID_API_URL')
    end

    def tango_platform_name
      env_value_or_error('TANGO_PLATFORM_NAME')
    end

    def tango_platform_key
      env_value_or_error('TANGO_PLATFORM_KEY')
    end

    def mailchimp_marketing_url
      env_value_or_error('MAILCHIMP_MARKETINIG_URL')
    end

    def mailchimp_password
      env_value_or_error('MAILCHIMP_PASSWORD')
    end

    def use_mailchimp?
      env_value_or_error('USE_MAILCHIMP')
    end

    def schlesinger_api_key
      env_value_or_error('SCHLESINGER_API_KEY')
    end

    def schlesinger_demand_api_url
      env_value_or_error('SCHLESINGER_DEMAND_API_URL')
    end

    def schlesinger_definition_api_url
      env_value_or_error('SCHLESINGER_DEFINITION_API_URL')
    end

    def schlesinger_redirect_url
      env_value_or_error('SCHLESINGER_REDIRECT_URL')
    end

    def schlesinger_hash_key
      env_value_or_error('SCHLESINGER_HASH_KEY')
    end

    private

    def env_value_or_error(var)
      ENV.fetch(var) || raise(error_message(var))
    end

    def error_message(var)
      "Missing #{var} ENV var. Please add it for this environment."
    end
  end
end
