class VendorMailer < ApplicationMailer
  default from: 'tcthinh10061998@gmail.com'

  def invite(vendor)
    @vendor_hard_code = "tctvipkg1998@gmail.com" # replace by @vendor.email

    mail to: @vendor_hard_code, subject: "Invite #{@vendor_hard_code}" 
  end
end
