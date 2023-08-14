# frozen_string_literal: true

class Panelist::DemographicsController < Panelist::BaseController
  skip_before_action :verify_demographic_questions_answered
  skip_before_action :verify_welcomed

  def show
    return redirect_to panelist_dashboard_path if current_panelist.demos_completed?

    @category = current_panelist.primary_panel.demo_questions_categories.by_sort_order.find do |category|
      current_panelist.unanswered_questions_for_category(category).any?
    end

    redirect_to demographics_category_url(@category.slug)
  end

  # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
  def create
    new_answers.each do |option_id|
      current_panelist.demo_answers.create(demo_option_id: option_id)
    rescue ActiveRecord::RecordNotUnique
      # do nothing
    end

    @unanswered_questions = current_panelist.unanswered_questions

    if @unanswered_questions.any?
      if new_answers.empty?
        flash[:alert] = t('.flash.no_answers', default: 'No new answers detected.')
      else
        answer = t('.flash.answer', default: 'answer').pluralize(new_answers.count)
        flash[:notice] = t(
          '.flash.success_some',
          default: "Thanks! Successfully saved #{new_answers.count} #{answer}.",
          count: new_answers.count,
          subject: answer
        )
      end

      redirect_to demographics_url
    else
      flash[:notice] = t('.flash.success_all', default: 'All questions answered successfully. Thanks for completing your demographics.')
      redirect_to panelist_dashboard_url
    end
  end
  # rubocop:enable Metrics/MethodLength, Metrics/AbcSize

  private

  def demographics_params
    return [] if params[:demographics].nil?

    params.require(:demographics).permit!
  end

  def new_answers
    demographics_params.to_h.values&.flatten&.reject(&:empty?)
  end
end
