# frozen_string_literal: true

# Usage: rails runner lib/scripts/suspend_business_professional_panelists.rb

panelist_emails = %w[
  fkf1956@gmail.com myckstor54@yahoo.com elaineshapiro21@gmail.com dbrackettlvs2sew@yahoo.com mrs.bristol10@gmail.com krisgd70@gmail.com eratliff1975@gmail.com
  neilwilkinson@bellsouth.net joshuacyr1@gmail.com staceylazenby@yahoo.com anc88919@gmail.com darlene_zamorano@yahoo.com stacymxgarry@gmail.com phoenixgold86@gmail.com
  maemae5785@gmail.com salvidadennis@gmail.com derrickolove@gmail.com rainbowjp15@gmail.com aaronandkristina8990@gmail.com trogdeng@yahoo.com violeteyes9085@gmail.com
  bwilliams50411@gmail.com bobbyejogreen@gmail.com bellecindy87@hotmail.com spratlincj@yahoo.com kathy.lauck@yahoo.com dtarlen@yahoo.com pu36esm1@gmail.com
  cynthia63245@gmail.com sharonsalinas@hotmail.com joyv72315@gmail.com hemmahb@gmail.com valerieh3567@gmail.com biljan2@comcast.net piersoljimmy@gmail.com
  seidlstudios@yahoo.com thehoffmantribe.1122@gmail.com vixon261991@gmail.com norikonagamoto@yahoo.com dwing333@yahoo.com clvyska@gmail.com pcheelton@gmail.com
  hmtowler@gmail.com lorreshinda@gmail.com ssj1237038@aol.com cristinaestolas@gmail.com karenkufner@gmail.com earning@thelightoflove.com debbie@atlruths.com
  hlayton@me.com mathersheather2@gmail.com kb3956475@gmail.com ddosborne72@gmail.com jan.tepas1@gmail.com kitcat1163@gmail.com dawnchavis1964@gmail.com
  badbunny0u812@gmail.com dapreeanderson12@gmail.com jili.may12@gmail.com patriciadeale62@gmail.com pmccoy@gmx.us jmkanzler@yahoo.com theresapeverall@aol.com
  camillecarter1992@gmail.com charlesogutu859@gmail.com michaelmigl51@gmail.com tdksbaskets@aol.com jones46118@yahoo.com mcsexywolf@gmail.com illusionhot21@gmail.com
  ramfan99@gmail.com cntrygrl29483@gmail.com creativeelegance2@yahoo.com tanya.olsen72@gmail.com odaatple@gmail.com arrakikans@gmail.com rtkoenig4501@gmail.com
  jutsie.far@gmail.com dkfelkins@yahoo.com alonzostacy@yahoo.com timberdaniels@gmail.com dharbarger6062@gmail.com leslieyates5@gmail.com meekslavetta78@gmail.com
  momathomas6@gmail.com kingman2023@gmail.com nil_gomes@yahoo.com tabi9770@gmail.com xjenniferleonx@gmail.com shaunk@mac.com sillycritter7@gmail.com tanukabhatt@gmail.com
  allencatrina63@gmail.com downsj2020@yahoo.com methodsx1991@gmail.com willkent1967@gmail.com chrissy143831@gmail.com graciedelarosa2@gmail.com brperkins2@gmail.com
  carolhartle@ymail.com angelskin2019@gmail.com dkernodle0822@gmail.com sasha.moody6869@gmail.com deniserosencrans73@gmail.com thisisana@yahoo.com demishiar@gmail.com
  krystalbrown.kb9@gmail.com perez.bobbi@yahoo.com rochelleevelyn885@yahoo.com rayfordlatanya@yahoo.com lblively76@hotmail.com tara.hensley8990@gmail.com
  bgricebrandy@icloud.com joielea@hotmail.com nicdud89@gmail.com klmtwinsjk@yahoo.com tpotter771@gmail.com rodneyhammons1811@gmail.com ribak6@aol.com billchavers@earthlink.net
  randeela@gmail.com madams65.att@gmail.com swheeler3737@gmail.com margo3pascoe@gmail.com tinydugas@hotmail.com fishervalleyfelines@charter.net angellianabb32@gmail.com
  elliottsmom31@yahoo.com bcoppage1@icloud.com seejudy11@aol.com dorigal8@aol.com allierae1980@hotmail.com sansyk22022@aol.com ramonacampbell43@gmail.com barrylipnick23@gmail.com
  nicolearcher727@gmail.com anthonyrom92@gmail.com legendary.future76@gmail.com barrylipnick23@gmail.com6 aabe8@mchsi.com terir53@yahoo.com msredhen41@gmail.com
  tanitabeasley@msn.com 1eyedalina@gmail.com latonyabenney0921@gmail.com blake@arrington.com jennmalloe6@gmail.com sharon.dugger@gmail.com tccollins7@gmail.com
  lindahopson@gmail.com brgolds10@icloud.com kctw04@gmail.com tleight1972@gmail.com mtrmike1@yahoo.com gerrysaba@gmail.com stephssolution@gmail.com bblessed333@gmail.com
  joyce11032003@yahoo.com callawayel@gmail.com rjfam9@gmail.com blundon1770@gmail.com sesquivel@rocketmail.com tigerarmstrong@rocketmail.com brleessummit@yahoo.com
  classyldy901@gmail.com authoramyarmstrong@gmail.com mnieves6744@yahoo.com raquel_hisey@aol.com crazyhawkfly@aol.com butterbrenda1959@yahoo.com aschatzger@gmail.com
  nutmegwilly@gmail.com iluv2watchsports@aol.com garylc01@bellsouth.net jdcarlos1@hotmail.com maryann_capps@hotmail.com gerrylicea@aol.com anniealto@aol.com
  kws1215@icloud.com seachell2@msn.com mary122958@gmail.com heatherfeather9360@gmail.com merrillcom@yahoo.com vfiorentino@sbcglobal.net gonzalescowboy1963@gmail.com
  lauriewhite420@yahoo.com constance.zeller@yahoo.com jennifermarek@icloud.com eandjracquet1981@yahoo.com raisedup444@gmail.com cliffordsteeley8@gmail.com
  cronnshirley2018@gmail.com mckenzee18@gmail.com michellepbroyles@yahoo.com tammyann711@gmail.com kathleengladdenknouse@gmail.com cant_call_me13@yahoo.com
  r.j.express23@gmail.com mbma2264@gmail.com wwjdlove4@gmail.com rachel.hirschhaut@gmail.com infohudsonoutlet@gmail.com jstpi26800@aol.com calmarioncrutcher@gmail.com
  kathyperrydesigns@yahoo.com noelkong55@hotmail.com lauraperez0527@yahoo.com keithbrody1234@gmail.com nova.soper@hotmail.com myhomebiz@mail.com brendajoplin@yahoo.com
  gothycvamp@gmail.com airwaydani@aol.com imshara1@centurylink.net prayingpastorcarl@yahoo.com dtrinidad3@comcast.net lotusflwr62@gmail.com mayleighamiller93@gmail.com
  bjyatchmenoff@gmail.com drolfes11@gmail.com pkdubay67@yahoo.com preethysr.ibdkfc@gmail.com keithfressheed@yahoo.com daragay9@gmail.com penny.routt1@gmail.com
  organicpanic420@gmail.com hzemaitis8985@gmail.com leeora@att.net jackieleewhitney@gmail.com curryanita24@gmail.com jjobrien1000@yahoo.com simply.sharonhaley@gmail.com
  jamiey227@gmail.com kneehigh1950@aol.com bridgethoy1984@gmail.com cshinsky2003@gmail.com tcroot9284@gmail.com jazzybay23@gmail.com jamieedwards873@gmail.com
  charitie.wells@yahoo.com ccj002785@yahoo.com patricia.petrola@yahoo.com aprincess0909@yahoo.com joanjokinen3@gmail.com wowplayer619@gmail.com valkt55@yahoo.com
  andreaa98112@gmail.com genevamills2015@gmail.com kelly_simpson2@icloud.com cbhhopper58@gmail.com teresagale86@gmail.com ktorres2420@gmail.com jamiemarti83@gmail.com
  rodneys204@gmail.com mrscortes1965@gmail.com kellirodriguez3angels@gmail.com erickbro@gmail.com gdbyetormance@yahoo.com hoodinismom@gmail.com barnettcynthia@live.com
  lorimastroserio@gmail.com schraf3@msn.com colleenvdd@gmail.com angelinapachecohollis@gmail.com gzylstra13@gmail.com cdsacksteder@yahoo.com natestewart@mail.com
  bethpace84@gmail.com tigerready30@gmail.com richardoyler49@google.com showmestate4u@yahoo.com easonarenitra74@gmail.com hargravejohnn04@gmail.com mariannegermane@yahoo.com
  o4godsake.mm@gmail.com cyspacey@yahoo.com rjeanmaxim@gmail.com bcrump256@gmail.com lstphns2@gmail.com norlieplouis@gmail.com homade80@yahoo.com beckysuebentley@gmail.com
  crazycatlady54@yahoo.com cr4034183@gmail.com blancaallen@rocketmail.com pssatte001@hotmail.com terrawestfall@gmail.com apollo69mark@gmail.com sandyrose70@live.com
  rbthatcherjr@gmail.com mikaylaspringer1@gmail.com k.just4kixs@gmail.com benjaminbrown113@gmail.com sheilas.mail2020@gmail.com fosterblake175@gmail.com arabychic270@gmail.com
  1jackwhtfan@gmail.com mbush2264@yahoo.com cholder67@aol.com judv8@yahoo.com byneph@gmail.com paulaga@comcast.net alrubk51@gmail.com jennifercohen52@gmail.com
  ron.jiggie@gmail.com suezeek004@gmail.com ludog160@ymail.com melaniesmith1055@gmail.com caspen1969@gmail.com nancybunkley@gmail.com slrmoon2000@yahoo.com jazzoo100@yahoo.com
  tyquel04@yahoo.com kimberlydouse@gmail.com martenjworld2@gmail.com ddivy.27@gmail.com sharonromanucci@gmail.com lyndsmulvaney@gmail.com bobio6977@gmail.com
  bmusick1941@icloud.com keenachurch@hardrock.com dianeldifrancesco@gmail.com only4t2c@gmail.com sophiapope1953@gmail.com rovondawylie@yahoo.com phreedommiller0@gmail.com
  pande1955@aol.com cherylfonseca63@gmail.com nlumbattis@gmail.com pamhammontree1952@gmail.com eclarks@aol.com ethia.clarks@aol.com turtlegirlsrj40@gmail.com
  shadey61808@gmail.com capacitymemphis@outlook.com roxyg1030@yahoo.com purpleone1929@yahoo.com michelleforbes1975@gmail.com saraharana81@gmail.com jenny512565@gmail
  mbattermix@aol.com cuevasm1016@gmail.com ephraim2010@gmail.com dlayman09@gmail.com wrighyolonda@yahoo.com nitam2@suddenlink.net sfdc.nareshg@gmail.com
  ocoeebonding@gmail.com 113sunshine@sbcglobal.net vera_jazmin@yahoo.com msrtinsampson373@gmail.com sglassmaster2@gmail.com cnagy56@gmail.com ducky434@gmail.com
  keithmjr0813@icloud.com heatherenck1@gmail.com sgreg0922@aol.com woffordmichael58@gmail.com jenny512565@gmail.com muskienut007@yahoo.com histeez123@gmail.com
  cassidylsauer@gmail.com anishasamiy.l@gmail.com anniesira@gmail.com katnewmandesigns@yahoo.com arleneshelsky@gmail.com maryheck420@yahoo.com coleen3581@hotmail.com
  rboswell22@gmail.com bellebollo@gmail jp13i.t.s8@gmail.com dchilds553@aol.com johnshelbyreader@att.net thais_young@yahoo.com royalemporium127@outlook.com denisesmith884@yahoo.com
  pameladavis6767@gmail.com psychrn918@yahoo.com sharonlyn1987@gmail.com rickijudith@gmail.com cynthialeggett14@gmail.com brendaleeappel@aol.com pittmansdp@gmail.com
  ren477@yahoo.com urmi.manzoor@gmail.com dmaraney@yahoo.com j-white2004@live.com blackmonlinda70@gmail.com mhager6@cfl.rr.com dothanmary@yahoo.com lbeam517@gmail.com
  conraecole@gmail.com kirk_goetz@outlook.com baytowndental@gmail.com wormjake@yahoo.com pazpaz22@yahoo.com aimee.kossoy@gmail.com joytgordon@gmail.com margotbiz@cs.com
  gramscray6@gmail.com vigiltressa5@gmail.com amy.kossoy@gmail.com rpbarbis@optonline.net rimrocks@yahoo.com fdunsmoor@aol.com lj.herzog@yahoo.com lifesaholiday2day@live.com
  shirleytemple09@gmail.com edfranks1@gmail.com poolsidefunkelly@msn.com rona.somers@gmail.com ksbickford@yahoo.com patricebullen@outlook.com btimber12@aol.com
  harris.leonard@gmail.com heathercowans88@gmail.com kukanag@yahoo.com carebear1906@yahoo.com jackiegibbs761@gmail.com mediaate@gmail.com sstein9232@gmail.com
  misso.medina@gmail.com mjdnyc2000@icloud.com silverspiritwolf15@att.net patjones26800@gmail.com mwatkins130@yahoo.comaki madamgray64@gmail.com weimardog@aol.com
  jec.sc.2017@gmail.com debrasgifts@aol.com sfrerichs1234@gmail.com visitingthelonelyones@gmail.com jacaridad43@aol.com btimber32379@outlook.com l_edwardsgmail.@net
  xrwiebeck77@yahoo.com fiftyfifty48@hotmail.com dlehmann107@gmail.com kierganpat@yahoo.com lhaid@comcast.net mamak99@hotmail.com heaneyartstudio@yahoo.com krxo1077@yahoo.com
  irisll@juno.com jaunitaburdette@gmail.com brendamatteson1960@gmail.com grizzlyy2k@gmail.com connie@kenbek.com hugh@thecarlings.com crystalrvr@yahoo.com wandafayethomas57@gmail.com
  cocotomh@aol.com smith.team65@gmail.com fldem406@gmail.com npeters@yahoo.com ladeejohn@netzero.com spoiledpooh@gmail.com val_baca@outlook.com bluedove0402@gmail.com
  patscott13@gmail.com jaserie8779@yahoo.com asigali132@gmail.com kendall2312@gmail.com lmackichan@gmail.com minnievag641@hotmail.com brendakay@email.com gclarity@nycap.rr.com
  roundstone3@nycap.r.com petekalbacher@gmail.com njhedger@suddenlink.net s.tingler218@gmail.com janm32353@gmail.com pamn88@gmail.com jackiebdupree@gmail.com worldeagles@gmail.com
  staytongw@yahoo.com mchugh842@gmail.com gyrl74@yahoo.com pamelia124@hotmail.com kendall2312@icloud.com normsmom1975@gmail.com harlowsandy372@gmail.com nodeerhere@gmail.com
  gregoryrocky@juno.com dpcsandy@hotmail.com shelley9296@gmail.com materialguy4u2@yahoo.com kathyadkins1492@gmail.com marss2@comcast.net lucindariva790@gmail.com
  ericalton@gmail.com debodennison@gmail.com ses803@bellsouth.net richardblue646@gmail.com barry33215@gmail.com vicki.acquah@att.net m0ney4m0m1@gmail.com sylviamaya@gmail.com
  jakaeaton@gmail.com duslawson@gmail.com asarina1953@yahoo.com cindyadams4864@gmail.com eehinson@netzero.com mommyboy1947@hotmail.com hkwarmbier@sbcglobal.net
  wildchild196123@yahoo.com kevin@circle22.net tammymanley88807@gmail.com melkittysqueek@doglover.com jmscwolfe32@gmail.com lilhaines7@gmail.com jufromva@outlook.com
  barbdunleavy1@gmail.com westonda25@gmai.com myakkamama52@gmail.com charmainefdyer516@gmail.com lynandshannon@att.net sgwheeler614@gmail.com tephiheidimcglaughlin@gmail.com
  aweston797@gmail.com zawawi11@yahoo.com luistheodoratorres@gmail.com btaylor696923@gmail.com hopepren69@gmail.com reinertdianne3@gmail.com janetfairchild30@gmail.com
  hellestraes@gmail.com sojaded2571@aol.com vpikec36@gmail.com robjsim@hotmail.com debblount16@gmail.com mrtsuz1120@gmail.com cinnamond1119@gmail.com singinggrandma6@gmail.com
  nicolerosen111@gmail.com ashlaws18@gmail.com cbuszkiewicz777@gmail.com lyndellinger@cox.net rickeyhbusiness@yahoo.com ldsdad66@gmail.com taichan248@gmail.com
  thfails9@gmail.com chrisraible@verizon.net gatorsworth48@gmail.com timciryak@gmail.com domco21@hotmail.com wdreitlein@gmail.com stevenbrandwene@hotmail.com
  aflynnbiz@gmail.com gunneyleblanc@gmail.com gardeninghobby@yahoo.com jasonkisielewski@gmail.com andishprd@yahoo.com mochaflavoredluv@yahoo.com pippy0318@gmail.com
  cindylustar@outlook.com whageshi@aol.com jbhedtkamp@comcast.net roz50@aol.com karenblanton56@icloud.com jtgalbraith@gmail.com angelorulli@gmail.com cwrightrucker@gmail.com
  abbeythornburg@yahoo.com cristy9180@icloud.com coleenverrier@gmail.com rileyjudy019@gmail.com dianetilford@outlook.com eolanna87@gmail.com joannharos@aol.com
  kristeen.mcdonough90@gmail.com grahamindy@icloud.com akilahwimbley6@gmail.com mazzeo5389@aol.com meisekothen@yahoo.com mrscoggins83@yahoo.com lmasterson64@gmail.com
  karen77rynbrandt@gmail.com jcarluzzo@gmail.com lnmarie2112@gmail.com janmayer32353@gmail.com smbardol.enterprises@gmail.com jkenn19@yahoo.com k.naisbitt@live.com
  kimsanotary@gmail.com rfelder001@yahoo.com susanwaz@aol.com lorettablocker@yahoo.com jackiesprior@gmail.com vondams32@gmail.com holshouserclaire@gmail.com
  firehotess88@gmail.com jennyrev@gmail.com nancyvillarreal44@gmail.comna lilacgal64@gmail.com art_f2001@yahoo.com promkeep1@aol.com ling2jie2@gmail.com
  stacybear1030@gmail.com edwardsloette@yahoo.com gemini2times@gmail.com deborahelyse49@gmail.com kate@speaksure.com dianew3234@gmail.com rslijk@cox.net
  momacajun@gmail.com ccj002785@gmail.com trayvonnerussell0@gmail.com dan.zimmer1972@gmail.com rf7482@comcast.net chiefgotch1955@yahoo.com adriennefnorwood@gmail.com
  saladbecca@gmail.com janmayer32353@gmail.comj ficarottog@yahoo.com pennloon3@aol.com johnharris36@aol.com lovemysoftball@aol.com lid_kelso@yahoo.com javon360@yahoo.com
  2bicpayne@gmail.com verleneskin51@gmail.com karen_anderson521@aol.com klassy_kook@yahoo.com elaine21@outlook.com luwoo2@aol.com suzettepitman24@yahoo.com elizabethreckert@yahoo.com
  edmelyn.r@yahoo.com daisymoles@gmail.com laine567@aol.com erplot@gmail.com mshubert2011@hormail.com garryharris48@yahoo.com suzefeld@gmail.com debwersal@gmail.com
  joanieledonne@gmail.com alikatt3x3x3@gmail.com jjg@cfl.rr.com linda.salmons@g.mail.com bobbiedee@aol.com debranolette69@gmail.com cwestern@umn.edu susan@asmandl.com
  retiredsheriff@embarqmail.comr glitterboy007@gmail.com babydoc333@aol.com salhorace1@aol.com drawolkow@aol.com kathybutts6@hotmail.com barpalm@optonline.net
  mike.mason@mm-consults.com gloriasimo2@gmail.com georgevanluvensr17@gmail.com bicpayne2@gmail.com johjeslar@gmail.com rosiland2012@gmail.com fame1459@yahoo.com
  ladyd14969@gmail.com greg.pilakowski@yahoo.com jenn.khow@gmail.com michaellonganevler@gmail.com frmaloney52@gmail.com christydaigle@gmail.com kristagail456@gmail.com
  e.brock1@cox.net bobtraviswa@gmail.com hobbsdnb@yahoo.com linda.p44@yahoo.com sandraslk@hotmail.com qf747400@msn.com wegotthis2001@gmail.com bc1377green@gmail.com
  idanitsche@gmail.com stolldogg@gmail.com randeels@gmail.com anniestours@verizon.net tinkandbob55555@gmail.com kathye65@frontier.com strinden@consolidated.net
  stcfellow@gmail.com cynthialeggett41@gmail.com willdr757@gmail.com dirremaschngodrii5@gmail.com holmgirl406@gmail.com carrilynrock@gmail.com thuzella@gmail.com
  sweet_thing53536@hotmail.com mrsashford19@gmail.com terrijean123@gmail.com amosh911@gmail.com kimsuebell@yahoo.com lorrie6583@gmail.com sunni.bunnie77@gmail.com
  rmlinda@gmail.com jmckeever393@gmail.com shannonwalker757@gmail.com toddhaugen46@yahoo.com lisa.meyerer@outlook.com ramonatennison@hotmail.com efrenpc@msn.com
  arndt.jim@gmail.com jvelez002.jv@gmail.com davidsscott352@gmail.com wink641942@gmail.com llgold46@yahoo.com mamabush53@gmail.com frankel.j.m@gmail.com
  ma.gutlove@verizon.net debsingssongs@aol.com keirstensooter@gmail.com gabenyc01@gmail.com mskidd24@gmail.com mpulley911@gmail.com jgcolemanramirez@yahoo.com
  lamerten@yahoo.com felomancer@gmail.com crazycaren@live.com silkonsatin78@gmail.com renodyb@gmail.com ray.roths@gmail.com eabagasao@hotmail.com brian.estee@gmail.com
  mshubert2011@hotmail.com piotr199@outlook.com rosenwaeme@gmail.com rathnav@hotmail.com lorenzobrittany5@gmail.com sharonkjohnson.skj@gmail.com wiselinda0225@yahoo.com
  charlotte.hyatt@gmail.com bethavanhorn9@gmail.com tss1964@protonmail.com eddierosenbaum@gmail.com cleanrory@gmail.com ckbertrand@icloud.com d.s.g.homebase@gmail.com
  mssandraartrip@gmail.com kristenlstefan@gmail.com ksumner816@gmail.com nisey67@hotmail.com louu83@yahoo.com hollywoodhectorthestar@gmail.com nortelight@hotmail.com
  alaness2010@hotmail.com jlacon816@gmail.com kristaclare@yahoo.com massagelife@outlook.com ddosborne81@yahoo.com joannbonin1@gmail.com kimrkent2244@gmail.com
  k4kinard@bellsouth.net sampsonmartin56@gmail.com ssherlock239@gmail.com margaretscanlon4040@gmail.com dexi39@hotmail.com curlypolyanna@yahoo.com slsp33@gmail.com
  louu83@gmail.com stevenpro6613@gmail.com jrsmith5601@gmail.com vmdemasi@aol.com jimmy_e01@yahoo.com anothergoodwingypzygirl@gmail.com dwoo34@yahoo.com glenn1206@yahoo.com
  frankcat2001@yahoo.com bstovall735@gmail.com rochnyc@aol.com mommy_myers3@yahoo.com hanskmeyer@gmail.com happygoluckylady67@gmail.com grammaaida@gmail.com
  mrspettis17@gmail.com jim@mccutcheonmusic.com d.johnson305786@gmail.com rosacj@hotmail.com chericharbonneau1963@yahoo.com suzannahandlillies@gmail.com olivekayrose@aol.com
  sandrasezz@aol.com icaboop27@gmail.com janlin79@hotmail.com elvis_garcia13@yahoo.com budrfligem@yahoo.com davidbeamish0@gmail.com miapaulchery@gmail.com jeanamclellan43@yahoo.com
  jennandleah@gmail.com amandamendoza728@gmail.com msexton64@yahoo.com phoenixmike@icloud.com john.arnett.wms@gmail.com sherryp19551926@hotmail.com sshannon.karp@gmail.com
  dorje51@msn.com jennlys59@gmail.com artefxforchrist@gmail.com madolynhere@verizon.net shanegentry5@gmail.com udaytheperfect@gmail.com augusthart82518@yahoo.com
  gious1likeme@gmail.com hillsidetoke48@gmail.com staytona5@aol.com shariwilkerson8@yahoo.com jeanbw@gmail.com janie.jeffries.8875@gmail.com pkroe8044@aol.com
  wahg@charmedd.com cursedntempting@yahoo.com jon.hersh@gmail.com dillygirl69@aol.com jenlorea84@gmail.com ydevaraj@gmail.com tellenwong@gmail.com wileysmassage@gmail.com
  motobrat06@gmail.com johnohio@gmail.com corey@robinprint.com jimmyrhall3@gmail.com mdg1958d@comcast.net arambris@gmail.com sweetlilsuccubus@gmail.com vickigonzales2004@yahoo.com
  shondraholland041217@gmail.com shot_z29@hotmail.com dianatheodore1980@yahoo.com jill.trvl@gmail.com tsherman661961@gmail.com smartin197145@yahoo.com helensitgraves520@gmail.com
  deedee.lynette@gmail.com zoocrewgal@live.com mansueto@seekingwisdom.com wilmajoey2@gmail.com sheila.smith@comcast.net dnice_@hotmail.com pokemonlover1910@gmail.com
  debrarosser112@gmail.com amysterling1975@gmail.com buddha@lmi.net boozieq112573@gmail.com mrscortes21@gmail.com td41080@yahoo.com shirleylwoolam@gmail.com
  rocetajos@icloud.com astrongwater@nyc.rr.com steelrzs1@gmail.com colleenmmcdonald@gmail.com sharonkae75@gmail.com rpear22291@hotmail.com drmefixu2@yahoo.com
  ellesimon.consulting@gmail.com gpaniker@yahoo.com bob.travis3@comcast.net kevinpdicarlo@gmail.com stacyarble@icloud.com corthardesty@gmail.com vivries07@aol.com
]

count = 0

panelist_emails.each do |email|
  panelist = Panelist.find_by(email: email)

  next if panelist.blank?

  panelist.suspend unless panelist.suspended?

  panelist.notes.create!(employee_id: 0, body: 'Suspended per Josh Giles: Facebook B2B verification')

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

  panelist.notes.create!(employee_id: 0, body: 'Suspended per Josh Giles: Facebook B2B verification')

  count += 1
end

puts "#{count} panelists were suspended."
