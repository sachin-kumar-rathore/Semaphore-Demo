class Admin < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable

  protected

  def send_devise_notification(notification, *args)
    notification == :reset_password_instructions ? TransactionEmailWorker.perform_async(3, 'admin', self.id, { token: args[0] })
                                                 : super
  end
end
