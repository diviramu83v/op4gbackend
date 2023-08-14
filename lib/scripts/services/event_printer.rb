# frozen_string_literal: true

# Helps print output for troubleshooting/debugging traffic events.
class EventPrinter
  def initialize(event:)
    @event = event
    @onboarding = event.onboarding
  end

  def print
    pre_post = calculate_pre_post
    message = @event.message
    timestamp = @event.created_at

    puts "- #{pre_post} / #{message} / #{timestamp}"

    if pre_post == 'pre'
      print_pre_survey_clean_id_message(message)
      print_pre_clean_id_elapsed_time_message(message)
      print_pre_recaptcha_elapsed_time_message(message)
    else
      print_post_survey_clean_id_message(message)
    end
  end

  private

  def calculate_pre_post
    @event.traffic_check ? @event.traffic_check.traffic_step.when : 'n/a'
  end

  def print_pre_survey_clean_id_message(message)
    return unless message == 'clean_id: failed'

    traffic_checks = survey_clean_id_checks('pre')
    print_clean_id_errors(traffic_checks)
  end

  def print_pre_clean_id_elapsed_time_message(message)
    return unless message == 'pre_analyze: failed: clean_id: took too long'

    steps = survey_clean_id_steps('pre')
    print_elapsed_time(steps)
  end

  def print_post_survey_clean_id_message(message)
    return unless message == 'clean_id: failed'

    traffic_checks = survey_clean_id_checks('post')
    print_clean_id_errors(traffic_checks)
  end

  def print_pre_recaptcha_elapsed_time_message(message)
    return unless message == 'pre_analyze: failed: recaptcha: took too long'

    steps = survey_recaptcha_steps('pre')
    print_elapsed_time(steps)
  end

  def survey_clean_id_steps(pre_post)
    @onboarding.traffic_steps
               .where(when: pre_post, category: 'clean_id')
               .order(:id)
  end

  def survey_recaptcha_steps(pre_post)
    @onboarding.traffic_steps
               .where(when: pre_post, category: 'recaptcha')
               .order(:id)
  end

  def survey_clean_id_checks(pre_post)
    steps = @onboarding.traffic_steps
                       .where(when: pre_post, category: 'clean_id')
                       .order(:id)

    steps.map do |step|
      step.traffic_checks.where(controller_action: 'show').order(:id)
    end.flatten
  end

  def print_clean_id_errors(traffic_checks)
    traffic_checks.each do |check|
      puts "  => score:#{clean_id_score(check)} / unique:#{clean_id_unique?(check)}"
    end
  end

  def print_elapsed_time(traffic_steps)
    traffic_steps.each do |step|
      puts "  => time elapsed:#{step.elapsed_time}"
    end
  end

  def clean_id_score(traffic_check)
    return 'CORS error' if traffic_check.data_collected.is_a?(String)

    traffic_check.data_collected&.dig('forensic', 'marker', 'score') || 'missing'
  end

  def clean_id_unique?(traffic_check)
    return 'CORS error' if traffic_check.data_collected.is_a?(String)

    unique_value = traffic_check.data_collected&.dig('forensic', 'unique', 'isEventUnique')
    return 'missing' if unique_value.nil?

    traffic_check.data_collected&.dig('forensic', 'unique', 'isEventUnique')
  end
end
