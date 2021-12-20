# frozen_string_literal: true

class State < ApplicationRecord
  belongs_to :country
  has_many :shop_states
  has_many :shops, through: :shop_states
end
