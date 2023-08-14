# frozen_string_literal: true

require 'test_helper'

class Employee::PanelistsControllerTest < ActionDispatch::IntegrationTest
  before do
    load_and_sign_in_panelist_editor_employee
  end

  it 'gets the panlist index page, and searches if term is present' do
    get panelists_url, params: { term: 'term' }

    assert_ok_with_no_warning
  end

  it 'gets the panlist index page, but don\'t search if term isn\'t present' do
    get panelists_url

    assert_ok_with_no_warning
  end

  it 'gets the panelist page' do
    @panelist = panelists(:standard)

    get panelist_url(@panelist)

    assert_ok_with_no_warning
  end

  it 'shows an alert if the panelist\'s current ip is blocked' do
    Onboarding.any_instance.stubs(:clean_id_data).returns({ 'TransactionId' => 'fd278f99-22d8-4d9c-972d-15b14b413c15', 'Score' => 0, 'ORScore' => 5.91,
                                                            'Duplicate' => true, 'IsMobile' => false })
    @ip_address = ip_addresses(:standard)
    @ip_address.update(
      blocked_at: Faker::Date.backward(days: 90),
      status: 'blocked',
      category: 'deny-auto',
      address: '1.1.1.1'
    )
    @panelist = panelists(:standard)
    @panelist.update(current_sign_in_ip: '1.1.1.1')

    get panelist_url(@panelist)
    assert_response :ok
    assert_not_nil flash[:notice]
  end

  describe 'a panelist page with notes' do
    setup do
      @panelist = panelists(:standard)
      3.times do
        PanelistNote.create(panelist: @panelist, employee: @employee)
      end
    end

    it 'loads as expected' do
      get panelist_url(@panelist)

      assert_ok_with_no_warning
    end
  end

  it 'lists the correct link to survey queries' do
    load_and_sign_in_admin
    invitation = project_invitations(:standard)

    get survey_queries_url(invitation.survey)

    assert_response :ok
    assert_equal "/surveys/#{invitation.survey.id}/queries", survey_queries_path(invitation.survey)
  end

  describe '#edit' do
    setup do
      @panelist = panelists(:standard)
    end

    it 'loads the page' do
      get edit_panelist_url(@panelist)

      assert_response :ok
    end
  end

  describe '#update' do
    setup do
      @panelist = panelists(:standard)
    end

    it 'should update the panelist' do
      params = { panelist: { first_name: 'testname' } }

      put panelist_url(@panelist), params: params
      @panelist.reload
      assert_equal 'testname', @panelist.first_name
    end

    test 'update fail' do
      Panelist.any_instance.expects(:update).returns(false)
      params = { panelist: { first_name: 'testname' } }

      put panelist_url(@panelist), params: params

      assert_not_nil flash[:notice]
    end
  end
end
