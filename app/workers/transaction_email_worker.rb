class TransactionEmailWorker
  include Sidekiq::Worker

  def perform(type_id, object_type, object_id, opts={})
    TransactionMailer.send_email(type_id, mailer_object(object_type, object_id), opts).deliver
  end
  
  private

  def mailer_object(object_type, object_id)
    object_type.classify.constantize.find_by_id(object_id)
  end
end
