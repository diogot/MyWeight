# -- project setup

desc 'Install/update and configure project'
task :setup => [ :setup_dependencies, :configure ]

task :setup_dependencies => [ :install_dependencies, :submodule_update ] do
  sh 'bundle install'
end

task :configure => [ :pod_repo_update, :pod_install, :clean_artifacts] do
  # sh 'bundle exec fastlane run clear_derived_data'
end

task :install_dependencies do
  # brew_update
  # brew_install 'carthage'
end

# desc 'Updated submodules'
task :submodule_update do
#   sh 'git submodule update --init --recursive'
end

# -- cocoapods

# desc 'Pod repo update'
task :pod_repo_update do
  sh 'bundle exec pod repo update --silent'
end

# desc 'Pod install'
task :pod_install do
  sh 'bundle exec pod install'
end

# -- carthage

# CARTHAGE_OPTIONS = '--platform iOS --no-use-binaries'
#
# task :carthage_install, [ :dependency ] do |t, args|
#   dependency = args[:dependency]
#   sh "carthage bootstrap #{CARTHAGE_OPTIONS} #{dependency}"
# end
#
# desc 'Install carthage dependencies'
# task :carthage_update, [ :dependency ] do |t, args|
#   dependency = args[:dependency]
#   sh "carthage update #{CARTHAGE_OPTIONS} #{dependency}"
# end
#
# task :carthage_clean, [ :dependency ] do |t, args|
  # hasDependency = args[:dependency].to_s.strip.length != 0
  # sh 'rm -rf "~/Library/Caches/org.carthage.CarthageKit/"' unless hasDependency
  # sh "rm -rf '#{BASE_PATH}/Carthage/'" unless hasDependency
# end

# -- brew

def brew_update
  sh 'brew update || brew update'
end

def brew_install( formula )
  fail 'no formula' if formula.to_s.strip.length == 0
  sh " ( brew list #{formula} ) && ( brew outdated #{formula} || brew upgrade #{formula} ) || ( brew install #{formula} ) "
end
