# frozen_string_literal: true

require 'test_helper'

class PrescreenerQuestionTest < ActiveSupport::TestCase
  describe '#failed?' do
    describe 'failed_because_all_answers_selected' do
      it 'should fail multi select where all answers are chosen' do
        @prescreener_question = prescreener_questions(:multi_answer)
        select_all_answers(@prescreener_question)
        assert @prescreener_question.question_failed?
        assert @prescreener_question.onboarding.screened?
      end

      it 'should pass multi select where not all answers are chosen' do
        @prescreener_question = prescreener_questions(:multi_answer)
        select_a_correct_answer(@prescreener_question)
        assert_not @prescreener_question.question_failed?
      end
    end

    describe 'pass_if_any_selected' do
      setup do
        @prescreener_question = prescreener_questions(:multi_answer)
        @prescreener_question.update!(passing_criteria: 'pass_if_any_selected')
      end

      it 'should fail' do
        unselect_all_correct_answers(@prescreener_question)
        assert @prescreener_question.question_failed?
        assert @prescreener_question.onboarding.screened?
      end

      it 'should pass' do
        select_a_correct_answer(@prescreener_question)
        assert_not @prescreener_question.question_failed?
      end
    end

    describe 'pass_if_all_selected' do
      setup do
        @prescreener_question = prescreener_questions(:multi_answer)
        @prescreener_question.update!(passing_criteria: 'pass_if_all_selected')
      end

      it 'should fail' do
        select_only_one_correct_answer(@prescreener_question)
        assert @prescreener_question.question_failed?
        assert @prescreener_question.onboarding.screened?
      end

      it 'should pass' do
        select_all_correct_answers(@prescreener_question)
        assert_not @prescreener_question.question_failed?
      end
    end

    describe 'fail_if_any_selected' do
      setup do
        @prescreener_question = prescreener_questions(:multi_answer)
        @prescreener_question.update!(passing_criteria: 'fail_if_any_selected')
      end

      it 'should fail' do
        select_a_correct_answer(@prescreener_question)
        assert @prescreener_question.question_failed?
        assert @prescreener_question.onboarding.screened?
      end

      it 'should pass' do
        unselect_all_correct_answers(@prescreener_question)
        assert_not @prescreener_question.question_failed?
      end
    end
  end

  describe '#self.generate_questions' do
    setup do
      params1 = {
        question_type: 'single_answer',
        passing_criteria: 'pass_if_any_selected',
        body: 'Yo?',
        status: 'active'
      }
      params2 = {
        question_type: 'single_answer',
        passing_criteria: 'pass_if_any_selected',
        body: 'Whaaa?',
        status: 'deleted'
      }
      @survey = surveys(:standard)
      @survey.prescreener_question_templates.create(params1)
      @survey.prescreener_question_templates.create(params2)
    end

    test 'only active questions are added' do
      questions = PrescreenerQuestion.generate_questions(@survey)
      questions.each do |question|
        template = PrescreenerQuestionTemplate.find(question[:prescreener_question_template_id])
        assert_not template.deleted?
      end
    end
  end

  private

  def select_a_correct_answer(question)
    correct_answer = question.target_answers.first
    question.update(selected_answers: [correct_answer])
  end

  def unselect_all_correct_answers(question)
    question.update(selected_answers: [])
  end

  def select_all_correct_answers(question)
    question.update(selected_answers: question.target_answers)
  end

  def select_only_one_correct_answer(question)
    question.update(selected_answers: [question.target_answers.first])
  end

  def select_all_answers(question)
    question.update(selected_answers: question.answer_options)
  end
end
