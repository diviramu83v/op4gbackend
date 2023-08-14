# frozen_string_literal: true

class AddNonprofitOfTheMonthFieldToNonprofits < ActiveRecord::Migration[5.1]
  def change
    add_column :nonprofits, :made_nonprofit_of_the_month_at, :datetime
  end
end
