class TransactionEmailWorker
  include Sidekiq::Worker

  def perform(type_id, task_id)
    task = Task.find_by_id(task_id)
    TransactionMailer.send_email(type_id, task).deliver
  end
end
