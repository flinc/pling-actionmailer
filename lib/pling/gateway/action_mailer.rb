require 'pling'
require 'action_mailer'

module Pling
  module Gateway
    class ActionMailer < Base
      class Mailer < ::ActionMailer::Base
        append_view_path File.expand_path('../../../../app/views', __FILE__)

        def pling_message(message, device, configuration)
          @message, @device, @configuration = message, device, configuration

          mail(:to => device.identifier, :from => configuration[:from]) do |format|
            format.text { render 'pling/mailer/pling_message' } if configuration[:text]
            format.html { render 'pling/mailer/pling_message' } if configuration[:html]
          end
        end
      end

      handles :email, :mail, :actionmailer

      def initialize(configuration)
        setup_configuration(configuration, :require => [:from])
      end

      def deliver!(message, device)
        mailer = configuration[:mailer] || Pling::Gateway::ActionMailer::Mailer
        mailer.pling_message(message, device, configuration).deliver
      end

      private

        def default_configuration
          super.merge({
            :html => true,
            :text => true
          })
        end

    end
  end
end
