# frozen_string_literal: true

# this is a calculator for the cint cpi
# loi param must be between 1 - 60
# incidence_rate param must be between 1 - 100
# rubocop:disable Metrics/ClassLength
class CintCpiCalculator
  def initialize(loi:, incidence_rate:)
    @loi = loi
    @incidence_rate = incidence_rate
  end

  def calculate!
    loi_group = loi_range_group
    incidence_group = incidence_rate_range_group
    loi_hash = CintCpiCalculator.try("loi#{loi_group}".to_sym)

    return if loi_hash.blank? || incidence_group.blank?

    loi_hash[incidence_group.to_s]
  end

  def self.loi3
    LOI_3
  end

  def self.loi6
    LOI_6
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

  def self.loi30
    LOI_30
  end

  def self.loi35
    LOI_35
  end

  def self.loi40
    LOI_40
  end

  def self.loi45
    LOI_45
  end

  def self.loi50
    LOI_50
  end

  def self.loi55
    LOI_55
  end

  def self.loi60
    LOI_60
  end

  private

  def loi_range_group
    loi_groups = [3, 6, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55, 60]
    loi_groups.each_with_index do |group, index|
      return 3 if @loi <= 3
      return group if @loi <= group && @loi >= loi_groups[index - 1]
    end
  end

  def incidence_rate_range_group
    incidence_groups = [2, 4, 6, 9, 14, 19, 29, 49, 74, 100]
    incidence_groups.each_with_index do |group, index|
      return 2 if @incidence_rate <= 2
      return 100 if @incidence_rate == 100
      return group if @incidence_rate <= group && @incidence_rate >= incidence_groups[index - 1]
    end
  end

  LOI_3 = {
    '2' => 2584,
    '4' => 1360,
    '6' => 976,
    '9' => 800,
    '14' => 640,
    '19' => 536,
    '29' => 468,
    '49' => 304,
    '74' => 220,
    '100' => 155
  }.freeze

  LOI_6 = {
    '2' => 2624,
    '4' => 1388,
    '6' => 1004,
    '9' => 828,
    '14' => 676,
    '19' => 580,
    '29' => 520,
    '49' => 348,
    '74' => 265,
    '100' => 195
  }.freeze

  LOI_10 = {
    '2' => 2624,
    '4' => 1388,
    '6' => 1004,
    '9' => 828,
    '14' => 676,
    '19' => 580,
    '29' => 520,
    '49' => 348,
    '74' => 265,
    '100' => 195
  }.freeze

  LOI_15 = {
    '2' => 2624,
    '4' => 1388,
    '6' => 1004,
    '9' => 828,
    '14' => 676,
    '19' => 580,
    '29' => 520,
    '49' => 348,
    '74' => 265,
    '100' => 195
  }.freeze

  LOI_20 = {
    '2' => 2624,
    '4' => 1388,
    '6' => 1004,
    '9' => 828,
    '14' => 676,
    '19' => 580,
    '29' => 540,
    '49' => 388,
    '74' => 265,
    '100' => 240
  }.freeze

  LOI_25 = {
    '2' => 2664,
    '4' => 1428,
    '6' => 1044,
    '9' => 868,
    '14' => 696,
    '19' => 580,
    '29' => 540,
    '49' => 424,
    '74' => 265,
    '100' => 265
  }.freeze

  LOI_30 = {
    '2' => 2700,
    '4' => 1468,
    '6' => 1060,
    '9' => 888,
    '14' => 712,
    '19' => 600,
    '29' => 560,
    '49' => 464,
    '74' => 315,
    '100' => 315
  }.freeze

  LOI_35 = {
    '2' => 2740,
    '4' => 1504,
    '6' => 1100,
    '9' => 928,
    '14' => 752,
    '19' => 616,
    '29' => 580,
    '49' => 500,
    '74' => 385,
    '100' => 385
  }.freeze

  LOI_40 = {
    '2' => 2780,
    '4' => 1544,
    '6' => 1140,
    '9' => 964,
    '14' => 792,
    '19' => 656,
    '29' => 600,
    '49' => 540,
    '74' => 435,
    '100' => 435
  }.freeze

  LOI_45 = {
    '2' => 2796,
    '4' => 1564,
    '6' => 1156,
    '9' => 984,
    '14' => 812,
    '19' => 696,
    '29' => 636,
    '49' => 580,
    '74' => 485,
    '100' => 485
  }.freeze

  LOI_50 = {
    '2' => 2876,
    '4' => 1640,
    '6' => 1236,
    '9' => 1060,
    '14' => 888,
    '19' => 772,
    '29' => 696,
    '49' => 616,
    '74' => 530,
    '100' => 530
  }.freeze

  LOI_55 = {
    '2' => 2952,
    '4' => 1716,
    '6' => 1312,
    '9' => 1100,
    '14' => 928,
    '19' => 812,
    '29' => 772,
    '49' => 712,
    '74' => 675,
    '100' => 675
  }.freeze

  LOI_60 = {
    '2' => 3088,
    '4' => 1796,
    '6' => 1388,
    '9' => 1176,
    '14' => 1004,
    '19' => 928,
    '29' => 848,
    '49' => 752,
    '74' => 725,
    '100' => 725
  }.freeze
end
# rubocop:enable Metrics/ClassLength
