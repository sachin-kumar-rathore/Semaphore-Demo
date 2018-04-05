class TransactionMailer < ApplicationMailer

  def send_email(emailTypeId, mailerObj, opts={})
    transaction_email = TransactionalEmail.find_by_type_id(emailTypeId)
    @email_body = generate_email_body(emailTypeId, transaction_email.body, mailerObj, opts)
    attachments.inline['logo.png'] = File.read("#{Rails.root}/app/assets/images/updatedLogo.png")
    mail(to: email_address(mailerObj), subject: transaction_email.subject)
  end

  def send_test_email(emailTypeId, parameters, send_to)
    @email_body = generate_email_body(emailTypeId, parameters[:body], Task.new)
    attachments.inline['logo.png'] = File.read("#{Rails.root}/app/assets/images/updatedLogo.png")
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
      return [ ["_NAME_", "Test User"], ["_LINK_", tasks_url], ["_ASSIGNER_", "TestAssigener"], ["_SIGN_IN_URL_", new_user_session_url] ]
    else
      case emailTypeId
        when 1
          [ ["_NAME_", mailerObj.name], ["_ORG_URL_", mailerObj.url], ["_EMAIL_", mailerObj.primary_contact_email] ]
        when 2, 10
          [ ["_NAME_", mailerObj.full_name], ["_EMAIL_", mailerObj.email], ["_SIGN_IN_URL_", new_user_session_url], ["_ORG_", mailerObj.organization.name] ]
        
        when 3
          reset_password_constants(mailerObj, opts)
        
        when 4
          password_confirmation_constants(mailerObj)
        
        when 5..7 # New Task Creation, New Task Assigned, New Tasks Re-Assigned 
          [ ["_NAME_", mailerObj.assignee.full_name], ["_LINK_", tasks_url], ["_ASSIGNER_", mailerObj.user.full_name] ]
        
        when 8
          [ ["_NAME_", mailerObj.full_name], ["_SIGN_IN_URL_", new_user_session_url.to_s], ["_LINK_",  accept_user_invitation_url(invitation_token: opts['token'])] ]
        
        when 9, 11, 12, 13
          new_user = mailerObj.organization.users.find_by_id(opts['new_user_id'])
          [ ["_NAME_", mailerObj.full_name], ["_SIGN_IN_URL_", new_user_session_url], ["_EMAIL_", mailerObj.email], ["_USERNAME_", new_user.try(:full_name)], ["_USEREMAIL_", new_user.try(:email)] ]
        
        else
          [ ["_NAME_", "Test User"], ["_LINK_", tasks_url], ["_ASSIGNER_", "TestAssigener"] ]
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

  def reset_password_constants(mailerObj, opts)
    if mailerObj.class.to_s == 'Admin'
      user_name = mailerObj.email
      password_accept_link = edit_admin_password_url(reset_password_token: opts['token'])
    else
      user_name = mailerObj.full_name
      password_accept_link = edit_user_password_url(reset_password_token: opts['token'])
    end 
   
    [ ["_NAME_", user_name], ["_LINK_",  password_accept_link] ]
  end

  def password_confirmation_constants(mailerObj)
    user_name = mailerObj.class.to_s == 'User' ? mailerObj.full_name : mailerObj.email
    sign_in_link = mailerObj.class.to_s == 'User' ? new_user_session_url : new_admin_session_url
    
    [ ["_NAME_", user_name], ["_SIGN_IN_URL_", sign_in_link] ]
  end
end
