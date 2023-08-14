# frozen_string_literal: true

# Usage: rails runner lib/scripts/demographic_data.rb

def percentage(count, total)
  ((count.to_f / total) * 100.0).round(2)
end

def process_results(results, total)
  results.each do |answer, count|
    puts "#{answer}: #{count} - #{percentage(count, total)}%"
  end
end

panel = Panel.find(50)

panel.demo_questions.each do |demo_question|
  next unless demo_question.id == 229 || demo_question.id == 234 || demo_question.id == 223

  results = Hash.new(0)
  total = 0
  puts demo_question.body.to_s
  panel.panelists.active.each do |panelist|
    panelist.demo_answers.each do |demo_answer|
      if demo_answer.demo_question == demo_question
        results[demo_answer.demo_option.label] += 1
        total += 1
      end
    end
  end
  process_results(results, total)
  puts ' '
end
