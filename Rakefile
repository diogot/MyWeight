require 'fileutils'

BASE_PATH = File.expand_path('.', File.dirname(__FILE__))
APP_NAME = 'MyWeight'
ARTIFACTS_DEFAULT_PATH = "#{BASE_PATH}/build"
TEST_REPORTS_DEFAULT_PATH = "#{BASE_PATH}/reports"
WORKSPACE_PATH = "#{BASE_PATH}/#{APP_NAME}.xcworkspace"
TEST_SCHEME = 'MyWeight'
ARCHIVE_SCHEME = 'MyWeight'

task :default => [ :help ]
task :help do
  sh 'rake -T'
end

at_exit do
  puts '           ¯\_(ツ)_/¯' unless $!.nil? || $!.is_a?(SystemExit) && $!.success?
end
