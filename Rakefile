require 'rubygems'
require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'
require 'spec/rake/spectask'
require 'rake/gempackagetask'
require 'rubygems/specification'
require 'date'

PLUGIN = "rorem"
NAME = "rorem"
GEM_VERSION = "0.1"
AUTHOR = "Jonas Nicklas"
EMAIL = "jonas.nicklas@gmail.com"
HOMEPAGE = "http://rorem.rubyforge.org"
SUMMARY = "Random Data Generator"

spec = Gem::Specification.new do |s|
  s.name = NAME
  s.version = GEM_VERSION
  s.platform = Gem::Platform::RUBY
  s.has_rdoc = true
  s.extra_rdoc_files = ["README", "LICENSE", 'TODO']
  s.summary = SUMMARY
  s.description = s.summary
  s.author = AUTHOR
  s.email = EMAIL
  s.homepage = HOMEPAGE
  s.require_path = 'lib'
  s.autorequire = PLUGIN
  s.files = %w(LICENSE README Rakefile TODO) + Dir.glob("{lib,spec,assets,tasks}/**/*")
end

Rake::GemPackageTask.new(spec) do |pkg|
  pkg.gem_spec = spec
end

desc "install the plugin locally"
task :install => [:package] do
  sh %{sudo gem install pkg/#{NAME}-#{VERSION} --no-update-sources}
end

desc "create a gemspec file"
task :make_spec do
  File.open("#{GEM}.gemspec", "w") do |file|
    file.puts spec.to_ruby
  end
end

namespace :jruby do

  desc "Run :package and install the resulting .gem with jruby"
  task :install => :package do
    sh %{#{SUDO} jruby -S gem install pkg/#{NAME}-#{Merb::VERSION}.gem --no-rdoc --no-ri}
  end
  
end

file_list = FileList['spec/*_spec.rb']

desc "Run all examples"
Spec::Rake::SpecTask.new('spec') do |t|
  t.spec_files = file_list
end

namespace :spec do
  desc "Run all examples with RCov"
  Spec::Rake::SpecTask.new('rcov') do |t|
    t.spec_files = file_list
    t.rcov = true
    t.rcov_opts = ['--exclude', 'spec']
  end
  
  desc "Generate an html report"
  Spec::Rake::SpecTask.new('report') do |t|
    t.spec_files = file_list
    t.rcov = true
    t.rcov_opts = ['--exclude', 'spec']
    t.spec_opts = ["--format", "html:doc/specs.html"]
    t.fail_on_error = false
  end
  
  desc "Heckle"
  Spec::Rake::SpecTask.new('heckle') do |t|
    t.spec_files = file_list
    t.spec_opts = ["--heckle", "Rorem"]
  end

end

desc 'Default: run unit tests.'
task :default => 'spec'

namespace "doc" do
  
  desc 'Generate documentation for the Rorem plugin.'
  Rake::RDocTask.new(:normal) do |rdoc|
    rdoc.rdoc_dir = 'doc'
    rdoc.title    = 'Rorem Random Data Generator'
    rdoc.options << '--line-numbers' << '--inline-source'
    rdoc.rdoc_files.include('README')
    rdoc.rdoc_files.include('lib/**/*.rb')
  end
  
  desc 'Generate documentation for the Rorem plugin using the allison template.'
  Rake::RDocTask.new(:allison) do |rdoc|
    rdoc.rdoc_dir = 'rdoc'
    rdoc.title    = 'Rorem Random Data Generator'
    rdoc.options << '--line-numbers' << '--inline-source'
    rdoc.rdoc_files.include('README')
    rdoc.rdoc_files.include('lib/**/*.rb')
    rdoc.main = "README" # page to start on
    rdoc.template = "~/projects/allison/allison.rb"
  end
end