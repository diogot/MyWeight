# frozen_string_literal: true

begin
  require 'plist'
rescue LoadError
  puts 'plist not installed yet!'
end

def test_archive_config
  CONFIG['test_archive']
end

# -- danger

desc 'Run danger'
task :danger do
  sh 'bundle exec danger'
end

# -- Tests

desc 'Run unit tests'
task :unit_tests do
  config = test_archive_config['unit_tests']
  xcode scheme: config['scheme'],
        actions: 'clean analyze test',
        destination: config['destination'],
        report_name: 'unit-tests'
end

task :clean_artifacts do
  sh "rm -rf '#{default_artifacts_path}' '#{default_reports_path}'"
end

task :generate_xcode_summary, [:output_path] do |_t, args|
  build_file = args[:output_path]
  sh "cat #{xcode_log_file(report_name: 'unit-tests')} | XCPRETTY_JSON_FILE_OUTPUT=#{build_file} xcpretty -f `xcpretty-json-formatter`"
end

def default_artifacts_path
  artifacts_path = ENV['ARTIFACTS_PATH'] || path(test_archive_config['build_path'])
  File.expand_path artifacts_path
  FileUtils.mkdir_p artifacts_path

  artifacts_path
end

def default_reports_path
  reports_path = ENV['TEST_REPORTS_PATH'] || path(test_archive_config['reports_path'])
  File.expand_path reports_path
  FileUtils.mkdir_p reports_path

  reports_path
end

def xcode_log_file(report_name: '', artifacts_path: default_artifacts_path)
  "#{artifacts_path}/xcode-#{report_name}.log"
end

# -- Release

desc 'Release'
task :release, [:env] => %i[archive generate_ipa]

task :archive, [:env] do |_t, args|
  env = args[:env].to_s
  config = test_archive_config['release'][env]
  xcode(scheme: config['scheme'],
        actions: 'clean archive',
        destination: 'generic/platform=iOS',
        configuration: config['configuration'],
        report_name: "archive-#{env}",
        archive_path: archive_path(config['output']))
end

task :generate_ipa, [:env] do |_t, args|
  env = args[:env].to_s
  config = test_archive_config['release'][env]
  export_ipa(archive_path: archive_path(config['output']),
             export_path: export_path(config['output']),
             build_plist: create_export_plist,
             report_name: "export-#{env}")
end

# task :upload do
#   sh "bundle exec pilot upload --verbose --skip_waiting_for_build_processing true --skip_submission true --wait_processing_interval 1 -i '#{ipa_file_path}' -a '#{bundle_id}'"
# end

def archive_path(filename, path: default_artifacts_path)
  "#{path}/#{filename}.xcarchive"
end

def export_path(filename, path: default_artifacts_path)
  "#{path}/#{filename}-ipa"
end

# def ipa_file_path(path: export_path)
#   files = Dir[File.join(path, '*.ipa')]
#   raise "No IPA found in #{export_path}" if files.to_s.strip.empty?
#   files.last
# end

# -- build

def xcode(scheme: '',
          actions: '',
          destination: '',
          configuration: '',
          report_name: '',
          archive_path: '',
          reports_path: default_reports_path,
          artifacts_path: default_artifacts_path)
  xcode_log_file = xcode_log_file(report_name: report_name, artifacts_path: artifacts_path)
  report_file = "#{reports_path}/#{report_name}.xml"

  xcode_configuration = "-configuration '#{configuration}'" unless configuration.to_s.strip.empty?
  other_options = 'CODE_SIGNING_REQUIRED=NO CODE_SIGN_IDENTITY= PROVISIONING_PROFILE=' unless actions.include? 'archive'
  archive_options = archive_path.to_s.strip.empty? ? '-enableCodeCoverage YES' : "-archivePath '#{archive_path}'"

  project = if WORKSPACE_PATH.nil?
              "-project #{PROJECT_PATH}"
            else
              "-workspace '#{WORKSPACE_PATH}'"
            end

  sh "rm -f '#{xcode_log_file}' '#{report_file}'"
  sh "set -o pipefail && xcodebuild #{other_options} #{xcode_configuration} -destination '#{destination}' #{project} -scheme '#{scheme}' #{archive_options} #{actions} | tee '#{xcode_log_file}' | xcpretty --color --no-utf -r junit -o '#{report_file}'"
end

def export_ipa(archive_path: '',
               export_path: '',
               build_plist: '',
               report_name: '',
               reports_path: default_reports_path,
               artifacts_path: default_artifacts_path)
  xcode_log_file = "#{artifacts_path}/xcode-#{report_name}.log"
  report_file = "#{reports_path}/#{report_name}.xml"

  sh "set -o pipefail && xcodebuild -exportArchive -archivePath '#{archive_path}' -exportPath '#{export_path}' -exportOptionsPlist '#{build_plist}' | tee '#{xcode_log_file}' | xcpretty --color --no-utf -r junit -o '#{report_file}'"
end

def create_export_plist(plist_directory: default_artifacts_path)
  plist = { method: 'app-store' }
  plist_path = "#{plist_directory}/export.plist"
  plist.save_plist plist_path
  plist_path
end
