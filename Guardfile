guard :rspec, cmd: 'bundle exec rspec -f doc' do
  watch(%r{^spec/.+_spec\.rb$})

  watch('spec/spec_helper.rb')        { 'spec' }
  watch(%r{^spec/support/.+\.rb$})    { 'spec' }
  watch(%r{^spec/factories/.+})       { 'spec' }

  watch(%r{^app/(.+)\.rb$})           { |m| "spec/#{m[1]}_spec.rb" }
  watch(%r{^app/(.+)\.haml$})         { |m| "spec/#{m[1]}.haml_spec.rb" }
  watch(%r{^lib/(.+)\.rb$})           { |m| "spec/lib/#{m[1]}_spec.rb" }

  watch('app/controllers/application_controller.rb')  { 'spec/controllers' }

  watch(%r{^app/views/layouts/.+})    { 'spec/features' }
end
