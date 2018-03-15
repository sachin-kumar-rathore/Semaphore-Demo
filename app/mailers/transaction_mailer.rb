class TransactionMailer < ApplicationMailer

  def send_email(emailTypeId, mailerObj)
    transaction_email = TransactionalEmail.find_by_type_id(emailTypeId)
    @email_body = generate_email_body(emailTypeId, transaction_email.body, mailerObj)
    mail(to: mailerObj.assignee.email, subject: transaction_email.subject)
  end

  def send_test_email(emailTypeId, parameters, send_to)
    @email_body = generate_email_body(emailTypeId, parameters[:body], Task.new)
    mail(to: send_to, subject: parameters[:subject])
  end

  private

  def generate_email_body(type_id, body, mailerObj)
    replacements = generate_email_constants(type_id, mailerObj)
    replacements.each {|replacement| body.gsub!(replacement[0], replacement[1])}
    return body
  end

  def generate_email_constants(emailTypeId, mailerObj)
    if mailerObj.new_record?
      return [ ["_NAME_", "Test User"], ["_TASK_LINK_", 'http://192.241.247.185/tasks'], ["_ASSIGNER_", "TestAssigener"] ]
    else
      case emailTypeId
        when 1
          [ ["_NAME_", mailerObj.assignee.full_name], ["_TASK_LINK_", tasks_url], ["_ASSIGNER_", mailerObj.user.full_name] ]
        when 2
          [ ["_NAME_", mailerObj.assignee.full_name], ["_TASK_LINK_", tasks_url], ["_ASSIGNER_", mailerObj.user.full_name] ]
        when 3
          [ ["_NAME_", mailerObj.assignee.full_name], ["_TASK_LINK_", tasks_url], ["_ASSIGNER_", mailerObj.user.full_name] ]
        when 4
          [ ["_NAME_", mailerObj.assignee.full_name], ["_TASK_LINK_", tasks_url], ["_ASSIGNER_", mailerObj.user.full_name] ]
        when 5..7 # New Task Creation, New Task Assigned, New Tasks Re-Assigned
          [ ["_NAME_", mailerObj.assignee.full_name], ["_TASK_LINK_", tasks_url], ["_ASSIGNER_", mailerObj.user.full_name] ]
        else
          [ ["_NAME_", "Test User"], ["_TASK_LINK_", 'http://192.241.247.185/tasks'], ["_ASSIGNER_", "TestAssigener"] ]
      end
    end
  end

end
