ActiveRecord::Base.logger = Logger.new(STDOUT)

10.times do |n|
  Country.create!(
    name: Faker::Address.country,
    sequence: n
  )
end
