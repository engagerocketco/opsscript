require "tilt"

class Template
  def initialize(template_path = nil)
    @template_path = template_path || default_template_path
  end

  def render(changelog)
    @subject = changelog.subject
    @projects = changelog.projects

    Tilt.new(@template_path).render(self, changelog: changelog)
  end

  def template_path
    File.join(Environment.root, @template_path)
  end

  def default_template_path
    File.join(Environment.root, "templates/changelog.html.haml")
  end
end
