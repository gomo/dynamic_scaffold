# frozen_string_literal: true

FactoryBot.define do
  factory :shop do
    sequence(:name) {|n| "Shop #{n}" }
    category
  end
end
