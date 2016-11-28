require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

task default: [:spec, :rubocop]

task :rubocop do
  sh 'rubocop'
end
