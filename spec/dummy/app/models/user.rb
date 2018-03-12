class User < ApplicationRecord
  enum role: { admin: 1, staff: 2, member: 3 }
  validates :email, presence: true, uniqueness: true
  validates :password, presence: { if: :new_record? }, length: { minimum: 6, allow_blank: true }
  attr_reader :password, :password_for_edit

  def password=(value)
    @password = value
    self.encrypted_password = Digest::MD5.hexdigest(value)
  end

  def password_for_edit=(value)
    @password_for_edit = value
    self.password = value if value.present?
  end
end
