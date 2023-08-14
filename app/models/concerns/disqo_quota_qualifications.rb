# frozen_string_literal: true

# this has methods that work with the quota qualifications data
module DisqoQuotaQualifications
  include DisqoQuotaSelections

  def find_in_qualifications(key)
    return find_age(key) if %w[age anychildage].include?(key)

    find_attribute(key)
  end

  def all_present_qualifications
    DisqoQuotaSelections::LABEL_OPTIONS.keys.map(&:to_s).each_with_object({}) do |label, hash|
      next if find_in_qualifications(label).blank?

      hash[label] = find_in_qualifications(label)
    end
  end

  private

  def find_attribute(key)
    key_hash = qualifications['and']&.find do |hash|
      hash.dig('equals', 'question') == key
    end
    key_hash&.dig('equals', 'values')
  end

  def find_age(key)
    key_hash = qualifications['and']&.find do |hash|
      hash.flatten.last['question'] == key
    end
    key_hash&.dig('range', 'values')&.first
  end
end
