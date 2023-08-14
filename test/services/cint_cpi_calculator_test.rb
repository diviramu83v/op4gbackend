# frozen_string_literal: true

require 'test_helper'

class CintCpiCalculatorTest < ActiveSupport::TestCase
  describe 'calculates the cpi' do
    test 'calculate 3 loi' do
      loi = 3
      incidence_rate = 100
      cpi = CintCpiCalculator.new(loi: loi, incidence_rate: incidence_rate).calculate!

      assert cpi == 155
    end

    test 'calculate 6 loi' do
      loi = 6
      incidence_rate = 19
      cpi = CintCpiCalculator.new(loi: loi, incidence_rate: incidence_rate).calculate!

      assert cpi == 580
    end

    test 'calculate 10 loi' do
      loi = 10
      incidence_rate = 48
      cpi = CintCpiCalculator.new(loi: loi, incidence_rate: incidence_rate).calculate!

      assert cpi == 348
    end

    test 'calculate 10 loi 24 ir' do
      loi = 10
      incidence_rate = 24
      cpi = CintCpiCalculator.new(loi: loi, incidence_rate: incidence_rate).calculate!

      assert cpi == 520
    end

    test 'calculate 15 loi' do
      loi = 15
      incidence_rate = 1
      cpi = CintCpiCalculator.new(loi: loi, incidence_rate: incidence_rate).calculate!

      assert cpi == 2624
    end

    test 'calculate 15 loi 59 ir' do
      loi = 15
      incidence_rate = 59
      cpi = CintCpiCalculator.new(loi: loi, incidence_rate: incidence_rate).calculate!

      assert cpi == 265
    end

    test 'calculate 20 loi' do
      loi = 20
      incidence_rate = 66
      cpi = CintCpiCalculator.new(loi: loi, incidence_rate: incidence_rate).calculate!

      assert cpi == 265
    end

    test 'calculate 25 loi' do
      loi = 25
      incidence_rate = 14
      cpi = CintCpiCalculator.new(loi: loi, incidence_rate: incidence_rate).calculate!

      assert cpi == 696
    end

    test 'calculate 30 loi' do
      loi = 30
      incidence_rate = 25
      cpi = CintCpiCalculator.new(loi: loi, incidence_rate: incidence_rate).calculate!

      assert cpi == 560
    end

    test 'calculate 35 loi' do
      loi = 35
      incidence_rate = 4
      cpi = CintCpiCalculator.new(loi: loi, incidence_rate: incidence_rate).calculate!

      assert cpi == 1504
    end

    test 'calculate 40 loi' do
      loi = 40
      incidence_rate = 17
      cpi = CintCpiCalculator.new(loi: loi, incidence_rate: incidence_rate).calculate!

      assert cpi == 656
    end

    test 'calculate 45 loi' do
      loi = 45
      incidence_rate = 2
      cpi = CintCpiCalculator.new(loi: loi, incidence_rate: incidence_rate).calculate!

      assert cpi == 2796
    end

    test 'calculate 50 loi' do
      loi = 50
      incidence_rate = 4
      cpi = CintCpiCalculator.new(loi: loi, incidence_rate: incidence_rate).calculate!

      assert cpi == 1640
    end

    test 'calculate 55 loi' do
      loi = 55
      incidence_rate = 100
      cpi = CintCpiCalculator.new(loi: loi, incidence_rate: incidence_rate).calculate!

      assert cpi == 675
    end

    test 'calculate 60 loi' do
      loi = 60
      incidence_rate = 29
      cpi = CintCpiCalculator.new(loi: loi, incidence_rate: incidence_rate).calculate!

      assert cpi == 848
    end
  end
end
