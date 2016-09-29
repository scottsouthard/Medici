class Museum < ApplicationRecord
  has_many :tickets
  has_many :taggings
  has_many :tags, through: :taggings
  default_scope { where(active: true) }
  accepts_nested_attributes_for :taggings, :allow_destroy => true
  has_many :exhibits
  has_many :events
  has_many :pieces

  has_attached_file :photo, styles: { large: "768x768>", medium: "300x300>", thumb: "100x100>" }
  validates_attachment_content_type :photo, content_type: /\Aimage\/.*\Z/

  validates_presence_of :name, :blurb, :description, :photo, :price, :address, :opening_time, :closing_time, :website
  validates_uniqueness_of :name
  validate :close_must_be_after_open

  geocoded_by :address
  after_validation :geocode, if: ->(obj){ obj.address.present? and obj.address_changed? }

  def close_must_be_after_open
    if opening_time == nil || closing_time == nil
      errors.add(:closing_time, "must be after start date")
    elsif opening_time >= closing_time
      errors.add(:closing_time, "must be after start date")
    end
  end

end
