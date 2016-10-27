require 'rake'
require 'rake/testtask'

Rake::TestTask.new do |test|
  test.libs << 'test'
  test.warning = false
  test.verbose = true
  test.test_files = FileList['test/*_test.rb']#.exclude("test/simple_server_test.rb")
end
task default: :test


