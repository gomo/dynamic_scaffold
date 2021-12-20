# frozen_string_literal: true

class ShopData
  include ActiveModel::Model
  include ActiveModel::Attributes
  include DynamicScaffold::JSONObject::Model

  attribute :foobar, :string
  attribute :quz, :string
end
