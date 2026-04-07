# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec) do |task|
  task.exclude_pattern = 'spec/integration/**/*_spec.rb'
end
RSpec::Core::RakeTask.new(:integration) do |task|
  task.pattern = 'spec/integration/**/*_spec.rb'
end

task default: %i[spec rubocop]

task :rubocop do
  sh 'rubocop'
end
