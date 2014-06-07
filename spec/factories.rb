include ActionDispatch::TestProcess

FactoryGirl.define do
  factory :header do
    name 'name'
    type :text
  end
end

FactoryGirl.define do
  factory :operation do
    name 'GeoScore'
  end
end

FactoryGirl.define do
  factory :source do
    label 'some file'
    file  { fixture_file_upload 'spec/fixtures/3col_header.csv', 'text/csv' }
  end
end

FactoryGirl.define do
  factory :work do
    operation
    source
  end
end
