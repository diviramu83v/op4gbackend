# frozen_string_literal: true

require 'test_helper'

class Employee::VendorsControllerTest < ActionDispatch::IntegrationTest
  setup do
    load_and_sign_in_employee(:operations)
  end

  describe '#index' do
    it 'renders correctly' do
      get vendors_url

      assert_response :ok
      assert_template :index
    end
  end

  describe '#new' do
    it 'renders correctly' do
      get new_vendor_url

      assert_response :ok
      assert_template :new
    end

    it 'does not show advanced options' do
      get new_vendor_url

      assert_select 'form' do
        refute_select 'h4', 'Advanced options'
      end
    end

    describe 'for operations managers' do
      setup do
        load_and_sign_in_employee(:operations_manager)
      end

      it 'shows advanced options' do
        get new_vendor_url

        assert_select 'form' do
          assert_select 'h4', 'Advanced options'
        end
      end
    end
  end

  describe '#create' do
    setup do
      attributes = vendors(:batch).attributes
      @params = { vendor: attributes }
    end

    describe 'success' do
      it 'creates a new record' do
        assert_difference -> { Vendor.count } do
          post vendors_url, params: @params
        end
      end

      it 'redirects to the index page' do
        post vendors_url, params: @params

        assert_redirected_to vendors_url
      end

      describe 'for operations managers' do
        setup do
          load_and_sign_in_employee(:operations_manager)
        end

        it 'creates a new record' do
          post vendors_url, params: @params

          assert_difference -> { Vendor.count } do
            post vendors_url, params: @params
          end
        end
      end
    end

    describe 'failure' do
      setup do
        Vendor.any_instance.expects(:save).returns(false).once
      end

      it 'does not create a new record' do
        assert_no_difference -> { Vendor.count } do
          post vendors_url, params: @params
        end
      end

      it 'renders the new page' do
        post vendors_url, params: @params

        assert_template :new
      end
    end
  end

  describe '#edit' do
    setup do
      @vendor = vendors(:batch)
    end

    it 'renders correctly' do
      get edit_vendor_url(@vendor)

      assert_response :ok
      assert_template :edit
    end

    it 'does not show advanced options' do
      get edit_vendor_url(@vendor)

      assert_select 'form' do
        refute_select 'h4', 'Advanced options'
      end
    end

    describe 'for operations managers' do
      setup do
        load_and_sign_in_employee(:operations_manager)
      end

      it 'shows advanced options' do
        get edit_vendor_url(@vendor)

        assert_select 'form' do
          assert_select 'h4', 'Advanced options'
        end
      end
    end
  end

  describe '#update' do
    setup do
      @vendor = vendors(:batch)
      attributes = @vendor.attributes
      @params = { vendor: attributes }
    end

    describe 'success' do
      it "updates the vendor's name" do
        patch vendor_url(@vendor), params: @params
        @vendor.reload

        assert_response :found
      end

      it 'returns to the vendors page' do
        patch vendor_url(@vendor), params: @params

        assert_redirected_to vendors_url
      end

      describe 'for operations managers' do
        setup do
          load_and_sign_in_employee(:operations_manager)
        end

        it 'creates a new record' do
          post vendors_url, params: @params

          patch vendor_url(@vendor), params: @params
          @vendor.reload

          assert_response :found
        end
      end
    end

    describe 'failure' do
      setup do
        attributes = vendors(:batch).attributes
        @params = { vendor: attributes }
        Vendor.any_instance.expects(:update).returns(false).once
      end

      it 'renders the edit page' do
        patch vendor_url(@vendor), params: @params

        assert_template :edit
      end
    end
  end
end
