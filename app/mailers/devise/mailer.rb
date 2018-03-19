if defined?(ActionMailer)
  class Devise::Mailer < Devise.parent_mailer.constantize
    include Devise::Mailers::Helpers

    def reset_password_instructions(record, token, opts={})
      TransactionEmailWorker.perform_async(3, 'user', record.id, { token: token })
    end
  end
end