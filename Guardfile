directories %w[app config lib spec]

guard :spork, rspec_env: { RAILS_ENV: 'test' } do
  watch('config/application.rb')
  watch('config/environment.rb')
  watch('config/environments/test.rb')
  watch(%r{^config/initializers/.+\.rb$})
  watch('config/routes.rb')
  watch('Gemfile.lock')
  watch('spec/spec_helper.rb') { :rspec }
end

guard :rspec, cmd: 'bundle exec rspec --drb -f doc', failed_mode: :keep do
  watch(%r{^spec/.+_spec\.rb$})

  watch('spec/spec_helper.rb')        { 'spec' }
  watch(%r{^spec/support/.+\.rb$})    { 'spec' }
  watch(%r{^spec/factories/.+})       { 'spec' }

  watch(%r{^app/(.+)\.rb$})           { |m| "spec/#{m[1]}_spec.rb" }
  watch(%r{^app/(.+)\.haml$})         { |m| "spec/#{m[1]}.haml_spec.rb" }
  watch(%r{^lib/(.+)\.rb$})           { |m| "spec/lib/#{m[1]}_spec.rb" }

  watch('app/controllers/application_controller.rb')  { 'spec/controllers' }

  watch(%r{^app/views/.+})            { 'spec/features' }
end
