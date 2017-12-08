class User < ApplicationRecord
  enum role: { admin: 1, staff: 2, member: 3 }
end
