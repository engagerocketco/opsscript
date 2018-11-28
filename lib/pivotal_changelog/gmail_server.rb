require "net/smtp"
require "mail"

class GmailMailServer
  def initialize(options = {})
    @subject = options[:subject] || "Default Subject"
    @from_name = options[:from_name] || "Default Name"
    @from_email = options[:from_email]
    @send_mail_passw = options[:send_mail_passw]
    @to_emails = options[:to_emails] || []
  end

  def send!(options = {})
    message_content = options[:message_content]
    subject = options[:subject] || @subject

    smtp_server = options[:smtp_server] || "smtp.gmail.com"
    smtp_port = options[:smtp_port] || 587
    domain = options[:domain] || "gmail.com"

    smtp = Net::SMTP.new smtp_server, smtp_port
    smtp.enable_starttls

    smtp.start(domain, @from_email, @send_mail_passw, :login)

    Mail.defaults do
      delivery_method :smtp_connection, { connection: smtp }
    end

    mail = Mail.new
    mail["from"] = "#{from_name} <#{from_email}>"
    mail["to"] = to_emails.join(",")
    mail["subject"] = subject
    mail.charset = "UTF-8"
    mail.content_transfer_encoding = "8bit"

    mail.html_part do
      content_type "text/html; charset=UTF-8"
      body message_content
    end

    mail.deliver!

    smtp.finish
  end

  attr_reader :from_name, :from_email, :to_emails, :subject
end
