require 'rubygems'
require 'rubygems/package_task'

gemspec = eval(File.read("datadog-sync.gemspec"))
Gem::PackageTask.new(gemspec).define

require 'rdoc/task'
Rake::RDocTask.new do |rdoc|
  version = File.exist?("VERSION") ? File.read("VERSION") : ""

  rdoc.rdoc_dir = "rdoc"
  rdoc.title = "datadog-sync #{version}"
  rdoc.rdoc_files.include("README*")
  rdoc.rdoc_files.include("lib/**/*.rb")
end
