# frozen_string_literal: true

# this is a calculator for the disqo cpi
# loi param must be between 1 - 25
# incidence_rate param must be between 1 - 100
# rubocop:disable Metrics/ClassLength
class CpiCalculator
  def initialize(loi:, incidence_rate:)
    @loi = loi
    @incidence_rate = incidence_rate
  end

  def calculate!
    loi_group = loi_range_group
    incidence_group = incidence_rate_range_group
    loi_hash = CpiCalculator.try("loi#{loi_group}".to_sym)

    return if loi_hash.blank? || incidence_group.blank?

    loi_hash[incidence_group.to_s]
  end

  def self.loi5
    LOI_5
  end

  def self.loi10
    LOI_10
  end

  def self.loi15
    LOI_15
  end

  def self.loi20
    LOI_20
  end

  def self.loi25
    LOI_25
  end

  private

  def loi_range_group
    loi_groups = [5, 10, 15, 20, 25]
    loi_groups.each_with_index do |group, index|
      return 5 if @loi <= 5
      return group if @loi <= group && @loi >= loi_groups[index - 1]
    end
  end

  def incidence_rate_range_group
    incidence_groups = [14, 19, 24, 29, 34, 39, 44, 49, 59, 69, 79, 100]
    incidence_groups.each_with_index do |group, index|
      return 14 if @incidence_rate < 14
      return 100 if @incidence_rate == 100
      return group if @incidence_rate <= group && @incidence_rate > incidence_groups[index - 1]
    end
  end

  LOI_5 = {
    '14' => 175,
    '19' => 170,
    '24' => 165,
    '29' => 160,
    '34' => 155,
    '39' => 150,
    '44' => 145,
    '49' => 140,
    '59' => 135,
    '69' => 130,
    '79' => 125,
    '100' => 120
  }.freeze

  LOI_10 = {
    '14' => 240,
    '19' => 230,
    '24' => 225,
    '29' => 210,
    '34' => 200,
    '39' => 195,
    '44' => 185,
    '49' => 175,
    '59' => 160,
    '69' => 155,
    '79' => 145,
    '100' => 135
  }.freeze

  LOI_15 = {
    '14' => 300,
    '19' => 290,
    '24' => 270,
    '29' => 255,
    '34' => 240,
    '39' => 230,
    '44' => 225,
    '49' => 210,
    '59' => 195,
    '69' => 180,
    '79' => 160,
    '100' => 150
  }.freeze

  LOI_20 = {
    '14' => 415,
    '19' => 395,
    '24' => 365,
    '29' => 330,
    '34' => 305,
    '39' => 285,
    '44' => 265,
    '49' => 245,
    '59' => 230,
    '69' => 205,
    '79' => 190,
    '100' => 170
  }.freeze

  LOI_25 = {
    '14' => 460,
    '19' => 435,
    '24' => 395,
    '29' => 385,
    '34' => 365,
    '39' => 335,
    '44' => 315,
    '49' => 290,
    '59' => 265,
    '69' => 240,
    '79' => 220,
    '100' => 195
  }.freeze
end
# rubocop:enable Metrics/ClassLength
