# frozen_string_literal: true

FactoryBot.define do
  factory :country do
    transient do
      with_name { false }
    end

    sequence(:name) {|n| "Country #{n}" }
    sequence(:sequence)

    after(:create) do |rec, evaluator|
      rec.name = evaluator.with_name if evaluator.with_name
      rec.save!
    end
  end
end
