require 'pling'
require 'action_mailer'

module Pling
  module Gateway
    class ActionMailer < Base
      class Mailer < ::ActionMailer::Base
        append_view_path File.expand_path('../../../../app/views', __FILE__)

        def pling_message(message, device, configuration)
          @message, @device, @configuration = message, device, configuration

          use_text = configuration.delete(:text)
          use_html = configuration.delete(:html)

          mail(configuration.merge(:to => device.identifier)) do |format|
            format.text { render 'pling/mailer/pling_message' } if use_text
            format.html { render 'pling/mailer/pling_message' } if use_html
          end
        end
      end

      handles :email, :mail, :actionmailer

      def initialize(configuration)
        setup_configuration(configuration, :require => [:from])
      end

      def deliver(message, device)
        message = Pling._convert(message, :message)
        device  = Pling._convert(device,  :device)

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