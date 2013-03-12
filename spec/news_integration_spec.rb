require 'rspec'
require_relative '../lib/processing'
require 'json'
require 'vcr'

Mail.defaults do
  delivery_method :test
end

describe 'News retrieving' do
  include Mail::Matchers

  let(:processing) { Processing.new(1) }
  before do
    Net::HTTP.stub(:get_response).and_return(response)
  end

  describe "with positive response" do
    let(:items) { [{title: 'First', points: 170}, {title: 'Exclude', points: 75}, {title: 'Second', points: 180}, {title: 'Exclude 2', points: 150}, {title: 'Exclude 3', points: 150}] }
    let(:response) { mock(code: '200', body: {items: items}.to_json) }

    it "sends letter with results" do
      processing.process
      should have_sent_email.with_subject('List of stories')
      should have_sent_email.matching_body(/Mode is 150/)
      should have_sent_email.matching_body(/Median is 150/)
      should have_sent_email.matching_body(/Mean is 145/)
      should have_sent_email.matching_body(/First/)
      should have_sent_email.matching_body(/Second/)
    end
  end
  
  describe "with not found response" do
    let(:response) { mock(code: '404') }
    it "notifies about problem" do
      processing.process
      should have_sent_email.with_subject('Error occurred')
    end
  end
end
