# frozen_string_literal: true

class ShopMemo < ApplicationRecord
  belongs_to :shop

  validates :title, presence: true
  validates :body, presence: true
end
