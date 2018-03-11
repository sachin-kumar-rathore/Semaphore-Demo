class TransactionMailer < ApplicationMailer

  def send_email(emailTypeId, mailerObj)
    transaction_email = TransactionalEmail.find_by_type_id(emailTypeId)
    @email_body = generate_email_body(emailTypeId, transaction_email.body, mailerObj)
    mail(to: mailerObj.assignee.email, subject: transaction_email.subject)
  end

  def send_test_email(emailTypeId, sent_to)
    transaction_email = TransactionalEmail.find_by_type_id(emailTypeId)
    @email_body = generate_email_body(emailTypeId, transaction_email.body, Task.new)
    mail(to: sent_to, subject: transaction_email.subject)
  end

  def generate_email_body(type_id, body, mailerObj)
    replacements = generate_email_constants(type_id, mailerObj)
    replacements.each {|replacement| body.gsub!(replacement[0], replacement[1])}
    return body
  end

  def generate_email_constants(emailTypeId, mailerObj)
    if mailerObj.new_record?
      return [ ["<NAME>", "Test User"], ["<TASK_LINK>", 'http://192.241.247.185/tasks'], ["<ASSIGNER>", "TestAssigener"] ]
    else
      case emailTypeId
        when 1
          [ ["<NAME>", mailerObj.assignee.full_name], ["<TASK_LINK>", tasks_url], ["<ASSIGNER>", mailerObj.user.full_name] ]
        when 2
          [ ["<NAME>", mailerObj.assignee.full_name], ["<TASK_LINK>", tasks_url], ["<ASSIGNER>", mailerObj.user.full_name] ]
        when 3
          [ ["<NAME>", mailerObj.assignee.full_name], ["<TASK_LINK>", tasks_url], ["<ASSIGNER>", mailerObj.user.full_name] ]
        when 4
          [ ["<NAME>", mailerObj.assignee.full_name], ["<TASK_LINK>", tasks_url], ["<ASSIGNER>", mailerObj.user.full_name] ]
        when 5..7 # New Task Creation, New Task Assigned, New Tasks Re-Assigned
          [ ["<NAME>", mailerObj.assignee.full_name], ["<TASK_LINK>", tasks_url], ["<ASSIGNER>", mailerObj.user.full_name] ]
        else
          [ ["<NAME>", "Test User"], ["<TASK_LINK>", 'http://192.241.247.185/tasks'], ["<ASSIGNER>", "TestAssigener"] ]
      end
    end
  end

end
