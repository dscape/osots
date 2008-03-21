class UserObserver < ActiveRecord::Observer
  def after_create(user)
    UserMailer.deliver_signup_notification(user)
  end

  def after_save(user)
    UserMailer.deliver_activation(user) if user.pending?
  end
  
  def after_update(user)
    UserMailer.deliver_forgot_password(user) unless user.password_reset_code.nil?
  end
end