# frozen_string_literal: true

require 'fileutils'
require 'yaml'

def path(file)
  path = File.expand_path(file, File.dirname(__FILE__))
  raise "File '#{path}' not found" unless File.exist? path
  path
end

CONFIG = YAML.load_file path 'rake-config.yml'
# puts CONFIG

BASE_PATH = path '.'

APP_NAME = CONFIG['app_name']
WORKSPACE_PATH = path CONFIG['workspace_path']
PROJECT_PATH = path CONFIG['project_path']

task default: [:help]
task :help do
  sh 'rake -T'
end

at_exit do
  puts '           ¯\_(ツ)_/¯' unless $!.nil? || $!.is_a?(SystemExit) && $!.success?
end
