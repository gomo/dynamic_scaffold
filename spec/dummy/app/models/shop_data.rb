class ShopData
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :foobar, :string
  attribute :quz, :string
  
  validates :foobar, presence: true

  class << self
    def dump(obj)
      obj = obj.attributes if obj.is_a? ActiveModel::Attributes
      obj.to_json if obj
    end

    def load(source)
      new(source ? JSON.parse(source) : {})
    end
  end
end
