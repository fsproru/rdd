guard :minitest, spring: false do
  watch(%r{^lib/(.+)\.rb$}) { |m| "test/lib/#{m[1]}_test.rb" }
  watch(%r{^test/(.*)\/?_test(.*)\.rb$})
  watch(%r{^test/test_helper\.rb$}) { 'test' }
end

guard :bundler do
  require 'guard/bundler'
  require 'guard/bundler/verify'
  helper = Guard::Bundler::Verify.new

  files = ['Gemfile']
  files += Dir['*.gemspec'] if files.any? { |f| helper.uses_gemspec?(f) }

  # Assume files are symlinked from somewhere
  files.each { |file| watch(helper.real_path(file)) }
end
