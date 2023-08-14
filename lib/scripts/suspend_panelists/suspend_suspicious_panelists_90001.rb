# frozen_string_literal: true

uids = %w[
  XCoFpPR7xF7PXEvwxvueh2UM xMmSivgA343qYSjQhgamGGPz fye6TPnk2CiDUUzxn1YuUrTv
  76TEDWNRmE2JPN7HMoL4gm4w TUDaoFp2h5xFTbNPbChjaSAP qy8Z8Hsx6Ryhu98UzmhHBWhJ
  UhqwKaFoR9Ak5x5V7NTuy6mg zoiCSo7tAwKkx16JM2pkaaLF ToFeffKSr2i4nQ3gPvnyu7z4
  GyBgmNrk8jXJDsUB9FFLQ17S hU2t5brauZT474wSZ71Wv8LM PjCVc89v95s9RpvLHA2EMZR3
  f9UjeT9s4RPTdXYKVi1A8Rtv B5XNVjSRPcXJUaAdSzKcFDLB a5usRGAzE15FAKQ9pqvRwwgD
  Wi1zmLoHqBiW3attTkcgCqSh tePRs4NCS9PKp4WaLZi4XDZL fpZmZ8h2Pd2L8wdAHgoVmqLN
  BLqKeYX3E9ioPgRdD2UozC9F 3z3NzaDSVQ5Ndiuh22GyVLQC ekzj2YHMimBwy3Jit6Hk7U1W
  Kq4FakwMohRZuedxsLBGWG1G usfnPaKpz1jekWH1jDZ13s4C z39SbMyMzRWkVEhk1ryXyUaj
  uvvf2bVDSJKBXLrW651WnLKy YLDd2bM1bRXywamvqdBrDnge sZNTB8e2sRtiFkJBDQFsMo4Q
  UWQm4D4UBkTDjjMhrkd6Jpp2 rGuhvH4XDHbTqpsjfWgKGM6W LCeLZPJrE7qLW2XYAwPfvaxb
  SaZPYNA76ygbK8XoYCwGKUXu x6spMFBSbw93K7X1F3jVCmZA 5rJD6eVB17qrwa6Uy5PX9obk
  Jb6Qn37mbDNWegCP32akcNtF Ev9qTHcC2yKzZQ7q1tWgMyT1 jLA6CHFvKtrNPnwWCiLELmyG
  y63NNeZG4EUxDyrg3yNKv7NT nV6rmJYsiXsjZUCegmcnbzNv Z4xhUGiMzfmkkWEfprkuK6ci
  fm3g4mUyWw2kFQw3XMg9vFDS WtCDxAuS4NFwie4iPWzBHiVh 7LaWX1NKqRPLLW8shDueHgVK
  VaUgN8bfszCANQJhEaSr2RiC NFNriYscno1sGTXvN5wyK5mJ Yw1s2cb86MNT4bwQ5pQWfEEn
  KcCkdRrPKJ5PtSEYf53gdfrz 2EHQGw3DehDRhQmdvFYLZ1pw YPSCzatpHUbCUurmQ9qRM9re
]

count = 0

uids.each do |uid|
  panelist = Onboarding.find_by(token: uid).panelist

  next if panelist.suspended?

  panelist.update(
    suspended_at: Time.now.utc,
    status: Panelist.statuses[:suspended]
  )

  panelist.notes.create(employee_id: 0, body: 'based on reports of bot traffic from Ops.')

  count += 1

  puts "#{panelist.name} was suspended."
  puts "  Panelist note: #{panelist.notes.last.body}"
end

puts "#{count} panelists were suspended."
