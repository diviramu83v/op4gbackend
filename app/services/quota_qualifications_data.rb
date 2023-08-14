# frozen_string_literal: true

# a service for creating the qualifications hash
class QuotaQualificationsData
  def initialize(params)
    @params = reject_blank_params(params.to_h)
  end

  # rubocop:disable Metrics/MethodLength
  def qualifications_hash
    qualifications = {
      and: []
    }
    @params.each_key do |key|
      qualifications[:and] << case key
                              when 'age', 'anychildage'
                                age_hash(key)
                              else
                                option_hash(key)
                              end
    end
    qualifications
  end
  # rubocop:enable Metrics/MethodLength

  private

  def option_hash(key)
    {
      equals: {
        values: condition_params_values(key),
        question: key
      }
    }
  end

  # rubocop:disable Metrics/PerceivedComplexity, Metrics/CyclomaticComplexity, Metrics/AbcSize
  def condition_params_values(key)
    if %w[geodmaregioncode geopostalcode].include?(key)
      params = @params[key]&.split(/\n/)&.map(&:strip)&.reject(&:blank?)
      params.map { |p| p.split(',') }&.flatten&.map(&:strip)
    elsif key == 'geocountry'
      @params[key] = [@params[key]]
    else
      @params[key]
    end
  end
  # rubocop:enable Metrics/PerceivedComplexity, Metrics/CyclomaticComplexity, Metrics/AbcSize

  # rubocop:disable Metrics/MethodLength
  def age_hash(key)
    {
      range: {
        values: [
          {
            gte: @params[key][:min_age],
            lte: @params[key][:max_age]
          }
        ],
        question: key,
        unit: 'years'
      }
    }
  end
  # rubocop:enable Metrics/MethodLength

  def reject_blank_params(params)
    params = reject_blank_values(params)
    reject_blank_keys(params)
  end

  def reject_blank_values(all_params)
    all_params.each_key do |key|
      next if %w[age anychildage geopostalcode geodmaregioncode geocountry].include?(key)

      all_params[key] = all_params[key].compact_blank
    end
  end

  def reject_blank_keys(all_params)
    all_params.reject do |param|
      if %w[anychildage age].include?(param)
        all_params[param].values.any?(&:blank?)
      else
        all_params[param].blank?
      end
    end
  end
end
