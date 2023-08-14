SELECT
	address, cnt
FROM
	ip_addresses
	JOIN (
		SELECT
			ip_address_id,
			count(*) AS cnt
		FROM
			ip_events
		WHERE
			message = 'InvalidAuthenticityToken'
      -- AND created_at > '2020-02-12'
		GROUP BY
			ip_address_id
		HAVING
			count(*) > 5) AS bad_ips ON ip_addresses.id = bad_ips.ip_address_id
WHERE
	category = 'allow'
ORDER BY
	cnt DESC;
