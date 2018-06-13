class OrganizationNotifierMailer < ApplicationMailer
  default :from => 'onacc.bookkeeping.com'

  admin_email = User.find_by(role: 'admin').email

  def thank_you_email(user)
    mail(:to => user.email, :subject => 'Thank you for contacting Onacc')
  end

  def activate_user(user)
    @user = user
    mail(:to => admin_email, :subject => 'Request to Activate Plan')
  end

  def plan_activated(user, password)
    @user = user
    @password = password
    mail(:to => user.email, :subject => 'Your Onacc a/c is active now!')
  end
end
