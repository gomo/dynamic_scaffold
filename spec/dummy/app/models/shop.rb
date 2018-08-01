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
  before_save :resize_image

  translates :desc, :keyword
  globalize_accessors :locales => [:en, :ja], :attributes => [:keyword]
  accepts_nested_attributes_for :translations
  [:en, :ja].each do |locale|
    validates :"keyword_#{locale}", presence: true
  end

  def resize_image
    return unless image_changed?
    return if image.blank?
    image.crop_and_resize
  end
end
