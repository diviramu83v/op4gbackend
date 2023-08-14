# frozen_string_literal: true

require 'test_helper'

class Employee::DemoAnswersControllerTest < ActionDispatch::IntegrationTest
  before do
    load_and_sign_in_panelist_editor_employee
    @panelist = panelists(:standard)
    @demo_answer = demo_answers(:standard)
  end

  describe '#edit' do
    it 'should load the page' do
      get edit_demo_answer_url(@demo_answer)

      assert_response :ok
    end
  end

  describe '#update' do
    setup do
      @demo_option = demo_options(:standard)
    end

    it 'should update the demo answer' do
      params = { demo_answer: { demo_option: @demo_option.id } }
      put demo_answer_url(@demo_answer), params: params
      @demo_answer.reload

      assert_equal @demo_answer.demo_option_id, @demo_option.id
    end
  end
end
