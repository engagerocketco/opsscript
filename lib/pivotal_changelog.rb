require "tracker_api"

class PivotalChangelog
  OUTPUT_FMT = "  - %<name>s (https://www.pivotaltracker.com/story/show/%<id>s)\n"
  STORY_TYPE_FMT = "**%<type>s**\n"

  attr_reader :token, :project_id

  def initialize(token, project_id)
    @token = token
    @project_id = project_id
  end

  def call
    delivered_stories.each do |story_type, stories|
      ioprint(story_type, stories)
    end
  end

  private

  def client
    @client ||= TrackerApi::Client.new(token: token)
  end

  def project
    @project ||= client.project(project_id)
  end

  def ioprint(story_type, stories)
    printf STORY_TYPE_FMT % { type: story_type }

    stories.each do |st|
      printf OUTPUT_FMT % { name: st.name, id: st.id }
    end
  end

  def delivered_stories
    project.stories(with_state: :delivered).group_by { |st| st.story_type }
  end
end
