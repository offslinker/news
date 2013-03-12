require 'mail'
require 'erb'
require_relative 'app_config'

Mail.defaults do
  delivery_method :smtp, { 
    address: 'smtp.gmail.com',
    port: '587',
    user_name: AppConfig.instance.config['gmail_user_name'],
    password: AppConfig.instance.config['gmail_password'],
    authentication: :plain,
    enable_starttls_auto: true
  }
end

class MailSender
  def self.send_error_mail
    Mail.new do
      from AppConfig.instance.config['sender']
      to   AppConfig.instance.config['recipient']
      subject 'Error occurred'
      body    'Error happenned on loading stories from HackerNews. Try again later'
    end.deliver
  end

  def self.send_success_mail(binding)
    Mail.new do
      from AppConfig.instance.config['sender']
      to   AppConfig.instance.config['recipient']
      subject 'List of stories'
      body    ERB.new(File.read(File.join(File.dirname(__FILE__),'template'))).result(binding)
    end.deliver
  end
end
