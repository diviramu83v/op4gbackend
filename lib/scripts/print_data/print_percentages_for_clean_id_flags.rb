# frozen_string_literal: true

# 1 argument: # 1 argument: number_of_months
# Usage: rails runner lib/scripts/print_percentages_for_clean_id_flags.rb 1

start_script = Time.zone.now
number_of_months = ARGV[0].to_i
@start_time = number_of_months.months.ago.beginning_of_month
@end_time = @start_time.end_of_month

puts "Start: #{@start_time}"
puts "End: #{@end_time}\n"

@accepted_onboardings = Onboarding.where(created_at: @start_time..@end_time).where(client_status: :accepted).select do |onboarding|
  onboarding.traffic_steps.pre_survey.where(category: 'clean_id').present?
end

@fraudulent_onboardings = Onboarding.where(created_at: @start_time..@end_time).where(client_status: :fraudulent).select do |onboarding|
  onboarding.traffic_steps.pre_survey.where(category: 'clean_id').present?
end

accepted_onboardings_count = @accepted_onboardings.count
fraudulent_onboardings_count = @fraudulent_onboardings.count

def dig_flag(flag, data)
  flag_array = flag.split('/')
  data.dig(*flag_array)
end

def increment_counts(data)
  continue if data.nil?
  @true_count += 1 if data == 'true'
  @false_count += 1 if data == 'false'
end

def get_true_false_count(flag, client_status)
  @true_count = 0
  @false_count = 0
  onboardings = client_status == :accepted ? @accepted_onboardings : @fraudulent_onboardings
  @flag = flag
  onboardings.each do |onboarding|
    clean_id_data = OnboardingCleanIdData.new(onboarding: onboarding).pre_survey_clean_id_data
    next if clean_id_data.is_a?(String) || clean_id_data.blank?

    @data = dig_flag(@flag, clean_id_data).to_s
    increment_counts(@data)
  end
  [@true_count, @false_count]
end

def calculate_percentage(true_false_count, total_count)
  true_percentage = (true_false_count[0] / total_count.to_f) * 100
  false_percentage = (true_false_count[1] / total_count.to_f) * 100
  [true_percentage, false_percentage]
end

def output_values(flag, accepted_percents, fraudulent_percents)
  difference = accepted_percents[0].round - fraudulent_percents[0].round
  return if difference.zero?

  puts flag
  puts "Accepted IDs:   TRUE:#{accepted_percents[0].round}%, FALSE:#{accepted_percents[1].round}%"
  puts "Fraudulent IDs: TRUE:#{fraudulent_percents[0].round}%, FALSE:#{fraudulent_percents[1].round}%"
  puts "Difference:     #{difference}%"
  puts
end

def output_hash(flag, accepted_hash, fraud_hash)
  puts flag
  puts 'Accepted'
  accepted_hash.first(15).to_h.each do |key, value|
    printf "%-6<value>s %<key>s\n", value: value, key: key
  end
  puts
  puts 'Fraudulent'
  fraud_hash.first(15).to_h.each do |key, value|
    printf "%-6<value>s %<key>s\n", value: value, key: key
  end
end

def get_count_hash(flag, client_status)
  onboardings = client_status == :accepted ? @accepted_onboardings : @fraudulent_onboardings
  count_hash = Hash.new(0)
  onboardings.each do |onboarding|
    clean_id_data = OnboardingCleanIdData.new(onboarding: onboarding).pre_survey_clean_id_data
    next if clean_id_data.is_a?(String) || clean_id_data.blank?

    key = dig_flag(flag, clean_id_data).to_s
    count_hash[key] += 1
  end
  count_hash = count_hash.sort_by { |_k, v| -v }.to_h
end

# isMobile
ismobile_accepted_result = get_true_false_count('forensic/property/isMobile', :accepted)
ismobile_fraudulent_result = get_true_false_count('forensic/property/isMobile', :fraudulent)
ismobile_accept_percents = calculate_percentage(ismobile_accepted_result, accepted_onboardings_count)
ismobile_fraud_percents = calculate_percentage(ismobile_fraudulent_result, fraudulent_onboardings_count)
output_values('isMobile', ismobile_accept_percents, ismobile_fraud_percents)

