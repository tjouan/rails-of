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
    label       'some file'
    sha256      '1d3cb3affc9fb394b1f2bcdf5d429bb4079e67202c11c20ed5dd7fbfd669103e'
    file_name   'mydata.csv'
    file_header true
    mime_type   'text/csv'
    charset     'utf-8'

    after :build do |e|
      e.stub(:to_file) do
        StringIO.new("name,score,active\nfoo,42,1\nbar,13,1\nbaz,32,0\n")
      end
    end
  end

  factory :user do
    name      'Bob'
    email     'bob@example.net'
    password  'p4ssw0rd'
  end

  factory :work do
    operation
    source
    parameters %w[0, 1]
  end
end
