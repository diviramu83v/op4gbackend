# frozen_string_literal: true

require 'test_helper'

class Employee::TrackingPixelsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @pixel = tracking_pixels(:standard)

    sign_in employees(:recruitment)
  end

  describe 'GET /edit' do
    it 'is successful' do
      get edit_pixel_url(@pixel)

      assert_response :ok
      assert_template :edit
    end
  end

  describe 'PATCH /update' do
    it 'redirects to pixels index url' do
      patch pixel_url(@pixel, params: { tracking_pixel: { description: 'Test update.' } })

      assert_redirected_to pixels_url
    end

    it 'updates the pixel record' do
      assert_changes -> { @pixel.reload.description }, to: 'Test update.' do
        patch pixel_url(@pixel, params: { tracking_pixel: { description: 'Test update.' } })
      end
    end

    describe 'error condition' do
      setup do
        TrackingPixel.any_instance.expects(:update).returns(false).once
      end

      it 'renders the edit form' do
        patch pixel_url(@pixel, params: { tracking_pixel: { description: 'Test update.' } })

        assert_template :edit
      end
    end
  end

  it 'should show tracking pixels page' do
    get pixels_url

    assert_ok_with_no_warning
  end

  it 'should show the new tracking pixel page' do
    get new_pixel_url

    assert_ok_with_no_warning
  end

  it 'should render a validation error and not redirect if a category is not chosen' do
    assert_difference -> { TrackingPixel.count }, 0 do
      post pixels_url, params: { tracking_pixel: { url: 'https://www.invalidatrributes.com' } }
    end

    assert_template :new
  end

  it 'should add a tracking pixel entry' do
    assert_difference -> { TrackingPixel.count }, 1 do
      post pixels_url, params: { tracking_pixel: { url: 'https://www.thisworks.com', category: 'welcome' } }
    end

    assert_redirected_to pixels_url
    assert_redirected_with_notice
  end

  it 'should delete the last added tracking pixel entry' do
    @pixel = tracking_pixels(:standard)

    assert_difference -> { TrackingPixel.count }, -1 do
      delete pixel_url(@pixel)
    end

    assert_redirected_to pixels_url
    assert_redirected_with_notice
  end
end
