# Sometimes it's a README fix, or something like that - which isn't relevant for
# including in a project's CHANGELOG for example
declared_trivial = pr_title.include? '#trivial'

# Make it more obvious that a PR is a work in progress and shouldn't be merged yet
warn 'PR is classed as Work in Progress' if (github.pr_title + github.pr_body).include? "[WIP]"

# Warn when there is a big PR
warn 'Big PR' if lines_of_code > 1000

fail 'Please add labels to this PR' if github.pr_labels.empty?

if github.pr_body.length < 5
  fail 'Please provide a summary in the Pull Request description'
end

build_file = 'xcode_raw.log'
test_log = File.read build_file

message test_log.lines.last
