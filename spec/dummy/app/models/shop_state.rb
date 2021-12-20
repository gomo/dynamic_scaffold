# frozen_string_literal: true

class ShopState < ApplicationRecord
  belongs_to :shop
  belongs_to :state
end
