class ShopData
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :foobar, :string
  attribute :quz, :string
  validates :foobar, presence: true
end
