require 'spec_helper'

describe Pling::ActionMailer::Mailer do
  subject { described_class }

  let(:message) { Pling::Message.new('Hello from Pling') }
  let(:device)  { Pling::Device.new(:identifier => 'DEVICEIDENTIFIER', :type => :email) }
  let(:mail)    { described_class.pling_message(message, device, configuration) }
  let(:configuration) do
    {
      :from => 'random@example.com',
      :html => true,
      :text => true
    }
  end

  specify { described_class.ancestors =~ ::ActionMailer::Base }

  describe '.pling_message' do

    it 'should return an instance of Mail::Message' do
      subject.pling_message(message, device, configuration).should be_kind_of(Mail::Message)
    end

    context '{ :html => true, :text => true }' do
      subject { described_class.pling_message(message, device, configuration) }

      its(:mime_type) { should eq('multipart/alternative') }
      it { should have(2).parts }

      specify { subject.parts.map(&:mime_type) =~ ['multipart/alternative', 'text/plain'] }
    end

    context '{ :html => false, :text => true }' do
      subject { described_class.pling_message(message, device, configuration.merge(:html => false, :text => true)) }

      its(:mime_type) { should eq('text/plain') }
      its(:body) { should eq('Hello from Pling') }
    end

    context '{ :html => true, :text => false }' do
      subject { described_class.pling_message(message, device, configuration.merge(:html => true, :text => false)) }

      its(:mime_type) { should eq('text/html') }
      its(:body) { should =~ /<html>(.*)Hello from Pling(.*)<\/html>/m }
    end

    it 'should use device.identifier as recipient' do
      mail.to.should include('DEVICEIDENTIFIER')
    end

    it 'should use sender from the configuration' do
      mail.from.should include('random@example.com')
    end

  end
end