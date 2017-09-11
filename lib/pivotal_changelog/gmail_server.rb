require 'net/smtp'
require 'time'

class GmailMailServer
  def initialize(options = {})
    @subject = options[:subject] || "Default Subject"
    @from_email = options[:from_email]
    @send_mail_passw = options[:send_mail_passw]
    @to_emails = options[:to_emails] || []
  end

  def msgstr_compiled(message_content)
    msgstr_compiled = msgstr % {
      from_email: @from_email,
      subject: @subject,
      to_emails: @to_emails.join(","),
      message_content: message_content
    }
  end

  def send!(options = {})
    message_content = options[:message_content]
    smtp_server = options[:smtp_server] || 'smtp.gmail.com'
    smtp_port = options[:smtp_port] || 587
    domain = options[:domain] || "gmail.com"

    smtp = Net::SMTP.new smtp_server, smtp_port
    smtp.enable_starttls

    smtp.start(domain, @from_email, @send_mail_passw, :login) do
      smtp.send_message msgstr_compiled(message_content),
        @from_email, *@to_emails
    end
  end

  def msgstr
    msgstr = <<~END_OF_MESSAGE
      From: Your Name <%<from_email>s>
      To: <%<to_emails>s>
      Subject: %<subject>s
      MIME-Version: 1.0
      %<message_content>s
    END_OF_MESSAGE
  end

end
