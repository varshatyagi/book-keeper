class OrganizationNotifierMailer < ApplicationMailer
  default :from => 'onacc.bookkeeping.com'

  admin_email = User.find_by(role: 'admin').email

  def send_thank_you_email(user)
    mail( :to => user.email, :subject => 'Thank you for signing up' )
  end

  def activate_user
    mail( :to => 'varsha@newput.com', :subject => 'Activate User' )
  end

  def plan_activated(user)
    @temporary_password = Common.generate_string
    mail( :to => user.email, :subject => 'Account has been activated' )

  end
end
