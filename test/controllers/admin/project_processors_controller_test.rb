# frozen_string_literal: true

require 'test_helper'

class Admin::ProjectProcessorsControllerTest < ActionDispatch::IntegrationTest
  setup do
    load_and_sign_in_admin
  end

  describe '#index' do
    it 'should load the page' do
      get project_processors_url

      assert_response :ok
    end
  end

  describe '#create' do
    setup do
      project = projects(:standard)
      project_file = "[WO 12345] test file (#{project.id})"
      csv_rows = <<~HEREDOC
        1
        #{project_file}
      HEREDOC
      @file = Tempfile.new('project.csv')
      @file.write(csv_rows)
      @file.rewind

      bad_rows = <<~HEREDOC
        1
        2
        3
      HEREDOC
      @bad_file = Tempfile.new('project.csv')
      @bad_file.write(bad_rows)
      @bad_file.rewind
    end

    it 'should download the report with good data' do
      post project_processors_url, params: { project: { upload: Rack::Test::UploadedFile.new(@file, 'text/csv') } }

      assert_response :ok
    end

    it 'should not create report with bad data' do
      post project_processors_url, params: { project: { upload: Rack::Test::UploadedFile.new(@bad_file, 'text/csv') } }

      assert_response :ok
    end
  end
end
