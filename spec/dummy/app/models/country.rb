class Country < ApplicationRecord
  default_scope {order(sequence: :desc)}
  has_many :states
  def my_attribute
    'My attribute value'
  end
end
