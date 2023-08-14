# frozen_string_literal: true

# State data based on ZIP code file. Provided by Archie.
class State < ApplicationRecord
  has_many :zips, dependent: :destroy
  has_many :panelists, through: :zips, inverse_of: :state
  has_many :demo_query_states, dependent: :destroy
  has_many :queries, through: :demo_query_states, inverse_of: :states, class_name: 'DemoQuery'

  validates :code, :name, presence: true

  scope :by_name, -> { order('name') }

  GATE = %w[
    AK AL AR AZ CA CO CT DC DE FL GA HI IA ID IL IN KS KY LA MA MD ME MI MN MO
    MS MT NC ND NE NH NJ NM NV NY OH OK OR PA RI SC SD TN TX UT VA VT WA WI WV
    WY
  ].freeze

  ROUTER = {
    'northeast' => %w[
      CT ME MA NH RI VT NJ NY PA
    ],
    'midwest' => %w[
      IL IN MI OH WI IA KS MN MO NE ND SD
    ],
    'south' => %w[
      DE FL GA MD NC SC VA DC WV AL KY MS TN AR LA OK TX
    ],
    'west' => %w[
      AZ CO ID MT NV NM UT WY AK CA HI OR WA
    ]
  }.freeze

  PANELIST = {
    us: %w[ AK AL AR AZ CA CO CT DC DE FL GA HI IA ID IL IN KS KY LA MA MD ME
            MI MN MO MS MT NC ND NE NH NJ NM NV NY OH OK OR PA RI SC SD TN TX
            UT VA VT WA WI WV WY ],
    au: %w[ACT JBT NSW NT QLD SA TAS VIC WA],
    ca: %w[AB BC MB NB NL NS NT NU ON PE QC SK YT],
    de: %w[BW BY BE BB HB HH HE NI MV NW RP SL SN ST SH TH],
    es: ['Andalucía', 'Aragón', 'Asturias', 'Islas Baleares', 'País Vasco', 'Islas Canarias',
         'Cantabria', 'Castilla-La Mancha', 'Castilla y León', 'Cataluña', 'Extremadura',
         'Galicia', 'Madrid', 'Murcia', 'Navarra', 'La Rioja', 'Valencia'],
    fr: %w[ARA BFC BRE CVL COR GES HDF IDF NOR NAQ OCC PDL PAC],
    it: %w[ AG AL AN AO AR AP AT AV BA BT BL BN BG BG BO BZ BS BR CA CL CB CI
            CE CT CZ CH CO CS CR KR CN EN FM FE FI FG FC FR GE GO GR IM IS AQ
            SP LT LE LC LI LO LU MC MN MS MT VS ME MI MO MB NA NO NU OG OT OR
            PD PA PR PV PG PU PE PC PI PT PN PZ PO RG RA RC RE RI RN RM RO SA
            SS SV SI SO SR TA TE TR TP TN TV TS TO UD VA VE VB VC VR VV VI VT],
    uk: ['The South East, excluding London', 'The South West', 'London',
         'The East of England', 'The West Midlands', 'The East Midlands', 'Wales', 'Yorkshire & the Humber',
         'The North West', 'The North East', 'Scotland', 'Northern Ireland']
  }.freeze

  QUERY = {
    us: %w[ AK AL AR AZ CA CO CT DC DE FL GA HI IA ID IL IN KS KY LA MA MD ME
            MI MN MO MS MT NC ND NE NH NJ NM NV NY OH OK OR PA RI SC SD TN TX
            UT VA VT WA WI WV WY ],
    # au: %w[ ACT JBT NSW NT QLD SA TAS VIC WA ],
    ca: %w[AB BC MB NB NL NS NT NU ON PE QC SK YT],
    # de: %w[ BW BY BE BB HB HH HE NI MV NW RP SL SN ST SH TH ],
    # es: %w[ ],
    # fr: %w[ ARA BFC BRE CVL COR GES HDF IDF NOR NAQ OCC PDL PAC ],
    # it: %w[ AG AL AN AO AR AP AT AV BA BT BL BN BG BG BO BZ BS BR CA CL CB CI
    #         CE CT CZ CH CO CS CR KR CN EN FM FE FI FG FC FR GE GO GR IM IS AQ
    #         SP LT LE LC LI LO LU MC MN MS MT VS ME MI MO MB NA NO NU OG OT OR
    #         PD PA PR PV PG PU PE PC PI PT PN PZ PO RG RA RC RE RI RN RM RO SA
    #         SS SV SI SO SR TA TE TR TP TN TV TS TO UD VA VE VB VC VR VV VI VT],
    uk: ['The South East, excluding London', 'The South West', 'London',
         'The East of England', 'The West Midlands', 'The East Midlands', 'Wales', 'Yorkshire & the Humber',
         'The North West', 'The North East', 'Scotland', 'Northern Ireland']
  }.freeze

  def button_label
    "State : #{code} [ZIP data]"
  end
end
