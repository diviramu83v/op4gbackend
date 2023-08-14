# frozen_string_literal: true

require 'test_helper'

class InvitationCreationJobTest < ActiveJob::TestCase
  it 'tells the sample batch to create invitations' do
    sample_batch = sample_batches(:standard)

    sample_batch.expects(:create_invitations).once

    InvitationCreationJob.perform_now(sample_batch)
  end

  describe 'panelist already has 2 invitations that day' do
    setup do
      @panelist_one = panelists(:standard)
      @panelist_two = panelists(:active)
      DemoQuery.any_instance.stubs(:panelists).returns([@panelist_one, @panelist_two])
      @sample_batch = sample_batches(:standard)
      @sample_batch.query.panelists.each do |panelist|
        panelist.invitations.destroy_all
      end
      sample_batch = SampleBatch.create(count: 10, incentive_cents: 100, demo_query_id: DemoQuery.first.id, email_subject: 'test')
      @panelist_one.invitations.create(project_id: Project.last.id, sample_batch_id: SampleBatch.first.id, survey_id: Survey.first.id)
      @panelist_one.invitations.create(project_id: Project.last.id, sample_batch_id: sample_batch.id, survey_id: Survey.last.id)
    end

    it 'should not create invitation' do
      assert_equal 2, @panelist_one.invitations.count
      InvitationCreationJob.perform_now(@sample_batch)

      assert_equal 2, @panelist_one.invitations.count
    end
  end
end
