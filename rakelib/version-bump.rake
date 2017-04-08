
# -- Project version management

desc 'Bump build number'
task :bump_build do
  sh "cd #{File.dirname(PROJECT_PATH)} && agvtool next-version -all"
end

desc 'Bump patch version'
task :bump_patch => [ :has_current_version, :bump_build ] do
  new_version = bump( version: current_version, option: :patch )
  set_new_version new_version
end

desc 'Bump minor version'
task :bump_patch => [ :has_current_version, :bump_build ] do
  new_version = bump( version: current_version, option: :minor )
  set_new_version new_version
end

desc 'Bump major version'
task :bump_patch => [ :has_current_version, :bump_build ] do
  new_version = bump( version: current_version, option: :major )
  set_new_version new_version
end

task :has_current_version do
  sh current_version_command
end

task :set_version, [ :version ] do |t, args|
  set_new_version args[:version]
end

def set_new_version( version )
  sh "cd #{File.dirname(PROJECT_PATH)} && agvtool new-marketing-version #{version.to_s.strip}"
end

def bump( version: '',
          option: '' )
  version = version.split('.').map(&:to_i)
  case option
    when :patch
      version[2] = increase_number version[2]
    when :minor
      version.delete_at(2)
      version[1] = increase_number version[1]
    when :major
      version.delete_at(2)
      version[1] = 0
      version[0] = increase_number version[0]
   end
  version.join('.')
end

def increase_number( option )
  option.nil? ? 1 : option + 1
end

def full_version
  "#{current_version}-#{current_build}"
end

def current_version
  `#{current_version_command}`.strip!
end

def current_build
  `#{current_build_command}`.strip!
end

def current_version_command
  "cd #{File.dirname(PROJECT_PATH)} && agvtool mvers -terse1"
end

def current_build_command
  "cd #{File.dirname(PROJECT_PATH)} && agvtool vers -terse"
end
