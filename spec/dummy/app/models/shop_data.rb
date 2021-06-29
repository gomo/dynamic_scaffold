class ShopData
  include ActiveModel::Model

  attr_accessor :foobar

  validates :foobar, presence: true
end
