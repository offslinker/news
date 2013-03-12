require 'mail'
require 'erb'

Mail.defaults do
  delivery_method :smtp, { 
    address: 'smtp.gmail.com',
    port: '587',
    user_name: ENV['GMAIL_SMTP_USER'],
    password: ENV['GMAIL_SMTP_PASSWORD'],
    authentication: :plain,
    enable_starttls_auto: true
  }
end

class MailSender
  def self.send_error_mail
    Mail.new do
      from 'offslinker@gmail.com'
      to   'alex.slynko@gmail.com'
      subject 'Error occurred'
      body    'Error happenned on loading stories from HackerNews. Try again later'
    end.deliver
  end

  def self.send_success_mail(binding)
    Mail.new do
      from 'offslinker@gmail.com'
      to   'alex.slynko@gmail.com'
      subject 'List of stories'
      body    ERB.new(File.read(File.join(File.dirname(__FILE__),'template'))).result(binding)
    end.deliver
  end
end
