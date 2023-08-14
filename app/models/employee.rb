# frozen_string_literal: true

require 'securerandom'
require 'bcrypt'

# An employee represents an Op4G employee or contractor, with various roles.
class Employee < ApplicationRecord
  has_many :employee_roles, dependent: :destroy
  has_many :roles, through: :employee_roles, inverse_of: :employees
  has_many :ip_histories, dependent: :destroy, class_name: 'EmployeeIpHistory', inverse_of: :employee

  has_many :managed_projects, dependent: :nullify, inverse_of: :manager, class_name: 'Project', foreign_key: :manager_id
  has_many :sold_projects, dependent: :nullify, inverse_of: :salesperson, class_name: 'Project', foreign_key: :salesperson_id
  has_many :survey_warnings, through: :managed_projects
  has_many :test_uids, dependent: :destroy
  has_many :demo_queries, dependent: :destroy
  has_many :disqo_feasibilities, dependent: :destroy
  has_many :cint_feasibilities, dependent: :destroy
  has_many :expert_recruit_batches, dependent: :destroy
  has_many :client_sent_surveys, dependent: :destroy

  has_one :survey_test_mode, dependent: :destroy

  after_create :add_test_survey_mode

  # has_many :system_events, dependent: :nullify

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  # :registerable, :recoverable,
  devise :database_authenticatable, :rememberable, :trackable, :validatable, :jwt_authenticatable, jwt_revocation_strategy: JwtDenylist

  validates :email, :first_name, :last_name, presence: true

  scope :by_name, -> { order(:first_name, :last_name) }
  scope :locked_panel, -> { joins(:employee_roles).joins(:roles).where(roles: { name: 'Locked panel' }).uniq }

  def name
    "#{first_name} #{last_name}"
  end

  def initials
    "#{first_name[0]}#{last_name[0]}"
  end

  def effective_role_include?(name, effective_role)
    role = Role.find_by(name: name)
    return false if effective_role.present? && effective_role != role.name

    return true if effective_role.present? && effective_role == role.name

    roles.include?(role)
  end

  def roles_include?(name)
    role = Role.find_by(name: name)
    roles.include?(role)
  end

  def admin?
    roles_include?('Admin')
  end

  def effective_role_admin?(effective_role)
    admin? && (effective_role.nil? || effective_role == 'Admin')
  end

  def locked_panel?(effective_role)
    effective_role_include?('Locked panel', effective_role) || effective_role == 'Admin'
  end

  def ops_manager?(effective_role)
    effective_role_include?('Operations manager', effective_role)
  end

  def admin_or_ops_manager?(effective_role)
    effective_role_admin?(effective_role) || ops_manager?(effective_role)
  end

  def can_view_panelist_data?(effective_role)
    effective_role_admin?(effective_role) || effective_role_include?('Panelist data', effective_role)
  end

  def operations_employee?(effective_role)
    effective_role_admin?(effective_role) || effective_role_include?('Operations', effective_role)
  end

  def warning_count
    survey_warnings.active.count
  end

  def feasibility_count
    demo_queries.where(survey: nil).count
  end

  def test_mode_on?
    return false if survey_test_mode.nil?

    survey_test_mode.easy_mode?
  end

  def self.with_role(role_name)
    joins(:roles).where(roles: { name: role_name })
  end

  def add_test_survey_mode
    create_survey_test_mode
  end

  def on_jwt_dispatch(token, payload)
  end

  def self.auth_headers(headers, user, scope: nil, aud: nil)
    scope ||= Devise::Mapping.find_scope!(user)
    aud ||= headers[Warden::JWTAuth.config.aud_header]
    token, payload = Warden::JWTAuth::UserEncoder.new.call(
      user, scope, aud
    )
    user.on_jwt_dispatch(token, payload) if user.respond_to?(:on_jwt_dispatch)
    Warden::JWTAuth::HeaderParser.to_headers(headers, token)
  end
end
