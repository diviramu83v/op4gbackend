# frozen_string_literal: true

require 'test_helper'

class PanelistSuspenderTest < ActiveSupport::TestCase
  describe '#auto_suspend' do
    setup do
      @panelist = panelists(:standard)
      @suspender = PanelistSuspender.new(@panelist)
    end

    it 'should not suspend panelist' do
      @data = { 'TransactionId' => 'eb815afc-c4eb-47e9-89a8-8981b32f7ca4', 'Score' => 0, 'ORScore' => 0.45, 'Duplicate' => false, 'IsMobile' => false }
      @panelist.update!(clean_id_data: @data)
      stub_request(:get, 'https://gateway.navigatorsurveys.com/cleanid/result/eb815afc-c4eb-47e9-89a8-8981b32f7ca4')
        .to_return(status: 200,
                   body: '{"result": { "Score": 0, "ORScore": 0.45, "Duplicate": false}}',
                   headers: { 'Content-Type' => 'application/json' })
      assert_no_difference -> { Panelist.suspended.count } do
        @suspender.auto_suspend
      end
    end

    it 'should suspend panelist for failing CleanID' do
      @data = { 'TransactionId' => 'eb815afc-c4eb-47e9-89a8-8981b32f7ca4', 'Score' => 26, 'ORScore' => 0.45, 'Duplicate' => false, 'IsMobile' => false }
      @panelist.update!(clean_id_data: @data)
      stub_request(:get, 'https://gateway.navigatorsurveys.com/cleanid/result/eb815afc-c4eb-47e9-89a8-8981b32f7ca4')
        .to_return(status: 200,
                   body: '{"result": { "Score": 26, "ORScore": 0.45, "Duplicate": false}}',
                   headers: { 'Content-Type' => 'application/json' })

      assert_difference -> { Panelist.suspended.count } do
        @suspender.auto_suspend
      end
    end

    it 'should create note' do
      @data = { 'TransactionId' => 'eb815afc-c4eb-47e9-89a8-8981b32f7ca4', 'Score' => 26, 'ORScore' => 0.45, 'Duplicate' => false, 'IsMobile' => false }
      @panelist.update!(clean_id_data: @data)

      assert_difference -> { @panelist.notes.count } do
        @suspender.auto_suspend
      end
    end

    it 'should suspend panelist for invalid country' do
      @data = { 'TransactionId' => 'eb815afc-c4eb-47e9-89a8-8981b32f7ca4', 'Score' => 26, 'ORScore' => 0.45, 'Duplicate' => false, 'IsMobile' => false }
      @panelist.update!(clean_id_data: @data)

      assert_difference -> { Panelist.suspended.count } do
        @suspender.auto_suspend
      end
    end
  end

  describe '#manual_suspend!' do
    setup do
      @employee = employees(:operations)
      @panelist = panelists(:standard)
      @note = panelist_notes(:standard)
      @suspender = PanelistSuspender.new(@panelist)
    end

    it 'should suspend panelist and create note' do
      assert_difference ['Panelist.suspended.count', 'PanelistNote.count'], 1 do
        @suspender.manual_suspend!(employee: @employee, note_body: @note.body)
      end
    end

    it 'should not suspend panelist nor create a note if the note is invalid' do
      @note.body = nil

      assert_no_difference ['Panelist.suspended.count', 'PanelistNote.count'] do
        @suspender.manual_suspend!(employee: @employee, note_body: @note.body)
      end
    end
  end
end
