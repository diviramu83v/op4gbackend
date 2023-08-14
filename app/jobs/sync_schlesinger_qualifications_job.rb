# frozen_string_literal: true

# Regularly refreshes the cache for the surveys API.
class SyncSchlesingerQualificationsJob
  include Sidekiq::Worker

  def perform
    QUALIFICATION_QUESTION_IDS.each do |qualification_id|
      response = SchlesingerApi.new.qualification_answers_for_question(qualification_id)
      qualification_question = create_or_update_question(response, qualification_id)
      create_or_update_answers(response, qualification_question)
    end
  end

  def create_or_update_answers(response, qualification_question)
    response['qualificationAnswers'].each do |answer|
      attributes = { answer_id: answer['answerId'],
                     text: answer['text'],
                     answer_code: answer['answerCode'] }

      qualification_answer = qualification_question.qualification_answers.create_with(
        attributes
      ).find_or_create_by(answer_id: answer['answerId'])
      qualification_answer.update(attributes)
    end
  end

  def create_or_update_question(response, qualification_id)
    attributes = { name: response['name'],
                   text: response['text'],
                   slug: response['name'].parameterize.underscore,
                   qualification_category_id: response['qualificationCategoryId'],
                   qualification_type_id: response['qualificationTypeId'] }
    qualification_question = SchlesingerQualificationQuestion.create_with(
      attributes
    ).find_or_create_by(qualification_id: qualification_id)
    qualification_question.update(attributes)
    qualification_question
  end

  QUALIFICATION_QUESTION_IDS = [59, 60, 63, 145, 143, 631, 62, 148, 65, 64, 152, 149, 151, 70, 75, 72, 61, 76, 73, 74, 71, 8077, 19_703, 6921, 630, 66, 79,
                                114, 89, 1297, 122, 82, 77, 150, 126, 69, 68, 106, 107, 67].freeze
end
