# frozen_string_literal: true

require 'test_helper'

class Panelist::DemographicsControllerTest < ActionDispatch::IntegrationTest
  setup do
    load_and_sign_in_confirmed_panelist_with_base_info
    @option = demo_options(:standard)
  end

  it 'should get the panelist dashboard if demos are completed' do
    assert @panelist.demos_completed?

    get demographics_url

    assert_redirected_to panelist_dashboard_url
  end

  describe 'demographics show page with demographic questions' do
    setup do
      @demo_question_category = demo_questions_category(:standard)
      @demo_question_category.update(panel: @panelist.primary_panel)
    end

    it 'should get the show page if demos are not completed' do
      Panelist.any_instance.stubs(:demos_completed?).returns(false)

      get demographics_url

      assert_redirected_to demographics_category_url(@demo_question_category.slug)
    end
  end

  it 'should save and redirect to the dashboard if all questions are answered' do
    params = { demographics: { fake: @option.id } }

    post demographics_url, params: params

    assert_redirected_to panelist_dashboard_url
  end

  it 'should ignore multiple posts with the same options' do
    params = { demographics: { fake: @option.id } }

    post demographics_url, params: params
    post demographics_url, params: params

    assert_redirected_to panelist_dashboard_url
  end

  describe 'create with unanswered questions' do
    setup do
      @demo_question_category = demo_questions_category(:standard)
      @demo_question_category.update(panel: @panelist.primary_panel)
      @panelist.unanswered_questions << @demo_question_category.demo_questions.first
    end

    it 'should save with unanswered new questions' do
      params = { demographics: { fake: @option.id } }

      post demographics_url, params: params

      assert_redirected_to demographics_url
    end

    it 'should save with unanswered no new questions' do
      post demographics_url

      assert_redirected_to demographics_url
    end
  end
end
