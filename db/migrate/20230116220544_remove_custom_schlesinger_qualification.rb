# frozen_string_literal: true

class RemoveCustomSchlesingerQualification < ActiveRecord::Migration[6.1]
  def change
    schlesinger_question = SchlesingerQualificationQuestion.find(816)
    schlesinger_question.destroy
  end
end
