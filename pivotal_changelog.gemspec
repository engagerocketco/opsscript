Gem::Specification.new do |s|
  s.name        = 'pivotal_changelog'
  s.version     = '0.0.5'
  s.licenses    = ['MIT']
  s.summary     = ""
  s.description = ""
  s.authors     = ["DuyKhoa"]
  s.email       = 'duykhoa12t@gmail.com'
  s.files       = ["lib/pivotal_changelog.rb"]
  s.homepage    = ''
  s.bindir      = 'bin'
  s.require_path = 'lib'
  s.executables << 'pivotal_changelog'

  s.add_development_dependency 'minitest'
  s.add_development_dependency 'tracker_api'
end
