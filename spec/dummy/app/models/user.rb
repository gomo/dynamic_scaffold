class User < ApplicationRecord
  enum role: { admin: 1, staff: 2, member: 3 }
  validates :encrypted_password, presence: true

  attr_accessor :password
end
