require 'factory_bot'

FactoryBot.define do
  factory :organization do
    name { Faker::Company.name }
    status { :active }
  end
end
