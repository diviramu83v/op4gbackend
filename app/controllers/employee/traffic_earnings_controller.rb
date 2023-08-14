# frozen_string_literal: true

class Employee::TrafficEarningsController < Employee::RecruitmentBaseController
  authorize_resource class: 'RecruitingCampaign'

  # rubocop:disable Metrics/AbcSize
  def show
    offer = if params['recruiting_campaign_id']
              RecruitingCampaign.find(params['recruiting_campaign_id'])
            elsif params['affiliate_id']
              Affiliate.find(params['affiliate_id'])
            elsif params['nonprofit_id']
              Nonprofit.find(params['nonprofit_id'])
            else
              raise 'required param not found'
            end

    @report_name, @report_data = build_traffic_record(offer)
  end
  # rubocop:enable Metrics/AbcSize

  def build_traffic_record(offer)
    offer_data =
      query_traffic_data(offer).find_each.reduce({}) do |acc, campaign|
        add_traffic_data_to_results(acc, campaign)
      end

    [get_offer_name(offer), offer_data]
  end

  private

  def get_offer_name(offer)
    if offer.is_a?(RecruitingCampaign)
      if offer.campaignable.present?
        offer.campaignable.name
      else
        offer.code
      end
    else
      offer&.name
    end
  end

  def query_traffic_data(offer)
    filter = filter_for_model(offer)

    onboarding_records(filter)
  end

  def filter_for_model(offer)
    case offer
    when RecruitingCampaign
      { campaign: offer }
    when Affiliate
      { affiliate_code: offer.code }
    when Nonprofit
      { campaign: offer.campaigns }
    else
      raise "Invalid object type: #{offer}"
    end
  end

  def onboarding_records(where_clause)
    Onboarding.complete
              .select('earnings.total_amount_cents',
                      'onboardings.id',
                      'onboardings.survey_finished_at',
                      'panelists.welcomed_at',
                      'surveys.cpi_cents')
              .joins(:earning, :panelist, onramp: [:survey])
              .where(panelists: where_clause)
  end

  def add_traffic_data_to_results(offer_data, traffic_record)
    survey_year = traffic_record.survey_finished_at.year
    recruitment_year = traffic_record.welcomed_at.year

    offer_data[survey_year] = {} unless offer_data[survey_year]
    offer_survey_year_data = offer_data[survey_year]

    offer_survey_year_data[recruitment_year] = 0.0 unless offer_survey_year_data[recruitment_year]
    offer_survey_year_data[recruitment_year] = offer_survey_year_data[recruitment_year].to_f + calculate_profit(traffic_record)

    offer_data
  end

  def calculate_profit(traffic_record)
    cpi = traffic_record.cpi_cents
    earnings = traffic_record.total_amount_cents || 0.0
    cpi - earnings
  end
end
