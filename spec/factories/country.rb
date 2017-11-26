FactoryBot.define do
  factory :country do
    sequence(:name) {|n| "Country #{n}" }
    sequence(:sequence)
  end
end
