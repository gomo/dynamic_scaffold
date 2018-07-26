class Shop < ApplicationRecord
  belongs_to :category
  has_many :shop_states
  has_many :states, inverse_of: :shops, through: :shop_states
  enum status: { draft: 0, published: 1, hidden: 2 }

  attr_accessor :foobar, :cropper_image

  validates :name, presence: true, length: { in: 3..20 }
  validates :category_id, presence: true
  validates :status, presence: true, inclusion: { in: Shop.statuses.keys, allow_blank: true }
  validates :memo, length: { maximum: 30 }

  mount_uploader :image, ShopImageUploader

  def store_image!
    image.crop_and_resize
    super
  end
end
