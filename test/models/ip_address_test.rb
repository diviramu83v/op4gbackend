# frozen_string_literal: true

require 'test_helper'

class IpAddressTest < ActiveSupport::TestCase
  describe 'fixture' do
    it 'is valid' do
      ip_address = ip_addresses(:standard)
      assert ip_address.valid?
      assert_empty ip_address.errors
    end
  end

  describe 'associations' do
    subject { ip_addresses(:standard) }

    should have_many(:events).class_name('IpEvent')
  end

  describe 'columns' do
    subject { ip_addresses(:standard) }

    should have_db_column(:address)
    should have_db_column(:blocked_at)
    should have_db_column(:request_count)
    should have_db_column(:blocked_count)
  end

  describe 'fixtures' do
    test ':ip_address' do
      ip = ip_addresses(:standard)

      assert_not ip.blocked?
      assert_nil ip.blocked_at
      assert_equal 'allow', ip.category
    end

    test ':manually_blocked_ip_address' do
      ip = ip_addresses(:standard)
      ip.update(
        blocked_at: Faker::Date.backward(days: 90),
        status: 'blocked',
        category: 'deny-manual'
      )

      assert ip.blocked?
      assert_not_nil ip.blocked_at
      assert_equal 'deny-manual', ip.category
    end

    test ':auto_blocked_ip_address' do
      ip = ip_addresses(:standard)
      ip.update(
        blocked_at: Faker::Date.backward(days: 90),
        status: 'blocked',
        category: 'deny-auto'
      )

      assert ip.blocked?
      assert_not_nil ip.blocked_at
      assert_equal 'deny-auto', ip.category
    end
  end

  describe 'validations' do
    test 'category_matches_block_date' do
      ip = ip_addresses(:standard)

      ip.update(category: 'allow', blocked_at: Time.now.utc)
      assert_not ip.valid?

      ip.update(category: 'deny-manual', blocked_at: nil)
      assert_not ip.valid?

      ip.update(category: 'deny-auto', blocked_at: nil)
      assert_not ip.valid?
    end

    it 'throws the correct validation errors' do
      ip = IpEvent.new
      ip.save

      assert_not ip.valid?
      assert ip.errors.full_messages.include?('Ip must exist')
    end
  end

  describe '#auto_block' do
    describe 'unblocked ip address' do
      setup do
        @ip = ip_addresses(:standard)
      end

      describe 'ip feature flag present' do
        setup do
          FeatureManager.stubs(:ip_auto_blocking?).returns(true)
        end

        it 'updates blocked date' do
          @ip.auto_block && @ip.reload

          assert_not_nil @ip.blocked_at
          assert @ip.blocked?
        end
      end

      describe 'ip feature flag missing' do
        setup do
          FeatureManager.stubs(:ip_auto_blocking?).returns(nil)
        end

        it 'updates blocked date' do
          @ip.auto_block && @ip.reload

          assert_nil @ip.blocked_at
          assert_not @ip.blocked?
        end
      end
    end

    describe 'blocked ip address' do
      setup do
        @ip = ip_addresses(:standard)
        @ip.update(
          blocked_at: Faker::Date.backward(days: 90),
          status: 'blocked',
          category: 'deny-manual'
        )
      end

      it 'does not change blocked date' do
        original_block_date = @ip.blocked_at

        @ip.auto_block && @ip.reload

        assert_equal original_block_date, @ip.blocked_at
      end
    end
  end

  describe '#manually_block' do
    describe 'unblocked ip address' do
      setup do
        @ip = ip_addresses(:standard)
      end

      it 'updates blocked date' do
        assert_nil @ip.blocked_at

        @ip.manually_block && @ip.reload

        assert_not_nil @ip.blocked_at
        assert @ip.blocked?
      end
    end

    describe 'blocked ip address' do
      setup do
        @ip = ip_addresses(:standard)
        @ip.update(
          blocked_at: Faker::Date.backward(days: 90),
          status: 'blocked',
          category: 'deny-manual'
        )
      end

      it 'does not change blocked date' do
        original_block_date = @ip.blocked_at

        @ip.manually_block && @ip.reload

        assert_equal original_block_date, @ip.blocked_at
      end
    end
  end

  describe '#unblock' do
    setup do
      @manual_ip_block = ip_addresses(:standard)
      @manual_ip_block.update(
        blocked_at: Faker::Date.backward(days: 90),
        status: 'blocked',
        category: 'deny-manual'
      )

      @auto_ip_block = ip_addresses(:second)
      @auto_ip_block.update(
        blocked_at: Faker::Date.backward(days: 90),
        status: 'blocked',
        category: 'deny-auto'
      )
    end

    it 'removes the blocked date' do
      assert_not_nil @manual_ip_block.blocked_at
      @manual_ip_block.unblock && @manual_ip_block.reload
      assert_nil @manual_ip_block.blocked_at

      assert_not_nil @auto_ip_block.blocked_at
      @auto_ip_block.unblock && @auto_ip_block.reload
      assert_nil @auto_ip_block.blocked_at
    end

    it 'removes the block category' do
      assert_equal 'deny-manual', @manual_ip_block.category
      @manual_ip_block.unblock && @manual_ip_block.reload
      assert_equal 'allow', @manual_ip_block.category

      assert_equal 'deny-auto', @auto_ip_block.category
      @auto_ip_block.unblock && @auto_ip_block.reload
      assert_equal 'allow', @auto_ip_block.category
    end
  end

  describe '#blocked?' do
    subject { ip_addresses(:standard) }

    it 'returns true when blocked date is set' do
      subject.update!(category: 'deny-manual', blocked_at: Time.now.utc)
      assert subject.blocked?

      subject.update!(category: 'deny-auto', blocked_at: Time.now.utc)
      assert subject.blocked?
    end

    it 'returns false when blocked date is nil' do
      subject.update!(category: 'allow', blocked_at: nil)
      assert_not subject.blocked?
    end
  end

  describe '#record_suspicious_event!' do
    subject { ip_addresses(:standard) }

    it 'creates a new ip event record' do
      assert_difference -> { IpEvent.count } do
        subject.record_suspicious_event!(message: 'InvalidAuthenticityToken')
      end
    end
  end

  describe '.find_or_create' do
    it 'requires a named address parameter' do
      assert_raises ArgumentError do
        IpAddress.find_or_create('1.2.3.4')
      end
    end

    it 'creates a new record if appropriate' do
      @address = '1.2.3.4'

      assert_nil IpAddress.find_by(address: @address)

      assert_difference -> { IpAddress.count } do
        IpAddress.find_or_create(address: @address)
      end
    end

    it 'finds an existing record' do
      @ip = ip_addresses(:standard)
      @address = @ip.address

      assert_equal @ip, IpAddress.find_or_create(address: @address)
    end

    describe 'when encountering a race condition' do
      setup do
        @ip = ip_addresses(:standard)
        @address = @ip.address

        IpAddress.expects(:find_or_create_by).raises(ActiveRecord::RecordNotUnique)
      end

      it 'returns the matching record' do
        assert_equal @ip, IpAddress.find_or_create(address: @address)
      end
    end
  end

  describe '.auto_block' do
    it 'requires a named address parameter' do
      assert_raises ArgumentError do
        IpAddress.auto_block('1.2.3.4')
      end
    end

    it 'calls #auto_block' do
      IpAddress.any_instance.expects(:auto_block).once

      @address = '1.2.3.4'

      IpAddress.auto_block(address: @address, reason: 'test')
    end

    it 'creates a new record if appropriate' do
      @address = '1.2.3.4'

      assert_nil IpAddress.find_by(address: @address)

      assert_difference -> { IpAddress.count } do
        IpAddress.auto_block(address: @address, reason: 'test')
      end
    end

    it 'flags an existing record' do
      @ip = ip_addresses(:standard)
      @address = @ip.address

      assert_not_nil IpAddress.find_by(address: @address)

      assert_no_difference -> { IpAddress.count } do
        IpAddress.auto_block(address: @address, reason: 'test')
      end
    end
  end

  describe '.blocked_automatically' do
    setup do
      @ip_address = ip_addresses(:standard)
    end

    it 'includes the auto blocked records in .blocked' do
      FeatureManager.stubs(:ip_auto_blocking?).returns(true)
      assert_difference -> { IpAddress.not_allowed.count } do
        @ip_address.auto_block
      end
    end

    it 'includes the auto blocked records in .blocked_automatically' do
      FeatureManager.stubs(:ip_auto_blocking?).returns(true)
      assert_difference -> { IpAddress.blocked_automatically.count } do
        @ip_address.auto_block
      end
    end

    it 'does not include the manually blocked records in .blocked_automatically' do
      assert_no_difference -> { IpAddress.blocked_automatically.count } do
        @ip_address.manually_block
      end
    end

    it 'does not include the allowed records in .blocked_automatically' do
      assert_no_difference -> { IpAddress.blocked_automatically.count } do
        @ip_address.update(category: 'allow', blocked_at: nil)
      end
    end
  end

  describe '.blocked_manually' do
    setup do
      @ip_address = ip_addresses(:standard)
    end

    it 'includes the manually blocked records in .blocked' do
      assert_difference -> { IpAddress.not_allowed.count } do
        @ip_address.manually_block
      end
    end

    it 'includes the manually blocked records in .blocked_manually' do
      assert_difference -> { IpAddress.blocked_manually.count } do
        @ip_address.manually_block
      end
    end

    it 'does not include the auto blocked records in .blocked_manually' do
      assert_no_difference -> { IpAddress.blocked_manually.count } do
        @ip_address.auto_block
      end
    end

    it 'does not include the allowed records in .blocked_manually' do
      assert_no_difference -> { IpAddress.blocked_manually.count } do
        @ip_address.update(category: 'allow', blocked_at: nil)
      end
    end
  end

  describe '.block_suspicious_ips' do
    setup do
      @ip = ip_addresses(:standard)
    end

    it 'blocks an IP address with a bunch of events' do
      FeatureManager.expects(:ip_auto_blocking?).returns(true)
      10.times do
        IpEvent.create(ip: @ip, message: 'warning')
      end

      assert_difference -> { IpAddress.not_allowed.count } do
        IpAddress.block_suspicious_ips
      end
    end

    it 'does not block an IP address under a certain number of events' do
      FeatureManager.expects(:ip_auto_blocking?).never
      9.times do
        IpEvent.create(ip: @ip, message: 'warning')
      end

      assert_no_difference -> { IpAddress.blocked.count } do
        IpAddress.block_suspicious_ips
      end
    end
  end

  describe '#sort_by_context' do
    setup do
      @onboarding_ip = ip_addresses(:second)
      @onboarding = onboardings(:standard)
      @onboarding.update!(ip_address: @onboarding_ip)

      @panelist_ip = ip_addresses(:third)
      @panelist = panelists(:standard)
      @panelist.ip_histories.create!(ip_address: @panelist_ip, source: 'signup')
    end

    it 'returns true' do
      @context = 'onboarding'
      assert_includes(IpAddress.sort_by_context(@context), @onboarding_ip)
    end

    it 'returns false' do
      @context = 'onboarding'
      assert_not_includes(IpAddress.sort_by_context(@context), @panelist_ip)
    end

    it 'returns true' do
      @context = 'panelist'
      assert_includes(IpAddress.sort_by_context(@context), @panelist_ip)
    end

    it 'returns false' do
      @context = 'panelist'
      assert_not_includes(IpAddress.sort_by_context(@context), @onboarding_ip)
    end
  end
end
