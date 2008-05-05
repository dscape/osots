# Email settings
 ActionMailer::Base.delivery_method = :smtp
 ActionMailer::Base.smtp_settings = {
   :address => "smtp.gmail.com",
   :port => 25,
   :domain => "yourapplication.com",
   :authentication => :login,
   :user_name => "db2minho",
   :password => "sho=nupe"  
# }
