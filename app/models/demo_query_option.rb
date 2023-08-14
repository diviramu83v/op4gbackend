# frozen_string_literal: true

# A demographic query option connects a query with an answer to a question. A
#   query targeting Op4G US Males would have two query options: Op4G:US and Op4G:Male.
class DemoQueryOption < ApplicationRecord
  belongs_to :demo_query
  belongs_to :demo_option
end
