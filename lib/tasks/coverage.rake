# frozen_string_literal: true

if Rails.env.test? || Rails.env.development?
  require 'simplecov'

  DEFAULT_MINIMUM_COVERAGE = 94

  namespace :coverage do
    desc 'Check current coverage against minimum coverage and output result'
    task check: :environment do
      required_coverage = DEFAULT_MINIMUM_COVERAGE
      coverage = current_coverage
      ratio = "#{coverage} / #{required_coverage}"
      if coverage < required_coverage
        puts "Coverage is below required threshold: #{ratio}"
        exit 1
      else
        puts "Coverage is above required threshold: #{ratio}"
      end
    end

    def current_coverage
      file = Rails.root.join('coverage/index.html').read
      doc = Nokogiri::HTML.parse(file)
      node = doc.css('h2 .covered_percent > .green').first
      node.text.to_f
    end
  end
end
