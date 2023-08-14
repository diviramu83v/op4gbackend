# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2023_07_31_032625) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "hstore"
  enable_extension "pg_stat_statements"
  enable_extension "plpgsql"

  create_table "action_text_rich_texts", force: :cascade do |t|
    t.string "name", null: false
    t.text "body"
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "affiliates", force: :cascade do |t|
    t.string "code", null: false
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_affiliates_on_code", unique: true
  end

  create_table "ages", force: :cascade do |t|
    t.integer "value", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["value"], name: "index_ages_on_value", unique: true
  end

  create_table "api_tokens", force: :cascade do |t|
    t.string "token", null: false
    t.string "status", default: "sandbox", null: false
    t.string "description", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "vendor_id", null: false
    t.index ["vendor_id"], name: "index_api_tokens_on_vendor_id"
  end

  create_table "campaigns", force: :cascade do |t|
    t.bigint "project_id", null: false
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "confirmed_completion_count"
    t.text "temporary_keys", array: true
    t.index ["project_id"], name: "index_campaigns_on_project_id"
  end

  create_table "cint_events", force: :cascade do |t|
    t.jsonb "events_data", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "cint_survey_id"
    t.index ["cint_survey_id"], name: "index_cint_events_on_cint_survey_id"
  end

  create_table "cint_feasibilities", force: :cascade do |t|
    t.integer "days_in_field"
    t.integer "incidence_rate"
    t.integer "loi"
    t.integer "limit"
    t.integer "country_id"
    t.integer "min_age"
    t.integer "max_age"
    t.text "variable_ids", default: [], array: true
    t.integer "number_of_panelists"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "employee_id"
    t.text "region_ids", default: [], array: true
    t.string "gender"
    t.text "postal_codes"
    t.index ["employee_id"], name: "index_cint_feasibilities_on_employee_id"
  end

  create_table "cint_surveys", force: :cascade do |t|
    t.string "cint_id"
    t.bigint "survey_id", null: false
    t.integer "limit", null: false
    t.integer "expected_incidence_rate", null: false
    t.integer "loi", null: false
    t.text "variable_ids", default: [], array: true
    t.integer "cint_country_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "min_age"
    t.integer "max_age"
    t.string "status", default: "draft", null: false
    t.datetime "activated_at"
    t.integer "cpi_cents"
    t.text "region_ids", default: [], array: true
    t.string "gender"
    t.text "postal_codes"
    t.string "name"
    t.index ["survey_id"], name: "index_cint_surveys_on_survey_id"
  end

  create_table "clean_id_devices", force: :cascade do |t|
    t.string "device_code", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["device_code"], name: "index_clean_id_devices_on_device_code", unique: true
  end

  create_table "client_sent_survey_invitations", force: :cascade do |t|
    t.string "email", null: false
    t.boolean "opt_in", default: false
    t.bigint "onramp_id", null: false
    t.string "token"
    t.string "status", default: "initialized", null: false
    t.datetime "clicked_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "unsubscribe_token"
    t.index ["onramp_id"], name: "index_client_sent_survey_invitations_on_onramp_id"
    t.index ["token"], name: "index_client_sent_survey_invitations_on_token", unique: true
  end

  create_table "client_sent_surveys", force: :cascade do |t|
    t.bigint "survey_id", null: false
    t.bigint "employee_id", null: false
    t.string "description"
    t.string "email_subject"
    t.integer "incentive_cents"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["employee_id"], name: "index_client_sent_surveys_on_employee_id"
    t.index ["survey_id"], name: "index_client_sent_surveys_on_survey_id"
  end

  create_table "client_sent_unsubscriptions", force: :cascade do |t|
    t.string "email"
    t.bigint "client_sent_survey_invitation_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["client_sent_survey_invitation_id"], name: "index_client_unsubscription_on_client_sent_survey_invitation_id"
  end

  create_table "clients", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "custom_uid_parameter"
    t.string "custom_key_parameter"
    t.index ["name"], name: "index_clients_on_name", unique: true
  end

  create_table "close_out_reasons", force: :cascade do |t|
    t.string "title", null: false
    t.text "definition"
    t.string "category", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "complete_milestones", force: :cascade do |t|
    t.integer "target_completes"
    t.bigint "survey_id", null: false
    t.string "status", default: "active", null: false
    t.datetime "sent_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["survey_id"], name: "index_complete_milestones_on_survey_id"
  end

  create_table "completes_decoders", force: :cascade do |t|
    t.text "encoded_uids", null: false
    t.bigint "employee_id", null: false
    t.datetime "decoded_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["employee_id"], name: "index_completes_decoders_on_employee_id"
  end

  create_table "conversions", force: :cascade do |t|
    t.bigint "offer_id", null: false
    t.string "tune_code", null: false
    t.integer "payout_cents", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "affiliate_id"
    t.datetime "tune_created_at"
    t.index ["affiliate_id"], name: "index_conversions_on_affiliate_id"
    t.index ["offer_id"], name: "index_conversions_on_offer_id"
    t.index ["tune_code"], name: "index_conversions_on_tune_code", unique: true
  end

  create_table "counties", force: :cascade do |t|
    t.string "code"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_counties_on_code", unique: true
    t.index ["name"], name: "index_counties_on_name", unique: true
  end

  create_table "countries", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "nonprofit_flag", default: false, null: false
    t.string "slug", null: false
  end

  create_table "decoded_uids", force: :cascade do |t|
    t.string "uid", null: false
    t.bigint "onboarding_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "entry_number", default: 0, null: false
    t.string "decodable_type"
    t.bigint "decodable_id"
    t.index ["decodable_type", "decodable_id"], name: "index_decoded_uids_on_decodable_type_and_decodable_id"
    t.index ["id"], name: "tmp_decoded_uids_id"
    t.index ["id"], name: "tmp_recontact_invitations_id"
    t.index ["onboarding_id"], name: "index_decoded_uids_on_onboarding_id"
    t.index ["onboarding_id"], name: "tmp_decoded_uids_onboarding_id"
  end

  create_table "decodings", force: :cascade do |t|
    t.text "encoded_uids", null: false
    t.bigint "employee_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "decoded_at"
    t.index ["employee_id"], name: "index_decodings_on_employee_id"
  end

  create_table "demo_answers", force: :cascade do |t|
    t.bigint "panelist_id", null: false
    t.bigint "demo_option_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["demo_option_id"], name: "index_demo_answers_on_demo_option_id"
    t.index ["panelist_id", "demo_option_id"], name: "index_demo_answers_on_panelist_id_and_demo_option_id", unique: true
    t.index ["panelist_id"], name: "index_demo_answers_on_panelist_id"
  end

  create_table "demo_options", force: :cascade do |t|
    t.bigint "demo_question_id", null: false
    t.string "label", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "old_code"
    t.integer "sort_order", default: 0, null: false
    t.string "subject"
    t.index ["demo_question_id"], name: "index_demo_options_on_demo_question_id"
  end

  create_table "demo_queries", force: :cascade do |t|
    t.bigint "panel_id"
    t.bigint "country_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "campaign_id"
    t.bigint "survey_id"
    t.bigint "employee_id"
    t.bigint "client_id"
    t.integer "feasibility_total"
    t.index ["campaign_id"], name: "index_demo_queries_on_campaign_id"
    t.index ["client_id"], name: "index_demo_queries_on_client_id"
    t.index ["country_id"], name: "index_demo_queries_on_country_id"
    t.index ["employee_id"], name: "index_demo_queries_on_employee_id"
    t.index ["panel_id"], name: "index_demo_queries_on_panel_id"
    t.index ["survey_id"], name: "index_demo_queries_on_survey_id"
  end

  create_table "demo_query_ages", force: :cascade do |t|
    t.bigint "demo_query_id"
    t.bigint "age_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["age_id"], name: "index_demo_query_ages_on_age_id"
    t.index ["demo_query_id", "age_id"], name: "index_demo_query_ages_on_demo_query_id_and_age_id", unique: true
    t.index ["demo_query_id"], name: "index_demo_query_ages_on_demo_query_id"
  end

  create_table "demo_query_counties", force: :cascade do |t|
    t.bigint "demo_query_id", null: false
    t.bigint "county_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["county_id"], name: "index_demo_query_counties_on_county_id"
    t.index ["demo_query_id", "county_id"], name: "index_demo_query_counties_on_demo_query_id_and_county_id", unique: true
    t.index ["demo_query_id"], name: "index_demo_query_counties_on_demo_query_id"
  end

  create_table "demo_query_divisions", force: :cascade do |t|
    t.bigint "demo_query_id"
    t.bigint "division_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["demo_query_id", "division_id"], name: "index_demo_query_divisions_on_demo_query_id_and_division_id", unique: true
    t.index ["demo_query_id"], name: "index_demo_query_divisions_on_demo_query_id"
    t.index ["division_id"], name: "index_demo_query_divisions_on_division_id"
  end

  create_table "demo_query_dmas", force: :cascade do |t|
    t.bigint "demo_query_id", null: false
    t.bigint "dma_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["demo_query_id", "dma_id"], name: "index_demo_query_dmas_on_demo_query_id_and_dma_id", unique: true
    t.index ["demo_query_id"], name: "index_demo_query_dmas_on_demo_query_id"
    t.index ["dma_id"], name: "index_demo_query_dmas_on_dma_id"
  end

  create_table "demo_query_msas", force: :cascade do |t|
    t.bigint "demo_query_id", null: false
    t.bigint "msa_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["demo_query_id", "msa_id"], name: "index_demo_query_msas_on_demo_query_id_and_msa_id", unique: true
    t.index ["demo_query_id"], name: "index_demo_query_msas_on_demo_query_id"
    t.index ["msa_id"], name: "index_demo_query_msas_on_msa_id"
  end

  create_table "demo_query_onboardings", force: :cascade do |t|
    t.bigint "demo_query_id", null: false
    t.bigint "onboarding_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["demo_query_id", "onboarding_id"], name: "index_query_onboardings_on_query_id_and_onboarding_id", unique: true
    t.index ["demo_query_id"], name: "index_demo_query_onboardings_on_demo_query_id"
    t.index ["onboarding_id"], name: "index_demo_query_onboardings_on_onboarding_id"
    t.index ["onboarding_id"], name: "tmp_demo_query_onboardings_onboarding_id"
  end

  create_table "demo_query_options", force: :cascade do |t|
    t.bigint "demo_query_id"
    t.bigint "demo_option_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["demo_option_id"], name: "index_demo_query_options_on_demo_option_id"
    t.index ["demo_query_id"], name: "index_demo_query_options_on_demo_query_id"
  end

  create_table "demo_query_pmsas", force: :cascade do |t|
    t.bigint "demo_query_id", null: false
    t.bigint "pmsa_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["demo_query_id", "pmsa_id"], name: "index_demo_query_pmsas_on_demo_query_id_and_pmsa_id", unique: true
    t.index ["demo_query_id"], name: "index_demo_query_pmsas_on_demo_query_id"
    t.index ["pmsa_id"], name: "index_demo_query_pmsas_on_pmsa_id"
  end

  create_table "demo_query_project_inclusions", force: :cascade do |t|
    t.bigint "demo_query_id", null: false
    t.bigint "project_id", null: false
    t.bigint "survey_response_pattern_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug"
    t.index ["demo_query_id"], name: "index_demo_query_project_inclusions_on_demo_query_id"
    t.index ["project_id"], name: "index_demo_query_project_inclusions_on_project_id"
    t.index ["survey_response_pattern_id"], name: "index_project_inclusion_survey_response"
  end

  create_table "demo_query_regions", force: :cascade do |t|
    t.bigint "demo_query_id", null: false
    t.bigint "region_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["demo_query_id", "region_id"], name: "index_demo_query_regions_on_demo_query_id_and_region_id", unique: true
    t.index ["demo_query_id"], name: "index_demo_query_regions_on_demo_query_id"
    t.index ["region_id"], name: "index_demo_query_regions_on_region_id"
  end

  create_table "demo_query_state_codes", force: :cascade do |t|
    t.bigint "demo_query_id"
    t.string "code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["demo_query_id", "code"], name: "index_demo_query_state_codes_on_demo_query_id_and_code", unique: true
    t.index ["demo_query_id"], name: "index_demo_query_state_codes_on_demo_query_id"
  end

  create_table "demo_query_states", force: :cascade do |t|
    t.bigint "demo_query_id", null: false
    t.bigint "state_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["demo_query_id", "state_id"], name: "index_demo_query_states_on_demo_query_id_and_state_id", unique: true
    t.index ["demo_query_id"], name: "index_demo_query_states_on_demo_query_id"
    t.index ["state_id"], name: "index_demo_query_states_on_state_id"
  end

  create_table "demo_query_zips", force: :cascade do |t|
    t.bigint "demo_query_id", null: false
    t.bigint "zip_code_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["demo_query_id", "zip_code_id"], name: "index_demo_query_zips_on_demo_query_id_and_zip_code_id", unique: true
    t.index ["demo_query_id"], name: "index_demo_query_zips_on_demo_query_id"
    t.index ["zip_code_id"], name: "index_demo_query_zips_on_zip_code_id"
  end

  create_table "demo_questions", force: :cascade do |t|
    t.bigint "country_id"
    t.string "input_type", null: false
    t.integer "sort_order", null: false
    t.string "label", null: false
    t.string "import_label"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "body", null: false
    t.string "button_label"
    t.bigint "demo_questions_category_id", null: false
    t.datetime "archived_at"
    t.bigint "follow_up_to_question_id"
    t.text "follow_up_question_ids", default: [], array: true
    t.index ["country_id"], name: "index_demo_questions_on_country_id"
    t.index ["demo_questions_category_id"], name: "index_demo_questions_on_demo_questions_category_id"
    t.index ["follow_up_to_question_id"], name: "index_demo_questions_on_follow_up_to_question_id"
  end

  create_table "demo_questions_categories", force: :cascade do |t|
    t.string "name", null: false
    t.string "slug", null: false
    t.integer "sort_order", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "panel_id", null: false
    t.index ["panel_id"], name: "index_demo_questions_categories_on_panel_id"
  end

  create_table "demographic_detail_results", force: :cascade do |t|
    t.bigint "demographic_detail_id", null: false
    t.text "uid", null: false
    t.bigint "panelist_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["demographic_detail_id"], name: "index_demographic_detail_results_on_demographic_detail_id"
    t.index ["panelist_id"], name: "index_demographic_detail_results_on_panelist_id"
  end

  create_table "demographic_details", force: :cascade do |t|
    t.text "upload_data"
    t.bigint "panel_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["panel_id"], name: "index_demographic_details_on_panel_id"
  end

  create_table "devise_api_tokens", force: :cascade do |t|
    t.string "resource_owner_type", null: false
    t.bigint "resource_owner_id", null: false
    t.string "access_token", null: false
    t.string "refresh_token"
    t.integer "expires_in", null: false
    t.datetime "revoked_at"
    t.string "previous_refresh_token"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["access_token"], name: "index_devise_api_tokens_on_access_token"
    t.index ["previous_refresh_token"], name: "index_devise_api_tokens_on_previous_refresh_token"
    t.index ["refresh_token"], name: "index_devise_api_tokens_on_refresh_token"
    t.index ["resource_owner_type", "resource_owner_id"], name: "index_devise_api_tokens_on_resource_owner"
  end

  create_table "disqo_feasibilities", force: :cascade do |t|
    t.integer "days_in_field"
    t.integer "incidence_rate"
    t.integer "loi"
    t.integer "cpi"
    t.integer "completes_wanted"
    t.jsonb "qualifications", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "number_of_panelists"
    t.bigint "employee_id"
    t.index ["employee_id"], name: "index_disqo_feasibilities_on_employee_id"
  end

  create_table "disqo_quotas", force: :cascade do |t|
    t.string "quota_id"
    t.float "cpi"
    t.integer "completes_wanted"
    t.jsonb "qualifications", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "survey_id"
    t.string "status", default: "paused", null: false
    t.integer "loi", null: false
    t.integer "conversion_rate", null: false
    t.integer "soft_launch_completes_wanted"
    t.datetime "soft_launch_completed_at"
    t.index ["survey_id"], name: "index_disqo_quotas_on_survey_id"
  end

  create_table "divisions", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_divisions_on_name", unique: true
  end

  create_table "dmas", force: :cascade do |t|
    t.string "code"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_dmas_on_code", unique: true
    t.index ["name"], name: "index_dmas_on_name", unique: true
  end

  create_table "earnings", force: :cascade do |t|
    t.bigint "sample_batch_id"
    t.bigint "panelist_id", null: false
    t.integer "total_amount_cents", default: 0, null: false
    t.integer "panelist_amount_cents", default: 0, null: false
    t.integer "nonprofit_amount_cents", default: 0, null: false
    t.bigint "nonprofit_id"
    t.string "period", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "period_year"
    t.bigint "campaign_id"
    t.bigint "onboarding_id"
    t.bigint "earnings_batch_id"
    t.datetime "hidden_at"
    t.bigint "panel_id"
    t.string "category"
    t.index ["campaign_id"], name: "index_earnings_on_campaign_id"
    t.index ["earnings_batch_id"], name: "index_earnings_on_earnings_batch_id"
    t.index ["nonprofit_id"], name: "index_earnings_on_nonprofit_id"
    t.index ["onboarding_id"], name: "index_earnings_on_onboarding_id"
    t.index ["onboarding_id"], name: "tmp_earnings_onboarding_id"
    t.index ["panel_id"], name: "index_earnings_on_panel_id"
    t.index ["panelist_id", "campaign_id"], name: "index_earnings_on_panelist_id_and_campaign_id", unique: true
    t.index ["panelist_id", "sample_batch_id"], name: "index_earnings_on_panelist_id_and_sample_batch_id", unique: true
    t.index ["panelist_id"], name: "index_earnings_on_panelist_id"
    t.index ["period"], name: "index_earnings_on_period"
    t.index ["period_year"], name: "index_earnings_on_period_year"
    t.index ["sample_batch_id"], name: "index_earnings_on_sample_batch_id"
    t.index ["updated_at"], name: "tmp_earnings_updated"
  end

  create_table "earnings_batches", force: :cascade do |t|
    t.integer "amount_cents", null: false
    t.text "ids", null: false
    t.bigint "employee_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "survey_id", null: false
    t.index ["employee_id"], name: "index_earnings_batches_on_employee_id"
    t.index ["survey_id"], name: "index_earnings_batches_on_survey_id"
  end

  create_table "email_confirmation_reminders", force: :cascade do |t|
    t.bigint "panelist_id", null: false
    t.datetime "send_at", null: false
    t.string "status", default: "waiting", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["panelist_id"], name: "index_email_confirmation_reminders_on_panelist_id"
  end

  create_table "email_descriptions", force: :cascade do |t|
    t.string "name", null: false
    t.text "description", null: false
    t.boolean "default", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "employee_ip_histories", force: :cascade do |t|
    t.bigint "employee_id", null: false
    t.bigint "ip_address_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["employee_id"], name: "index_employee_ip_histories_on_employee_id"
    t.index ["ip_address_id"], name: "index_employee_ip_histories_on_ip_address_id"
    t.index ["updated_at"], name: "tmp_ip_employee_ip_histories_at"
  end

  create_table "employee_roles", id: false, force: :cascade do |t|
    t.integer "employee_id"
    t.integer "role_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["employee_id", "role_id"], name: "index_employee_roles_on_employee_id_and_role_id", unique: true
  end

  create_table "employees", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "password_salt", limit: 255, default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "phone"
    t.index ["email"], name: "index_employees_on_email", unique: true
    t.index ["reset_password_token"], name: "index_employees_on_reset_password_token", unique: true
  end

  create_table "expert_recruit_batches", force: :cascade do |t|
    t.bigint "survey_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "description"
    t.string "status", default: "waiting", null: false
    t.string "email_subject", default: "Take this survey", null: false
    t.integer "incentive_cents"
    t.integer "time"
    t.bigint "employee_id"
    t.text "csv_data"
    t.datetime "sent_at"
    t.datetime "reminders_started_at"
    t.datetime "reminders_finished_at"
    t.string "from_email"
    t.boolean "send_for_client", default: false
    t.string "client_phone"
    t.string "client_name"
    t.string "color", default: "#163755"
    t.index ["employee_id"], name: "index_expert_recruit_batches_on_employee_id"
    t.index ["survey_id"], name: "index_expert_recruit_batches_on_survey_id"
  end

  create_table "expert_recruit_unsubscriptions", force: :cascade do |t|
    t.string "email"
    t.bigint "expert_recruit_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["expert_recruit_id"], name: "index_expert_recruit_unsubscriptions_on_expert_recruit_id"
  end

  create_table "expert_recruits", force: :cascade do |t|
    t.string "email", null: false
    t.string "token", null: false
    t.bigint "survey_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "expert_recruit_batch_id"
    t.string "description"
    t.string "first_name"
    t.string "unsubscribe_token"
    t.datetime "clicked_at"
    t.index ["expert_recruit_batch_id"], name: "index_expert_recruits_on_expert_recruit_batch_id"
    t.index ["survey_id"], name: "index_expert_recruits_on_survey_id"
  end

  create_table "gate_surveys", force: :cascade do |t|
    t.string "state"
    t.string "zip"
    t.date "birthdate"
    t.integer "age"
    t.string "gender"
    t.string "income"
    t.string "ethnicity"
    t.integer "onboarding_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "incentive_batches", force: :cascade do |t|
    t.integer "reward_cents"
    t.bigint "employee_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "status", default: "waiting", null: false
    t.text "csv_data"
    t.string "survey_name"
    t.index ["employee_id"], name: "index_incentive_batches_on_employee_id"
  end

  create_table "incentive_recipients", force: :cascade do |t|
    t.string "email_address"
    t.bigint "incentive_batch_id", null: false
    t.string "status", default: "initialized", null: false
    t.boolean "sent", default: false, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "first_name"
    t.string "last_name"
    t.index ["incentive_batch_id"], name: "index_incentive_recipients_on_incentive_batch_id"
  end

  create_table "ip_addresses", force: :cascade do |t|
    t.string "address", null: false
    t.integer "request_count", default: 0, null: false
    t.integer "blocked_count", default: 0, null: false
    t.datetime "blocked_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "category", default: "allow", null: false
    t.string "status", default: "allowed", null: false
    t.string "block_category"
    t.string "blocked_reason"
    t.index ["address"], name: "index_ip_addresses_on_address", unique: true
    t.index ["category"], name: "index_ip_addresses_on_category"
    t.index ["id"], name: "tmp_ip_addresses_id"
    t.index ["updated_at"], name: "tmp_ip_addresses_updated_at"
  end

  create_table "ip_events", force: :cascade do |t|
    t.bigint "ip_address_id", null: false
    t.string "message", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ip_address_id"], name: "index_ip_events_on_ip_address_id"
  end

  create_table "jwt_denylist", force: :cascade do |t|
    t.string "jti", null: false
    t.datetime "exp", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["jti"], name: "index_jwt_denylist_on_jti"
  end

  create_table "keys", force: :cascade do |t|
    t.bigint "project_id"
    t.bigint "campaign_id"
    t.string "value", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "used_at"
    t.bigint "survey_id", null: false
    t.index ["campaign_id"], name: "index_keys_on_campaign_id"
    t.index ["project_id", "value"], name: "index_keys_on_project_id_and_value", unique: true
    t.index ["project_id"], name: "index_keys_on_project_id"
    t.index ["survey_id"], name: "index_keys_on_survey_id"
  end

  create_table "landing_page_emails", force: :cascade do |t|
    t.string "email", null: false
    t.boolean "opt_in", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "msas", force: :cascade do |t|
    t.string "code"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_msas_on_code", unique: true
    t.index ["name"], name: "index_msas_on_name", unique: true
  end

  create_table "nonprofits", force: :cascade do |t|
    t.string "name", null: false
    t.text "mission"
    t.boolean "fully_qualified", default: false, null: false
    t.boolean "front_page", default: false, null: false
    t.string "address_line_1"
    t.string "address_line_2"
    t.string "city"
    t.string "state"
    t.string "zip_code"
    t.bigint "country_id", null: false
    t.string "phone"
    t.string "url"
    t.string "ein"
    t.string "contact_name"
    t.string "contact_title"
    t.string "contact_phone"
    t.string "contact_email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "manager_name"
    t.string "manager_email"
    t.string "logo_file_name"
    t.string "logo_content_type"
    t.integer "logo_file_size"
    t.datetime "logo_updated_at"
    t.datetime "archived_at"
    t.integer "earning_adjustment_cents", default: 0, null: false
    t.index ["country_id"], name: "index_nonprofits_on_country_id"
  end

  create_table "offers", force: :cascade do |t|
    t.string "code", null: false
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_offers_on_code", unique: true
  end

  create_table "onboardings", force: :cascade do |t|
    t.bigint "onramp_id", null: false
    t.string "uid", null: false
    t.string "token", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "recaptcha_token", null: false
    t.string "gate_survey_token", null: false
    t.string "error_message"
    t.datetime "recaptcha_started_at"
    t.datetime "recaptcha_passed_at"
    t.bigint "panelist_id"
    t.bigint "survey_response_pattern_id"
    t.datetime "survey_started_at"
    t.datetime "survey_finished_at"
    t.datetime "failed_onboarding_at"
    t.datetime "bypassed_security_at"
    t.datetime "attempted_again_at"
    t.string "response_token", null: false
    t.datetime "response_page_loaded_at"
    t.datetime "response_token_used_at"
    t.string "error_token", null: false
    t.string "email"
    t.string "affiliate_code"
    t.string "sub_affiliate_code"
    t.datetime "webhook_notification_sent_at"
    t.integer "panel_id"
    t.bigint "project_invitation_id"
    t.bigint "survey_router_source_id"
    t.datetime "fraud_attempted_at"
    t.string "onboarding_token", null: false
    t.bigint "ip_address_id"
    t.string "status", default: "initialized", null: false
    t.string "client_status"
    t.bigint "survey_response_url_id"
    t.datetime "marked_fraud_at"
    t.datetime "marked_post_survey_failed_at"
    t.string "security_status", default: "unsecured", null: false
    t.bigint "recontact_invitation_id"
    t.string "initial_survey_status"
    t.bigint "close_out_reason_id"
    t.datetime "bypassed_all_at"
    t.jsonb "api_params", default: {}
    t.string "rejected_reason"
    t.index ["close_out_reason_id"], name: "index_onboardings_on_close_out_reason_id"
    t.index ["error_token"], name: "index_onboardings_on_error_token", unique: true
    t.index ["gate_survey_token"], name: "index_onboardings_on_gate_survey_token", unique: true
    t.index ["id"], name: "tmp_onboardings_id"
    t.index ["ip_address_id"], name: "index_onboardings_on_ip_address_id"
    t.index ["ip_address_id"], name: "tmp_onboading_ip_address"
    t.index ["onboarding_token"], name: "index_onboardings_on_onboarding_token", unique: true
    t.index ["onramp_id", "uid"], name: "index_onboardings_on_onramp_id_and_uid", unique: true
    t.index ["onramp_id"], name: "index_onboardings_on_onramp_id"
    t.index ["panelist_id"], name: "index_onboardings_on_panelist_id"
    t.index ["project_invitation_id"], name: "index_onboardings_on_project_invitation_id"
    t.index ["recaptcha_token"], name: "index_onboardings_on_recaptcha_token", unique: true
    t.index ["recontact_invitation_id"], name: "index_onboardings_on_recontact_invitation_id"
    t.index ["response_token"], name: "index_onboardings_on_response_token", unique: true
    t.index ["status"], name: "index_onboardings_on_status"
    t.index ["survey_response_pattern_id"], name: "index_onboardings_on_survey_response_pattern_id"
    t.index ["survey_response_url_id"], name: "index_onboardings_on_survey_response_url_id"
    t.index ["survey_router_source_id"], name: "index_onboardings_on_survey_router_source_id"
    t.index ["token"], name: "index_onboardings_on_token", unique: true
    t.index ["uid"], name: "index_onboardings_on_uid"
    t.index ["updated_at"], name: "tmp_onboardings_updated_at"
  end

  create_table "onboardings_back", id: false, force: :cascade do |t|
    t.integer "id"
    t.index ["id"], name: "tmp_onboardings_back_id"
  end

  create_table "onramps", force: :cascade do |t|
    t.string "token", null: false
    t.bigint "vendor_batch_id"
    t.boolean "check_recaptcha", default: false, null: false
    t.boolean "check_gate_survey", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "bypass_token", null: false
    t.datetime "disabled_at"
    t.integer "survey_router_id"
    t.string "category", default: "testing", null: false
    t.bigint "api_vendor_id"
    t.bigint "panel_id"
    t.bigint "survey_id"
    t.boolean "check_clean_id", default: false, null: false
    t.boolean "ignore_security_flags", default: false, null: false
    t.boolean "check_prescreener", default: false, null: false
    t.bigint "cint_survey_id"
    t.bigint "disqo_quota_id"
    t.boolean "has_prescreener_failures"
    t.bigint "schlesinger_quota_id"
    t.index ["api_vendor_id"], name: "index_onramps_on_api_vendor_id"
    t.index ["bypass_token"], name: "index_onramps_on_bypass_token", unique: true
    t.index ["cint_survey_id"], name: "index_onramps_on_cint_survey_id"
    t.index ["disqo_quota_id"], name: "index_onramps_on_disqo_quota_id"
    t.index ["panel_id"], name: "index_onramps_on_panel_id"
    t.index ["schlesinger_quota_id"], name: "index_onramps_on_schlesinger_quota_id"
    t.index ["survey_id"], name: "index_onramps_on_survey_id"
    t.index ["survey_router_id"], name: "index_onramps_on_survey_router_id"
    t.index ["token"], name: "index_onramps_on_token", unique: true
    t.index ["vendor_batch_id"], name: "index_onramps_on_vendor_batch_id"
  end

  create_table "op4g_devices", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "panel_countries", force: :cascade do |t|
    t.bigint "panel_id", null: false
    t.bigint "country_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["country_id"], name: "index_panel_countries_on_country_id"
    t.index ["panel_id"], name: "index_panel_countries_on_panel_id"
  end

  create_table "panel_memberships", force: :cascade do |t|
    t.bigint "panel_id", null: false
    t.bigint "panelist_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["panel_id", "panelist_id"], name: "index_panel_memberships_on_panel_id_and_panelist_id", unique: true
    t.index ["panel_id"], name: "index_panel_memberships_on_panel_id"
    t.index ["panelist_id"], name: "index_panel_memberships_on_panelist_id"
  end

  create_table "panelist_ip_histories", force: :cascade do |t|
    t.bigint "panelist_id", null: false
    t.bigint "ip_address_id", null: false
    t.string "source", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ip_address_id"], name: "index_panelist_ip_histories_on_ip_address_id"
    t.index ["panelist_id"], name: "index_panelist_ip_histories_on_panelist_id"
  end

  create_table "panelist_notes", force: :cascade do |t|
    t.integer "panelist_id", null: false
    t.integer "employee_id", null: false
    t.string "body", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "panelist_status_events", force: :cascade do |t|
    t.bigint "panelist_id", null: false
    t.string "status", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["panelist_id"], name: "index_panelist_status_events_on_panelist_id"
  end

  create_table "panelists", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email", null: false
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "postal_code"
    t.bigint "country_id"
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "password_salt"
    t.string "locale", default: "en", null: false
    t.string "address"
    t.string "city"
    t.string "state"
    t.bigint "zip_code_id"
    t.string "token", null: false
    t.integer "age"
    t.date "update_age_at"
    t.date "birthdate"
    t.string "search_terms"
    t.datetime "suspended_at"
    t.datetime "agreed_to_terms_at"
    t.bigint "campaign_id"
    t.bigint "original_panel_id", null: false
    t.string "offer_code"
    t.string "affiliate_code"
    t.string "sub_affiliate_code"
    t.string "sub_affiliate_code_2"
    t.bigint "nonprofit_id"
    t.bigint "original_nonprofit_id"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.integer "donation_percentage", default: 0, null: false
    t.string "address_line_two"
    t.datetime "deleted_at"
    t.integer "original_donation_percentage", default: 0, null: false
    t.integer "legacy_earnings_cents", default: 0, null: false
    t.integer "flag_count"
    t.datetime "welcomed_at"
    t.bigint "archived_nonprofit_id"
    t.datetime "deactivated_at"
    t.datetime "last_activity_at"
    t.string "status", default: "signing_up", null: false
    t.bigint "primary_panel_id", null: false
    t.datetime "in_danger_at"
    t.datetime "last_invited_at"
    t.jsonb "clean_id_data", default: {}
    t.bigint "clean_id_device_id"
    t.string "facebook_authorized"
    t.string "facebook_image"
    t.string "facebook_uid"
    t.string "provider"
    t.boolean "lock_flag", default: false
    t.boolean "verified_flag", default: false
    t.datetime "paypal_verified_at"
    t.string "paypal_uid"
    t.integer "score"
    t.integer "score_percentile"
    t.string "paypal_verification_status", default: "unverified", null: false
    t.integer "average_reaction_time"
    t.boolean "suspend_and_pay_status", default: false
    t.string "business_name"
    t.boolean "using_mailchimp"
    t.boolean "premium"
    t.string "id_card_file_name"
    t.string "id_card_content_type"
    t.bigint "id_card_file_size"
    t.datetime "id_card_updated_at"
    t.boolean "passed_clean_id_previous_version"
    t.index ["affiliate_code"], name: "index_panelists_on_affiliate_code"
    t.index ["archived_nonprofit_id"], name: "index_panelists_on_archived_nonprofit_id"
    t.index ["campaign_id"], name: "index_panelists_on_campaign_id"
    t.index ["clean_id_device_id"], name: "index_panelists_on_clean_id_device_id"
    t.index ["confirmation_token"], name: "index_panelists_on_confirmation_token", unique: true
    t.index ["country_id"], name: "index_panelists_on_country_id"
    t.index ["email"], name: "index_panelists_on_email", unique: true
    t.index ["nonprofit_id"], name: "index_panelists_on_nonprofit_id"
    t.index ["offer_code"], name: "index_panelists_on_offer_code"
    t.index ["original_nonprofit_id"], name: "index_panelists_on_original_nonprofit_id"
    t.index ["original_panel_id"], name: "index_panelists_on_original_panel_id"
    t.index ["primary_panel_id"], name: "index_panelists_on_primary_panel_id"
    t.index ["reset_password_token"], name: "index_panelists_on_reset_password_token", unique: true
    t.index ["status"], name: "index_panelists_on_status"
    t.index ["token"], name: "index_panelists_on_token", unique: true
    t.index ["updated_at"], name: "tmp_panelists_at"
    t.index ["zip_code_id"], name: "index_panelists_on_zip_code_id"
  end

  create_table "panels", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "abbreviation"
    t.string "slug", null: false
    t.string "landing_page_title"
    t.text "landing_page_content"
    t.integer "incentive_cents"
    t.string "status", default: "active"
    t.bigint "country_id"
    t.string "category", default: "standard", null: false
    t.index ["country_id"], name: "index_panels_on_country_id"
    t.index ["name"], name: "index_panels_on_name", unique: true
    t.index ["slug"], name: "index_panels_on_slug", unique: true
  end

  create_table "payment_upload_batches", force: :cascade do |t|
    t.datetime "paid_at", null: false
    t.string "period", null: false
    t.text "payment_data", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "employee_id", null: false
    t.text "error_data"
    t.index ["employee_id"], name: "index_payment_upload_batches_on_employee_id"
  end

  create_table "payments", force: :cascade do |t|
    t.bigint "panelist_id", null: false
    t.integer "amount_cents", default: 0, null: false
    t.datetime "paid_at", null: false
    t.string "period", null: false
    t.datetime "voided_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "period_year"
    t.datetime "hidden_at"
    t.bigint "payment_upload_batch_id"
    t.string "description"
    t.index ["panelist_id"], name: "index_payments_on_panelist_id"
    t.index ["payment_upload_batch_id"], name: "index_payments_on_payment_upload_batch_id"
    t.index ["period"], name: "index_payments_on_period"
    t.index ["period_year"], name: "index_payments_on_period_year"
  end

  create_table "pmsas", force: :cascade do |t|
    t.string "code"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_pmsas_on_code", unique: true
    t.index ["name"], name: "index_pmsas_on_name", unique: true
  end

  create_table "prescreener_answer_templates", force: :cascade do |t|
    t.string "body", null: false
    t.boolean "target", default: false
    t.bigint "prescreener_question_template_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "sort_order"
    t.index ["prescreener_question_template_id"], name: "question_template"
  end

  create_table "prescreener_library_questions", force: :cascade do |t|
    t.string "question", null: false
    t.text "answers", default: [], array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "prescreener_question_templates", force: :cascade do |t|
    t.string "body"
    t.bigint "survey_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "sort_order"
    t.string "question_type", default: "single_answer", null: false
    t.string "passing_criteria", default: "pass_if_any_selected", null: false
    t.text "temporary_answers", default: [], array: true
    t.string "status", default: "active"
    t.index ["survey_id"], name: "index_prescreener_question_templates_on_survey_id"
  end

  create_table "prescreener_questions", force: :cascade do |t|
    t.string "body"
    t.bigint "onboarding_id", null: false
    t.string "token", null: false
    t.string "status", default: "incomplete"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "sort_order"
    t.string "question_type"
    t.string "passing_criteria"
    t.bigint "prescreener_question_template_id"
    t.string "answer_options", default: [], array: true
    t.string "target_answers", default: [], array: true
    t.string "selected_answers", default: [], array: true
    t.boolean "failed"
    t.index ["onboarding_id"], name: "index_prescreener_questions_on_onboarding_id"
    t.index ["onboarding_id"], name: "tmp_prescreener_questions_onboarding_id"
    t.index ["prescreener_question_template_id"], name: "index_prescreener_questions_on_prescreener_question_template_id"
    t.index ["token"], name: "index_prescreener_questions_on_token", unique: true
    t.index ["updated_at"], name: "tmp_prescreener_questions_updated_at"
  end

  create_table "project_invitations", force: :cascade do |t|
    t.bigint "project_id", null: false
    t.bigint "panelist_id", null: false
    t.bigint "sample_batch_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "survey_id", null: false
    t.datetime "sent_at"
    t.string "token", null: false
    t.datetime "clicked_at"
    t.datetime "finished_at"
    t.datetime "declined_at"
    t.datetime "reminded_at"
    t.datetime "tmp_finished_at"
    t.string "status", default: "initialized", null: false
    t.datetime "rejected_at"
    t.datetime "paid_at"
    t.integer "group"
    t.index ["panelist_id"], name: "index_project_invitations_on_panelist_id"
    t.index ["project_id"], name: "index_project_invitations_on_project_id"
    t.index ["sample_batch_id", "panelist_id"], name: "index_project_invitations_on_sample_batch_id_and_panelist_id", unique: true
    t.index ["sample_batch_id"], name: "index_project_invitations_on_sample_batch_id"
    t.index ["status"], name: "index_project_invitations_on_status"
    t.index ["survey_id", "panelist_id"], name: "index_project_invitations_on_survey_id_and_panelist_id", unique: true
    t.index ["survey_id"], name: "index_project_invitations_on_survey_id"
    t.index ["token"], name: "index_project_invitations_on_token", unique: true
    t.index ["updated_at"], name: "tmp_ip_project_invitations_at"
  end

  create_table "project_reports", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "report_file_name"
    t.string "report_content_type"
    t.integer "report_file_size"
    t.datetime "report_updated_at"
  end

  create_table "projects", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "client_id"
    t.bigint "salesperson_id"
    t.bigint "manager_id"
    t.integer "work_order"
    t.text "notes"
    t.string "payment_token", null: false
    t.datetime "started_at"
    t.datetime "finished_at"
    t.string "relevant_id_level", default: "survey", null: false
    t.string "relevant_id_token", null: false
    t.datetime "waiting_at"
    t.string "close_out_status", default: "waiting", null: false
    t.integer "deleted_sent_invitations_count"
    t.string "product_name"
    t.boolean "unbranded", default: false, null: false
    t.date "estimated_start_date"
    t.date "estimated_complete_date"
    t.date "start_date"
    t.date "complete_date"
    t.index ["client_id"], name: "index_projects_on_client_id"
    t.index ["manager_id"], name: "index_projects_on_manager_id"
    t.index ["payment_token"], name: "index_projects_on_payment_token", unique: true
    t.index ["salesperson_id"], name: "index_projects_on_salesperson_id"
  end

  create_table "recontact_invitation_batches", force: :cascade do |t|
    t.text "encoded_uids"
    t.string "status", default: "initialized", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "incentive_cents"
    t.string "subject"
    t.text "email_body"
    t.bigint "survey_id"
    t.text "csv_data"
    t.index ["survey_id"], name: "index_recontact_invitation_batches_on_survey_id"
  end

  create_table "recontact_invitations", force: :cascade do |t|
    t.bigint "recontact_invitation_batch_id", null: false
    t.string "uid", null: false
    t.bigint "onboarding_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "token", null: false
    t.string "status", default: "unsent", null: false
    t.string "url"
    t.index ["onboarding_id"], name: "index_recontact_invitations_on_onboarding_id"
    t.index ["recontact_invitation_batch_id"], name: "index_recontact_invitations_on_recontact_invitation_batch_id"
    t.index ["token"], name: "index_recontact_invitations_on_token", unique: true
  end

  create_table "recruiting_campaigns", force: :cascade do |t|
    t.string "code", null: false
    t.boolean "incentive_flag", default: false, null: false
    t.integer "incentive_cents"
    t.datetime "campaign_started_at"
    t.datetime "campaign_stopped_at"
    t.integer "max_signups"
    t.string "description"
    t.boolean "project_zero_flag", default: false, null: false
    t.string "source_label"
    t.string "group_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "campaignable_type"
    t.bigint "campaignable_id"
    t.boolean "lock_flag", default: false
    t.boolean "business_name_flag", default: false
    t.index ["campaignable_type", "campaignable_id"], name: "index_campaigns_on_campaignable_type_and_campaignable_id"
    t.index ["code"], name: "index_recruiting_campaigns_on_code", unique: true
  end

  create_table "redirect_logs", force: :cascade do |t|
    t.text "url", null: false
    t.bigint "survey_response_url_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["survey_response_url_id"], name: "index_redirect_logs_on_survey_response_url_id"
  end

  create_table "regions", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_regions_on_name", unique: true
  end

  create_table "return_key_onboardings", force: :cascade do |t|
    t.bigint "return_key_id"
    t.bigint "onboarding_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["onboarding_id"], name: "index_return_key_onboardings_on_onboarding_id"
    t.index ["onboarding_id"], name: "tmp_return_key_onboardings_onboarding_id"
    t.index ["return_key_id"], name: "index_return_key_onboardings_on_return_key_id"
  end

  create_table "return_keys", force: :cascade do |t|
    t.string "token", null: false
    t.bigint "survey_id", null: false
    t.datetime "used_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["survey_id"], name: "index_return_keys_on_survey_id"
    t.index ["token"], name: "index_return_keys_on_token", unique: true
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sample_batches", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "count", null: false
    t.datetime "sent_at"
    t.integer "incentive_cents", null: false
    t.bigint "demo_query_id", null: false
    t.string "label"
    t.string "email_subject", null: false
    t.text "description"
    t.datetime "closed_at"
    t.datetime "invitations_created_at"
    t.datetime "reminders_finished_at"
    t.datetime "reminders_started_at"
    t.datetime "invitations_started_at"
    t.datetime "triggered_at"
    t.boolean "soft_launch_batch", default: false, null: false
    t.index ["demo_query_id"], name: "index_sample_batches_on_demo_query_id"
  end

  create_table "schlesinger_qualification_answers", primary_key: "answer_id", force: :cascade do |t|
    t.string "text"
    t.string "answer_code"
    t.bigint "qualification_question_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "schlesinger_qualification_questions", primary_key: "qualification_id", force: :cascade do |t|
    t.string "name"
    t.string "text"
    t.integer "qualification_category_id"
    t.integer "qualification_type_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "slug"
    t.index ["slug"], name: "index_schlesinger_qualification_questions_on_slug"
  end

  create_table "schlesinger_quotas", force: :cascade do |t|
    t.string "name"
    t.float "cpi"
    t.string "schlesinger_project_id"
    t.string "schlesinger_survey_id"
    t.string "schlesinger_quota_id"
    t.integer "completes_wanted"
    t.jsonb "qualifications", default: {}
    t.string "status", default: "awarded", null: false
    t.integer "loi", null: false
    t.integer "conversion_rate", null: false
    t.integer "soft_launch_completes_wanted"
    t.datetime "soft_launch_completed_at"
    t.bigint "survey_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "industry_id"
    t.datetime "start_date_time"
    t.datetime "end_date_time"
    t.bigint "study_type_id"
    t.bigint "sample_type_id"
    t.index ["survey_id"], name: "index_schlesinger_quotas_on_survey_id"
  end

  create_table "signup_reminders", force: :cascade do |t|
    t.bigint "panelist_id", null: false
    t.datetime "send_at"
    t.string "status", default: "waiting"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["panelist_id"], name: "index_signup_reminders_on_panelist_id"
  end

  create_table "states", force: :cascade do |t|
    t.string "code"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_states_on_code", unique: true
    t.index ["name"], name: "index_states_on_name", unique: true
  end

  create_table "survey_adjustments", force: :cascade do |t|
    t.bigint "survey_id", null: false
    t.integer "offset", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["survey_id"], name: "index_survey_adjustments_on_survey_id"
  end

  create_table "survey_api_targets", force: :cascade do |t|
    t.string "genders", array: true
    t.string "countries", null: false, array: true
    t.string "status", default: "inactive", null: false
    t.bigint "survey_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "age_range", default: [], array: true
    t.integer "payout_cents", null: false
    t.string "states", array: true
    t.string "education", array: true
    t.string "employment", array: true
    t.string "income", array: true
    t.string "race", array: true
    t.string "number_of_employees", array: true
    t.string "job_title", array: true
    t.string "decision_maker", array: true
    t.string "custom_option"
    t.index ["survey_id"], name: "index_survey_api_targets_on_survey_id"
  end

  create_table "survey_response_patterns", force: :cascade do |t|
    t.string "slug", null: false
    t.string "name", null: false
    t.integer "sort", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "survey_response_urls", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "token", null: false
    t.bigint "project_id", null: false
    t.string "slug"
    t.index ["project_id"], name: "index_survey_response_urls_on_project_id"
    t.index ["token"], name: "index_survey_response_urls_on_token", unique: true
  end

  create_table "survey_router_sources", force: :cascade do |t|
    t.integer "router_id", null: false
    t.string "code", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "token"
    t.index ["router_id"], name: "index_survey_router_sources_on_router_id"
    t.index ["token"], name: "index_survey_router_sources_on_token", unique: true
  end

  create_table "survey_router_visitors", force: :cascade do |t|
    t.integer "survey_router_source_id"
    t.string "uid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "age"
    t.string "gender"
    t.string "email"
    t.string "state"
    t.string "income"
    t.string "token"
    t.index ["survey_router_source_id", "uid"], name: "index_survey_router_visitors_on_survey_router_source_id_and_uid", unique: true
    t.index ["token"], name: "index_survey_router_visitors_on_token", unique: true
  end

  create_table "survey_router_visits", force: :cascade do |t|
    t.bigint "survey_router_visitor_id", null: false
    t.string "visit_code", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["survey_router_visitor_id"], name: "index_survey_router_visits_on_survey_router_visitor_id"
    t.index ["visit_code"], name: "index_survey_router_visits_on_visit_code", unique: true
  end

  create_table "survey_routers", force: :cascade do |t|
    t.string "name", null: false
    t.integer "amount_cents", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "bypass_token", null: false
    t.index ["bypass_token"], name: "index_survey_routers_on_bypass_token", unique: true
  end

  create_table "survey_test_modes", force: :cascade do |t|
    t.boolean "easy_test", default: false, null: false
    t.bigint "employee_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["employee_id"], name: "index_survey_test_modes_on_employee_id"
  end

  create_table "survey_warnings", force: :cascade do |t|
    t.string "category", default: "unfiltered", null: false
    t.bigint "survey_id", null: false
    t.bigint "sample_batch_id"
    t.string "status", default: "active", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["sample_batch_id"], name: "index_survey_warnings_on_sample_batch_id"
    t.index ["survey_id"], name: "index_survey_warnings_on_survey_id"
  end

  create_table "surveys", force: :cascade do |t|
    t.string "base_link"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "token", null: false
    t.string "name", null: false
    t.integer "loi"
    t.integer "target"
    t.integer "cpi_cents"
    t.boolean "prevent_overlapping_invitations", default: false, null: false
    t.integer "router_id"
    t.integer "router_filter_min_age"
    t.integer "router_filter_max_age"
    t.string "router_filter_gender"
    t.integer "router_filter_max_completed"
    t.string "router_filter_states", array: true
    t.string "router_filter_incomes", array: true
    t.bigint "project_id", null: false
    t.datetime "added_to_api_at"
    t.text "temporary_keys", array: true
    t.string "category", null: false
    t.string "language"
    t.string "status", default: "draft", null: false
    t.datetime "finished_at"
    t.datetime "started_at"
    t.datetime "waiting_at"
    t.bigint "country_id"
    t.string "audience"
    t.string "client_test_link"
    t.index ["country_id"], name: "index_surveys_on_country_id"
    t.index ["project_id"], name: "index_surveys_on_project_id"
    t.index ["router_filter_incomes"], name: "index_surveys_on_router_filter_incomes", using: :gin
    t.index ["router_filter_states"], name: "index_surveys_on_router_filter_states", using: :gin
    t.index ["router_id"], name: "index_surveys_on_router_id"
    t.index ["token"], name: "index_surveys_on_token", unique: true
  end

  create_table "system_event_summaries", force: :cascade do |t|
    t.datetime "day_happened_at", null: false
    t.string "action", null: false
    t.integer "count", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["day_happened_at", "action"], name: "index_system_event_summaries_on_day_happened_at_and_action", unique: true
  end

  create_table "system_events", force: :cascade do |t|
    t.text "description", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "happened_at", null: false
    t.bigint "employee_id"
    t.bigint "api_token_id"
    t.index ["api_token_id"], name: "index_system_events_on_api_token_id"
    t.index ["employee_id"], name: "index_system_events_on_employee_id"
  end

  create_table "target_types", force: :cascade do |t|
    t.string "name", default: ""
    t.string "description", default: ""
  end

  create_table "tblRFP", force: :cascade do |t|
    t.bigint "project_id", null: false
    t.integer "total_n_size", default: 0, null: false
    t.integer "no_of_countries", default: 1, null: false
    t.integer "no_of_open_ends", null: false
    t.boolean "pi", default: false, null: false
    t.boolean "tracker", default: false, null: false
    t.boolean "qualfollowup", default: false, null: false
    t.text "additional_details"
    t.bigint "assigned_to_id"
    t.datetime "bid_due_date", default: -> { "CURRENT_TIMESTAMP" }
    t.string "status", default: "open", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["assigned_to_id"], name: "index_tblRFP_on_assigned_to_id"
    t.index ["project_id"], name: "index_tblRFP_on_project_id"
  end

  create_table "tblRFPCountries", force: :cascade do |t|
    t.bigint "tblRFP_id"
    t.bigint "country_id", null: false
    t.index ["country_id"], name: "index_tblRFPCountries_on_country_id"
    t.index ["tblRFP_id"], name: "index_tblRFPCountries_on_tblRFP_id"
  end

  create_table "tblRFPTargetQualifications", force: :cascade do |t|
    t.bigint "tblRFP_id", null: false
    t.bigint "target_id", null: false
    t.string "field_name", default: "", null: false
    t.string "field_value", default: "", null: false
    t.index ["target_id"], name: "index_tblRFPTargetQualifications_on_target_id"
    t.index ["tblRFP_id"], name: "index_tblRFPTargetQualifications_on_tblRFP_id"
  end

  create_table "tblRFPTargets", force: :cascade do |t|
    t.bigint "tblRFP_id", null: false
    t.bigint "country_id", null: false
    t.string "name", default: "1", null: false
    t.integer "ir"
    t.integer "loi"
    t.integer "nsize"
    t.integer "quotas", default: 0, null: false
    t.bigint "target_type_id"
    t.string "feasible_detail", default: "[]"
    t.string "cpi_detail", default: "[]"
    t.index ["country_id"], name: "index_tblRFPTargets_on_country_id"
    t.index ["target_type_id"], name: "index_tblRFPTargets_on_target_type_id"
    t.index ["tblRFP_id"], name: "index_tblRFPTargets_on_tblRFP_id"
  end

  create_table "tblRFPVendors", force: :cascade do |t|
    t.bigint "tblRFP_id", null: false
    t.bigint "vendor_id", null: false
    t.bigint "rfp_target_id", null: false
    t.integer "feasible_count", default: 0, null: false
    t.integer "cpi", default: 0, null: false
    t.string "status", default: "open", null: false
    t.index ["rfp_target_id"], name: "index_tblRFPVendors_on_rfp_target_id"
    t.index ["tblRFP_id"], name: "index_tblRFPVendors_on_tblRFP_id"
    t.index ["vendor_id"], name: "index_tblRFPVendors_on_vendor_id"
  end

  create_table "test_uids", force: :cascade do |t|
    t.bigint "onramp_id", null: false
    t.bigint "employee_id", null: false
    t.integer "uid", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["employee_id"], name: "index_test_uids_on_employee_id"
    t.index ["onramp_id", "employee_id", "uid"], name: "index_test_uids_on_onramp_id_and_employee_id_and_uid", unique: true
    t.index ["onramp_id"], name: "index_test_uids_on_onramp_id"
  end

  create_table "tracking_pixels", force: :cascade do |t|
    t.string "url", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "category", null: false
    t.string "description"
    t.index ["category"], name: "index_tracking_pixels_on_category"
    t.index ["url"], name: "index_tracking_pixels_on_url", unique: true
  end

  create_table "traffic_checks", force: :cascade do |t|
    t.bigint "traffic_step_id", null: false
    t.string "controller_action", null: false
    t.string "status", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.json "data_collected"
    t.bigint "ip_address_id"
    t.index ["id"], name: "tmp_ip_traffic_checks_id"
    t.index ["ip_address_id"], name: "index_traffic_checks_on_ip_address_id"
    t.index ["ip_address_id"], name: "tmp_ip_traffic_checks_at"
    t.index ["traffic_step_id"], name: "index_traffic_checks_on_traffic_step_id"
  end

  create_table "traffic_events", force: :cascade do |t|
    t.bigint "onboarding_id", null: false
    t.string "category", null: false
    t.string "message", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "traffic_check_id"
    t.string "url"
    t.index ["category"], name: "index_traffic_events_on_category"
    t.index ["id"], name: "tmp_traffic_events_at"
    t.index ["id"], name: "tmp_traffic_events_id"
    t.index ["onboarding_id"], name: "index_traffic_events_on_onboarding_id"
    t.index ["traffic_check_id"], name: "index_traffic_events_on_traffic_check_id"
    t.index ["traffic_check_id"], name: "tmp_traffic_events_check_id"
  end

  create_table "traffic_reports", force: :cascade do |t|
    t.string "report_type"
    t.string "report_file_name"
    t.string "report_content_type"
    t.integer "report_file_size"
    t.datetime "report_updated_at"
    t.bigint "campaign_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "survey_id"
    t.index ["campaign_id"], name: "index_traffic_reports_on_campaign_id"
    t.index ["survey_id"], name: "index_traffic_reports_on_survey_id"
  end

  create_table "traffic_step_lookups", force: :cascade do |t|
    t.text "uids", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "traffic_steps", force: :cascade do |t|
    t.bigint "onboarding_id", null: false
    t.integer "sort_order", default: 0, null: false
    t.string "when"
    t.string "category"
    t.string "token", null: false
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["id"], name: "tmp_traffic_steps_id"
    t.index ["onboarding_id"], name: "index_traffic_steps_on_onboarding_id"
    t.index ["token"], name: "index_traffic_steps_on_token", unique: true
  end

  create_table "unsubscriptions", force: :cascade do |t|
    t.string "email"
    t.bigint "panelist_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["panelist_id"], name: "index_unsubscriptions_on_panelist_id"
  end

  create_table "vendor_batches", force: :cascade do |t|
    t.bigint "vendor_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "campaign_id"
    t.integer "incentive_cents", null: false
    t.integer "invitation_count"
    t.string "complete_url"
    t.string "terminate_url"
    t.string "overquota_url"
    t.string "security_url"
    t.bigint "survey_id"
    t.integer "quoted_completes"
    t.integer "requested_completes"
    t.index ["campaign_id", "vendor_id"], name: "index_vendor_batches_on_campaign_id_and_vendor_id", unique: true
    t.index ["campaign_id"], name: "index_vendor_batches_on_campaign_id"
    t.index ["survey_id"], name: "index_vendor_batches_on_survey_id"
    t.index ["vendor_id"], name: "index_vendor_batches_on_vendor_id"
  end

  create_table "vendors", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "abbreviation"
    t.string "complete_url"
    t.string "terminate_url"
    t.string "overquota_url"
    t.string "security_url"
    t.boolean "gate_survey_on_by_default", default: false, null: false
    t.string "complete_webhook_url"
    t.boolean "active", default: true, null: false
    t.string "uid_parameter"
    t.boolean "collect_followup_data", default: false, null: false
    t.boolean "security_disabled_by_default", default: false, null: false
    t.boolean "disable_redirects", default: false, null: false
    t.text "follow_up_wording"
    t.boolean "send_complete_webhook", default: false, null: false
    t.boolean "send_secondary_webhook", default: false, null: false
    t.string "secondary_webhook_url"
    t.string "hash_key"
    t.string "webhook_method", default: "post", null: false
    t.text "contact_info"
    t.string "hashing_param"
    t.boolean "include_hashing_param_in_hash_data", default: false, null: false
  end

  create_table "zip_codes", force: :cascade do |t|
    t.string "code", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "msa_id"
    t.bigint "pmsa_id"
    t.bigint "dma_id"
    t.bigint "state_id", null: false
    t.bigint "region_id", null: false
    t.bigint "division_id", null: false
    t.bigint "county_id"
    t.index ["code"], name: "index_zip_codes_on_code", unique: true
    t.index ["county_id"], name: "index_zip_codes_on_county_id"
    t.index ["division_id"], name: "index_zip_codes_on_division_id"
    t.index ["dma_id"], name: "index_zip_codes_on_dma_id"
    t.index ["msa_id"], name: "index_zip_codes_on_msa_id"
    t.index ["pmsa_id"], name: "index_zip_codes_on_pmsa_id"
    t.index ["region_id"], name: "index_zip_codes_on_region_id"
    t.index ["state_id"], name: "index_zip_codes_on_state_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "api_tokens", "vendors"
  add_foreign_key "campaigns", "projects"
  add_foreign_key "cint_events", "cint_surveys"
  add_foreign_key "cint_feasibilities", "employees"
  add_foreign_key "cint_surveys", "surveys"
  add_foreign_key "client_sent_survey_invitations", "onramps"
  add_foreign_key "client_sent_surveys", "employees"
  add_foreign_key "client_sent_surveys", "surveys"
  add_foreign_key "complete_milestones", "surveys"
  add_foreign_key "conversions", "affiliates"
  add_foreign_key "conversions", "offers"
  add_foreign_key "decodings", "employees"
  add_foreign_key "demo_answers", "demo_options"
  add_foreign_key "demo_answers", "panelists"
  add_foreign_key "demo_options", "demo_questions"
  add_foreign_key "demo_queries", "campaigns"
  add_foreign_key "demo_queries", "clients"
  add_foreign_key "demo_queries", "countries"
  add_foreign_key "demo_queries", "employees"
  add_foreign_key "demo_queries", "panels"
  add_foreign_key "demo_queries", "surveys"
  add_foreign_key "demo_query_ages", "ages"
  add_foreign_key "demo_query_ages", "demo_queries"
  add_foreign_key "demo_query_counties", "counties"
  add_foreign_key "demo_query_counties", "demo_queries"
  add_foreign_key "demo_query_divisions", "demo_queries"
  add_foreign_key "demo_query_divisions", "divisions"
  add_foreign_key "demo_query_dmas", "demo_queries"
  add_foreign_key "demo_query_dmas", "dmas"
  add_foreign_key "demo_query_msas", "demo_queries"
  add_foreign_key "demo_query_msas", "msas"
  add_foreign_key "demo_query_onboardings", "demo_queries"
  add_foreign_key "demo_query_options", "demo_options"
  add_foreign_key "demo_query_options", "demo_queries"
  add_foreign_key "demo_query_pmsas", "demo_queries"
  add_foreign_key "demo_query_pmsas", "pmsas"
  add_foreign_key "demo_query_project_inclusions", "demo_queries"
  add_foreign_key "demo_query_project_inclusions", "projects"
  add_foreign_key "demo_query_project_inclusions", "survey_response_patterns"
  add_foreign_key "demo_query_regions", "demo_queries"
  add_foreign_key "demo_query_regions", "regions"
  add_foreign_key "demo_query_state_codes", "demo_queries"
  add_foreign_key "demo_query_states", "demo_queries"
  add_foreign_key "demo_query_states", "states"
  add_foreign_key "demo_query_zips", "demo_queries"
  add_foreign_key "demo_query_zips", "zip_codes"
  add_foreign_key "demo_questions", "countries"
  add_foreign_key "demo_questions", "demo_questions", column: "follow_up_to_question_id"
  add_foreign_key "demo_questions", "demo_questions_categories"
  add_foreign_key "demo_questions_categories", "panels"
  add_foreign_key "demographic_detail_results", "demographic_details"
  add_foreign_key "demographic_detail_results", "panelists"
  add_foreign_key "demographic_details", "panels"
  add_foreign_key "disqo_feasibilities", "employees"
  add_foreign_key "disqo_quotas", "surveys"
  add_foreign_key "earnings", "earnings_batches"
  add_foreign_key "earnings", "nonprofits"
  add_foreign_key "earnings", "panelists"
  add_foreign_key "earnings", "panels"
  add_foreign_key "earnings", "recruiting_campaigns", column: "campaign_id"
  add_foreign_key "earnings", "sample_batches"
  add_foreign_key "earnings_batches", "employees"
  add_foreign_key "earnings_batches", "surveys"
  add_foreign_key "email_confirmation_reminders", "panelists"
  add_foreign_key "employee_roles", "employees"
  add_foreign_key "employee_roles", "roles"
  add_foreign_key "expert_recruit_batches", "employees"
  add_foreign_key "expert_recruit_batches", "surveys"
  add_foreign_key "expert_recruits", "expert_recruit_batches"
  add_foreign_key "expert_recruits", "surveys"
  add_foreign_key "incentive_batches", "employees"
  add_foreign_key "incentive_recipients", "incentive_batches"
  add_foreign_key "ip_events", "ip_addresses"
  add_foreign_key "keys", "campaigns"
  add_foreign_key "keys", "projects"
  add_foreign_key "keys", "surveys"
  add_foreign_key "nonprofits", "countries"
  add_foreign_key "onboardings", "close_out_reasons"
  add_foreign_key "onboardings", "ip_addresses"
  add_foreign_key "onboardings", "onramps"
  add_foreign_key "onboardings", "panelists"
  add_foreign_key "onboardings", "project_invitations"
  add_foreign_key "onboardings", "recontact_invitations"
  add_foreign_key "onboardings", "survey_response_patterns"
  add_foreign_key "onboardings", "survey_response_urls"
  add_foreign_key "onboardings", "survey_router_sources"
  add_foreign_key "onramps", "cint_surveys"
  add_foreign_key "onramps", "disqo_quotas"
  add_foreign_key "onramps", "panels"
  add_foreign_key "onramps", "schlesinger_quotas"
  add_foreign_key "onramps", "survey_routers"
  add_foreign_key "onramps", "surveys"
  add_foreign_key "onramps", "vendor_batches"
  add_foreign_key "onramps", "vendors", column: "api_vendor_id"
  add_foreign_key "panel_countries", "countries"
  add_foreign_key "panel_countries", "panels"
  add_foreign_key "panel_memberships", "panelists"
  add_foreign_key "panel_memberships", "panels"
  add_foreign_key "panelist_notes", "employees"
  add_foreign_key "panelist_notes", "panelists"
  add_foreign_key "panelist_status_events", "panelists"
  add_foreign_key "panelists", "clean_id_devices"
  add_foreign_key "panelists", "countries"
  add_foreign_key "panelists", "nonprofits"
  add_foreign_key "panelists", "nonprofits", column: "archived_nonprofit_id"
  add_foreign_key "panelists", "nonprofits", column: "original_nonprofit_id"
  add_foreign_key "panelists", "panels", column: "original_panel_id"
  add_foreign_key "panelists", "panels", column: "primary_panel_id"
  add_foreign_key "panelists", "recruiting_campaigns", column: "campaign_id"
  add_foreign_key "panelists", "zip_codes"
  add_foreign_key "panels", "countries"
  add_foreign_key "payment_upload_batches", "employees"
  add_foreign_key "payments", "panelists"
  add_foreign_key "payments", "payment_upload_batches"
  add_foreign_key "prescreener_answer_templates", "prescreener_question_templates"
  add_foreign_key "prescreener_question_templates", "surveys"
  add_foreign_key "prescreener_questions", "prescreener_question_templates"
  add_foreign_key "project_invitations", "panelists"
  add_foreign_key "project_invitations", "projects"
  add_foreign_key "project_invitations", "sample_batches"
  add_foreign_key "project_invitations", "surveys"
  add_foreign_key "projects", "clients"
  add_foreign_key "projects", "employees", column: "manager_id"
  add_foreign_key "projects", "employees", column: "salesperson_id"
  add_foreign_key "recontact_invitation_batches", "surveys"
  add_foreign_key "recontact_invitations", "recontact_invitation_batches"
  add_foreign_key "redirect_logs", "survey_response_urls"
  add_foreign_key "return_key_onboardings", "return_keys"
  add_foreign_key "sample_batches", "demo_queries"
  add_foreign_key "schlesinger_qualification_answers", "schlesinger_qualification_questions", column: "qualification_question_id", primary_key: "qualification_id"
  add_foreign_key "schlesinger_quotas", "surveys"
  add_foreign_key "survey_adjustments", "surveys"
  add_foreign_key "survey_api_targets", "surveys"
  add_foreign_key "survey_response_urls", "projects"
  add_foreign_key "survey_router_sources", "survey_routers", column: "router_id"
  add_foreign_key "survey_router_visits", "survey_router_visitors"
  add_foreign_key "survey_test_modes", "employees"
  add_foreign_key "surveys", "countries"
  add_foreign_key "surveys", "projects"
  add_foreign_key "surveys", "survey_routers", column: "router_id"
  add_foreign_key "system_events", "api_tokens"
  add_foreign_key "system_events", "employees"
  add_foreign_key "tblRFP", "employees", column: "assigned_to_id"
  add_foreign_key "tblRFP", "projects"
  add_foreign_key "tblRFPCountries", "\"tblRFP\"", column: "tblRFP_id"
  add_foreign_key "tblRFPCountries", "countries"
  add_foreign_key "tblRFPTargetQualifications", "\"tblRFPTargets\"", column: "target_id"
  add_foreign_key "tblRFPTargetQualifications", "\"tblRFP\"", column: "tblRFP_id"
  add_foreign_key "tblRFPTargets", "\"tblRFPCountries\"", column: "country_id"
  add_foreign_key "tblRFPTargets", "\"tblRFP\"", column: "tblRFP_id"
  add_foreign_key "tblRFPVendors", "\"tblRFPTargets\"", column: "rfp_target_id"
  add_foreign_key "tblRFPVendors", "\"tblRFP\"", column: "tblRFP_id"
  add_foreign_key "tblRFPVendors", "vendors"
  add_foreign_key "traffic_checks", "ip_addresses"
  add_foreign_key "traffic_checks", "traffic_steps"
  add_foreign_key "traffic_events", "traffic_checks"
  add_foreign_key "traffic_reports", "surveys"
  add_foreign_key "unsubscriptions", "panelists"
  add_foreign_key "vendor_batches", "campaigns"
  add_foreign_key "vendor_batches", "surveys"
  add_foreign_key "vendor_batches", "vendors"
  add_foreign_key "zip_codes", "counties"
  add_foreign_key "zip_codes", "divisions"
  add_foreign_key "zip_codes", "dmas"
  add_foreign_key "zip_codes", "msas"
  add_foreign_key "zip_codes", "pmsas"
  add_foreign_key "zip_codes", "regions"
  add_foreign_key "zip_codes", "states"
end
