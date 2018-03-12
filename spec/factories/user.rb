FactoryBot.define do
  factory :user do
    transient do
      role_value :member
    end

    password 'password'
    sequence(:email) {|n| "#{n}@example.com" }
    sequence(:sequence)
    role { role_value }
  end
end
