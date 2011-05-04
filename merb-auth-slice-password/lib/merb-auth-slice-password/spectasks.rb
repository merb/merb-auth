require "rspec/core/rake_task"
namespace :slices do
  namespace :"merb-auth-slice-password" do

    desc "Run slice specs within the host application context"
    task :spec => [ "spec:explain", "spec:default" ]

    namespace :spec do

      slice_root = File.expand_path(File.join(File.dirname(__FILE__), '..', '..'))

      task :explain do
        puts "\nNote: By running MerbAuthSlicePassword specs inside the application context any\n" +
             "overrides could break existing specs. This isn't always a problem,\n" +
             "especially in the case of views. Use these spec tasks to check how\n" +
             "well your application conforms to the original slice implementation."
      end

      RSpec::Core::RakeTask.new('default') do |t|
        t.pattern = "#{slice_root}/spec/**/*_spec.rb"
      end

      desc "Run all model specs, run a spec for a specific Model with MODEL=MyModel"
      RSpec::Core::RakeTask.new('model') do |t|
        if(ENV['MODEL'])
          t.pattern = "#{slice_root}/spec/models/**/#{ENV['MODEL']}_spec.rb"
        else
          t.pattern = "#{slice_root}/spec/models/**/*_spec.rb"
        end
      end

      desc "Run all controller specs, run a spec for a specific Controller with CONTROLLER=MyController"
      RSpec::Core::RakeTask.new('controller') do |t|
        if(ENV['CONTROLLER'])
          t.pattern = "#{slice_root}/spec/controllers/**/#{ENV['CONTROLLER']}_spec.rb"
        else
          t.pattern = "#{slice_root}/spec/controllers/**/*_spec.rb"
        end
      end

      desc "Run all view specs, run specs for a specific controller (and view) with CONTROLLER=MyController (VIEW=MyView)"
      RSpec::Core::RakeTask.new('view') do |t|
        if(ENV['CONTROLLER'] and ENV['VIEW'])
          t.pattern = "#{slice_root}/spec/views/**/#{ENV['CONTROLLER']}/#{ENV['VIEW']}*_spec.rb"
        elsif(ENV['CONTROLLER'])
          t.pattern = "#{slice_root}/spec/views/**/#{ENV['CONTROLLER']}/*_spec.rb"
        else
          t.pattern = "#{slice_root}/spec/views/**/*_spec.rb"
        end
      end

      desc "Run all specs"
      RSpec::Core::RakeTask.new('all') do |t|
        t.pattern = "#{slice_root}/spec/**/*_spec.rb"
      end

    end

  end
end
