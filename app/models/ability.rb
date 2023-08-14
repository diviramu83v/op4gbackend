# frozen_string_literal: true

# The only place we currently need fine-grain authorization is for the
#   employee section of the site. Panelists can only do things within the
#   panelist section, so they're not included. Admins can do anything.
# Avoid using :manage in most cases. Assign :destroy explicitly.

# rubocop:disable Metrics/MethodLength
class Ability
  include CanCan::Ability
  # rubocop:disable Metrics/AbcSize, Metrics/PerceivedComplexity, Metrics/CyclomaticComplexity
  def initialize(user, session)
    return unless user.present? && user.is_a?(Employee)

    @effective_role = session[:effective_role] if session[:effective_role]

    if user.effective_role_admin?(@effective_role)
      can :manage, :all
      return
    end

    # Alias most common actions. Excluding delete on purpose.
    alias_action :read, :create, :update, to: :view_and_modify

    can :view_and_modify, :effective_role if user.admin?

    can :read, :all

    if user.effective_role_include?('Operations', @effective_role) || user.effective_role_include?('Operations manager', @effective_role)
      can :view_and_modify, Client
      can :view_and_modify, DemoQuery
      can :view_and_modify, DemoQueryOption
      can :view_and_modify, Earning
      can :view_and_modify, Key
      can :view_and_modify, ReturnKey
      can :view_and_modify, Onboarding
      can :view_and_modify, Onramp
      can :view_and_modify, Project
      can :view_and_modify, ProjectReport
      can :view_and_modify, RecontactInvitationBatch
      can :view_and_modify, SampleBatch
      can :view_and_modify, Survey
      can :view_and_modify, SurveyAdjustment
      can :view_and_modify, Vendor
      can :view_and_modify, VendorBatch
      can :view_and_modify, SurveyWarning
      can :view_and_modify, PrescreenerQuestionTemplate
      can :view_and_modify, PrescreenerAnswerTemplate
      can :view_and_modify, PrescreenerLibraryQuestion

      can :destroy, DemoQuery
      can :destroy, DemoQueryOption
      can :destroy, Earning
      can :destroy, Key
      can :destroy, Onboarding
      can :destroy, Onramp
      can :destroy, SampleBatch
      can :destroy, Survey
      can :destroy, VendorBatch
      can :destroy, PrescreenerQuestionTemplate
      can :destroy, PrescreenerAnswerTemplate
      can :destroy, PrescreenerLibraryQuestion
    end

    if user.effective_role_include? 'Operations manager', @effective_role
      can :view_and_modify, SurveyApiTarget
      can :view_and_modify, SurveyWarning
    end

    if user.effective_role_include? 'Panelist editor', @effective_role
      can :view_and_modify, Panelist
      can :destroy, Panelist
    end

    if user.effective_role_include? 'Recruitment', @effective_role
      can :view_and_modify, Panel
      can :view_and_modify, TrackingPixel
      can :view_and_modify, Nonprofit
      can :view_and_modify, IncentiveBatch
      can :view_and_modify, RecruitingCampaign, campaignable_type: 'Nonprofit'
      can :destroy, Nonprofit
      can :destroy, TrackingPixel
    end

    if user.effective_role_include? 'Sales', @effective_role
      can :view_and_modify, Panel
      can :view_and_modify, DemoQuery
      can :view_and_modify, DemoQueryOption
    end

    return unless user.effective_role_include? 'Security', @effective_role

    can :view_and_modify, IpAddress
    can :destroy, IpAddress
  end
  # rubocop:enable Metrics/AbcSize, Metrics/PerceivedComplexity, Metrics/CyclomaticComplexity
end
# rubocop:enable Metrics/MethodLength
