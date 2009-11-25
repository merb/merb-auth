# Assume a typical dev checkout to fetch the current merb-core version
require File.expand_path('../../merb/merb-core/lib/merb-core/version', __FILE__)

require 'fileutils'

merb_auth_gems = [
  'merb-auth-core',
  'merb-auth-more',
  'merb-auth-slice-password',
  'merb-auth'
]

def gem_command(command)
  sh "#{RUBY} -S gem #{command}"
end

def rake_command(command)
  sh "#{RUBY} -S rake #{command}"
end

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
