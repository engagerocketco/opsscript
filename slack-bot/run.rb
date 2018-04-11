require "slack-ruby-bot"
require_relative "../lib/pivotal_changelog"
require_relative "../lib/candidate_email"

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
      message_content: template.render(changelog),
      subject: changelog.subject
    )

    client.say(text: "OK, Done! please check your email", channel: data.channel)
  end

  command "candidate" do |client, data, match|
    name, email = match["expression"].split

    class Candidate
      def initialize(name, email)
        @name = name
        @email = email
      end

      def get_binding
        binding
      end
    end

    # Slack convert email to <mailto...>
    email = email.match(/mailto:(.*\@.*)\|/)[1]

    candidate = Candidate.new(name, email)

    client.say(text: "I will send technical test to #{email}", channel: data.channel)

    config_file = "/home/.pivotalconfig.yaml"

    content = ERB.new(
      File.read(File.join(Environment.root, "templates/exercise.html.erb"))
    ).result(candidate.get_binding)

    CandidateEmail.new(
      config_file: config_file,
      subject: "Hello from EngageRocket!",
      content: content,
      to_emails: [ email ]
    ).send!

    client.say(text: "Done", channel: data.channel)
  end
end

OpsBot.run
