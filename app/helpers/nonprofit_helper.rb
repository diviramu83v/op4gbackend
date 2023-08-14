# frozen_string_literal: true

# View helpers for navigation
module NonprofitHelper
  # rubocop:disable Metrics/AbcSize
  def format_nonprofit_address(nonprofit)
    content = []

    content << tag.p(nonprofit.address_line_1, class: 'mb-0')
    content << tag.p(nonprofit.address_line_2, class: 'mb-0') if nonprofit.address_line_2.present?
    content << tag.p("#{nonprofit.city}, #{nonprofit.state} #{nonprofit.zip_code}", class: 'mb-0')
    content << tag.p(nonprofit.country.name, class: 'mb-0')

    safe_join(content)
  end
  # rubocop:enable Metrics/AbcSize

  # rubocop:disable Metrics/AbcSize
  def format_nonprofit_contact(nonprofit)
    content = []

    content << tag.p(nonprofit.contact_name, class: 'mb-0 font-weight-bold')
    content << tag.p(nonprofit.contact_title, class: 'mb-0') if nonprofit.contact_title.present?
    content << tag.p(mail_to(nonprofit.contact_email), class: 'mb-0') if nonprofit.contact_email.present?
    content << tag.p(nonprofit.contact_phone, class: 'mb-0') if nonprofit.contact_phone.present?

    safe_join(content)
  end
  # rubocop:enable Metrics/AbcSize

  def format_nonprofit_manager(nonprofit)
    content = []

    content << tag.p(nonprofit.manager_name, class: 'mb-0 font-weight-bold')
    content << tag.p(mail_to(nonprofit.manager_email), class: 'mb-0') if nonprofit.manager_email.present?

    safe_join(content)
  end
end
