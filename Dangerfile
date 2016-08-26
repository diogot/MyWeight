
def warning_important_file_changed(file)
  warn "Do you really want to modify #{file}?" if git.modified_files.include?(file)
end

# Sometimes it's a README fix, or something like that - which isn't relevant for
# including in a project's CHANGELOG for example
declared_trivial = github.pr_title.include? '#trivial'

# Make it more obvious that a PR is a work in progress and shouldn't be merged yet
warn 'PR is classed as Work in Progress' if (github.pr_title + github.pr_body).include? "[WIP]"

# Warn when there is a big PR
warn 'Big PR' if git.lines_of_code > 1000

warning_important_file_changed '.gitignore'
warning_important_file_changed '.travis.yml'
warning_important_file_changed 'circle.yml'
warning_important_file_changed 'Rakefile'
warning_important_file_changed 'Gemfile'
warning_important_file_changed 'Gemfile.lock'
warning_important_file_changed 'Podfile'
warning_important_file_changed 'Podfile.lock'

fail 'Please add labels to this PR' if github.pr_labels.empty?

if github.pr_body.length < 5
  fail 'Please provide a summary in the Pull Request description'
end


# Change it later
raw_build_file = 'xcode_raw.log'
build_file = File.expand_path 'result.json'
system "cat #{raw_build_file} | XCPRETTY_JSON_FILE_OUTPUT=#{build_file} xcpretty -f `xcpretty-json-formatter`"

json = xcode_summary.report build_file

