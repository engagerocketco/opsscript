require "pivotal_changelog"
require "minitest/autorun"

class ChangelogTest < Minitest::Test
  class ProjectMock
    def stories(*)
      []
    end
  end

  class TrackerClientMock
    def initialize(*); end

    def project(id)
      ProjectMock.new
    end
  end

  def setup
    @klass = Changelog
  end

  def test_initialize_without_params
    changelog = Changelog.new(ptclient_klass: TrackerClientMock)
    assert_instance_of(Changelog, changelog)
  end

  def test_initializer_with_params
    changelog = Changelog.new(ptclient_klass: TrackerClientMock, token: "abc", project_id: 123)
    assert_instance_of(Changelog, changelog)
  end
end
