require 'rubygems'
require 'rubygems/package_task'

$:.push File.expand_path("../lib", __FILE__)
require "datadog_sync/version"

gemspec = eval(File.read("datadog-sync.gemspec"))
Gem::PackageTask.new(gemspec).define

require 'rdoc/task'
Rake::RDocTask.new do |rdoc|
  version = DatadogSync::VERSION

  rdoc.rdoc_dir = "rdoc"
  rdoc.title = "datadog-sync #{version}"
  rdoc.rdoc_files.include("README*")
  rdoc.rdoc_files.include("lib/**/*.rb")
end
