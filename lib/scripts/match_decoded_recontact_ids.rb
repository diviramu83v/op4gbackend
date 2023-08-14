# frozen_string_literal: true

original_ids = %w[
  fSn4YpfGSdknQTpKuaY518sM
  MbF3SySXcFZueNML7U6ikzB3
  BrNrvn9uC2Ed8evTMbEqs82g
  GrJcHqb5w2bkPGaG9L86cPdX
  xDRmjsUTEVJ3jdcicYqWHs4n
  RUFYSszYCKGiB1PyqDSJVA7D
  XXGRwFTWnJH9b1cM38VuqPAV
  vWn7uXRSin1B8Gj8QtnCLHP9
  n3ezYcyPG3qv55eqQN1fDayu
  N6HHh2zuoF7VvCvtxh3nwnBV
  DATWmfsZWwo9NJRKhTEmiwz7
  rP3AbKTEUDnB1dVjhRfLSVX5
  eprrhcKGGfxLz4Kuw5vZXFPU
  gy45dvGB5QAYJMgFaTo1vMaJ
  z4vTp2w15Sg4ATWRYegZWW4C
  8NzYqLzoKugPwJX3y7LvxkWj
  ef9j1mwiyug1gxvVq4xUMYHq
  Jhm6Cj3ksxhaU9YaFqmjqCvF
  uiYE26BfJJzGxLqvNYg2iTK6
  GzBSZLpqsjh9xtyNj4SiGKPP
  dJ467jhHVH8FNyBnt5mUC43e
  n7cu1bbZV68id5qRB53SawZP
  QjEGRifHgBM6kzmqc1RXeZUj
  1mFtYqGLbpAfhWUvzaMe93tg
  7zbjPuJjEMqZ3cfAAui3Romr
  HJ1Lmpmb8J3PbMzCb9qH5Chi
  qeNKvPvfZyhkXrYPSwETERXe
  JKr2oQJ6xAnczpYVUdfZxt9q
  min6hS53HEjN5gqBRBmxSjgJ
  hZsUk2hK1DLQT3wmbbbMve2r
  XKLEhGMtDB8MtEjrzM8AyfTW
  Gx2EHWn71JxTmkiYyuWTefdf
  kCJRgbpj8mdd6WqyTEcphNhY
  DJeLcNMG3w6JEZVnJBQaeJmk
  vDn9pk4pLrXrsumaAM7NBtUs
  HojbMa1sB2hxkeChoxrWWG2s
  hM1ZnvTgnyaa7C4QsnvxNhwk
  gbCRMivi5PwqWVBziCTUHxFJ
  cFxq7uUmj8Wn8yhqPU7ckcGn
  dLQsZGe5cDraG4udYFo7FRfW
  oa8NDLqiBkrgoS2YSSk3YcVQ
  KF4SVcDVX9qVXrDLEc3YDyUF
  qpNthLxxvuDBtvGhB5H5qoWw
  X5ps4pdoPRGo1RaAkBg4147x
  25Fd74QBpuwxei87JFRsz5SS
  Wa583cFVmM854r9vSfXd74Yn
  8Kc8qynxwcSDJpRntuLGXXiU
  hVAW1xLn81yjZcjhq1wjtAMH
  3Gjezy57Pa7gJp4rGAEU3PKs
  yRKDxpiqCGR1j7mdLgL2Wsvo
  kkpkb6uavd53btPB1UjLouAg
  euP7Ug3zZM9udoAU3BsbZYPi
  HXtPyGFoJfnpoRBUhpSXfiJg
  n5yikQzR56wcEX7HANBU4g3o
  PCrmncQhdPZY9UUYYrbYeEHU
  oC7enyspYyPMk975fZV9BEdD
  9EzSoPpnp3deEERMiUrXNbqK
  5U4TRN5nUtYdcXhd2A5WK5Hr
  USJ2FWmtpGyCcjyjR1g4Pzu8
  uEJun5FQBS2Ceh3fvRvrvM5G
  avV51kNQ5LnJDwAqnxPQeTQy
  GKGNaLLSQ9yhu8xf5q5oigVE
  VsBTp2cfVutKWTMyV1LcQxrE
  hPkGyVF7QSTbjyPi1AhgbDgK
  8pP8niwMtDhrN4dqohKe99of
  sQR1ffA9yBULHhBfu2k9Q1ue
  pweAg5bi4FtZpxAaD9W46gUD
  qZ2p6bm1CYwKba2KEfa2j3y3
  5Woa8NDKXJspvqY7Ujoy7LAS
  PcqJQdecs1YjPV4HhwnjWN7X
  2WAqf8rYs9gNz3a33oPeMc94
  pkGjto197VVvKBXajPLqDvTf
  Z7q7kJ9ExYDbQMenvj9ktWrB
  dZLQXut2LJ7jFUWtb3YeQUtQ
  W5LngDrUKQsFWi3MMVGV5NBK
  5rybDEhVVgDv3Ns3ZXXHrDsz
  iJp4bD8u6BQfuZF6HrdLWbqD
  6NCgJ34WPhtFoLUWDC4SHGSc
  9f6kvjMs7udeiZpcJFMnZoc2
  NEdw6m8RxcmkPeKnH8kPvStR
  oWhzhfiZP4fQLxE6ekqAcPxs
  cJmN71HWMnntseZ85Xqtyv3w
  hNdwPuTQdPrMvgphBXFfBLo1
  8J1kcBTctYT6j9Ci3haS9pQU
  ER1nMyB1HBe5tXC8nqGbt4Ga
  gqGbsB1byTqauFowtbM2SHdv
  RMQujnGmAqtvvQqj9MiNbN6V
  zqXdy4NkeSPbjTK47zvZFcAi
  ykofeDBHmofgcQ6ZoRWVRhKe
  k4EmzrEMNw1KVrw8x5Mr2dwZ
  kznekVbcxELfxHtq3FY65ubu
  s784K13d9H6V12ivr4WRikWX
  MhhAaULL8CDsRbD1Kus4Jiii
  ojfw9GjYj1CdNuocVwwGCJus
  qKX5D7ZHsvvKJyFdF5Nm2AE1
  MYEG3nUkp2pJBY4PWk92CsMy
  RXZVoNkwJiG6X4s1prEze7Vk
  csBbiiyHzGuP4xLH9zik6yxg
  TT6ptCqb4yYHAkzFT6HEFaNh
  mNMLqV12ak5cH87T9c5kR9J9
]
original_invitations = ProjectInvitation.where(token: original_ids)
raise 'missing some original invitations' if original_invitations.count != original_ids.count

