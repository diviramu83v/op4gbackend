# frozen_string_literal: true

require 'test_helper'

class DemoQueryFilterTest < ActionDispatch::IntegrationTest
  describe 'adding and removing a filter through the asynchronous actions' do
    setup do
      load_operations_employee
      sign_employee_in employee: @employee

      @country = countries(:standard)
      @demo_question = demo_questions(:standard)
      @demo_questions_category = demo_questions_category(:standard)
      @panel = panels(:standard)
      @query = DemoQuery.create(panel: @panel, country: @country)
    end

    it 'can add and remove a filter asynchronously' do
      visit query_url(@query)
      @question = @query.questions.first

      original_body = page.body

      click_on(@question.demo_options.first.label)
      visit query_url(@query) # TODO: figure out how to remove this. Shouldn't be necessary.

      assert_not_equal original_body, page.body

      click_on("#{@question.button_label} : #{@question.demo_options.first.label}")
      visit query_url(@query) # TODO: figure out how to remove this. Shouldn't be necessary.

      assert_equal original_body, page.body
    end
  end
end
