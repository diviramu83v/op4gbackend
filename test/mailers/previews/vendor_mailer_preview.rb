# Preview all emails at http://localhost:3000/rails/mailers/vendor_mailer
class VendorMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/vendor_mailer/invite
  def invite
    VendorMailer.invite
  end

end
