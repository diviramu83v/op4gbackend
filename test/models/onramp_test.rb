# frozen_string_literal: true

require 'test_helper'

class OnrampTest < ActiveSupport::TestCase
  describe 'fixtures' do
    describe 'standard' do
      it 'is valid' do
        onramp = onramps(:testing)
        assert onramp.valid?
        assert_empty onramp.errors
      end
    end

    describe 'panel' do
      it 'is valid' do
        onramp = onramps(:panel)
        assert onramp.valid?
        assert_empty onramp.errors
      end
    end

    describe 'vendor' do
      it 'is valid' do
        onramp = onramps(:vendor)
        assert onramp.valid?
        assert_empty onramp.errors
      end
    end

    describe 'api' do
      it 'is valid' do
        onramp = onramps(:api)
        assert onramp.valid?
        assert_empty onramp.errors
      end
    end

    describe 'router' do
      it 'is valid' do
        onramp = onramps(:router)
        assert onramp.valid?
        assert_empty onramp.errors
      end
    end
  end

  describe '#enableable?' do
    setup do
      @onramp = onramps(:panel)
      @onramp.update(disabled_at: Time.now.utc)
      @onramp.project.assign_status('live')
    end

    it 'should return true if onramp is live or on hold' do
      assert @onramp.enableable?
    end
  end

  describe '#disqo_id' do
    setup do
      @onramp = onramps(:disqo)
    end

    it 'should return disqo quota id' do
      assert_equal @onramp.disqo_quota.quota_id, @onramp.disqo_id
    end

    it 'should return "no quota found" when there is no disqo quota' do
      onramp = onramps(:panel)
      onramp.update!(category: 'disqo')
      assert_equal 'no quota found', onramp.disqo_id
    end
  end

  describe '#secured?' do
    setup do
      @onramp = onramps(:testing)
    end

    test 'testing onramp returns false' do
      assert_equal @onramp.secured?, false
    end

    test 'testing onramp returns false even with all other checks true' do
      @onramp.update!(check_recaptcha: true, check_clean_id: true)
      assert_equal @onramp.secured?, false
    end

    test 'non testing onramp, recaptcha true, clean_id true, returns true' do
      @onramp = onramps(:panel)
      @onramp.update!(check_recaptcha: true, check_clean_id: true)
      assert_equal @onramp.secured?, true
    end

    test 'check recaptcha false, returns false' do
      @onramp = onramps(:panel)
      @onramp.update!(check_recaptcha: false)
      assert_equal @onramp.secured?, false
    end

    test 'returns false without recaptcha/clean_id/relevant_id checks true' do
      @onramp = onramps(:vendor)
      assert_equal @onramp.secured?, false
    end

    test 'returns true with check_recaptcha true and check_clean_id true' do
      @onramp = onramps(:vendor)
      @onramp.update!(check_recaptcha: true, check_clean_id: true)
      assert_equal @onramp.secured?, true
    end

    test 'returns false without recaptcha/clean_id/relevant_id checks' do
      @onramp = onramps(:api)
      assert_equal @onramp.secured?, false
    end

    test 'returns true with check_recaptcha true' do
      @onramp = onramps(:api)
      @onramp.update!(check_clean_id: true, check_recaptcha: true)
      assert_equal @onramp.secured?, true
    end
  end

  describe '#unaccepted_count' do
    setup do
      @project = projects(:standard)
      @onramp = onramps(:vendor)
      @onboarding = onboardings(:standard)
      @onboarding.update!(onramp: @onramp)
    end
    it 'gives a count of 0' do
      assert_equal @onramp.unaccepted_count, 0
    end

    it 'gives a count of 1' do
      @onboarding.accepted!
      assert_equal @onramp.unaccepted_count, 1
    end

    it 'gives a count of 1' do
      @onboarding.rejected!
      assert_equal @onramp.unaccepted_count, 1
    end

    it 'gives a count of 1' do
      @onboarding.fraudulent!
      assert_equal @onramp.unaccepted_count, 1
    end
  end

  describe '#remaining_id_count' do
    setup do
      @onramp = onramps(:vendor)
      @onboarding = onboardings(:complete)
      @onboarding.update!(onramp: @onramp)
    end

    it 'should calculate the remaining id count' do
      assert_equal @onramp.onboardings.complete.count, 1
      assert_equal @onramp.onboardings.complete.accepted.count, 0
      assert_equal @onramp.onboardings.complete.fraudulent.count, 0
      assert_equal @onramp.onboardings.complete.rejected.count, 0
      assert_equal @onramp.remaining_id_count, 1
    end
  end

  describe '#vendor_name' do
    setup do
      @onramp = onramps(:vendor)
    end

    it 'should return the vendor name' do
      assert_equal @onramp.vendor_name, 'Test vendor for vendor batch traffic'
    end

    it 'should return Disqo' do
      @onramp = onramps(:disqo)
      assert_equal @onramp.vendor_name, 'Disqo'
    end

    it 'should return Disqo' do
      @onramp = onramps(:cint)
      assert_equal @onramp.vendor_name, 'Cint'
    end
  end

  describe 'after_update callback' do
    setup do
      @onramp = onramps(:testing)
    end

    test 'sends email when clean ID turned off' do
      @onramp.update!(check_clean_id: true, check_recaptcha: true)

      email = mock('email')
      EmployeeMailer.expects(:onramp_security_turned_off).returns(email)
      email.expects(:deliver_later)

      @onramp.update!(check_clean_id: false)
    end

    test 'sends email when recaptcha turned off' do
      @onramp.update!(check_clean_id: true, check_recaptcha: true)

      email = mock('email')
      EmployeeMailer.expects(:onramp_security_turned_off).returns(email)
      email.expects(:deliver_later)

      @onramp.update!(check_recaptcha: false)
    end

    test 'sends email when both turned off' do
      @onramp.update!(check_clean_id: true, check_recaptcha: true)

      email = mock('email')
      EmployeeMailer.expects(:onramp_security_turned_off).returns(email)
      email.expects(:deliver_later)

      @onramp.update!(check_clean_id: false, check_recaptcha: false)
    end

    test 'does not send email when both are on' do
      @onramp.update!(check_clean_id: false, check_recaptcha: false)

      EmployeeMailer.expects(:onramp_security_turned_off).never

      @onramp.update!(check_clean_id: true, check_recaptcha: true)
    end
  end
end
