# frozen_string_literal: true

require 'test_helper'

class MadMimiDangerListTest < ActiveSupport::TestCase
  setup do
    @panelist = panelists(:active)
  end

  describe '#add' do
    it 'calls the Mad Mimi API' do
      MadMimiApi.any_instance.expects(:add_to_list).once
      MadMimiDangerList.new.add(panelist: @panelist)
    end
  end

  describe '#remove' do
    it 'calls the Mad Mimi API' do
      MadMimiApi.any_instance.expects(:remove_from_list).once
      MadMimiDangerList.new.remove(panelist: @panelist)
    end
  end
end