# isEventUnique
isunique_accepted_result = get_true_false_count('forensic/unique/isEventUnique', :accepted)
isunique_fraudulent_result = get_true_false_count('forensic/unique/isEventUnique', :fraudulent)
isunique_accept_percents = calculate_percentage(isunique_accepted_result, accepted_onboardings_count)
isunique_fraud_percents = calculate_percentage(isunique_fraudulent_result, fraudulent_onboardings_count)
output_values('isEventUnique', isunique_accept_percents, isunique_fraud_percents)

# isKnownBrowser
isknownbrowser_accepted_result = get_true_false_count('forensic/marker/isKnownBrowser', :accepted)
isknownbrowser_fraud_result = get_true_false_count('forensic/marker/isKnownBrowser', :fraudulent)
isknownbrowser_accept_percents = calculate_percentage(isknownbrowser_accepted_result, accepted_onboardings_count)
isknownbrowser_fraud_percents = calculate_percentage(isknownbrowser_fraud_result, fraudulent_onboardings_count)
output_values('isKnownBrowser', isknownbrowser_accept_percents, isknownbrowser_fraud_percents)

# isObsoleteBrowser
isobsbrowser_accepted_result = get_true_false_count('forensic/marker/isObsoleteBrowser', :accepted)
isobsbrowser_fraudulent_result = get_true_false_count('forensic/marker/isObsoleteBrowser', :fraudulent)
isobsbrowser_accept_percents = calculate_percentage(isobsbrowser_accepted_result, accepted_onboardings_count)
isobsbrowser_fraud_percents = calculate_percentage(isobsbrowser_fraudulent_result, fraudulent_onboardings_count)
output_values('isObsoleteBrowser', isobsbrowser_accept_percents, isobsbrowser_fraud_percents)

# isKnownOs
isknownos_accepted_result = get_true_false_count('forensic/marker/isKnownOs', :accepted)
isknownos_fraudulent_result = get_true_false_count('forensic/marker/isKnownOs', :fraudulent)
isknownos_accept_percents = calculate_percentage(isknownos_accepted_result, accepted_onboardings_count)
isknownos_fraud_percents = calculate_percentage(isknownos_fraudulent_result, fraudulent_onboardings_count)
output_values('isKnownOs', isknownos_accept_percents, isknownos_fraud_percents)

# isObsoleteOs
isobsos_accepted_result = get_true_false_count('forensic/marker/isObsoleteOs', :accepted)
isobsos_fraudulent_result = get_true_false_count('forensic/marker/isObsoleteOs', :fraudulent)
isobsos_accept_percents = calculate_percentage(isobsos_accepted_result, accepted_onboardings_count)
isobsos_fraud_percents = calculate_percentage(isobsos_fraudulent_result, fraudulent_onboardings_count)
output_values('isObsoleteOs', isobsos_accept_percents, isobsos_fraud_percents)

# isKnownDeviceType
isknowndev_accepted_result = get_true_false_count('forensic/marker/isKnownDeviceType', :accepted)
isknowndev_fraudulent_result = get_true_false_count('forensic/marker/isKnownDeviceType', :fraudulent)
isknowndev_accept_percents = calculate_percentage(isknowndev_accepted_result, accepted_onboardings_count)
isknowndev_fraud_percents = calculate_percentage(isknowndev_fraudulent_result, fraudulent_onboardings_count)
output_values('isKnownDeviceType', isknowndev_accept_percents, isknowndev_fraud_percents)

# isKnownUserAgent
isknownuser_accepted_result = get_true_false_count('forensic/marker/isKnownUserAgent', :accepted)
isknownuser_fraudulent_result = get_true_false_count('forensic/marker/isKnownUserAgent', :fraudulent)
isknownuser_accept_percents = calculate_percentage(isknownuser_accepted_result, accepted_onboardings_count)
isknownuser_fraud_percents = calculate_percentage(isknownuser_fraudulent_result, fraudulent_onboardings_count)
output_values('isKnownUserAgent', isknownuser_accept_percents, isknownuser_fraud_percents)

# isKnownDomain
isknowndom_accepted_result = get_true_false_count('forensic/marker/isKnownDomain', :accepted)
isknowndom_fraudulent_result = get_true_false_count('forensic/marker/isKnownDomain', :fraudulent)
isknowndom_accept_percents = calculate_percentage(isknowndom_accepted_result, accepted_onboardings_count)
isknowndom_fraud_percents = calculate_percentage(isknowndom_fraudulent_result, fraudulent_onboardings_count)
output_values('isKnownDomain', isknowndom_accept_percents, isknowndom_fraud_percents)

