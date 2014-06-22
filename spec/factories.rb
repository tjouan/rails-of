include ActionDispatch::TestProcess

FactoryGirl.define do
  factory :header do
    name      'name'
    type      :text
    position  0
  end

  factory :operation do
    name  'GeoScore'
    ref   'geoscore'
  end

  factory :source do
    label     'some file'
    sha256    '1d3cb3affc9fb394b1f2bcdf5d429bb4079e67202c11c20ed5dd7fbfd669103e'
    file_name '3col_header.csv'
    mime_type 'text/csv'
    charset   'utf-8'
    file      { StringIO.new("name,score,active\nfoo,42,1\nbar,13,1\nbaz,32,0\n") }

    factory :source_latin1 do
      file { File.new('spec/fixtures/3col_header_body_latin1.csv') }
    end

    factory :source_with_upload do
      file { fixture_file_upload 'spec/fixtures/3col_header.csv', 'text/csv' }
    end
  end

  factory :work do
    operation
    source
    parameters []
  end
end
