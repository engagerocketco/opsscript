require "slack-ruby-bot"
require_relative "../lib/pivotal_changelog"

class OpsBot < SlackRubyBot::Bot
  command "hi" do |client, data, match|
    client.say(text: "Arf", channel: data.channel)
  end

  command "release-note" do |client, data, match|
    text = "Bork! <@#{data.user}>"
    client.say(text: text, channel: data.channel)

    config_file = "/home/.pivotalconfig.yaml"
    builder = Builder.new(config_file)

    changelog = builder.changelog
    mail_server = builder.mail_server
    template = builder.template

    mail_server.send!(
      message_content: template.render(changelog),
      subject: changelog.subject
    )

    client.say(text: "Woof! Woof!", channel: data.channel)
  end
end

OpsBot.run
