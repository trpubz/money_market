FactoryBot.define do
  factory :market do
    name { Faker::Fantasy::Tolkien.location }
    street { Faker::Address.street_address }
    city { Faker::Address.city }
    county { "Rio Grande" }
    state { Faker::Address.state_abbr }
    zip { Faker::Address.zip }
    lat { Faker::Address.latitude }
    lon { Faker::Address.longitude }
  end
end
