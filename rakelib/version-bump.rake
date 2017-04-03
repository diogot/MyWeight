
# -- Version bump

desc 'Bump build number'
task :bump_build do
  sh 'agvtool next-version -all'
end

def current_version
  version = `agvtool mvers -terse1`.strip!
  build = `agvtool vers -terse`.strip!
  "v#{version}-#{build}"
end
