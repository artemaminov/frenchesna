class Dog < ApplicationRecord
  belongs_to :mother, class_name: 'Dog', foreign_key: 'mother_id', optional: true
  belongs_to :father, class_name: 'Dog', foreign_key: 'father_id', optional: true
  has_many :kids, class_name: 'Dog'

  has_many :pictures, class_name: "Image", inverse_of: :dog
  belongs_to :avatar, class_name: "Image", optional: true
  belongs_to :background, class_name: "Image", optional: true

  accepts_nested_attributes_for :pictures, :kids, allow_destroy: true

  # scope :background, -> { joins(:pictures).where(background: true) }

  enum gender: { male: 1, female: 0 }

  validates :name, :nickname, :birthdate, :gender, :award_point, :about, :rip, presence: true
end