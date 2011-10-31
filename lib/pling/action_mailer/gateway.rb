require 'pling'
require 'action_mailer'

module Pling
  module ActionMailer
    class Gateway < Pling::Gateway

      handles :email, :mail, :actionmailer

      def initialize(configuration)
        setup_configuration(configuration, :require => [:from])
      end

      def deliver!(message, device)
        mailer = configuration[:mailer] || Pling::ActionMailer::Mailer
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
