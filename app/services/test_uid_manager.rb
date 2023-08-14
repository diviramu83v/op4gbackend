# frozen_string_literal: true

# a class that manages test uids for test links
class TestUidManager
  def initialize(employee:, onramp:)
    raise 'employee parameter must not be nil' if employee.nil?
    raise 'onramp parameter must not be nil' if onramp.nil?

    @employee = employee
    @onramp = onramp
  end

  def next
    last_uid = last_used_uid(@employee, @onramp)
    uid = next_uid_number(last_uid)
    new_uid = TestUid.create(employee: @employee, onramp: @onramp, uid: uid)
    "#{@employee.initials&.downcase}_test_#{new_uid.uid}"
  end

  private

  def next_uid_number(last_used_uid)
    if last_used_uid.present?
      last_used_uid + 1
    else
      1
    end
  end

  def last_used_uid(employee, onramp)
    employee.test_uids.newest_first.find_by(onramp: onramp)&.uid
  end
end
