# frozen_string_literal: true

require 'test_helper'

class ProjectVendorTest < ActiveSupport::TestCase
  describe 'validations' do
    subject { ProjectVendor.new }

    should validate_presence_of(:project_id)
    should validate_presence_of(:vendor_id)
    should validate_presence_of(:incentive)
    should validate_numericality_of(:project_id)
    should validate_numericality_of(:vendor_id)
    should validate_numericality_of(:incentive)
  end

  describe '#save' do
    before do
      @vendor = vendors(:batch)
    end

    it 'creates a vendor batch for each survey' do
      survey = Survey.create(
        project: Project.create(
          name: Faker::Company.name,
          manager: Employee.create(
            first_name: Faker::Name.first_name,
            last_name: Faker::Name.last_name,
            email: Faker::Internet.email,
            password: Faker::Internet.password
          )
        ),
        name: Faker::Company.name,
        category: 'standard',
        audience: 'audience',
        country_id: 284_678_023
      )
      project = Project.create(manager: employees(:operations), surveys: [survey], name: Faker::Name.name, product_name: 'sample_only')
      complete_url = 'https://testing.com?complete'
      terminate_url = 'https://testing.com?terminate'
      overquota_url = 'https://testing.com?overquota'

      assert_difference -> { VendorBatch.count }, 1 do
        ProjectVendor.new(project_id: project.id, vendor_id: @vendor.id, incentive: 5.0, quoted_completes: 300, requested_completes: 300,
                          complete_url: complete_url, terminate_url: terminate_url, overquota_url: overquota_url).save
      end
    end
  end
end
