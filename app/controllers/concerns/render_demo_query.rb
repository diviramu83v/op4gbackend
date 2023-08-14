# frozen_string_literal: true

module RenderDemoQuery
  include ActiveSupport::Concern

  private

  def render_demo_query_options
    render_demo_query_partial('employee/demo_queries/options', 'demo_query_options')
  end

  def render_demo_query_zip_codes
    render_demo_query_partial('employee/demo_query_zip_codes/zip_codes', 'demo_query_zip_codes')
  end

  def render_demo_query_traffic
    render_demo_query_partial('employee/demo_query_traffic/traffic', 'demo_query_traffic')
  end

  def render_demo_query_partial(buttons_partial_name, source)
    buttons_markup = render_to_string partial: buttons_partial_name
    active_filter_markup = render_to_string partial: 'employee/demo_queries/details',
                                            locals: { flash: flash, source: source }

    partial_name = Pathname.new(buttons_partial_name).basename

    "{ \"filter\": \"#{active_filter_markup.gsub!('"', '\"')}\",
       \"#{partial_name}\": \"#{buttons_markup.gsub!('"', '\"').gsub(/[\r\n]/, '')}\" }"
  end

  # rubocop:disable Metrics/MethodLength
  def question_panelist_count(query)
    panel = query.panel
    sql_query = <<-SQL.squish
    SELECT
        demo_questions.id,
        count(DISTINCT panelists.id) AS panelist_count
    FROM
        demo_answers
        JOIN panelists ON demo_answers.panelist_id = panelists.id
        JOIN demo_options ON demo_answers.demo_option_id = demo_options.id
        JOIN demo_questions ON demo_options.demo_question_id = demo_questions.id
        JOIN demo_questions_categories ON demo_questions.demo_questions_category_id = demo_questions_categories.id
    WHERE
        panelists.primary_panel_id = #{panel.id}
        AND demo_questions_categories.panel_id = #{panel.id}
        AND panelists.status = 'active'
    GROUP BY
        demo_questions.id,
        demo_questions.body,
        demo_questions_categories.sort_order,
        demo_questions.sort_order
    ORDER BY
        demo_questions_categories.sort_order,
        demo_questions.sort_order;
    SQL
    Rails.cache.fetch("query/#{query.id}/question_panelist_count/#{query.panel.id}", expires_in: 1.hour, force: false) do
      ActiveRecord::Base.connection.exec_query(sql_query)
    end
  end
  # rubocop:enable Metrics/MethodLength
end
