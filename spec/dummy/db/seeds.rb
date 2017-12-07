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
    name: Faker::StarWars.planet,
    memo: Faker::StarWars.quote.slice(0, 30),
    category: category
  )
end

3.times do |n|
  User.roles.keys.each do |role|
    User.create!(
      email: Faker::Internet.email,
      encrypted_password: Faker::Crypto.md5,
      role: role
    )
  end
end
