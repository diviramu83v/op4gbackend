# frozen_string_literal: true

uid_list = %w[
  gi8EhPp887JUH9jTcdNnH1WX
  HqRnXzJU8RWnHiwaevrLnyyo
  fG3DHZrLpfMw8YM914qB6bKp
  VdCM5RxUbfC2mgMr2S6W7K2w
  1Tp3jHzBfd3uwnmJDnSTd7Mi
  3jEMQT7pTGSr3Y5k5TURZ3KT
  648WG3PPDPWvModeCFVsruaP
  SXRMTGuv4TDkKiXbQeQ54iav
  iY5qsRE5CvdjXw2KYyGwLDNt
  GWCatSioQXjzbjhzuM1zZcxi
  KRrPPim6CeXzzKvSNVru1xSt
  qmZgfJBAsXZScWB92EQ4HquK
  yQw5axPhezxnLcYN9Qgtuu6n
  nY3vXYNYMjGCGiEtcKkfKu95
  4zw822fessUS5hAX9h6vN6FX
  dsysZ9fENTCtTMbGZRyBAZeh
  y1pHm4VaojdeX5y2dfHsaE8B
  TVcN5C6LNtca4HmAni6LoSi4
  pQu8x6VGN36UttbSXE7EWWBb
  P9mH38beC4MsubPggoeHfEYb
  bYQUAUXgMkm2Ru2UdxL6C5oX
  Ejr4yY6pA5mgshMjeaj2gTZk
  eHSbYRJL1F9r5F7eiUQgs2pc
  QLQGPqDG7mUSnoiXoCqpjrMM
  FkMw1hvPjsPMj2ad5vzSX455
  XAegqhYqZxyHHNsAZ8dkeh2T
  8cK11iVzAvX5oR9mVbctk6i7
  3JZPdfHHxKvm3rzFAjzUVC2g
  b1UwK7kc81x7Y2zoXPDx8Bai
  QkCPA4V1FAWD4a2wBv8F7hRG
  ig6nWakQwMxCgEPGcFzieR11
  K5RSpZyoGq1uzCjpg2iY3WL8
  NpWWzYB2uQzBJFxQ8UPgEbyC
  Q655swLzL8bT2cxum8m5zggD
]

uid_list.each do |uid|
  onboarding = Onboarding.find_by(uid: uid)

  puts "#{onboarding.panelist.name} starting status is: #{onboarding.panelist.status}"

  onboarding.panelist.suspended!
  puts "  #{onboarding.panelist.name} is now suspended? #{onboarding.panelist.suspended?}"

  onboarding.panelist.notes.create!(employee: Employee.find(0), body: 'Suspended for being in the wrong country.')
  onboarding.panelist.notes.each do |note|
    puts "    #{onboarding.panelist.name} is '#{note.body}'"
  end

  puts "  #{onboarding.panelist.name} ending status is: #{onboarding.panelist.status}"
end
