# frozen_string_literal: true

# this provides methods for the
# panelist completes funnel reporting stats
module CompletesFunnel
  def total_invitations(year: nil, month: nil)
    onboardings = Onboarding.joins(:panelist).where(panelist: panelists)
    invitations = ProjectInvitation.where(onboarding: onboardings)
    collection_with_filter_count(invitations, year, month).count
  end

  def total_clicks(year: nil, month: nil)
    onboardings = Onboarding.joins(:panelist).where(panelist: panelists)
    invitations = ProjectInvitation.clicked.where(onboarding: onboardings)
    collection_with_filter_count(invitations, year, month).count
  end

  def total_completes(year: nil, month: nil)
    onboardings = Onboarding.complete.joins(:panelist).where(panelist: panelists)
    collection_with_filter_count(onboardings, year, month).count
  end

  def total_accepted_completes(year: nil, month: nil)
    onboardings = Onboarding.complete.accepted.joins(:panelist).where(panelist: panelists)
    collection_with_filter_count(onboardings, year, month).count
  end

  def total_completers(year: nil, month: nil)
    onboardings = Onboarding.complete.accepted.joins(:panelist).where(panelist: panelists)
    onboardings = collection_with_filter_count(onboardings, year, month)
    Panelist.where(onboardings: onboardings).count
  end

  def total_invited_panelists(year: nil, month: nil)
    onboardings = Onboarding.joins(:panelist).where(panelist: panelists)
    onboardings = collection_with_filter_count(onboardings, year, month)
    invitations = ProjectInvitation.where(onboarding: onboardings)
    Panelist.active.where(invitations: invitations).count
  end

  def total_uninvited_panelists(year: nil, month: nil)
    panelists.active.count - total_invited_panelists(year: year, month: month)
  end

  def pull_completes_funnel_data(year: nil, month: nil)
    @resource = self

    html = ApplicationController.render(
      partial: 'employee/completes_funnel/completes_row',
      locals: { resource: @resource, year: year, month: month }
    )

    CompletesFunnelChannel.broadcast_to(@resource, html)
  end

  private

  def collection_with_filter_count(collection, year, month)
    date = find_date(year, month)
    if date.nil?
      collection
    elsif month == 'All'
      collection.where("#{collection.klass.name.underscore.pluralize}.created_at BETWEEN ? AND ?", date.beginning_of_year, date.end_of_year)
    else
      collection.where("#{collection.klass.name.underscore.pluralize}.created_at BETWEEN ? AND ?", date.beginning_of_month, date.end_of_month)
    end
  end

  def find_date(year, month)
    if year == 'All' || (year.nil? && month.nil?)
      nil
    elsif month == 'All'
      DateTime.new(year.to_i)
    else
      DateTime.strptime("#{month} #{year}", '%B %Y')
    end
  end
end
