# frozen_string_literal: true

# Run with: rails runner lib/scripts/print_onboarding_ip_addresses.rb > ~/Downloads/test.csv
PROJECT_ID = 16_428

project = Project.find(PROJECT_ID)

onboardings = project.onboardings.where.not(survey_started_at: nil)

header_row_one = ''
header_row_two = ''

header_row_one += 'Op4G,,,,'
header_row_two += 'Decoded UID,Encoded UID,Survey Start Time,IP Address,'

header_row_one += 'CleanID,,'
header_row_two += 'deviceId,multiDeviceId,'

header_row_one += 'CleanID: property,,,,,,,,,'
header_row_two += 'deviceType,isMobile,os,platform,browser,hardwareName,hardwareModel,hardwareVendor,ipAddress,'

header_row_one += 'CleanID: unique,'
header_row_two += 'isEventUnique,'

header_row_one += 'CleanID: marker,,,,,,,,,,,,,,,,,,,,,,,,,,,,'
header_row_two += 'score,invalidCount,invalidLowCount,invalidMediumCount,invalidHighCount,invalidCriticalCount,'
header_row_two += 'isKnownBrowser,isObsoleteBrowser,isKnownOs,isObsoleteOs,isKnownDeviceType,isKnownUserAgent,isKnownDomain,'
header_row_two += 'isBot,isDenylisted,isAllowlisted,isAnonymous,isTampered,isResist,isVelocity,isOscillating,'
header_row_two += 'isLang,isGeoLang,isGeoOsLang,isGeoPostal,isGeoCountry,isGeoTz,isGeoOffHrs,'

header_row_one += 'CleanID: geo,,'
header_row_two += 'countryCode,stateProvince,city'

puts header_row_one
puts header_row_two

# rubocop:disable Metrics/BlockLength
onboardings.each do |o|
  columns = []

  columns << o.uid.to_s
  columns << o.token.to_s
  columns << o.survey_started_at.to_s
  columns << o.ip_address.address.to_s

  # columns << o.clean_id_data&.dig('forensic')&.dig('requestId').to_s
  columns << o.clean_id_data&.dig('forensic')&.dig('deviceId').to_s
  columns << o.clean_id_data&.dig('forensic')&.dig('multiDeviceId').to_s

  columns << o.clean_id_data&.dig('forensic')&.dig('property')&.dig('deviceType').to_s
  columns << o.clean_id_data&.dig('forensic')&.dig('property')&.dig('isMobile').to_s
  columns << o.clean_id_data&.dig('forensic')&.dig('property')&.dig('os').to_s
  columns << o.clean_id_data&.dig('forensic')&.dig('property')&.dig('platform').to_s
  columns << o.clean_id_data&.dig('forensic')&.dig('property')&.dig('browser').to_s
  columns << o.clean_id_data&.dig('forensic')&.dig('property')&.dig('hardwareName').to_s
  columns << o.clean_id_data&.dig('forensic')&.dig('property')&.dig('hardwareModel').to_s
  columns << o.clean_id_data&.dig('forensic')&.dig('property')&.dig('hardwareVendor').to_s
  columns << o.clean_id_data&.dig('forensic')&.dig('property')&.dig('ipAddress').to_s

  columns << o.clean_id_data&.dig('forensic')&.dig('unique')&.dig('isEventUnique').to_s

  columns << o.clean_id_data&.dig('forensic')&.dig('marker')&.dig('score').to_s
  columns << o.clean_id_data&.dig('forensic')&.dig('marker')&.dig('invalidCount').to_s
  columns << o.clean_id_data&.dig('forensic')&.dig('marker')&.dig('invalidLowCount').to_s
  columns << o.clean_id_data&.dig('forensic')&.dig('marker')&.dig('invalidMediumCount').to_s
  columns << o.clean_id_data&.dig('forensic')&.dig('marker')&.dig('invalidHighCount').to_s
  columns << o.clean_id_data&.dig('forensic')&.dig('marker')&.dig('invalidCriticalCount').to_s
  columns << o.clean_id_data&.dig('forensic')&.dig('marker')&.dig('isKnownBrowser').to_s
  columns << o.clean_id_data&.dig('forensic')&.dig('marker')&.dig('isObsoleteBrowser').to_s
  columns << o.clean_id_data&.dig('forensic')&.dig('marker')&.dig('isKnownOs').to_s
  columns << o.clean_id_data&.dig('forensic')&.dig('marker')&.dig('isObsoleteOs').to_s
  columns << o.clean_id_data&.dig('forensic')&.dig('marker')&.dig('isKnownDeviceType').to_s
  columns << o.clean_id_data&.dig('forensic')&.dig('marker')&.dig('isKnownUserAgent').to_s
  columns << o.clean_id_data&.dig('forensic')&.dig('marker')&.dig('isKnownDomain').to_s
  columns << o.clean_id_data&.dig('forensic')&.dig('marker')&.dig('isBot').to_s
  columns << o.clean_id_data&.dig('forensic')&.dig('marker')&.dig('isDenylisted').to_s
  columns << o.clean_id_data&.dig('forensic')&.dig('marker')&.dig('isAllowlisted').to_s
  columns << o.clean_id_data&.dig('forensic')&.dig('marker')&.dig('isAnonymous').to_s
  columns << o.clean_id_data&.dig('forensic')&.dig('marker')&.dig('isTampered').to_s
  columns << o.clean_id_data&.dig('forensic')&.dig('marker')&.dig('isResist').to_s
  columns << o.clean_id_data&.dig('forensic')&.dig('marker')&.dig('isVelocity').to_s
  columns << o.clean_id_data&.dig('forensic')&.dig('marker')&.dig('isOscillating').to_s
  columns << o.clean_id_data&.dig('forensic')&.dig('marker')&.dig('isLang').to_s
  columns << o.clean_id_data&.dig('forensic')&.dig('marker')&.dig('isGeoLang').to_s
  columns << o.clean_id_data&.dig('forensic')&.dig('marker')&.dig('isGeoOsLang').to_s
  columns << o.clean_id_data&.dig('forensic')&.dig('marker')&.dig('isGeoPostal').to_s
  columns << o.clean_id_data&.dig('forensic')&.dig('marker')&.dig('isGeoCountry').to_s
  columns << o.clean_id_data&.dig('forensic')&.dig('marker')&.dig('isGeoTz').to_s
  columns << o.clean_id_data&.dig('forensic')&.dig('marker')&.dig('isGeoOffHrs').to_s

  columns << o.clean_id_data&.dig('forensic')&.dig('geo')&.dig('countryCode').to_s
  columns << o.clean_id_data&.dig('forensic')&.dig('geo')&.dig('stateProvince').to_s
  columns << o.clean_id_data&.dig('forensic')&.dig('geo')&.dig('city').to_s

  puts columns.join(',')
end
# rubocop:enable Metrics/BlockLength
