$:.push File.expand_path("../lib", __FILE__)

require "datadog_sync/version"

Gem::Specification.new do |s|
  s.name = "datadog-sync"
  s.version = DatadogSync::VERSION
  s.platform = Gem::Platform::RUBY
  s.extra_rdoc_files = ["README.md", "LICENSE" ]
  s.summary = "Sync your DataDog."
  s.description = s.summary
  s.license = "MIT"
  s.author = "Ivan Larionov"
  s.email = "xeron.oskom@gmail.com"
  s.homepage = "http://github.com/xeron/datadog-sync"

  s.required_ruby_version = ">= 1.9.3"

  s.add_dependency "dogapi"
  s.add_dependency "json"

  s.bindir = "bin"
  s.executables = %w( dd-sync )

  s.require_path = "lib"
  s.files = %w(Rakefile LICENSE README.md) + Dir.glob("lib/**/*", File::FNM_DOTMATCH).reject { |f| File.directory?(f) }
end
