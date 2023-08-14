# frozen_string_literal: true

class Admin::MonthlyEarningsReportsController < Admin::BaseController
  # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
  def show
    monthly_earnings_query = <<-SQL.squish
      SELECT
        period,
        SUM(total_amount_cents) / 100.0 AS total,
        SUM(nonprofit_amount_cents) / 100.0 AS nonprofit,
        SUM(CASE WHEN panelists.status = 'active' THEN panelist_amount_cents ELSE 0 END) / 100.0 AS panelist,
        SUM(CASE WHEN panelists.status != 'active' THEN panelist_amount_cents ELSE 0 END) / 100.0 AS "inactive panelist"
      FROM
        earnings
      LEFT JOIN
        panelists ON earnings.panelist_id = panelists.id
      WHERE
        period != to_char(current_date, 'YYYY-MM')
      GROUP BY
        period
      ORDER BY
        period
    SQL

    @results = ActiveRecord::Base.connection.exec_query(monthly_earnings_query)

    respond_to do |format|
      format.html
      format.csv do
        csv_file = CSV.generate do |csv|
          csv << ['Period', 'Total', 'Nonprofit', 'Panelist', 'Inactive panelist']

          @results.rows.sort_by(&:first).reverse.each do |result|
            csv << result.each do |cell|
              if cell.is_a?(String)
                cell
              else
                cell.to_f.round(2)
              end
            end
          end
        end

        send_data csv_file
      end
    end
  end
  # rubocop:enable Metrics/MethodLength, Metrics/AbcSize
end
