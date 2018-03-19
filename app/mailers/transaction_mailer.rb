class TransactionMailer < ApplicationMailer

  def send_email(emailTypeId, mailerObj, opts={})
    transaction_email = TransactionalEmail.find_by_type_id(emailTypeId)
    @email_body = generate_email_body(emailTypeId, transaction_email.body, mailerObj, opts)
    mail(to: email_address(mailerObj), subject: transaction_email.subject)
  end

  def send_test_email(emailTypeId, parameters, send_to)
    @email_body = generate_email_body(emailTypeId, parameters[:body], Task.new)
    mail(to: send_to, subject: parameters[:subject])
  end

  private

  def generate_email_body(type_id, body, mailerObj, opts={})
    replacements = generate_email_constants(type_id, mailerObj, opts)
    replacements.each {|replacement| body.gsub!(replacement[0], replacement[1])}
    return body
  end

  def generate_email_constants(emailTypeId, mailerObj, opts={})
    if mailerObj.new_record?
      return [ ["_NAME_", "Test User"], ["_LINK_", 'http://192.241.247.185/tasks'], ["_ASSIGNER_", "TestAssigener"], ["_SIGN_IN_URL_", new_user_session_url] ]
    else
      case emailTypeId
        when 1
          [ ["_NAME_", mailerObj.name], ["_ORG_URL_", mailerObj.url], ["_EMAIL_", mailerObj.primary_contact_email] ]
        when 2
          [ ["_NAME_", mailerObj.full_name], ["_EMAIL_", mailerObj.email], ["_SIGN_IN_URL_", new_user_session_url] ]
        
        when 3
          [ ["_NAME_", mailerObj.full_name], ["_LINK_",  edit_user_password_url(mailerObj, reset_password_token: opts['token'])] ]
        
        when 4
          [ ["_NAME_", mailerObj.full_name], ["_SIGN_IN_URL", new_user_session_url] ]
        
        when 5..7 # New Task Creation, New Task Assigned, New Tasks Re-Assigned 
          [ ["_NAME_", mailerObj.assignee.full_name], ["_LINK_", tasks_url], ["_ASSIGNER_", mailerObj.user.full_name] ]
        else
          [ ["_NAME_", "Test User"], ["_LINK_", 'http://192.241.247.185/tasks'], ["_ASSIGNER_", "TestAssigener"] ]
      end
    end
  end

  def email_address(mailerObj)
    case mailerObj.class.to_s.downcase.to_sym
    when :task 
      mailerObj.assignee.email
    when :organization
      mailerObj.primary_contact_email
    else
      mailerObj.email
    end
  end

end