require "erb"

class Template
  def initialize(template_path = nil)
    @template_path = template_path || default_template_path
  end

  def render(binding)
    ERB.new(load_template).result(binding)
  end

  def load_template
    File.read(@template_path)
  end

  def default_template_path
    File.expand_path File.join(__dir__, "..", "..", "templates", "changelog.html.erb")
  end
end
