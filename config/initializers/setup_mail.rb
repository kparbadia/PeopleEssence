EMAIL_RECIEVER_DEV_ENV = "kishor@nascenia.com"

class DevelopmentMailInterceptor
  def self.delivering_email(message)
    message.subject = "#{message.to} #{message.subject}"
    message.to = EMAIL_RECIEVER_DEV_ENV
  end
end

ActionMailer::Base.smtp_settings = {
  :address => "smtp.gmail.com",
  :port => 587,
  :domain => "gmail.com",
  :authentication => :plain,
  :user_name => "xxx@gmail.com",
  :password => "xxx"
}

if Rails.env.development?
  puts "All mails in dev mode will be delivered to #{EMAIL_RECIEVER_DEV_ENV}, can be changed in 'config/initializers/mail_setup.rb' "
  ActionMailer::Base.register_interceptor(DevelopmentMailInterceptor)
end