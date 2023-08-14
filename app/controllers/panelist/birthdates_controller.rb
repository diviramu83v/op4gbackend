# frozen_string_literal: true

class Panelist::BirthdatesController < Panelist::BaseController
  def edit; end

  def update
    if current_panelist.update(birthdate: birthdate)
      current_panelist.calculate_age
      flash[:notice] = t('panelist.birthdates.update.success_flash', default: 'Account successfully updated.')
      redirect_to edit_account_birthdate_url
    else
      render :edit
    end
  rescue ArgumentError
    flash.now[:alert] = t('panelist.birthdates.update.alert_flash', default: 'Account could not be updated.')
    render 'edit'
  end

  private

  def birthdate
    date = "#{params.dig(:panelist, :year)}-#{params.dig(:panelist, :month)}-#{params.dig(:panelist, :day)}"
    Date.parse(date)
    date
  end
end
