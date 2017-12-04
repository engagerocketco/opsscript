
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

  def template_path
    File.join(Environment.root, @template_path)
  end

  def default_template_path
    File.join(Environment.root, "templates/index.html.erb")
  end
end
