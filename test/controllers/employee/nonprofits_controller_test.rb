# frozen_string_literal: true

require 'test_helper'

class Employee::NonprofitsControllerTest < ActionDispatch::IntegrationTest
  before do
    load_and_sign_in_recruitment_employee

    @nonprofit = nonprofits(:one)
  end

  it 'gets the nonprofit#index page' do
    get nonprofits_url

    assert_ok_with_no_warning
  end

  it 'gets the nonprofit#show page' do
    get nonprofit_url(@nonprofit)
    assert_ok_with_no_warning
  end

  it 'gets the nonprofit#new page' do
    get new_nonprofit_url
    assert_ok_with_no_warning
  end

  it 'gets the nonprofit#create page and redirects back to the nonprofit if the attributes update successfully' do
    post nonprofits_url, params: { nonprofit: nonprofits(:one).attributes }

    assert_redirected_to Nonprofit.last
  end

  it 'gets the nonprofit#create page and renders the \'new\' view if the attributes do not update successfully' do
    @fake_nonprofit = Nonprofit.new(nonprofits(:one).attributes)
    @fake_nonprofit['name'] = nil

    post nonprofits_url, params: { nonprofit: @fake_nonprofit.attributes }

    assert_template :new
  end

  it 'gets the nonprofit#edit page' do
    get edit_nonprofit_url(@nonprofit)
    assert_ok_with_no_warning
  end

  it 'gets the nonprofit#update page and redirects to nonprofit if the attributes update successfully' do
    put nonprofit_url(@nonprofit), params: { nonprofit: nonprofits(:one).attributes }

    assert_redirected_to @nonprofit
  end

  it 'gets the nonprofit#update page and renders the edit page if the attribues do not update successfully' do
    @fake_nonprofit = Nonprofit.new(nonprofits(:one).attributes)
    @fake_nonprofit['name'] = nil

    put nonprofit_url(@nonprofit), params: { nonprofit: @fake_nonprofit.attributes }

    assert_template :edit
  end

  it 'calls the nonprofit#archive method when the delete action is called' do
    @mock_nonprofit = MiniTest::Mock.new
    @mock_nonprofit.expect :archive, true

    delete nonprofit_url(@nonprofit)

    assert_redirected_to nonprofits_path
  end

  it 'alerts and renders the show action if the update fails' do
    assert_nil @nonprofit.archived_at

    Nonprofit.any_instance.stubs(:update).returns(false)

    delete nonprofit_url(@nonprofit)

    @nonprofit.reload

    assert_nil @nonprofit.archived_at
    assert_template 'show'
  end
end
