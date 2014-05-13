include ActionDispatch::TestProcess

FactoryGirl.define do
  factory :data_file do
    label 'some file'

    factory :data_file_with_file do
      file { fixture_file_upload 'spec/fixtures/sample_0.csv', 'text/csv' }
    end
  end
end
