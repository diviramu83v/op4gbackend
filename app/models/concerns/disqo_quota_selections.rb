# frozen_string_literal: true

# a class for providing options for disqo quotas
# rubocop:disable Metrics/ModuleLength
module DisqoQuotaSelections
  include DisqoQuotaSelectionsHashes

  MIN_AGE = 13
  MAX_AGE = 105
  MIN_CHILD_AGE = 0

  def self.find_in_hash(filter)
    DisqoQuotaSelections.try("#{filter}_options".to_sym)
  end

  def self.gender_options
    GENDER_OPTIONS
  end

  def self.geocountry_options
    GEOCOUNTRY_OPTIONS
  end

  def self.geousregion_options
    GEOUSREGION_OPTIONS
  end

  def self.georegion_options
    GEOREGION_OPTIONS
  end

  def self.groceryshoppingduty_options
    GROCERY_SHOPPING_DUTY_OPTIONS
  end

  def self.children_options
    CHILDREN_OPTIONS
  end

  def self.industry_options
    INDUSTRY_OPTIONS
  end

  def self.purchaseauth_options
    PURCHASE_AUTH_OPTIONS
  end

  def self.financialdecisionmaker_options
    FINANCIAL_DECISION_MAKER_OPTIONS
  end

  def self.investableassets_options
    INVESTABLE_ASSETS_OPTIONS
  end

  def self.insurancetype_options
    INSURANCE_TYPE_OPTIONS
  end

  def self.loantype_options
    LOAN_TYPE_OPTIONS
  end

  def self.financialproduct_options
    FINANCIAL_PRODUCT_OPTIONS
  end

  def self.internetbusinessuse_options
    INTERNET_BUSINESS_USE_OPTIONS
  end

  def self.onlineshopping_options
    ONLINE_SHOPPING_OPTIONS
  end

  def self.onlinepurchase_options
    ONLINE_PURCHASE_OPTIONS
  end

  def self.socialnetworks_options
    SOCIAL_NETWORKS_OPTIONS
  end

  def self.socialnetworkuse_options
    SOCIAL_NETWORK_USE_OPTIONS
  end

  def self.favoritepublications_options
    FAVORITE_PUBLICATIONS_OPTIONS
  end

  def self.storetype_options
    STORE_TYPE_OPTIONS
  end

  def self.purchaseditems_options
    PURCHASED_ITEMS_OPTIONS
  end

  def self.grocerypurchases_options
    GROCERY_PURCHASES_OPTIONS
  end

  def self.purchasetype_options
    PURCHASE_TYPE_OPTIONS
  end

  def self.rentorown_options
    RENT_OR_OWN_OPTIONS
  end

  def self.ethnicity_options
    ETHNICITY_OPTIONS
  end

  def self.educationlevel_options
    EDUCATION_LEVEL_OPTIONS
  end

  def self.employmentstatus_options
    EMPLOYEMENT_STATUS_OPTIONS
  end

  def self.householdincome_options
    HOUSEHOLD_INCOME_OPTIONS
  end

  def self.jobposition_options
    JOB_POSITION_OPTIONS
  end

  def self.onlinepaymentmethod_options
    ONLINE_PAYMENT_METHOD_OPTIONS
  end

  def self.ownlease_options
    OWN_LEASE_OPTIONS
  end

  def self.newoldvehicle_options
    NEW_OLD_VEHICLE_OPTIONS
  end

  def self.autopurchaseprospect_options
    AUTO_PURCHASE_PROSPECT_OPTIONS
  end

  def self.hightechdevices_options
    HIGH_TECH_DEVICES_OPTIONS
  end

  def self.employertype_options
    EMPLOYER_TYPE_OPTIONS
  end

  def self.yearsinindustry_options
    YEARS_IN_INDUSTRY_OPTIONS
  end

  def self.employmentdepartment_options
    EMPLOYMENT_DEPARTMENT_OPTIONS
  end

  def self.smartphoneuse_options
    SMARTPHONE_USE_OPTIONS
  end

  def self.internetpersonaluse_options
    INTERNET_PERSONAL_USE_OPTIONS
  end

  def self.restaurantvisits_options
    RESTAURANT_VISITS_OPTIONS
  end

  def self.fastfoodvisits_options
    FAST_FOOD_VISITS_OPTIONS
  end

  def self.cookingfrequency_options
    COOKING_FREQUENCY_OPTIONS
  end

  def self.alcoholconsumption_options
    COOKING_FREQUENCY_OPTIONS
  end

  def self.alcoholconsumptiontypes_options
    ALCOHOL_CONSUMPTION_TYPES_OPTIONS
  end

  def self.weeklyalcoholconsumption_options
    WEEKLY_ALCOHOL_CONSUMPTION_OPTIONS
  end

  def self.health_options
    HEALTH_OPTIONS
  end

  def self.personalhealth_options
    PERSONAL_HEALTH_OPTIONS
  end

  def self.yearlytravelfrequency_options
    YEARLY_TRAVEL_FREQUENCY_OPTIONS
  end

  def self.travelsites_options
    TRAVEL_SITE_OPTIONS
  end

  def self.employeecount_options
    EMPLOYEE_COUNT_OPTIONS
  end

  def self.vehicleownorlease_options
    VEHICLE_OWN_OR_LEASE_OPTIONS
  end
end
# rubocop:enable Metrics/ModuleLength