# isBot
isbot_accepted_result = get_true_false_count('forensic/marker/isBot', :accepted)
isbot_fraudulent_result = get_true_false_count('forensic/marker/isBot', :fraudulent)
isbot_accept_percents = calculate_percentage(isbot_accepted_result, accepted_onboardings_count)
isbot_fraud_percents = calculate_percentage(isbot_fraudulent_result, fraudulent_onboardings_count)
output_values('isBot', isbot_accept_percents, isbot_fraud_percents)

# isDenylisted
isdenylist_accepted_result = get_true_false_count('forensic/marker/isDenylisted', :accepted)
isdenylist_fraudulent_result = get_true_false_count('forensic/marker/isDenylisted', :fraudulent)
isdenylist_accept_percents = calculate_percentage(isdenylist_accepted_result, accepted_onboardings_count)
isdenylist_fraud_percents = calculate_percentage(isdenylist_fraudulent_result, fraudulent_onboardings_count)
output_values('isDenylisted', isdenylist_accept_percents, isdenylist_fraud_percents)

# isAllowlisted
isallowlist_accepted_result = get_true_false_count('forensic/marker/isAllowlisted', :accepted)
isallowlist_fraudulent_result = get_true_false_count('forensic/marker/isAllowlisted', :fraudulent)
isallowlist_accept_percents = calculate_percentage(isallowlist_accepted_result, accepted_onboardings_count)
isallowlist_fraud_percents = calculate_percentage(isallowlist_fraudulent_result, fraudulent_onboardings_count)
output_values('isAllowlisted', isallowlist_accept_percents, isallowlist_fraud_percents)

# isAnonymous
isanonymous_accepted_result = get_true_false_count('forensic/marker/isAnonymous', :accepted)
isanonymous_fraudulent_result = get_true_false_count('forensic/marker/isAnonymous', :fraudulent)
isanonymous_accept_percents = calculate_percentage(isanonymous_accepted_result, accepted_onboardings_count)
isanonymous_fraud_percents = calculate_percentage(isanonymous_fraudulent_result, fraudulent_onboardings_count)
output_values('isAnonymous', isanonymous_accept_percents, isanonymous_fraud_percents)

# isTampered
istampered_accepted_result = get_true_false_count('forensic/marker/isTampered', :accepted)
istampered_fraudulent_result = get_true_false_count('forensic/marker/isTampered', :fraudulent)
istampered_accept_percents = calculate_percentage(istampered_accepted_result, accepted_onboardings_count)
istampered_fraud_percents = calculate_percentage(istampered_fraudulent_result, fraudulent_onboardings_count)
output_values('isTampered', istampered_accept_percents, istampered_fraud_percents)

# isResist
isresist_accepted_result = get_true_false_count('forensic/marker/isResist', :accepted)
isresist_fraudulent_result = get_true_false_count('forensic/marker/isResist', :fraudulent)
isresist_accept_percents = calculate_percentage(isresist_accepted_result, accepted_onboardings_count)
isresist_fraud_percents = calculate_percentage(isresist_fraudulent_result, fraudulent_onboardings_count)
output_values('isResist', isresist_accept_percents, isresist_fraud_percents)

# isVelocity
isvelocity_accepted_result = get_true_false_count('forensic/marker/isVelocity', :accepted)
isvelocity_fraudulent_result = get_true_false_count('forensic/marker/isVelocity', :fraudulent)
isvelocity_accept_percents = calculate_percentage(isvelocity_accepted_result, accepted_onboardings_count)
isvelocity_fraud_percents = calculate_percentage(isvelocity_fraudulent_result, fraudulent_onboardings_count)
output_values('isVelocity', isvelocity_accept_percents, isvelocity_fraud_percents)

# isOscillating
isoscill_accepted_result = get_true_false_count('forensic/marker/isOscillating', :accepted)
isoscill_fraudulent_result = get_true_false_count('forensic/marker/isOscillating', :fraudulent)
isoscill_accept_percents = calculate_percentage(isoscill_accepted_result, accepted_onboardings_count)
isoscill_fraud_percents = calculate_percentage(isoscill_fraudulent_result, fraudulent_onboardings_count)
output_values('isOscillating', isoscill_accept_percents, isoscill_fraud_percents)

