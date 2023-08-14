# frozen_string_literal: true

# View helpers for the schlesinger form.
module SchlesingerFormHelper
  def form_type_for_question(qual_form, question)
    case question.qualification_type_id
    when 6 then range_form(qual_form, question)
    else multi_punch_form(qual_form, question)
    end
  end

  def multi_punch_form(qual_form, question)
    render partial: 'multi_punch_form', locals: { question: question, qual_form: qual_form }
  end

  def range_form(qual_form, question)
    render partial: 'range_form', locals: { question: question, qual_form: qual_form }
  end
end
