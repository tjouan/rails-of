include ActionDispatch::TestProcess

FactoryGirl.define do
  factory :article do
    zone 'traning'
    body <<-eoh
Some article
============

Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor
incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis
nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.
eoh
  end

  factory :header do
    name      'name'
    type      :text
    position  0
  end

  factory :offer do
    factory :free_offer do
      ref     'free'
      visible false
    end
  end

  factory :operation do
    name  'GeoScore'
    ref   'geoscore'
  end

  factory :source do
    user
    label       'some file'
    sha256      '1d3cb3affc9fb394b1f2bcdf5d429bb4079e67202c11c20ed5dd7fbfd669103e'
    file_name   'mydata.csv'

    after :build do |e|
      def e.rows
        [
          %w[foo 42 1],
          %w[bar 13 1],
          %w[baz 32 0]
        ]
      end
    end
  end

  factory :user do
    name      'Bob'
    email     'bob@example.net'
    password  'p4ssw0rd'

    trait :active do
      active true
    end

    trait :subscribed do
      after :create do |e|
        create :free_offer unless Offer.free_offer
        UserCreater.new(e).call
      end
    end

    factory :subscribed_user, traits: %i[active subscribed]
  end

  factory :work do
    user
    operation
    source { build :source, user: user }
    parameters %w[0, 1]
  end
end
