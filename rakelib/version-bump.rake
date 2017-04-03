
# -- Project version management

desc 'Bump build number'
task :bump_build do
  sh 'agvtool next-version -all'
end

task :has_current_version do
  sh 'agvtool mvers -terse1'
end

def current_version
  version = `agvtool mvers -terse1`.strip!
  build = `agvtool vers -terse`.strip!
  "v#{version}-#{build}"
end
