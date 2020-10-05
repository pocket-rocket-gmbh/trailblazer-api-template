# init organization

# Scenario setup

user_password = 'PassWord9876'
models_used_in_seed = [User, Organization]

# cleanup DB
if !Rails.env.production?
  models_used_in_seed.each do |model|
    model.destroy_all
  end
end

10.times { |i|
  org = Organization.create!(
    name: Faker::Company.name,
    status: 'active'
  )
  puts "Organization ##{i+1} created"

  user = User.create!(
    firstname: Faker::Name.first_name,
    lastname: Faker::Name.last_name,
    email: Faker::Internet.email,
    password: user_password,
    organization: org,
    role: :admin,
    status: 'confirmed'
  )

  puts "User ##{i+1} created"

  user = User.create!(
    firstname: Faker::Name.first_name,
    lastname: Faker::Name.last_name,
    email: Faker::Internet.email,
    password: user_password,
    organization: org,
    role: :user,
    status: 'confirmed'
  )

  puts "Admin ##{i+1} created"
}

# Root user
root_user = User.create!(
  firstname: 'Root',
  lastname: 'User',
  email: 'info@pocket-rocket.io',
  password: user_password,
  organization: Organization.first,
  role: :root,
  status: 'confirmed'
)
puts "Root user created"