# isLang
islang_accepted_result = get_true_false_count('forensic/marker/isLang', :accepted)
islang_fraudulent_result = get_true_false_count('forensic/marker/isLang', :fraudulent)
islang_accept_percents = calculate_percentage(islang_accepted_result, accepted_onboardings_count)
islang_fraud_percents = calculate_percentage(islang_fraudulent_result, fraudulent_onboardings_count)
output_values('isLang', islang_accept_percents, islang_fraud_percents)

# isGeoLang
isgeolang_accepted_result = get_true_false_count('forensic/marker/isGeoLang', :accepted)
isgeolang_fraudulent_result = get_true_false_count('forensic/marker/isGeoLang', :fraudulent)
isgeolang_accept_percents = calculate_percentage(isgeolang_accepted_result, accepted_onboardings_count)
isgeolang_fraud_percents = calculate_percentage(isgeolang_fraudulent_result, fraudulent_onboardings_count)
output_values('isGeoLang', isgeolang_accept_percents, isgeolang_fraud_percents)

# isGeoOsLang
isgeooslang_accepted_result = get_true_false_count('forensic/marker/isGeoOsLang', :accepted)
isgeooslang_fraudulent_result = get_true_false_count('forensic/marker/isGeoOsLang', :fraudulent)
isgeooslang_accept_percents = calculate_percentage(isgeooslang_accepted_result, accepted_onboardings_count)
isgeooslang_fraud_percents = calculate_percentage(isgeooslang_fraudulent_result, fraudulent_onboardings_count)
output_values('isGeoOsLang', isgeooslang_accept_percents, isgeooslang_fraud_percents)

# isGeoPostal
isgeopostal_accepted_result = get_true_false_count('forensic/marker/isGeoPostal', :accepted)
isgeopostal_fraudulent_result = get_true_false_count('forensic/marker/isGeoPostal', :fraudulent)
isgeopostal_accept_percents = calculate_percentage(isgeopostal_accepted_result, accepted_onboardings_count)
isgeopostal_fraud_percents = calculate_percentage(isgeopostal_fraudulent_result, fraudulent_onboardings_count)
output_values('isGeoPostal', isgeopostal_accept_percents, isgeopostal_fraud_percents)

# isGeoCountry
isgeocountry_accepted_result = get_true_false_count('forensic/marker/isGeoCountry', :accepted)
isgeocountry_fraudulent_result = get_true_false_count('forensic/marker/isGeoCountry', :fraudulent)
isgeocountry_accept_percents = calculate_percentage(isgeocountry_accepted_result, accepted_onboardings_count)
isgeocountry_fraud_percents = calculate_percentage(isgeocountry_fraudulent_result, fraudulent_onboardings_count)
output_values('isGeoCountry', isgeocountry_accept_percents, isgeocountry_fraud_percents)

# isGeoTz
isgeotz_accepted_result = get_true_false_count('forensic/marker/isGeoTz', :accepted)
isgeotz_fraudulent_result = get_true_false_count('forensic/marker/isGeoTz', :fraudulent)
isgeotz_accept_percents = calculate_percentage(isgeotz_accepted_result, accepted_onboardings_count)
isgeotz_fraud_percents = calculate_percentage(isgeotz_fraudulent_result, fraudulent_onboardings_count)
output_values('isGeoTz', isgeotz_accept_percents, isgeotz_fraud_percents)

# isGeoOffHrs
isgeoffhrs_accepted_result = get_true_false_count('forensic/marker/isGeoOffHrs', :accepted)
isgeoffhrs_fraudulent_result = get_true_false_count('forensic/marker/isGeoOffHrs', :fraudulent)
isgeoffhrs_accept_percents = calculate_percentage(isgeoffhrs_accepted_result, accepted_onboardings_count)
isgeoffhrs_fraud_percents = calculate_percentage(isgeoffhrs_fraudulent_result, fraudulent_onboardings_count)
output_values('isGeoOffHrs', isgeoffhrs_accept_percents, isgeoffhrs_fraud_percents)

# browser
accepted_hash = get_count_hash('forensic/property/browser', :accepted)
fraudulent_hash = get_count_hash('forensic/property/browser', :fraudulent)
output_hash('browser', accepted_hash, fraudulent_hash)

# operating system
accepted_hash = get_count_hash('forensic/property/os', :accepted)
fraudulent_hash = get_count_hash('forensic/property/os', :fraudulent)
output_hash('operating system', accepted_hash, fraudulent_hash)

end_script = Time.zone.now
puts "Run time: #{(end_script - start_script).to_i} seconds"
