# frozen_string_literal: true

# Monkey-patching the String class to detect numbers.
class String
  def numeric?
    !Float(self).nil?
  rescue StandardError
    false
  end

  def integer?
    to_i.to_s == self
  end
end
