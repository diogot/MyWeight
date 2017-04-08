# frozen_string_literal: true

# -- project setup

desc 'Install/update and configure project'
task setup: %i[setup_dependencies configure]

task setup_dependencies: %i[install_dependencies] do
  if BUNDLER_PATH.nil?
    sh 'bundle install'
  else
    sh "bundle check --path=#{BUNDLER_PATH} || bundle install --path=#{BUNDLER_PATH} --jobs=4 --retry=3"
  end
end

task configure: %i[pod_if_needed clean_artifacts]

task :install_dependencies do
  # brew_update
  # brew_install 'carthage'
end

# desc 'Updated submodules'
# task :submodule_update do
#   sh 'git submodule update --init --recursive'
# end

# -- cocoapods

desc 'Run CocoaPods if needed'
task :pod_if_needed do
  if needs_to_run_pod_install
    pod_repo_update
    pod_install
  else
    puts 'Skipping pod install because Pods seems updated'
  end
end

desc 'Pod repo update'
task :pod_repo_update do
  pod_repo_update
end

desc 'Pod install'
task :pod_install do
  pod_install
end

def needs_to_run_pod_install
  !FileUtils.compare_file('Podfile.lock', 'Pods/Manifest.lock')
rescue Exception => _
  true
end

def pod_repo_update
  sh 'bundle exec pod repo update --silent'
end

def pod_install
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

def brew_install(formula)
  raise 'no formula' if formula.to_s.strip.empty?
  sh " ( brew list #{formula} ) && ( brew outdated #{formula} || brew upgrade #{formula} ) || ( brew install #{formula} ) "
end
