require 'factory_bot'

FactoryBot.define do
  factory :customer do
    organization
    contact_person { "#{Faker::Name.first_name} #{Faker::Name.last_name}" }
    code { ('a'..'z').to_a.shuffle.first(4).join.upcase }
    company_name { Faker::Company.name }
    street { Faker::Address.street_name }
    zip { Faker::Address.zip }
    city { Faker::Address.city }
    phone { Faker::PhoneNumber.cell_phone_in_e164  }
    fax { Faker::PhoneNumber.cell_phone_in_e164 }
    email { Faker::Internet.email }
  end
end
