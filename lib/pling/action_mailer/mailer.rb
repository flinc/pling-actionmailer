require 'action_mailer'

module Pling
  module ActionMailer
    class Mailer < ::ActionMailer::Base
      append_view_path File.expand_path('../../../../app/views', __FILE__)

      def pling_message(message, device, configuration)
        @message, @device, @configuration = message, device, configuration

        mail(:to => device.identifier, :from => configuration[:from], :subject => message.subject) do |format|
          format.text { render 'pling/mailer/pling_message' } if configuration[:text]
          format.html { render 'pling/mailer/pling_message' } if configuration[:html]
        end
      end
    end
  end
end