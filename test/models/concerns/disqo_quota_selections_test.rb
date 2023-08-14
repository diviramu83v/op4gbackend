# frozen_string_literal: true

require 'test_helper'

class DisqoQuotaSelectionsTest < ActiveSupport::TestCase
  describe '#find_in_hash' do
    setup do
      @fields = DisqoQuotaSelections::LABEL_OPTIONS.keys.map(&:to_s)
    end

    test 'returns a hash' do
      @fields.each do |field|
        next if %w[age anychildage geopostalcode geodmaregioncode].include?(field)

        assert DisqoQuotaSelections.find_in_hash(field).instance_of?(Hash)
      end
    end
  end
end
