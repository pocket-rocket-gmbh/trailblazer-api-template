FactoryBot.define do

  # ------------------ Authorization ---------------
  factory :authenticate_json, class: OpenStruct do
    email { Faker::Internet.email }
    password { Faker::Internet.password }
  end
end