recontact_ids = %w[
  fZWxJLXavrwNYiYArMTdqZU3
  6SNyVRVggjKnoWTJEGBQGTXo
  aVd7659FxCt1u1tmzBvQawcq
  vPVYkBvv7X2FA6W9uuE5jbpU
  A6F9yWLGPY2XetVJ4kU33HpB
  5DRQcMMDSANFJEeLUCDj11PE
  cxRYMEay8HcUtkQiDFL5GB6c
  xXSg4nxdgw3HHX5QqTCLk69K
  uhpBqKvQrZHrkThBT2PxkF7m
  qVF8wLEchdCWGPw1z4N9AQuk
  Wm1PHc8Kurj8z5kiwQ4YKgng
  6SqqXAeCQfPZWkcUhEoDBNT8
  hfDFfUZgei9x9wft4Fsvubuj
  CG7m2bxG6akJWcLYCpRpvBab
  pgccNMsnDxdbgnpjBrbKpXHG
  Zxu7w8V4oBzAqx1LtwSnvgz1
  BdwrJbNzWhWH4KnzpMD3vcmJ
  o2sZUSNDUzseQzmQk4QM9oNF
  dm23fKZ7mBYrxh5rZKT1G2pU
  ffoySzzWMrM96h2H9fEVYJgZ
  PD11FAQJdxu13awNrkh6kCpa
  xqEpzGRMFbbJmpuo3Ey1kvFw
  b7Jv1jq9Ss9K9Fmq6PANkzJc
  bdfGPZo5LuZuYUJJxHU9Ax14
  CAZXcUJTMKaf5fTL1aznh3cx
  WbgSRe6uaLXcdJUz5y6TfHxK
  wdiRP3FahH8aFGvHfPcaNid5
  S4jg46q5KA1QxeMo49dyGrFS
  JogA6NhXsLhgYr4zH4T7JETw
  SA2r5XbsaDBSLF8AdExcypD9
  cf35SLV3Z2poS9Hu7JCs5hdm
  EZwW4Es2mjh9kRqx2RBHj9pH
  AEPCUYARkrdVWR2yHxP8kiD8
  DyYvjdEqVZBdf2ivBxeayBrv
  E3ifZh3jMHhSa2XGs8tZdYyp
  z8zFjQr8eHSiabyRPE7cA5rz
  zRHZ6aDKvg8vRcPXC6TWtT7z
  9FpKFmzMiG61FyZr76NsM5NZ
  TZFNmcVdDZQUTWvf64gbwnrK
  pEj31yUMaGXFRJjqhh2rmpAa
  vdxU1wqrN3h7ENTALzcECXXe
  7eGokRXbRdR1YyGK2pyCkrcL
  N4hGV6YwPi2Yky7hr1QuNw5z
  EVMiukUPXNFZuahSSW52iRhK
  cqeU7rhqKnDFvujT2c7SoFTA
  EEXH9BRz3KKEoZbi4QG6zAEY
  jJampwgKApENGkZzPV59TU9S
  UcUTp2ArE1fHY4Z1N9y8999D
  abRoGjJhYMHrPUmCwESCBbAJ
  dZxGEmca3N2L483q9c9snY8t
  VbSKXjRv9X4JbVRFUWCDTsVr
  rPFqm1rEMAHzUATS3vsgrwQ2
  HiUq9Jr6jN68xVJNFS5nwq1p
  TZLqUNGGXrLbxrzZQWEne9U4
  msxBFhKz71UaxFnqF5JkLboN
  bhRMbcp4B8TRzyNxFJDo1uf7
  EJH3rUaMcqWrFyVWv5hk4BHh
  UmqK7GYLVsdeM7RxWDR9XE7j
  LG5dpsVuQqXBiUS2g8osB8ZP
  2KJEAPBxt5YoYJTKoYFS9ybp
  HAWK9usm3HvfBoJpZGYCyRy7
  u5Vinh3AnupnHaJMxx5ocTiq
  dB7vbJLeNZxSVyrMwPSXoTXH
  vCoaeSYd4WR4Zf4dUC4K8sCw
  3pUJ2fTTjqTPN16Ncjpu47DF
  vNQrJsFTGrjGEgRVS8RbpB7M
  TbqcwC3jdkkTbCB6Lf8rzEiy
  KTBLaC5uQPxsQfCEY7kn9SAa
]
recontact_invitations = ProjectInvitation.where(token: recontact_ids)
raise 'missing some recontact invitations' if recontact_invitations.count != recontact_ids.count

puts 'original decoded UID,original client/encoded UID,recontact decoded UID,recontact client/encoded UID'

original_invitations.each do |invitation|
  matching_recontact_invitation = recontact_invitations.find_by(panelist: invitation.panelist)

  original_traffic = Onboarding.find_by(uid: invitation.token)
  raise 'original traffic record not found' if original_traffic.blank?

  if matching_recontact_invitation.present?
    recontact_traffic = Onboarding.find_by(uid: matching_recontact_invitation.token)
    raise 'recontact traffic record not found' if recontact_traffic.blank?

    puts "#{original_traffic.uid},#{original_traffic.token},#{recontact_traffic.uid},#{recontact_traffic.token}"
  else
    puts "#{original_traffic.uid},#{original_traffic.token},,"
  end
end
