class Dog < ApplicationRecord
  belongs_to :mother, class_name: "Dog", optional: true
  belongs_to :father, class_name: "Dog", optional: true
  belongs_to :avatar, class_name: "Image", dependent: :destroy, optional: true
  belongs_to :background, class_name: "Image", dependent: :destroy, optional: true

  has_many :kids, class_name: "Dog"
  has_many :pictures, class_name: "Image", dependent: :destroy

  accepts_nested_attributes_for :background, :avatar, :pictures, allow_destroy: true
  accepts_nested_attributes_for :kids

  enum gender: { male: 1, female: 0 }

  validates_presence_of :fullname, :nickname, :birthdate, :award_point, :about
  validates_inclusion_of :gender, in: %w(male female)
  validates_inclusion_of :rip, in: [true, false]
end