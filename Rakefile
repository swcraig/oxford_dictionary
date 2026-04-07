# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

task default: %i[spec rubocop]

task :rubocop do
  sh 'rubocop'
end
