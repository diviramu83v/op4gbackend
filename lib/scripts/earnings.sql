-- monthly earning totals
SELECT
	period,
	SUM(total_amount_cents) / 100.0 AS total,
	SUM(panelist_amount_cents) / 100.0 AS panelist,
	SUM(nonprofit_amount_cents) / 100.0 AS nonprofit
FROM
	earnings
	LEFT JOIN panelists ON earnings.panelist_id = panelists.id
WHERE
	earnings.period IN ('2019-08')
	AND panelists.welcomed_at IS NOT NULL
	AND (panelists.suspended_at IS NULL
		OR panelists.suspended_at < '2019-09-01')
	AND (panelists.deleted_at IS NULL
		OR panelists.deleted_at < '2019-09-01')
GROUP BY
	period
ORDER BY
	period;

-- nonprofit earnings
SELECT
	nonprofits.id,
	nonprofits.name,
	SUM(nonprofit_amount_cents) / 100.0 AS earnings
FROM
	earnings
	LEFT JOIN panelists ON earnings.panelist_id = panelists.id
	LEFT OUTER JOIN nonprofits ON earnings.nonprofit_id = nonprofits.id
WHERE
	earnings.period IN ('2019-08')
	AND earnings.nonprofit_amount_cents > 0
	AND panelists.welcomed_at IS NOT NULL
	AND (panelists.suspended_at IS NULL
		OR panelists.suspended_at < '2019-09-01')
	AND (panelists.deleted_at IS NULL
		OR panelists.deleted_at < '2019-09-01')
GROUP BY
	nonprofits.id,
	nonprofits.name
ORDER BY
	nonprofits.name;
