# -------------------

require 'json'

def url_for_path(path)
  commit = head_commit
  repo = env.request_source.pr_json[:head][:repo][:html_url]
  path = "/#{path}" unless path.start_with? '/'
  path, line = path.split(':')
  url = "#{repo}/blob/#{commit}#{path}"
  url += "#L#{line}" if line
end

def markdown_for_path(path)
  url = url_for_path(path)
  path[0] = '' if path.start_with? '/'
  "[#{path}](#{url})"
end

def format_path(path)
# need to be more general
  workspace_path = File.expand_path('.')
  path = path.gsub(workspace_path, '') if workspace_path
  markdown_for_path(path)
end

def should_ignore_warning(path)
  path =~ %r{.*/Frameworks/.*\.framework/.*}
end

def format_compile_warning(h)
  return nil if should_ignore_warning(h[:file_path])

  path = format_path(h[:file_path])
  "**#{path}**: #{h[:reason]}  \n" \
    "```\n" \
    "#{h[:line]}\n" \
    "```  \n"
end

def format_format_file_missing_error(h)
  path = format_path(h[:file_path])
  "**#{h[:reason]}**: #{path}"
end

def format_undefined_symbols(h)
  "#{h[:message]}  \n" \
    "> Symbol: #{h[:symbol]}  \n" \
    "> Referenced from: #{h[:reference]}"
end

def format_duplicate_symbols(h)
  "#{h[:message]}  \n" \
    "> #{h[:file_paths].map { |path| path.split('/').last }.join("\n> ")}\n"
end

def format_test_failure(suite_name, failures)
  failures.map { |f|
    path = format_path(f[:file_path])
    "**#{suite_name}**: #{f[:test_case]}, #{f[:reason]}  \n  #{path}  \n"
  }
end

# -------------------

def warning_important_file_changed(file)
  warn "Do you really want to modify #{file}?" if modified_files.include?(file)
end

# Sometimes it's a README fix, or something like that - which isn't relevant for
# including in a project's CHANGELOG for example
declared_trivial = pr_title.include? '#trivial'

# Make it more obvious that a PR is a work in progress and shouldn't be merged yet
warn 'PR is classed as Work in Progress' if (github.pr_title + github.pr_body).include? "[WIP]"

# Warn when there is a big PR
warn 'Big PR' if lines_of_code > 1000

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
build_file = 'result.json'
system "cat #{raw_build_file} | XCPRETTY_JSON_FILE_OUTPUT=#{build_file} xcpretty -f `xcpretty-json-formatter`"

# Compilation errors and warnings
buildlog_path = build_file
if File.file?(build_file)
  json = JSON.parse(File.read(buildlog_path), {:symbolize_names => true})

  warnings = [
    json[:warnings],
    json[:ld_warnings],
    json[:compile_warnings].map { |s| format_compile_warning(s) }
  ].flatten.uniq.compact
  warnings.each { |s| warn(s, sticky: false) }

  errors = [
    json[:errors],
    json[:compile_errors].map { |s| format_compile_warning(s) },
    json[:file_missing_errors].map { |s| format_format_file_missing_error(s) },
    json[:undefined_symbols_errors].map { |s| format_undefined_symbols(s) },
    json[:duplicate_symbols_errors].map { |s| format_duplicate_symbols(s) },
    json[:tests_failures].map { |k, v| format_test_failure(k, v) }.flatten
  ].flatten.uniq.compact
  errors.each { |s| fail(s, sticky: false) }
else
  fail("xcodebuild log not found")
end

