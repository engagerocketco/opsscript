require "tracker_api"
require "date"

class Changelog
  attr_reader :token, :project_id

  def initialize(options = {})
    @token = options[:token] || nil

    @sprint_duration = options[:sprint_duration] || 7
    @ptclient_klass = options[:ptclient_klass] || TrackerApi::Client
  end

  def subject
    @subject = format("Release Note - %<date>s", date: Date.today.to_s)
  end

  def items(project)
    @items ||= delivered_stories(project).select { |st| st.story_type != "release" }.group_by { |st| st.story_type }
  end

  def get_binding
    items
    subject
    binding
  end

  def delivered_stories(project)
    project.stories(with_state: :accepted, accepted_after: accept_after_monday) +
    project.stories(with_state: :delivered)
  end

  def accept_after_monday
    today = Date.today

    monday = today - (today.wday - 1) % 7
    (monday - (@sprint_duration - 7)) .to_time.iso8601
  end

  def client
    @client ||= @ptclient_klass.new(token: token)
  end

  def projects
    @project ||= client.projects
  end
end
