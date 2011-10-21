require 'spec_helper'

describe Pling::Gateway::ActionMailer do

  let(:valid_configuration) do
    { :from => 'random@example.com' }
  end

  let(:message) { Pling::Message.new('Hello from Pling') }
  let(:device)  { Pling::Device.new(:identifier => 'DEVICEIDENTIFIER', :type => :email) }

  let(:mail) { mock(:deliver => true) }

  before do
    Pling::Gateway::ActionMailer::Mailer.stub(:pling_message => mail)
  end

  it 'should handle various action mailer related device types' do
    Pling::Gateway::ActionMailer.handled_types.should =~ [:mail, :email, :actionmailer]
  end

  context 'when created with an invalid configuration' do
    [:from].each do |attribute|
      it "should raise an error when :#{attribute} is missing" do
        configuration = valid_configuration
        configuration.delete(attribute)
        expect { Pling::Gateway::ActionMailer.new(configuration) }.to raise_error(ArgumentError, /:#{attribute} is missing/)
      end
    end
  end

  context 'when created with a valid configuration' do
    it 'should pass the full configuration to the mailer' do
      configuration = valid_configuration.merge({ :something => true })
      gateway = Pling::Gateway::ActionMailer.new(configuration)

      Pling::Gateway::ActionMailer::Mailer.
        should_receive(:pling_message).
        with(anything, anything, hash_including(configuration)).and_return(mail)

      gateway.deliver(message, device)
    end

    it 'should allow configuration of the :mailer' do
      mailer = mock()
      mailer.should_receive(:pling_message).
        with(message, device, hash_including(valid_configuration)).
        and_return(mail)

      gateway = Pling::Gateway::ActionMailer.new(valid_configuration.merge(:mailer => mailer))

      gateway.deliver(message, device)
    end
  end

  describe '#deliver' do
    subject { Pling::Gateway::ActionMailer.new(valid_configuration) }

    it 'should raise an error if no message is given' do
      expect { subject.deliver(nil, device) }.to raise_error
    end

    it 'should raise an error the device is given' do
      expect { subject.deliver(message, nil) }.to raise_error
    end

    it 'should call #to_pling_message on the given message' do
      message.should_receive(:to_pling_message).and_return(message)
      subject.deliver(message, device)
    end

    it 'should call #to_pling_device on the given device' do
      device.should_receive(:to_pling_device).and_return(device)
      subject.deliver(message, device)
    end

    it 'should try to deliver the given message' do
      Pling::Gateway::ActionMailer::Mailer.
        should_receive(:pling_message).
        with(message, device, hash_including(valid_configuration)).
        and_return(mail)

      subject.deliver(message, device)
    end
  end
end