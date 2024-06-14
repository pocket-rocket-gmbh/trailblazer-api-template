require 'factory_bot'

FactoryBot.define do
  factory :user, class: User do
    organization
    firstname { Faker::Name.first_name }
    lastname { Faker::Name.last_name }
    email { Faker::Internet.email }
    role { :user }
    status { :confirmed }
    password { Faker::Internet.password }
    city { 'St. Wendel' }
    zip_code { '66606' }
    country { 'DE' }

    factory :user_admin do
      role { :admin }
    end

    factory :user_root do
      role { :root }
    end

    factory :user_unconfirmed do
      status { :unconfirmed }
    end

    factory :user_admin_unconfirmed do
      role { :admin }
      status { :unconfirmed }
    end
  end
end
