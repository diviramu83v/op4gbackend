# frozen_string_literal: true

panelists = Panelist.where('created_at >= ?', 90.days.ago)

total = panelists.count

signing_up = panelists.signing_up.count
confirmed = panelists.signing_up.where.not(confirmed_at: nil).count
unconfirmed = panelists.signing_up.where(confirmed_at: nil).count

active = panelists.active.count
suspended = panelists.suspended.count
deleted = panelists.deleted.count
deactivated = panelists.deactivated.count
deactivated_signup = panelists.deactivated_signup.count

puts "total: #{total}"
puts
puts "signing_up: #{signing_up} (#{(signing_up.to_f / total * 100).round(1)}%)"
puts "-- confirmed: #{confirmed} (#{(confirmed.to_f / total * 100).round(1)}%)"
puts "-- unconfirmed: #{unconfirmed} (#{(unconfirmed.to_f / total * 100).round(1)}%)"
puts
puts "active: #{active} (#{(active.to_f / total * 100).round(1)}%)"
puts
puts "suspended: #{suspended} (#{(suspended.to_f / total * 100).round(1)}%)"
puts "deleted: #{deleted} (#{(deleted.to_f / total * 100).round(1)}%)"
puts "deactivated: #{deactivated} (#{(deactivated.to_f / total * 100).round(1)}%)"
puts "deactivated_signup: #{deactivated_signup} (#{(deactivated_signup.to_f / total * 100).round(1)}%)"
