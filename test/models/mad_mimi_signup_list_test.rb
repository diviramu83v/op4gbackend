# frozen_string_literal: true

require 'test_helper'

class MadMimiSignupListTest < ActiveSupport::TestCase
  describe '#add' do
    setup do
      @panelist = panelists(:active)
    end

    it 'calls the Mad Mimi API' do
      MadMimiApi.any_instance.expects(:add_to_list).once
      MadMimiSignupList.new.add(panelist: @panelist)
    end
  end
end
