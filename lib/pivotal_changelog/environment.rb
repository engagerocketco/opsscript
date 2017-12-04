class Environment
  def self.root
    File.expand_path(File.join(__dir__, "..", ".."))
  end
end
