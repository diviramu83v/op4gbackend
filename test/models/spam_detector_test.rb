# frozen_string_literal: true

require 'test_helper'

class SpamDetectorTest < ActiveSupport::TestCase
  subject { SpamDetector }

  describe '.looks_fraudulent?' do
    describe "random request that shouldn't be detected" do
      setup do
        @request = stub(fullpath: '/random')
      end

      it 'is not fraudulent' do
        assert_not SpamDetector.looks_fraudulent?(request: @request)
      end
    end

    describe 'old redirect pattern' do
      setup do
        @request = stub(fullpath: '/status?full=')
      end

      it 'is fraudulent' do
        assert SpamDetector.looks_fraudulent?(request: @request)
      end
    end

    describe 'old complete request' do
      setup do
        @request = stub(fullpath: '/completed?sid=12170&token=twTrTEvvDZXR4S6Pd8RHTp4p')
      end

      it 'is fraudulent' do
        assert SpamDetector.looks_fraudulent?(request: @request)
      end
    end

    describe '.js request' do
      setup do
        @request = stub(fullpath: '.js')
      end

      it 'is fraudulent' do
        assert SpamDetector.looks_fraudulent?(request: @request)
      end
    end

    describe 'ads.txt request' do
      setup do
        @request = stub(fullpath: '/ads.txt')
      end

      it 'is fraudulent' do
        assert SpamDetector.looks_fraudulent?(request: @request)
      end
    end

    describe 'weird favicon request' do
      setup do
        @request = stub(fullpath: '/mriweb/templates/2.0/img/favicon.png')
      end

      it 'is fraudulent' do
        assert SpamDetector.looks_fraudulent?(request: @request)
      end
    end

    describe 'survey.ico request' do
      setup do
        @request = stub(fullpath: '/ssiweb/2018170/graphics/system/survey.ico')
      end

      it 'is fraudulent' do
        assert SpamDetector.looks_fraudulent?(request: @request)
      end
    end

    describe 'password page request' do
      setup do
        @request = stub(fullpath: '/password')
      end

      it 'is fraudulent' do
        assert SpamDetector.looks_fraudulent?(request: @request)
      end
    end

    describe 'followup page request' do
      setup do
        @request = stub(fullpath: '/followups')
      end

      it 'is fraudulent' do
        assert SpamDetector.looks_fraudulent?(request: @request)
      end
    end

    describe 'random numeric request' do
      setup do
        @request = stub(fullpath: '/1')
      end

      it 'is fraudulent' do
        assert SpamDetector.looks_fraudulent?(request: @request)
      end
    end

    describe 'request with survey domain as the path' do
      setup do
        @request = stub(fullpath: '/https://survey.op4g.com/')
      end

      it 'is fraudulent' do
        assert SpamDetector.looks_fraudulent?(request: @request)
      end
    end
  end
end
