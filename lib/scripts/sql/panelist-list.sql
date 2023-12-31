-- Some common fields when looking at a list of panelists.

SELECT id,
       created_at,
       email,
       first_name,
       last_name,
       postal_code,
       country_id,
       locale,
       address,
       address_line_two,
       city,
       state,
       paypal,
       update_age_at,
       birthdate,
       campaign_id,
       original_panel_id,
       offer_code,
       affiliate_code,
       sub_affiliate_code,
       sub_affiliate_code_2,
       nonprofit_id,
       original_nonprofit_id,
       donation_percentage,
       original_donation_percentage flag_count,
       welcomed_at,
       last_activity_at,
       category,
       STATUS,
       primary_panel_id,
       clean_id_device_id
FROM panelists
WHERE id IN (30166271,
             30171161,
             30171162,
             30171117,
             30171163,
             30171078,
             30171119,
             30171101,
             30013770,
             30171091,
             30171103,
             30171090,
             30171168,
             30171076,
             30171158,
             30171159,
             30162566,
             30171170,
             30171075,
             30171079,
             30171120,
             30171065,
             30171077,
             30171097,
             30171106,
             30171167,
             30171118,
             30171121,
             30171122,
             7486446,
             30069604,
             30118736,
             30167688,
             30171088,
             30001278,
             91174,
             30166353,
             30144325,
             30060720,
             30163509,
             30168917,
             92102,
             4523420,
             30127657,
             89892,
             30021277);

