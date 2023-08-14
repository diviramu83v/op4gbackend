require "test_helper"

class VendorMailerTest < ActionMailer::TestCase
  test "invite" do
    mail = VendorMailer.invite
    assert_equal "Invite", mail.subject
    assert_equal ["phamminhvu.drca@gmail.com"], mail.to
    assert_equal ["tcthinh10061998@gmail.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
