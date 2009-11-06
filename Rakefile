require 'rubygems'
require 'rake'

# Assume a typical dev checkout to fetch the current merb-core version
require File.expand_path('../../merb/merb-core/lib/merb-core/version', __FILE__)

# Load this library's version information
require File.expand_path('../lib/merb-auth/version', __FILE__)

begin

  require 'jeweler'

  Jeweler::Tasks.new do |gemspec|

    gemspec.version     = Merb::Auth::VERSION

    gemspec.name        = "merb-auth"
    gemspec.description = "Merb plugin that provides authentication support"
    gemspec.summary     = "The official authentication plugin for merb.  Setup for the default stack"

    gemspec.authors     = [ "Daniel Neighman" ]
    gemspec.email       = "has.sox@gmail.com"
    gemspec.homepage    = "http://merbivore.com/"

    # Needs to be listed explicitly because jeweler
    # otherwise thinks that everything inside the
    # merb-auth repo belongs to the merb-auth meta gem
    gemspec.files = [
      'LICENSE',
      'Rakefile',
      'README.textile',
      'TODO',
      'lib/merb-auth.rb',
      'lib/merb-auth/version.rb'
    ]

    # Runtime dependencies
    gemspec.add_dependency 'merb-core',                "~> #{Merb::VERSION}"
    gemspec.add_dependency 'merb-auth-core',           "~> #{Merb::VERSION}"
    gemspec.add_dependency 'merb-auth-more',           "~> #{Merb::VERSION}"
    gemspec.add_dependency 'merb-auth-slice-password', "~> #{Merb::VERSION}"

  end

  Jeweler::GemcutterTasks.new

rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'spec/rake/spectask'
Spec::Rake::SpecTask.new(:spec) do |spec|
  spec.spec_opts << '--options' << 'spec/spec.opts' if File.exists?('spec/spec.opts')
  spec.libs << 'lib' << 'spec'
  spec.spec_files = FileList['spec/**/*_spec.rb']
end

Spec::Rake::SpecTask.new(:rcov) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
end


def gem_command(command)
  sh "#{RUBY} -S #{(ENV['JEWELER_INSTALL_COMMAND'] || 'gem')} #{command}"
end

def rake_command(command)
  sh "#{RUBY} -S rake #{command}"
end


merb_auth_gems = [
  'merb-auth-core',
  'merb-auth-more',
  'merb-auth-slice-password',
  'merb-auth'
]

# FIXME
# Clear out jeweler generated install task
# We want to install all merb-auth gems

desc "Install all merb stack gems"
task :install => [] do
  merb_auth_gems.each do |gem_name|
    Dir.chdir(gem_name) { rake_command "install" }
  end
end

desc "Uninstall all merb stack gems"
task :uninstall do
  merb_auth_gems.each do |gem_name|
    gem_command "uninstall #{gem_name} --version=#{Merb::VERSION}"
  end
end

desc "Build all merb stack gems"
task :build do
  merb_auth_gems.each do |gem_name|
    Dir.chdir(gem_name) { rake_command "build" }
  end
end

desc "Generate gemspecs for all merb stack gems"
task :gemspec do
  merb_auth_gems[0..-2].each do |gem_name|
    Dir.chdir(gem_name) { rake_command "gemspec" }
  end
end

desc "Run specs for all merb stack gems"
task :spec do
  # Omit the merb-auth metagem, no specs there
  merb_auth_gems[0..-2].each do |gem_name|
    Dir.chdir(gem_name) { rake_command "spec" }
  end
end

task :default => 'spec'
