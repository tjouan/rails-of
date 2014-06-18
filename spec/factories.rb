include ActionDispatch::TestProcess

FactoryGirl.define do
  factory :header do
    name 'name'
    type :text
  end

  factory :operation do
    name 'GeoScore'
  end

  factory :source do
    label 'some file'
    file  { fixture_file_upload 'spec/fixtures/3col_header.csv', 'text/csv' }
  end

  factory :work do
    operation
    source
    parameters []
  end
end
