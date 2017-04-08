# frozen_string_literal: true

require 'fileutils'

BASE_PATH = File.expand_path('.', File.dirname(__FILE__))
ARTIFACTS_PATH = ENV['ARTIFACTS_PATH'] || "#{BASE_PATH}/build"
TEST_REPORTS_PATH = ENV['TEST_REPORTS_PATH'] || "#{BASE_PATH}/reports"
BUNDLER_PATH = ENV['BUNDLER_PATH']
APP_NAME = 'MyWeight'
WORKSPACE_PATH = "#{BASE_PATH}/#{APP_NAME}.xcworkspace"
PROJECT_PATH = "#{BASE_PATH}/#{APP_NAME}.xcodeproj"
TEST_SCHEME = 'MyWeight'
ARCHIVE_SCHEME = 'MyWeight'

task default: [:help]
task :help do
  sh 'rake -T'
end

at_exit do
  puts '           ¯\_(ツ)_/¯' unless $!.nil? || $!.is_a?(SystemExit) && $!.success?
end
