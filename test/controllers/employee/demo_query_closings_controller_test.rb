# frozen_string_literal: true

require 'test_helper'

class Employee::DemoQueryClosingsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in employees(:operations)
  end

  it 'successfully closes batches for a demo query' do
    @query = demo_queries(:standard)

    SampleBatch.any_instance.expects(:sent?).returns(true)

    post query_close_url(@query)

    assert_redirected_to survey_queries_url(@query.survey)
    assert_equal 'Successfully closed all open batches.', flash[:notice]
  end

  it 'should not have any batches to close' do
    @query = demo_queries(:standard)

    post query_close_url(@query)

    assert_redirected_to survey_queries_url(@query.survey)
    assert_equal 'No batches to close.', flash[:notice]
  end
end
