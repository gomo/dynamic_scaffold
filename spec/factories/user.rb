FactoryBot.define do
  factory :user do
    transient do
      role_value :member
    end
    
    sequence(:email) {|n| "#{n}@example.com" }
    sequence(:encrypted_password) {|n| "#{n}encrypted_password" }
    role {role_value}
  end
end
