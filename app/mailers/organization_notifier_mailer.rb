class OrganizationNotifierMailer < ApplicationMailer
  default :from => 'vipin@newput.com'

  def thank_you_email(user)
    mail(:to => user.email, :subject => 'Thank you for contacting Onacc')
  end

  def activate_user(user)
    @user = user
    mail(:to => 'satya@newput.com', :subject => 'Request to Activate Plan')
  end

  def plan_activated(user, password)
    @user = user
    @password = password
    mail(:to => user.email, :subject => 'Your Onacc a/c is active now!')
  end

  def forgot_password(user, password)
    @password = password
    mail(:to => user.email, :subject => 'Reset your Onacc acount password')
  end
end
