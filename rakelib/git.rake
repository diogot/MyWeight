# frozen_string_literal: true

begin
  require 'git'
rescue LoadError
  puts 'git not installed yet!'
end

desc 'Add tag with current version'
task :add_tag do
  git_working_directory.add_tag(current_version)
end

desc 'Push current branch and tags'
task :push do
  puts 'git push'
  g = git_working_directory
  branch = g.current_branch
  remote = 'origin'
  git_working_directory.push(remote, branch, tags: true)
end

def git_working_directory
  Git.open(BASE_PATH)
end
