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

  def test_initialize
    @changelog = Changelog.new(ptclient_klass: TrackerClientMock)
    @changelog.call
  end
end
