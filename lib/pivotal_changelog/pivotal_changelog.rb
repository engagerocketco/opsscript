require "tracker_api"
require "date"

class PivotalChangelog
  STORY_URL = "https://www.pivotaltracker.com/story/show/"
  OUTPUT_FMT = "\s-\s%<name>s\s(%<story_url>s%<id>s)\n"
  STORY_TYPE_FMT = "%<type>s\n"

  NOT_INCLUDED_STORIES_TYPE = [ :release ]

  attr_reader :token, :project_id

  def initialize(options = {})
    @token = options[:token] || nil
    @project_id = options[:project_id]

    @sprint_duration = options[:sprint_duration] || 7
    @release_dow = options[:release_dow] || 5

    @ptclient_klass = options[:ptclient_klass] || TrackerApi::Client
  end

  def call
    result = ""

    delivered_stories.group_by { |st| st.story_type }.each do |story_type, stories|
      result << STORY_TYPE_FMT % { type: story_type.upcase }
      result << stories_output(stories)
    end

    result
  end

  def stories_output(stories)
    stories.inject("") do |result, st|
      result << OUTPUT_FMT % { name: st.name, id: st.id, story_url: STORY_URL }
    end
  end

  def delivered_stories
    (project.stories(with_state: :accepted, accepted_after: accept_after_monday) +
    project.stories(with_state: :delivered))
  end

  # TODO: Fix the window time
  def accept_after_monday
    today = Date.today

    monday = today - (today.wday - 1) % 7
    monday.to_time.iso8601
  end

  def client
    @client ||= @ptclient_klass.new(token: token)
  end

  def project
    @project ||= client.project(project_id)
  end
end
