FactoryBot.define do
  factory :shop do
    sequence(:name) {|n| "Shop #{n}" }
    category
  end
end
