-- Total number of active panelists
SELECT
    count(*)
FROM
    panelists
WHERE
    welcomed_at IS NOT NULL
    AND suspended_at IS NULL
    AND deleted_at IS NULL;
-- 48,335

-- Total number of new panelists who are DOI and demos complete
SELECT
    count(*)
FROM
    panelists
WHERE
    welcomed_at IS NOT NULL
    AND suspended_at IS NULL
    AND deleted_at IS NULL;
-- 3,642

-- Invites sent (June 4 - August 10)
SELECT
    count(*)
FROM
    project_invitations
WHERE
    sent_at IS NOT NULL;
-- 1,122,967

-- Number of panelists receiving at least one invite
SELECT
    count(*)
FROM
    panelists
WHERE
    welcomed_at IS NOT NULL
    AND suspended_at IS NULL
    AND deleted_at IS NULL
    AND id IN (
        SELECT
            panelist_id
        FROM
            project_invitations
        WHERE
            sent_at IS NOT NULL);
-- 48,169

-- Number of panelists starting at least one survey (excludes vendor traffic)
SELECT
    count(*)
FROM
    panelists
WHERE
    welcomed_at IS NOT NULL
    AND suspended_at IS NULL
    AND deleted_at IS NULL
    AND id IN (
        SELECT
            panelist_id
        FROM
            onboardings
        WHERE
            survey_started_at IS NOT NULL);
-- 7,660

-- Total starts
SELECT
    count(*)
FROM
    onboardings
WHERE
    survey_started_at IS NOT NULL;
-- 332,517

-- Number of panelists completing at least one survey
SELECT
    count(*)
FROM
    panelists
WHERE
    welcomed_at IS NOT NULL
    AND suspended_at IS NULL
    AND deleted_at IS NULL
    AND id IN (
        SELECT
            panelist_id
        FROM
            onboardings
        WHERE
            survey_finished_at IS NOT NULL
            AND survey_response_pattern_id IN (
                SELECT
                    ID
                FROM
                    survey_response_patterns
                WHERE
                    slug = 'complete'));
-- 2,923

-- Total completes
SELECT
    count(*)
FROM
    onboardings
WHERE
    survey_finished_at IS NOT NULL
    AND survey_response_pattern_id IN (
        SELECT
            ID
        FROM
            survey_response_patterns
        WHERE
            slug = 'complete');
-- 83,513
