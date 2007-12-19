require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'
require 'spec/rake/spectask'

file_list = FileList['spec/*_spec.rb']

desc "Run all examples with RCov"
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
task :default => 'spec:rcov'

desc 'Test the Rorem plugin.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end

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