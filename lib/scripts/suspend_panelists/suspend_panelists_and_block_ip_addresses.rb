# frozen_string_literal: true

# Usage: rails runner lib/scripts/suspend_panelists/suspend_panelists_and_block_ip_addresses.rb
# Usage: heroku run rails runner lib/scripts/suspend_panelists/suspend_panelists_and_block_ip_addresses.rb -r production

uids = %w[
  mTWPf5C6gvzZNNV7Q6uDoArw tNxqHA5c7P3DrjrZe5RoZ2jv P62ukjQsakKJDbSsRcktqV7o XCmyCygsBTh7CUwPwCwSETR6 YmmvZsdNrXf8Ua2BG5zWrvft eGjyDCTjD88kXawfewxL8mR8
  bHyArfZhe5zgzdsg8L9CQKwq 3uTT7k2PYR1fmBs8TZvze28e 7eye9RGvuYmH3bWttsUDrvHN kcP3e2SavgaxWdpQk8tSehQ3 5SajaTxSzrxiYXxfgr53zNwu NyFN8Vca5wjEDVeMY7gc1qm7
  Xq8FfXd9Ueo3MqCXen56WnYn 2yFDzgvaG57BZeYntgJ2KSdF 9H7MJY2vhBNotkGHbVn2pDU9 QrhSJXHHfAWR8r5Hp9Xb5dML 3dnBD6zEUNGK2Y3hWX4BNPHF CAxKmTBLuuCqYjSTr1PFRGvc
  v1JoWtEj6yh6XrBpyyxuHuuG DigSvRYUKaueT8j3R569rnsK xf9CsLdw5cuQ9yvtfUSyDJpS rreKuD38izXh3oyQGsxwrcuM bf1PQgJE6ZCvQNVJJMGNTEyJ zEiyEpUrFjWbheysyz7KurG6
  xahZ2mFny2mEPMV2wxkRpPKj YBkvEfYr2xEfrgn1XaZqvSaz 9svKSkA33kthPsUY3Ezk2rws 28CQVwNJH22VanswJvstT46D UJwj2qyPKsSY3Cv85RSkVFE2 riuTN5jHLYwp1Bb13FTkFtDS
  q7RDLrammjLYnZBMjGBhMkjS Pkus2rnkQWKpJKBF8B9SUAse RWS4ikDpKru8V4tos2dfuYjJ edjNHV58Pj3Ue9rU83qXoi5q JoU2vnbSTzzW8eXd7vU89FuD Te7EYMsd1at4qTVsU3se5eZt
  e8UPgWWwnpgdbkPCj3FXKAns Z7MwwSZQmm8uTzNSAUmGktdg Qy2Nfr6apPmWPnRgugy2DtHg Ad9y2YJ7qGaQy15tCjsqRS1L hZ3eWoUUVoRpZfip87uwmBVE 7WAdFXhcxyE2AnKLAvsgZnAj
  yEcritnKHgAyFwF4sfP9qktS 8PqBTs23gahYGJuCNVXBXFhC YUyQnvAJG9C5Tf1Vqizm1BDb pp3Bk2Wb3Skk4BQLsUMJ5Yrg LKwoeqCewUR14R8GZGxJcauF UCJpvdhPgha6REp1kcLvLt8V
  q2FpesYFZeXdrjn9AiCwNvau THYtgoEbcUJDjaaFoPNzoUKD xmWvALQr8AgAqKEXHZFUTKAK sgiymBsRP8FF2S6BFVEkKFB6 Ju9nBrendoX2j7fDTswRvcL9 vwLwkQ1gtWJvTYEnUPBUZyRg
  nUG29NivAGtARjnYXFhm9gMT mWZYoKkZYRcjK2ywa4WrQnJk nyxFMCzipAFzitFi1peUA2KM BbjBixaPZ4rfiWV7bYGus2eo atbtEaVmeHooF1qQW1vXxjHc GTVgoZWqNcu9jzujBhH3mbXQ
  p5tgwP3cid1b9bxBfUAkFjEv Q1ukQbKgpa8yjsrCmEqkNLcm BFgDmkDVnkECLQWUjZZpBcCj cpRE8thtGitWgqCCYb9nZhrp hGn24ADmWfaAPNpfM1Ld9bVz 8uFsj8Yo56KkKxYnhM1RBzmU
  oGxxEmWovzgVFiEaw6fxBxbi irzb9TtUAVXpCMLF5GYdjn9f 3FRe8SS9UyEb5zEBq9AcWYGj EwUgrgPMw1J1ZTksKSweEJaL b16AVs3i7gJyCZJ9imfkUS37 aPhAEywZbj1jDgVoyza2mPQ8
  VV2eD2tYWccExTY4ULayfYhR 8FsSCKNAFEG9Td76LPbaotVW kc5PmYiR7pjyxm1vnowwYZTP LEsTw4XQn3kPdbJZ1SjcLAse V5DZAK496g6UczKmM7CyAeS4 UKY6ZazFLTVEnts1kZPSUivK
  Z71fKdEXKV5KPW1KENTrvZKe Mtt4mqfmi5r8BnG5Vde7BmYT JLRkxDG7kfyvuPBcYLVMzF1g q7JwkrxcPkg1AfSsHVZkuJTw EfczUDBAKK3vwMooFJcu34qC r6FneqEaTV73LrzeJemurWBM
  R4KajBw61ZzxTZSLyT5zMuhT vSrEXPNFe6derbmKnWVDSaj9 MKxwGbgnCipZjKRxjJrTshpi uVq6TtnUACp3BzdaU1TY5dhy uVvZvm11v8jBaoQAib6nBJq8 eyDgXVGM5p2ngMY1Zdjz5Eh9
  ZBTamrF4GNXtwbNSsoYJuwXx zkSwNzcxqE9Qk2nxfrzNEDSN VxP3YqJ5qyuJfwkxYyPUpuSg WxVWQEGYu4fk4n2ZvdXJvxcg eK4KfXScY3R1Y1rYWsaqjPeD y19Zy8hushzGpvankNip95Kz
  DQdkQivx3T3xwAK8M6aTD5QB eNxx2RjUi2Eb5bstnZgoMMBU
]

count = 0

onboardings = []

uids.each do |uid|
  onboarding = Onboarding.find_by(uid: uid)
  next if onboarding.blank?

  onboardings << onboarding
end

# block ip addresses
onboardings.each do |onboarding|
  next if onboarding.ip_address.blank?

  onboarding.ip_address.manually_block(reason: 'Blocked per Josh Giles: [WO 62692] Government Employees & Consultants (20495) - Lewis Global')
end

panelists = []

onboardings.each do |onboarding|
  next if onboarding.panelist.blank?

  panelists << onboarding.panelist
end

# susupend panelists
panelists.each do |panelist|
  next if panelist.blank?

  panelist.suspend unless panelist.suspended?

  panelist.notes.create!(employee_id: 0, body: 'Suspended per Josh Giles: [WO 62692] Government Employees & Consultants (20495) - Lewis Global')

  count += 1

rescue ActiveRecord::RecordInvalid
  # rubocop:disable Rails/SkipsModelValidations
  unless panelist.suspended?
    panelist.update_columns(
      suspended_at: Time.now.utc,
      status: Panelist.statuses[:suspended]
    )
  end
  # rubocop:enable Rails/SkipsModelValidations

  panelist.notes.create!(employee_id: 0, body: 'Suspended per Josh Giles: [WO 62692] Government Employees & Consultants (20495) - Lewis Global')

  count += 1
end

puts "#{count} panelists were suspended."
