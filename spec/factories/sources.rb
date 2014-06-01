include ActionDispatch::TestProcess

FactoryGirl.define do
  factory :source do
    label 'some file'
    file  { fixture_file_upload 'spec/fixtures/3col_header.csv', 'text/csv' }
  end
end
