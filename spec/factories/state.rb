FactoryBot.define do
  factory :state do
    sequence(:name) {|n| "State #{n}" }
    sequence(:sequence)
    country
  end
end
