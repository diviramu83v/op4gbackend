# frozen_string_literal: true

require 'test_helper'

class PanelistTest < ActiveSupport::TestCase
  describe 'scopes' do
    it 'should properly filter the panelist note scopes' do
      PanelistNote.delete_all
      assert PanelistNote.count.zero?

      employee_one = employees(:operations)
      employee_two = employees(:no_role)

      panelist_one = panelists(:standard)
      panelist_two = panelists(:active)

      PanelistNote.create(employee: employee_one, panelist: panelist_one, body: 'test')
      PanelistNote.create(employee: employee_one, panelist: panelist_two, body: 'test')
      PanelistNote.create(employee: employee_two, panelist: panelist_two, body: 'test')

      assert_equal 3, PanelistNote.count
      assert_equal 1, PanelistNote.for_panelist(panelist_one).count
      assert_equal 2, PanelistNote.for_panelist(panelist_two).count
    end
  end
end
