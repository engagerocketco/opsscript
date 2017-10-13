require "pivotal_changelog"
require "minitest/autorun"
require "ostruct"

class TemplateTest < Minitest::Test
  class Binding
    class Story < OpenStruct; end

    def initialize
      @stories = [
        Story.new(name: "Story 1"),
        Story.new(name: "Story 2"),
      ]
    end

    def get_binding
      binding
    end
  end

  def setup
    @template = Template.new
    @view = @template.render(Binding.new.get_binding)
  end

  def test_template_output
    assert_match('Story 1', @view)
    assert_match('Story 2', @view)
  end
end
