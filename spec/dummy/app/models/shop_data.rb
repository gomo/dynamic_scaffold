class ShopData
  include ActiveModel::Model
  include ActiveModel::Attributes
  include JSONObjectModel

  attribute :foobar, :string
  attribute :quz, :string
  validates :foobar, presence: true
end
