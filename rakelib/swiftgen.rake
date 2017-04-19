# frozen_string_literal: true

desc 'Generate strings'
task :swiftgen_strings do
  config = CONFIG['swiftgen']
  config['strings'].each do |strings, generated|
    sh "#{config['path']} strings -template dot-syntax-swift3 --output '#{generated}' '#{strings}'"
  end
end
