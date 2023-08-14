# frozen_string_literal: true

require 'test_helper'

class DisqoCpiCalculatorTest < ActiveSupport::TestCase
  describe 'calculates the cpi' do
    test 'calculate 5 min loi' do
      loi = 3
      incidence_rate = 100
      cpi = CpiCalculator.new(loi: loi, incidence_rate: incidence_rate).calculate!

      assert cpi == 120
    end

    test 'calculate 10 min loi' do
      loi = 10
      incidence_rate = 50
      cpi = CpiCalculator.new(loi: loi, incidence_rate: incidence_rate).calculate!

      assert cpi == 160
    end

    test 'calculate 15 min loi' do
      loi = 12
      incidence_rate = 49
      cpi = CpiCalculator.new(loi: loi, incidence_rate: incidence_rate).calculate!

      assert cpi == 210
    end

    test 'calculate 20 min loi' do
      loi = 17
      incidence_rate = 1
      cpi = CpiCalculator.new(loi: loi, incidence_rate: incidence_rate).calculate!

      assert cpi == 415
    end

    test 'calculate 25 min loi' do
      loi = 25
      incidence_rate = 78
      cpi = CpiCalculator.new(loi: loi, incidence_rate: incidence_rate).calculate!

      assert cpi == 220
    end
  end
end
