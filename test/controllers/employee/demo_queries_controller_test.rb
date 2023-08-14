# frozen_string_literal: true

require 'test_helper'

class Employee::DemoQueriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    load_and_sign_in_admin
  end

  describe '#index' do
    setup do
      @survey = surveys(:standard)
    end

    it 'renders' do
      get survey_queries_url(@survey)

      assert_response :ok
    end

    setup do
      sign_in employees(:operations)
      @survey = surveys(:standard)

      stub_request(:any, %r{op4g-traffic-reports.s3.amazonaws.com/traffic_reports})
        .to_return(status: 200, body: '', headers: {})

      stub_request(:any, %r{s3.amazonaws.com/op4g-traffic-reports/traffic_reports})
        .to_return(status: 200, body: '', headers: {})
    end

    it 'view panel step with vendor' do
      @params = { vendor_batch: { vendor_id: vendors(:batch).id, incentive: 2.5 } }
      post survey_vendors_url(@survey), params: @params
      assert_not_empty @survey.vendors

      get survey_vendors_url(@survey)

      assert_response :ok
    end

    it 'view panel step with reminder button greyed out due to batch not sent' do
      batch = sample_batches(:standard)

      @survey.queries << demo_queries(:standard)
      @survey.queries.first.sample_batches << batch

      get survey_queries_url(@survey)

      assert_not batch.sent?
      assert_select("a[href$='#{sample_batch_remind_path(@survey.sample_batches.first)}']") do |elements|
        assert elements.first[:class].include? 'disabled'
      end
    end

    it 'view panel step with reminder button greyed out due to batch recently sent' do
      batch = sample_batches(:standard)
      batch.update!(sent_at: Time.now.utc)

      @survey.queries << demo_queries(:standard)
      @survey.queries.first.sample_batches << batch

      get survey_queries_url(@survey)

      assert batch.sent?
      assert_select("a[href$='#{sample_batch_remind_path(@survey.sample_batches.first)}']") do |elements|
        assert elements.first[:class].include? 'disabled'
      end
    end

    it 'view panel step with reminder button greyed out due to reminders already queued' do
      batch = sample_batches(:standard)
      batch.update!(sent_at: Time.now.utc, reminders_started_at: Time.now.utc)

      @survey.queries << demo_queries(:standard)
      @survey.queries.first.sample_batches << batch

      get survey_queries_url(@survey)

      assert batch.sent? && batch.reminders_queued?
      assert_select("a[href$='#{sample_batch_remind_path(@survey.sample_batches.first)}']") do |elements|
        assert elements.first[:class].include? 'disabled'
      end
    end
  end

  describe '#new' do
    it 'responds successfully' do
      get new_query_url

      assert_response :success
    end
  end

  it 'create query' do
    assert_difference -> { DemoQuery.count } do
      panel = panels(:standard)
      post queries_url, params: { panel_id: panel.id }
    end
  end

  it 'create query with project' do
    @project = projects(:standard)

    assert_difference -> { DemoQuery.count } do
      panel = panels(:standard)
      post queries_url(project_id: @project.id), params: { panel_id: panel.id }
    end
  end

  it 'create query: missing panel' do
    assert_no_difference -> { DemoQuery.count } do
      post queries_url, params: {}
    end

    assert_redirected_to new_query_url
  end

  it 'create query: invalid panel' do
    assert_no_difference -> { DemoQuery.count } do
      post queries_url, params: { panel_id: -1 }
    end

    assert_redirected_to new_query_url
  end

  describe '#show' do
    it 'show query' do
      DemoQuery.any_instance.expects(:editable?).returns(true).once
      load_query

      get query_url(@query)

      assert_response :success
    end

    it 'shows query and query is not editable' do
      DemoQuery.any_instance.expects(:editable?).returns(false).once
      load_query

      get query_url(@query)

      assert_redirected_to survey_queries_url(@query.survey)
    end
  end

  it 'delete query' do
    @query = demo_queries(:standard)

    # Must remove sample batches first.
    Earning.delete_all
    @query.sample_batches.destroy_all
    assert_empty @query.sample_batches

    assert_difference -> { DemoQuery.count }, -1 do
      delete query_url(@query)
    end
  end

  it 'should not delete query' do
    @query = demo_queries(:standard)
    assert_not_empty @query.sample_batches

    assert_no_difference -> { DemoQuery.count } do
      delete query_url(@query)
    end
  end

  it 'should not remove sample batches' do
    @query = demo_queries(:standard)
    batch = sample_batches(:standard)
    batch.update!(query: @query)
    assert_not_empty @query.sample_batches

    assert_no_difference -> { @query.sample_batches.count } do
      delete query_url(@query)
    end
  end

  describe 'add onramp for new panels' do
    setup do
      @survey = surveys(:standard)
      @panel = panels(:random)
    end

    it 'should add an onramp for the new panel' do
      assert_difference -> { @survey.onramps.count } do
        post queries_url, params: { panel_id: @panel.id, survey_id: @survey.id }
      end
    end

    it 'should not add an onramp for already existing panel' do
      @onramp = onramps(:panel)
      @onramp.update!(survey: @survey, panel_id: @panel.id)

      assert_no_difference -> { @survey.onramps.count } do
        post queries_url, params: { panel_id: @panel.id, survey_id: @survey.id }
      end
    end
  end
end
