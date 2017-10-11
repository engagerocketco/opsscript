require 'net/smtp'
require 'time'

class GmailMailServer
  def initialize(options = {})
    @subject = options[:subject] || "Default Subject"
    @from_name = options[:from_name] || "Default Name"
    @from_email = options[:from_email]
    @send_mail_passw = options[:send_mail_passw]
    @to_emails = options[:to_emails] || []
  end

  def msgstr_compiled(message_content, subject)
    msgstr_compiled = msgstr % {
      from_email: @from_email,
      from_name: @from_name,
      subject: subject,
      to_emails: @to_emails.join(","),
      message_content: message_content
    }
  end

  def send!(options = {})
    message_content = options[:message_content]
    subject = options[:subject] || @subject
    smtp_server = options[:smtp_server] || 'smtp.gmail.com'
    smtp_port = options[:smtp_port] || 587
    domain = options[:domain] || "gmail.com"

    smtp = Net::SMTP.new smtp_server, smtp_port
    smtp.enable_starttls

    smtp.start(domain, @from_email, @send_mail_passw, :login) do
      smtp.send_message msgstr_compiled(message_content, subject),
        @from_email, *@to_emails
    end
  end

  def msgstr
    msgstr = <<~END_OF_MESSAGE
      From: %<from_name>s <%<from_email>s>
      To: <%<to_emails>s>
      Subject: %<subject>s
      Content-type: text/html
      MIME-Version: 1.0
      %<message_content>s
    END_OF_MESSAGE
  end
end
