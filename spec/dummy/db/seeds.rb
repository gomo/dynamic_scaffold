# frozen_string_literal: true

ActiveRecord::Base.logger = Logger.new(STDOUT)

3.times do |nc|
  country = Country.create!(
    name: Faker::Address.country,
    sequence: nc
  )

  category = Category.create!(
    name: Faker::Job.field,
    sequence: nc
  )

  3.times do |ns|
    State.create!(
      name: Faker::Address.state,
      sequence: ns,
      country: country
    )
  end

  Shop.create!(
    name: Faker::Movies::StarWars.planet,
    memo: Faker::Movies::StarWars.quote.slice(0, 30),
    category: category
  )
end

# for pagination
99.times do |n|
  Country.create!(
    name: Faker::Address.country,
    sequence: n
  )
end

3.times do |n|
  User.roles.each_key do |role|
    User.create!(
      email: Faker::Internet.email,
      password: 'password',
      role: role,
      sequence: n
    )
  end
end
