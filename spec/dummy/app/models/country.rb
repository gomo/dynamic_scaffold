class Country < ApplicationRecord
  has_many :states
  def my_attribute
    'My attribute value'
  end
end
