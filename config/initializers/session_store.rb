# frozen_string_literal: true

# This config will save the Devise session across subdomains.

Rails.application.config.session_store :cookie_store, key: '_my_app_session', domain: :all
