require "yaml"
require "ostruct"

class Builder
  def initialize(config_file = nil, config_options = {})
    @config = OpenStruct.new(load_config(config_file, config_options))
  end

  def load_config(config_file, config_options)
    if config_file
      YAML.load_file(config_file)
    else
      @config = default_config.merge(config_options)
    end
  end

  def template
    Template.new(@config.template_path)
  end

  def changelog
    Changelog.new(
      token: config.project_token,
      sprint_duration: config.sprint_duration
    )
  end

  def mail_server
    GmailMailServer.new(
      subject: config.subject,
      from_email: config.from_email,
      from_name: config.from_name,
      send_mail_passw: config.send_email_passwd,
      to_emails: config.to_emails
    )
  end

  def default_config
    {
      subject: "Hello from EngageRocket",
      from_email: "hello@engagerocket.co",
      send_email_passwd: nil,
      to_emails: [],
      project_token: nil,
      sprint_duration: 7
    }
  end

  def config
    raise IOError, "No config is found" unless @config
    @config
  end
end
