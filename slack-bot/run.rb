require "slack-ruby-bot"
require_relative "../lib/pivotal_changelog"

class OpsBot < SlackRubyBot::Bot
  command "ping" do |client, data, match|
    client.say(text: "pong", channel: data.channel)
  end

  command "release-note" do |client, data, match|
    text = "Request to send release note by <@#{data.user}>"
    client.say(text: text, channel: data.channel)

    config_file = "/home/.pivotalconfig.yaml"
    builder = Builder.new(config_file)

    changelog = builder.changelog
    mail_server = builder.mail_server
    template = builder.template

    mail_server.send!(
      message_content: template.render(changelog.get_binding),
      subject: changelog.subject
    )

    client.say(text: "OK, Done! please check your email", channel: data.channel)
  end
end

OpsBot.run
