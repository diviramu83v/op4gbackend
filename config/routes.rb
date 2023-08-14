# frozen_string_literal: true

# Using regex matchers on subdomain constraints to work with subdomains like, via: :all
# app.pr-5.op4g-staging.com.

# rubocop:disable Metrics/BlockLength
Rails.application.routes.draw do
  match '(*any)', to: redirect(subdomain: 'admin'), via: :all, constraints: { subdomain: 'new-admin' }
  # Employees => admin.op4g.com.
  constraints subdomain: /^admin(\.|$)/ do
    defaults subdomain: 'admin', tld_length: ENV.fetch('TLD_LENGTH', '1').to_i do
      scope module: :employee do
        devise_for :employee, path: '', controllers: { sessions: 'employee/sessions' }
        resources :employee, only: [] do
          resources :warnings, only: [:index]
          resources :feasibilities, only: [:index]
        end
        resource :operations_dashboard, only: [:show], path: 'operations'
        resources :queries, only: [:new, :create, :show, :destroy], controller: :demo_queries do
          resource :filter, only: [:destroy], controller: :demo_query_filters
          resources :options, only: [:create, :destroy], controller: :demo_query_options
          resources :ages, only: [:create, :destroy], controller: :demo_query_ages
          resources :age_ranges, only: [:create], controller: :demo_query_age_ranges
          resources :state_codes, only: [:create, :destroy], controller: :demo_query_state_codes
          resources :zips, only: [:index, :create, :destroy], controller: :demo_query_zip_codes
          resources :states, only: [:create, :destroy], controller: :demo_query_states
          resources :regions, only: [:create, :destroy], controller: :demo_query_regions
          resources :divisions, only: [:create, :destroy], controller: :demo_query_divisions
          resources :dmas, only: [:create, :destroy], controller: :demo_query_dmas
          resources :msas, only: [:create, :destroy], controller: :demo_query_msas
          resources :pmsas, only: [:create, :destroy], controller: :demo_query_pmsas
          resources :counties, only: [:create, :destroy], controller: :demo_query_counties
          resources :projects, only: [:new, :create], controller: :query_projects
          resource :sample, only: [:new, :create], controller: :sample_batches
          resource :close, only: [:create], controller: :demo_query_closings
          resource :traffic, only: [:show], controller: :demo_query_traffic
          resources :project_inclusions, only: [:create, :destroy], controller: :demo_query_project_inclusions
          resources :onboardings, only: [:create, :destroy], controller: :demo_query_onboardings
        end
        resources :clients, only: [:index, :new, :create, :show, :edit, :update] do
          resources :projects, only: [:new, :create], controller: :client_projects
        end
        resources :vendors, only: [:index, :new, :create, :edit, :update] do
          resource :block_rate_report, only: [:show], controller: :vendor_block_rate_reports
        end
        resource :project_search, only: [:create], path: '/projects/search'
        resources :projects, only: [:new, :create, :edit, :update, :show, :index] do
          resources :fraudulents, only: [:new, :show, :create, :destroy]
          resources :accepted_completes, only: [:new, :show, :create, :destroy]
          resources :rejected_completes, only: [:new, :show, :create, :destroy]
          resources :vendor_close_out_reports, only: [:index]
          resource :vendor_close_out_report_downloads, only: [:show]
          resources :panelist_earnings, only: [:index, :create]
          resources :finalize_project_statuses, only: [:index, :create], path: 'finalize_project_status'
          resource :product, only: [:update], controller: :project_product
          resource :work_order, only: [:update], controller: :project_work_orders
          resource :client, only: [:update], controller: :project_client
          resource :salesperson, only: [:update], controller: :project_salespeople
          resource :manager, only: [:update], controller: :project_managers
          resources :statuses, only: [:create], controller: :project_statuses, param: :id
          resources :recontacts, only: [:create]
          resources :vendors, only: [:new, :create], controller: :project_vendors
          resources :redirect_issues, only: [:index], controller: :redirect_logs
          resources :surveys, shallow: true do
            resource :onramps, controller: :survey_onramps
            resources :gate_surveys
            resource :cpi, controller: :survey_cpis
            resource :target, controller: :survey_targets
            resources :vendors, controller: :vendor_batches
            resource :completions, only: [:show], controller: :survey_completions
            resource :traffic
            resource :traffic_details
            resource :traffic_by_source
            resources :block_reasons, only: [:index], controller: :survey_block_reasons
            resources :keys
            resources :return_keys
            resource :keysets
            resources :adjustments, controller: :survey_adjustments
            resource :api_target, path: :api, controller: :survey_api_targets
            resource :api_target_activations, controller: :survey_api_target_activations
            resource :prescreener, controller: :survey_prescreener_activations
            resource :prescreener_clones, only: [:show, :create], path: 'clone_prescreener'
            resources :disqo_quotas, only: [:index, :new, :edit, :create, :update] do
              resources :disqo_quota_activations, only: [:create, :destroy], as: :activations
            end
            resources :cint_surveys, only: [:index, :new, :create, :edit, :update] do
              resources :cint_survey_activations, only: [:create, :destroy]
              resources :cint_survey_completions, only: [:create]
            end
            resources :cint_country_options, only: [:create]
            resources :schlesinger_quotas, only: [:index, :new, :edit, :create, :update] do
              resources :schlesinger_quota_activations, only: [:create, :destroy]
            end
            resources :complete_milestones, only: [:index, :create]
            resources :client_sent_surveys, only: [:index, :new, :edit, :create, :update]
            resource :client_sent_survey_unsubscriptions, only: [:show]
            resource :expert_recruit_unsubscriptions, only: [:show]
            resource :expert_recruit_completes, only: [:show]
            resources :expert_recruit_batches, only: [:index, :new, :edit, :create, :update, :destroy] do
              resources :send_expert_recruit_batches, only: [:create], as: :sends
              resources :expert_recruit_batch_reminders, only: [:create], as: :reminders
            end
            resource :earnings, only: [:destroy]
            resources :earnings, only: [:index, :new, :create]
            resources :queries, controller: :demo_queries
            resources :followup_surveys, path: :emails
            resources :prescreener_question_templates, as: :prescreener_questions, path: 'prescreener_questions' do
              resources :prescreener_answer_templates, as: :answers
              resource :prescreener_answer_templates, as: :all_answers, only: [:destroy]
              resources :prescreener_upload_answers, only: [:new, :create]
            end
            resources :library_question_selections, path: 'library_questions', only: [:index, :new, :create]
            resources :statuses, only: [:create], controller: :survey_statuses
            resource :traffic_search, only: [:create], path: '/traffics/search'
            resources :traffic_records, only: [:show]
            resource :clone, only: [:create], controller: :survey_clones
          end
        end
        resources :warnings, only: [:index, :destroy]
        resources :routers, only: [:index, :new, :create, :edit, :update]
        resource :project_report, only: [:show, :create]
        resource :personal_project_reports, only: [:show]
        scope :api, as: 'api' do
          resources :vendors, only: [:index, :show], controller: :api_vendors
          resources :disqo, only: [:index], controller: :api_disqo
          resources :disqo_surveys, only: [:index], controller: :api_disqo_surveys
          resources :disqo_single_year_completes, only: [:index], controller: :api_disqo_single_year_completes
          resources :disqo_single_month_completes, only: [:index], controller: :api_disqo_single_month_completes
          resources :cint, only: [:index], controller: :api_cint
          resources :cint_surveys, only: [:index], controller: :api_cint_surveys
          resources :cint_single_year_completes, only: [:index], controller: :api_cint_single_year_completes
          resources :cint_single_month_completes, only: [:index], controller: :api_cint_single_month_completes
          resources :completes, only: [:show], controller: :api_completes
          resources :fraud_rejects, only: [:show], controller: :api_fraud_rejects
        end
        resources :recontact_invitation_batches, only: [:edit, :update] do
          resource :launch, only: [:create], controller: :recontact_invitation_batch_launches
        end
        resources :recontacts, only: [:show, :edit, :update] do
          resource :traffic, only: [:show], controller: :recontact_traffic
          resource :traffic_details, only: [:show], controller: :recontact_traffic_details
          resource :onramps, only: [:show], controller: :recontact_onramps
          resource :id_matches, only: [:show], controller: :recontact_id_matches
          resources :invitation_batches, only: [:new, :create, :show], controller: :recontact_invitation_batches
          resources :recontact_invitations, only: [:new, :create]
        end
        resources :onboarding, only: [] do
          resources :traffic_steps, only: [:index]
          resources :traffic_events, only: [:index]
        end
        resources :panelist_suspensions, only: [:new, :create]
        resources :traffic_step_lookups, only: [:new, :create, :show]
        resources :demographic_details, only: [:new, :create, :show]
        resource :effective_roles, only: [:create]
        resources :cint_events, only: [:create]
        resource :unsubscriptions, only: [:show]
        resources :incentive_batches, only: [:new, :create, :index, :show, :edit, :update] do
          resources :send_incentive_batches, only: [:create], as: :sends
        end
        resources :decodings, only: [:new, :create, :show] do
          resource :errors, only: [:show], controller: :decoding_errors
          resource :testings, only: [:show], controller: :decoding_testings
          resource :combined, only: [:show], controller: :decoding_combined_panels
          resources :panel, only: [:show], controller: :decoding_panels
          resources :vendors, only: [:show], controller: :decoding_vendors
          resources :api_vendors, only: [:show], controller: :decoding_api_vendors
          resources :routers, only: [:show], controller: :decoding_routers
          resource :disqo, only: [:show], controller: :decoding_disqo
          resource :cint, only: [:show], controller: :decoding_cint
          resource :matches, only: [:show], controller: :decoding_matches
        end
        resources :completes_decoders, only: [] do
          resources :vendors, only: [:show], controller: :completes_decoder_vendors
          resources :panels, only: [:show], controller: :completes_decoder_panels
          resources :disqo_quotas, only: [:show], controller: :completes_decoder_disqo_quotas
          resources :cint_surveys, only: [:show], controller: :completes_decoder_cint_surveys
          resource :surveys, only: [:show], controller: :completes_decoder_surveys
        end
        resources :disqo_rejected_traffic_reports, only: [:index]
        resources :project_close_outs, only: [:index, :show]
        resources :closed_out_projects, only: [:index]
        resources :onramps, only: [:edit, :update] do
          resource :vendor_stats, only: [:show]
          resource :disabling, only: [:create, :destroy], controller: :onramp_disablings
          resource :prescreener, only: [:create, :destroy], controller: :onramp_prescreener_activations
        end
        resources :sample_batches, only: [:edit, :update, :destroy] do
          resource :launch, only: [:create], path: :invite, controller: :sample_batch_launches
          resource :clone, only: [:create], controller: :sample_batch_clones
          resource :close, only: [:create, :destroy], controller: :sample_batch_closings
          resource :remind, only: [:create], controller: :sample_batch_reminders
        end
        resources :vendor_batches, only: [:edit, :update, :destroy] do
          resource :invitations, only: [:update], controller: :vendor_batch_invitations
        end
        resources :keys, only: [:destroy]
        resource :screen_expansion, only: [:create, :destroy]

        resource :supply_dashboard, only: [:show], path: 'supply'

        resource :recruitment_dashboard, only: [:show], path: 'recruitment'
        resources :nonprofits, only: [:index, :show, :new, :create, :edit, :update, :destroy] do
          resource :earnings, only: [:show], controller: :traffic_earnings
          resource :profit, only: [:show], controller: :nonprofit_net_profit
          resources :nonprofit_panelists, only: [:index], as: :panelists, path: 'panelists'
          resources :recruiting_campaigns, only: [:new, :create], controller: :nonprofit_campaigns
          resource :stats, only: [:show], controller: :nonprofit_signup_stats
          resource :completes, only: [:show], controller: :nonprofit_completes_funnel
          resource :lifecycle, only: [:show], controller: :nonprofit_panelist_lifecycle_stats
        end
        resources :recruiting_campaigns, except: [:destroy] do
          resources :campaign_panelists, only: [:index], as: :panelists, path: 'panelists'
          resource :earnings, only: :show, controller: :traffic_earnings
          resource :profit, only: [:show], controller: :campaign_net_profit
          resource :demographic_details, only: [:show], controller: :campaign_demographic_details
          resource :stats, only: [:show], controller: :campaign_signup_stats
          resource :completes, only: [:show], controller: :campaign_completes_funnel
          resource :lifecycle, only: [:show], controller: :campaign_panelist_lifecycle_stats
        end
        resources :panels, only: [:index, :show] do
          resource :email_lists, only: [:show], controller: :panelist_email_lists
          resources :panel_panelists, only: :index, as: :panelists, path: 'panelists'
          resources :questions, only: [:index, :show, :new, :edit, :create, :update], controller: :panel_demo_questions do
            resource :categories, only: [:edit, :update], controller: :panel_demo_questions_categories
            resources :options, only: [:new, :edit, :create, :update], controller: :panel_demo_options
          end
          resource :combined, only: [:show], controller: :panel_panelist_reporting_combined
          resource :stats, only: [:show], controller: :panel_signup_stats
          resource :profit, only: [:show], controller: :panel_net_profit
          resource :completes, only: [:show], controller: :panel_completes_funnel
          resource :lifecycle, only: [:show], controller: :panel_panelist_lifecycle_stats
          resource :utilization, only: [:show], controller: :panel_utilization
          resource :underutilization, only: [:show], controller: :panel_underutilization
        end
        resources :prescreener_library_questions, except: [:show]
        resource :sales_dashboard, only: [:show], path: 'sales'
        resources :feasibilities, only: [:index, :new, :show, :create]
        resources :disqo_feasibilities, only: [:index, :new, :create, :edit, :update, :destroy]
        resources :cint_feasibilities, only: [:index, :new, :create]
        resources :cint_country_options, only: [:create]
        resources :cint_feasibility_country_options, only: [:create]

        resource :membership_dashboard, only: [:show], path: 'membership'
        resource :reporting_dashboard, only: [:show], path: 'reporting'
        resource :panel_completes_by_sources, only: [:new]
        resource :active_surveys_report, only: [:new]
        resource :vendor_performance_report, only: [:new]
        resource :block_rate_by_sources, only: [:new] do
          get :get_blocked_sources
        end
        resource :completes_by_vendors, only: [:new]
        resources :demo_answers, only: [:edit, :update]
        resources :panelists, only: [:index, :show, :edit, :update] do
          resource :suspension, only: [:create, :destroy], path: :suspend
          resource :invitations, only: [:show], controller: :panelist_invitations
          resources :notes, only: [:new, :create], controller: :panelist_notes
          resources :suspension_notes, only: [:new, :create], controller: :panelist_suspension_notes
          resources :suspend_and_pay_notes, only: [:new, :create], controller: :panelist_suspend_and_pay_notes
          resource :payments, only: [:show], controller: :panelist_payments
          resource :demographics, only: [:show], controller: :panelist_demographics
          resource :nonpayments, only: [:show], controller: :panelist_nonpayments
        end
        resources :expert_panelists, only: [:index, :show, :create]
        resources :pixels, only: [:index, :new, :create, :edit, :update, :destroy], controller: :tracking_pixels
        resource :completes_report, only: [:new]
        resource :affiliate_report, only: [:new, :show]
        resources :affiliates, only: [:index, :show] do
          resource :earnings, only: [:show], controller: :traffic_earnings
          resource :profit, only: [:show], controller: :affiliate_net_profit
          resource :stats, only: [:show], controller: :affiliate_signup_stats
          resource :completes, only: [:show], controller: :affiliate_completes_funnel
          resource :lifecycle, only: [:show], controller: :affiliate_panelist_lifecycle_stats
        end
        resource :block_reasons_report, only: [:new]
        resource :recruitment_source_report, only: [:new, :show]

        resource :security_dashboard, only: [:show], path: 'security'
        resource :denylist, only: [:show, :new, :create, :destroy]
        resources :ip_addresses, only: [:index, :show] do
          resource :ip_block, only: [:create, :destroy]
        end
        resource :survey_test_modes, only: :update

        root 'dashboard#index', as: :employee_dashboard
      end
      post '/sortable/reorder', to: 'sortable#reorder'
    end
  end

  # Panelists => my.op4g.com.
  constraints subdomain: /^my(\.|$)/ do
    defaults subdomain: :my, tld_length: ENV.fetch('TLD_LENGTH', '1').to_i do
      scope module: :panelist do
        devise_for :panelists, path: '', controllers: {
          registrations: 'panelist/registrations',
          confirmations: 'panelist/confirmations',
          omniauth_callbacks: 'panelist/omniauth_callbacks'
        }

        resource :locale, only: [:create]
        resource :landing_page, path: 'join', only: [:show]
        resource :terms_and_conditions, only: [:show], controller: 'terms_and_conditions'
        resource :privacy_policy, only: [:show], controller: 'privacy_policy'
        resource :base_demographics,      only: [:show, :create]
        resource :demographics, only: [:show, :create] do
          resources :categories, only: [:show], controller: 'demographic_categories'
        end
        resource :welcome, only: [:show]

        resource :account, only: [:show, :destroy], as: :account do
          resource :birthdate,          only: [:edit, :update]
          resource :demographics,       only: [:show], controller: 'account_demographics'
          resource :email,              only: [:edit, :update]
          resource :private,            only: [:edit, :create], controller: :private
          resource :contribution,       only: [:show, :update]
          resource :nonprofit,          only: [:update, :destroy]
          resource :payments,           only: [:show]
          resource :giveup4good,        only: [:show], controller: :giveup4good
        end

        resource :expert_unsubscribe, only: [:show], controller: 'expert_recruit_unsubscriptions'
        resource :expert_unsubscribe_confirmation, only: [:show], controller: 'expert_recruit_unsubscription_confirmations'
        resources :expert_recruit_unsubscriptions, only: [:create]
        resource :unsubscribe, only: [:show, :create], controller: 'unsubscriptions'
        resource :unsubscribe_confirmation, only: [:show], controller: 'unsubscription_confirmations'
        resource :accept_terms_and_conditions, only: [:show, :create]
        resource :support, only: [:show], controller: 'support'
        resources :invitations, only: [:show], param: :token
        resources :invitations, only: [:destroy]
        resource :clean_id, only: [:new, :show], path: 'clean/loading', controller: 'clean_ids'
        resource :facebook_deauthorization, only: [:create], controller: 'facebook_deauthorization'

        root 'dashboard#show', as: :panelist_dashboard
      end
    end
  end

  # Generate test events for surveys => testing.op4g.com.
  constraints subdomain: /^testing(\.|$)/ do
    defaults subdomain: :testing, tld_length: ENV.fetch('TLD_LENGTH', '1').to_i do
      scope module: :testing do
        resources :test_surveys, only: [:show], path: :surveys, controller: :surveys, param: :token
      end
    end
  end

  # Survey response endpoints.
  # GET requests even though they should really be POST.
  constraints subdomain: /^survey(\.|$)/ do
    defaults subdomain: :survey, tld_length: ENV.fetch('TLD_LENGTH', '1').to_i do
      scope module: :survey, as: :survey do
        resources :landing_page_emails, only: [:create, :index]
        resource :error, only: [:show], format: :html
        resource :recontact_invitation_errors, only: [:show], format: :html
        resources :recontact_invitations, only: [:show], param: :token
        resources :client_sent_surveys, only: [:show], param: :token
        resources :client_sent_survey_invitations, only: [:create, :index]
        resource :client_sent_unsubscribe, only: [:show], controller: 'client_sent_unsubscriptions'
        resource :client_sent_unsubscribe_confirmation, only: [:show], controller: 'client_sent_unsubscription_confirmations'
        resources :client_sent_unsubscriptions, only: [:create]
        resource :security_errors, only: [:show], path: 'security'
        resource :return_key_errors, only: [:show]
        resources :onramps, only: [:show], param: :token
        resources :step, only: [], param: :token do
          resource :check, only: [:new, :show, :create], path: '', controller: :traffic_checks
        end
        resources :screener_step, only: [], param: :token do
          resource :question, only: [:new, :create], path: '', controller: :prescreener_checks
        end
        resources :routers, only: [:show], param: :token do
          resources :visitors, only: [:new, :create, :edit, :update], controller: :router_visitors, param: :token
        end
        resources :responses, only: [:show], param: :token
        resource :hold, only: [:show]
        resource :complete, only: [:show], controller: :completions
        resource :full, only: [:show], controller: :fills
        resource :screened, only: [:show], controller: :screenings
        resource :thanks, only: [:show]
      end
    end
  end

  # Admins => admin.op4g.com.
  constraints subdomain: /^system(\.|$)/ do
    defaults subdomain: :system, tld_length: ENV.fetch('TLD_LENGTH', '1').to_i do
      require 'sidekiq/web'

      # Basic Auth for sidekiq
      Sidekiq::Web.use Rack::Auth::Basic do |username, password|
        ActiveSupport::SecurityUtils.secure_compare(::Digest::SHA256.hexdigest(username), ::Digest::SHA256.hexdigest(ENV.fetch('SIDEKIQ_AUTH_USERNAME'))) &
          ActiveSupport::SecurityUtils.secure_compare(::Digest::SHA256.hexdigest(password), ::Digest::SHA256.hexdigest(ENV.fetch('SIDEKIQ_AUTH_PASSWORD')))
      end

      mount Sidekiq::Web, at: '/sidekiq'

      scope module: :admin do
        resources :payments, only: [:index, :new, :create]
        resources :customer_panels, only: [:index, :new, :create, :show] do
          resources :customers, only: [:new, :create]
        end
        resources :events, only: [:index]
        resources :jobs, only: [:index]
        resources :project_processors, only: [:index, :create]
        resource :reports, only: [:show]
        resource :monthly_earnings_report, only: [:show], path: 'reports/monthly_earnings'
        resource :nonprofit_earnings_report, only: [:show, :create], path: 'reports/nonprofit_earnings'
        resources :api_tokens, only: [:index, :new, :edit, :create, :destroy, :update]
        root 'dashboard#index', as: :admin_dashboard
      end

      scope module: :table_data, as: :table_data, path: :data do
        resources :panels
        resources :countries
        resources :panelists
        resources :employees
        resources :roles
        resources :demo_questions_categories
        resources :demo_questions
        resources :demo_options
        resources :demo_answers
        resources :surveys
        resources :survey_response_patterns
        resources :vendors
        resources :vendor_batches
        resources :email_descriptions
        resources :zip_codes
        resources :counties
        resources :states
        resources :regions
        resources :divisions
        resources :msas
        resources :pmsas
        resources :dmas

        root to: 'panels#index', as: :dashboard
      end
      root to: 'panels#index', as: :root
    end
  end

  namespace :api do
    namespace :v1 do
      resources :countries, only: [:index]
      resources :projects, only: [:index]
      resources :vendors, only: [:index]
      resources :target_types, only: [:index]
      resources :rfp, only: [:index, :show] do
        get 'overview'
        get 'bids_requests/:id', on: :collection, to: 'rfp#vendor'
        put 'bids_requests/:id', on: :collection, to: 'rfp#bid_update'
        post 'bid_details', on: :collection, to: 'rfp#create_bid_details'
        put 'bid_details/:id', on: :collection, to: 'rfp#update_bid_details'
        post 'targetings', on: :collection, to: 'rfp#create_targetings'
        put 'targetings/:id', on: :collection, to: 'rfp#update_targetings'
        get 'result', on: :member, to: 'rfp#result'
        put 'result', on: :member, to: 'rfp#update_cpi_feasible_total'
        get 'countries/:rfp_country_id', on: :member, to: 'rfp#rfp_countries'
      end
      devise_for :employee, path: 'auth', controllers: {
        sessions: 'api/v1/employee/sessions',
      }
    end
  end

  constraints subdomain: /^api(\.|$)/ do
    defaults subdomain: 'api', tld_length: ENV.fetch('TLD_LENGTH', '1').to_i do
      scope module: :api do
        namespace :v1 do
          devise_for :employee, path: 'auth', controllers: {
            sessions: 'api/v1/employee/sessions',
          }
          resources :surveys, only: [:index]
          resources :panelists, only: [:create]
          resources :projects, only: [:index]
          resources :countries, only: [:index]
          resources :vendors, only: [:index]
          resources :target_types, only: [:index]
          resources :rfp, only: [:index, :show] do
            get 'bids_requests/:id', on: :collection, to: 'rfp#vendor'
            put 'bids_requests/:id', on: :collection, to: 'rfp#bid_update'
            post 'bid_details', on: :collection, to: 'rfp#create_bid_details'
            put 'bid_details/:id', on: :collection, to: 'rfp#update_bid_details'
            post 'targetings', on: :collection, to: 'rfp#create_targetings'
            put 'targetings/:id', on: :collection, to: 'rfp#update_targetings'
            get 'result', on: :member, to: 'rfp#result'
            put 'result', on: :member, to: 'rfp#update_cpi_feasible_total'
            get 'countries/:rfp_country_id', on: :member, to: 'rfp#rfp_countries'
          end
        end
      end
    end
  end

  root 'dashboard#index', as: :dashboard

  match '*path',
        controller: 'application',
        action: 'options_request',
        constraints: { method: 'OPTIONS' },
        via: :all

  match '*path',
        controller: 'application',
        action: 'head_request',
        constraints: { method: 'HEAD' },
        via: :all

  get '/400', to: 'errors#bad_request',           as: :bad_request
  get '/404', to: 'errors#not_found',             as: :not_found
  get '/500', to: 'errors#internal_server_error', as: :internal_server_error
  get '/422', to: 'errors#unprocessable_entity',  as: :unprocessable_entity

  match '*unmatched', to: 'errors#not_found', via: :all, constraints: ->(req) { req.path.exclude? 'rails/active_storage' }
end
# rubocop:enable Metrics/BlockLength
