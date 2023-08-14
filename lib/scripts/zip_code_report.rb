# frozen_string_literal: true

potential_zip_matches = ActiveRecord::Base.connection.execute(
  'SELECT * FROM panelists
      WHERE country_id = 1
        AND zip_code_id IS NULL
        AND (
          length(postal_code) = 5
          OR length(postal_code) = 10
        )
        AND postal_code ~ \'^[0-9\.\-]+$\'
        AND status = \'active\''
)

# Print the number of postal codes that are possibly valid, but have no zip_code_id
p "Number of unmatched 5 or 10-digit zip codes : #{potential_zip_matches.to_a.length}"

# Get all the zip codes in the U.S. (Some Chicago zip, and all the zips within 9999999 miles)
res = HTTParty.get('https://www.zipcodeapi.com/rest/0JVDqvUgO7h0jTIupi7h5BllomIVsZP141turd9pQrP9HpLysiIaTlUCwFemlKy0/radius.json/60007/9999999/mile?minimal')

zip_codes = JSON.parse(res.body)['zip_codes']

# Print out the number of zip codes returned by the zipcodeapi.com
p "looked up #{zip_codes.length} zip codes"

# Attempt to match the unmatched postal codes to the zipcodeapi.com list
matching_zips = []

potential_zip_matches.each do |zip|
  matching_zips << zip if zip_codes.include? zip['postal_code']
end

# Print the number of matching postal_codes
p "zips that match new codes: #{matching_zips.length}"

other_country_6_or_7_zip = ActiveRecord::Base.connection.execute("SELECT * FROM panelists WHERE country_id != 1
                                                                  AND zip_code_id IS NULL
                                                                  AND length(replace(postal_code, ' ', '')) >= 6
                                                                  AND status = 'active'")

# Print the number of non-U.S. postal codes that may be valid
p "Other country, possibly valid zips = #{other_country_6_or_7_zip.to_a.length}"
