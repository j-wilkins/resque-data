# A sample Guardfile
# More info at https://github.com/guard/guard#readme

# Add files and commands to this file, like the example:
#   watch(%r{file/path}) { `command(s)` }
#
guard 'shell' do
  watch(/(.*).rb/) do |m|
    puts `bundle exec rake test`
    _label = $?.exitstatus == 0 ? :success : :failed
    n '', 'Test Output', _label
  end
end

