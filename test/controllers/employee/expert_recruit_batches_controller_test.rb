# frozen_string_literal: true

require 'test_helper'

class Employee::ExpertRecruitBatchesControllerTest < ActionDispatch::IntegrationTest
  setup do
    load_and_sign_in_admin
    @survey = surveys(:standard)
  end

  describe '#index' do
    it 'should load the page' do
      get survey_expert_recruit_batches_url(@survey)

      assert_response :ok
    end
  end

  describe '#new' do
    it 'should load the page' do
      get new_survey_expert_recruit_batch_url(@survey)

      assert_response :ok
    end
  end

  describe '#edit' do
    setup do
      @expert_recruit_batch = expert_recruit_batches(:standard)
    end

    it 'should load the page' do
      get edit_expert_recruit_batch_url(@expert_recruit_batch)

      assert_response :ok
    end
  end

  describe '#create' do
    setup do
      csv_rows = <<~HEREDOC
        "test","t","tester","head of testing","testers of america","1-800-555-5555","test@testing.com"
      HEREDOC
      @file = Tempfile.new('test_data.csv')
      @file.write(csv_rows)
      @file.rewind
    end

    it 'should create batch with upload file' do
      params = {
        expert_recruit_batch: {
          emails_first_names: Rack::Test::UploadedFile.new(@file, 'text/csv'),
          description: 'test subjects',
          incentive: 2.00,
          time: 30,
          email_body: '<p>This is the email body.</p>',
          employee_id: employees(:locked_panel).id
        }
      }
      assert_difference -> { ExpertRecruitBatch.count } do
        post survey_expert_recruit_batches_url(@survey), params: params
      end

      assert_redirected_to survey_expert_recruit_batches_url(@survey)
    end

    it 'should create batch with pasted first names and emails' do
      params = {
        expert_recruit_batch: {
          pasted_first_names_emails: "joe@test.com, Joe\r\nbillybob@test.com, Billy Bob\r\nharry@test.com, Harry",
          description: 'test subjects',
          incentive: 2.00,
          time: 30,
          email_body: '<p>This is the email body.</p>',
          employee_id: employees(:locked_panel).id
        }
      }
      assert_difference -> { ExpertRecruitBatch.count } do
        post survey_expert_recruit_batches_url(@survey), params: params
      end

      assert_redirected_to survey_expert_recruit_batches_url(@survey)
    end

    it 'should fail to create batch due to missing required fields' do
      params = {
        expert_recruit_batch: {
          emails_first_names: Rack::Test::UploadedFile.new(@file, 'text/csv'),
          description: 'This will not create a batch due to missing required fields.',
          employee_id: employees(:locked_panel).id
        }
      }
      assert_no_difference -> { ExpertRecruitBatch.count } do
        post survey_expert_recruit_batches_url(@survey), params: params
      end

      assert_template :new
    end

    it 'should fail to create batch due to missing upload file or pasted first names and emails' do
      params = {
        expert_recruit_batch: {
          description: 'test subjects',
          incentive: 2.00,
          time: 30,
          employee_id: employees(:locked_panel).id
        }
      }

      assert_no_difference -> { ExpertRecruitBatch.count } do
        post survey_expert_recruit_batches_url(@survey), params: params
      end

      assert_template :new
      assert_not_nil flash[:alert]
    end

    it 'should fail to create batch due to missing employee phone number' do
      params = {
        expert_recruit_batch: {
          description: 'test subjects',
          incentive: 2.00,
          time: 30,
          employee_id: employees(:operations).id
        }
      }

      assert_no_difference -> { ExpertRecruitBatch.count } do
        post survey_expert_recruit_batches_url(@survey), params: params
      end

      assert_template :new
      assert_not_nil flash[:alert]
    end

    describe '#send_on_behalf_of_client?' do
      it 'should create batch with uploaded logo saved as an active storage attachment' do
        logo = fixture_file_upload(Rails.public_path.join('op4g-logo.png'), 'image/png')
        params = {
          expert_recruit_batch: {
            emails_first_names: Rack::Test::UploadedFile.new(@file, 'text/csv'),
            time: 30,
            incentive: 2.00,
            from_email: 'joe@test.com',
            email_body: '<p>This is the email body.</p>',
            employee_id: employees(:locked_panel).id,
            logo: logo,
            send_for_client: 1,
            email_signature: '<p>Sincerely,<br>Joe Smith</p>',
            client_name: 'Joe Smith',
            client_phone: '555-555-5555'
          }
        }
        assert_difference -> { ExpertRecruitBatch.count } do
          post survey_expert_recruit_batches_url(@survey), params: params
        end

        assert_difference -> { ActiveStorage::Attachment.count } do
          post survey_expert_recruit_batches_url(@survey), params: params
        end

        assert_redirected_to survey_expert_recruit_batches_url(@survey)
      end

      it 'should not create batch if from_email is missing' do
        logo = fixture_file_upload(Rails.public_path.join('op4g-logo.png'), 'image/png')
        params = {
          expert_recruit_batch: {
            emails_first_names: Rack::Test::UploadedFile.new(@file, 'text/csv'),
            time: 30,
            incentive: 2.00,
            email_body: '<p>This is the email body.</p>',
            employee_id: employees(:locked_panel).id,
            logo: logo,
            send_for_client: 1,
            email_signature: '<p>Sincerely,<br>Joe Smith</p>',
            client_name: 'Joe Smith',
            client_phone: '555-555-5555'
          }
        }
        assert_no_difference -> { ExpertRecruitBatch.count } do
          post survey_expert_recruit_batches_url(@survey), params: params
        end

        assert_template :new
      end

      it 'should not create batch if email_signature is missing' do
        logo = fixture_file_upload(Rails.public_path.join('op4g-logo.png'), 'image/png')
        params = {
          expert_recruit_batch: {
            emails_first_names: Rack::Test::UploadedFile.new(@file, 'text/csv'),
            time: 30,
            incentive: 2.00,
            from_email: 'joe@test.com',
            email_body: '<p>This is the email body.</p>',
            employee_id: employees(:locked_panel).id,
            logo: logo,
            send_for_client: 1,
            client_name: 'Joe Smith',
            client_phone: '555-555-5555'
          }
        }
        assert_no_difference -> { ExpertRecruitBatch.count } do
          post survey_expert_recruit_batches_url(@survey), params: params
        end

        assert_template :new
      end

      it 'should not create batch if client_name is missing' do
        logo = fixture_file_upload(Rails.public_path.join('op4g-logo.png'), 'image/png')
        params = {
          expert_recruit_batch: {
            emails_first_names: Rack::Test::UploadedFile.new(@file, 'text/csv'),
            time: 30,
            incentive: 2.00,
            from_email: 'joe@test.com',
            email_body: '<p>This is the email body.</p>',
            employee_id: employees(:locked_panel).id,
            logo: logo,
            send_for_client: 1,
            email_signature: '<p>Sincerely,<br>Joe Smith</p>',
            client_phone: '555-555-5555'
          }
        }
        assert_no_difference -> { ExpertRecruitBatch.count } do
          post survey_expert_recruit_batches_url(@survey), params: params
        end

        assert_template :new
      end

      it 'should not create batch if client_phone is missing' do
        logo = fixture_file_upload(Rails.public_path.join('op4g-logo.png'), 'image/png')
        params = {
          expert_recruit_batch: {
            emails_first_names: Rack::Test::UploadedFile.new(@file, 'text/csv'),
            time: 30,
            incentive: 2.00,
            from_email: 'joe@test.com',
            email_body: '<p>This is the email body.</p>',
            employee_id: employees(:locked_panel).id,
            logo: logo,
            send_for_client: 1,
            email_signature: '<p>Sincerely,<br>Joe Smith</p>',
            client_name: 'Joe Smith'
          }
        }
        assert_no_difference -> { ExpertRecruitBatch.count } do
          post survey_expert_recruit_batches_url(@survey), params: params
        end

        assert_template :new
      end
    end
  end

  describe '#update' do
    setup do
      @expert_recruit_batch = expert_recruit_batches(:standard)
    end

    it 'should update batch' do
      params = {
        expert_recruit_batch: {
          emails: 'test@test.com',
          description: 'test subjects',
          time: 35,
          email_body: '<p>This is the email body.</p>'
        }
      }
      assert_no_difference -> { ExpertRecruitBatch.count } do
        patch expert_recruit_batch_url(@expert_recruit_batch), params: params
      end

      assert_redirected_to survey_expert_recruit_batches_url(@survey)
    end

    it 'should fail to create batch' do
      params = {
        expert_recruit_batch: {
          time: ''
        }
      }
      patch expert_recruit_batch_url(@expert_recruit_batch), params: params

      assert_template :edit
    end
  end

  describe '#destroy' do
    setup do
      @expert_recruit_batch = expert_recruit_batches(:standard)
    end

    it 'should delete expert recruit batch' do
      assert_difference -> { ExpertRecruitBatch.count }, -1 do
        delete expert_recruit_batch_url(@expert_recruit_batch)
      end
    end
  end
end
