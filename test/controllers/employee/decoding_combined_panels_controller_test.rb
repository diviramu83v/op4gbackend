# frozen_string_literal: true

require 'test_helper'

class Employee::DecodingCombinedPanelsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @panel = Panel.find_by(name: 'Op4G')

    sign_in employees(:operations)
  end

  describe 'IDs from a single project' do
    setup do
      @decoding = decodings(:standard)
      # Fix this after adding onramps for each panel.
      @decoding.onboardings.each do |onboarding|
        onboarding.update!(
          project_invitation: project_invitations(:standard),
          panel: @panel
        )
      end

      assert_not @decoding.multiple_projects?
    end

    it 'renders the html view' do
      get decoding_combined_url(@decoding)
      assert_response :ok
    end

    it 'renders the csv view' do
      get decoding_combined_url(@decoding, format: :csv)
      assert_equal controller.headers['Content-Transfer-Encoding'], 'binary'
    end
  end

  describe 'IDs from multiple projects' do
    setup do
      @decoding = decodings(:standard)
      Decoding.any_instance.stubs(:multiple_projects?).returns(true)
      # Fix this after adding onramps for each panel.
      @decoding.onboardings.each do |onboarding|
        onboarding.update!(
          project_invitation: project_invitations(:standard),
          panel: @panel
        )
      end

      assert @decoding.multiple_projects?
    end

    it 'renders the html view' do
      get decoding_combined_url(@decoding)
      assert_response :ok
    end

    it 'renders the csv view' do
      get decoding_combined_url(@decoding, format: :csv)
      assert_equal controller.headers['Content-Transfer-Encoding'], 'binary'
    end
  end
end
