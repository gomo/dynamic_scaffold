class Shop < ApplicationRecord
  belongs_to :category
  enum status: { draft: 0, published: 1, hidden: 2 }
end
