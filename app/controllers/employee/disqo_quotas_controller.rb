# frozen_string_literal: true

class Employee::DisqoQuotasController < Employee::OperationsBaseController
  authorize_resource class: 'Survey'

  before_action :set_survey, except: [:edit, :update]

  def index; end

  def new
    @disqo_quota = @survey.disqo_quotas.new
  end

  def edit
    @disqo_quota = DisqoQuota.find(params[:id])
    @survey = @disqo_quota.survey
  end

  def create
    @disqo_quota = @survey.disqo_quotas.new(disqo_quota_params)
    @disqo_quota.qualifications = QuotaQualificationsData.new(qualifications_params).qualifications_hash
    if @disqo_quota.save
      flash[:notice] = 'Disqo quota saved successfully.'
      redirect_to survey_disqo_quotas_url(@survey)
    else
      render 'new'
    end
  end

  def update
    @disqo_quota = DisqoQuota.find(params[:id])
    @survey = @disqo_quota.survey
    @disqo_quota.qualifications = QuotaQualificationsData.new(qualifications_params).qualifications_hash
    if @disqo_quota.update(disqo_quota_params)
      flash[:notice] = 'Disqo quota updated successfully.'
      redirect_to survey_disqo_quotas_url(@survey)
    else
      render 'edit'
    end
  end

  private

  def disqo_quota_params
    params.require(:disqo_quota).permit(:cpi, :loi, :soft_launch_completes_wanted, :completes_wanted, :conversion_rate)
  end

  # rubocop:disable Metrics/MethodLength
  def qualifications_params
    params.require(:disqo_quota).permit(
      qualifications: [
        :geopostalcode,
        :geodmaregioncode,
        :geocountry,
        age: [:min_age, :max_age], # rubocop:disable Style/HashAsLastArrayItem
        anychildage: [:min_age, :max_age],
        geousregion: [],
        georegion: [],
        groceryshoppingduty: [],
        children: [],
        industry: [],
        purchaseauth: [],
        financialdecisionmaker: [],
        investableassets: [],
        insurancetype: [],
        loantype: [],
        financialproduct: [],
        internetbusinessuse: [],
        onlineshopping: [],
        onlinepurchase: [],
        socialnetworks: [],
        socialnetworkuse: [],
        favoritepublications: [],
        storetype: [],
        purchaseditems: [],
        grocerypurchases: [],
        purchasetype: [],
        gender: [],
        educationlevel: [],
        rentorown: [],
        employmentstatus: [],
        householdincome: [],
        ethnicity: [],
        jobposition: [],
        onlinepaymentmethod: [],
        ownlease: [],
        newoldvehicle: [],
        autopurchaseprospect: [],
        hightechdevices: [],
        employertype: [],
        yearsinindustry: [],
        employmentdepartment: [],
        smartphoneuse: [],
        internetpersonaluse: [],
        restaurantvisits: [],
        fastfoodvisits: [],
        cookingfrequency: [],
        alcoholconsumption: [],
        alcoholconsumptiontypes: [],
        weeklyalcoholconsumption: [],
        health: [],
        personalhealth: [],
        yearlytravelfrequency: [],
        travelsites: [],
        employeecount: [],
        vehicleownorlease: []
      ]
    )[:qualifications]
  end
  # rubocop:enable Metrics/MethodLength

  def set_survey
    @survey = Survey.find(params[:survey_id])
  end
end
