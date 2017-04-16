# frozen_string_literal: true

desc 'Generate strings'
task :swiftgen_strings do
  SWIFTGEN_STRINGS.each do |strings, generated|
    sh "#{SWIFTGEN_PATH} strings -template dot-syntax-swift3 --output '#{generated}' '#{strings}'"
  end
end
