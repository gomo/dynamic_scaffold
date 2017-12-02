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
    memo: Faker::StarWars.quote,
    category: category
  )
end