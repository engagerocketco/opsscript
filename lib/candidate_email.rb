require_relative "./pivotal_changelog"

# FIXME: Need to remodelize the project to remove duplicated code

class CandidateEmail
  def initialize(subject:, to_emails:, content:, config_file:)
    @subject = subject
    @content = content
    @to_emails = to_emails
    @config_file = config_file
  end

  attr_reader :subject, :to_emails, :content, :config_file

  def send!
    builder = Builder.new(config_file)

    config = builder.config

    mail_server = GmailMailServer.new(
      subject: subject,
      from_email: config.from_email,
      from_name: config.from_name,
      send_mail_passw: config.send_email_passwd,
      to_emails: to_emails
    )

    mail_server.send!(message_content: content)
  end
end
