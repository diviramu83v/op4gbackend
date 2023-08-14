# frozen_string_literal: true

# Overriding stock devise helper to create nicer error messages.
module DeviseHelper
  # rubocop:disable Rails/OutputSafety
  def devise_error_messages!
    return '' if resource.errors.empty?

    messages = resource.errors.full_messages.map { |msg| tag.li(msg) }.join

    html = <<-HTML
    <div id="error_explanation" class="alert alert-danger">
      <ul>#{messages}</ul>
    </div>
    HTML

    html.html_safe
  end
  # rubocop:enable Rails/OutputSafety
end
