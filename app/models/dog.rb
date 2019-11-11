class Dog < ApplicationRecord
  attr_accessor :mother_id, :father_id

  belongs_to :avatar, class_name: "Image", optional: true, inverse_of: :dog, dependent: :destroy
  belongs_to :background, class_name: "Image", optional: true, inverse_of: :dog, dependent: :destroy

  has_many :child_genealogies, class_name: "Genealogy", foreign_key: "parent_id", dependent: :destroy
  has_many :parent_genealogies, class_name: "Genealogy", foreign_key: "child_id", dependent: :destroy
  has_many :parents, through: :parent_genealogies, source: :parent
  has_many :kids, through: :child_genealogies, source: :child

  # , ->(dog) { unscope(:joins).joins('INNER JOIN "genealogies" ON "dogs"."id" = "genealogies"."child_id" WHERE "genealogies"."father_id" = "dog"."id" OR "genealogies"."mother_id" = "dog"."id"').where('"genealogies"."father_id" = "dog"."id" OR "genealogies"."mother_id" = "dog"."id"') }
  # has_many :genealogies, foreign_key: :father

  has_many :pictures, class_name: "Image", dependent: :destroy

  accepts_nested_attributes_for :avatar, :pictures, allow_destroy: true
  accepts_nested_attributes_for :kids, :parents, :child_genealogies, :parent_genealogies

  enum gender: { male: 1, female: 0 }

  validates_presence_of :fullname, :nickname, :birthdate, :awards, :about
  validates_inclusion_of :gender, in: %w(male female)
  validates_inclusion_of :rip, in: [true, false]

  scope :alive, -> { where(rip: false) }
  scope :puppies, -> { where(puppy: true) }
  scope :adults, -> { where(puppy: false) }
  scope :females, -> { where(gender: 'female') }
  scope :males, -> { where(gender: 'male') }
  scope :mother, -> { females.first }
  scope :father, -> { males.first }
  scope :not_itself, ->(self_id) { where.not(id: self_id) }
  scope :parentable, -> { adults.alive }
  scope :backgroundable, -> {  }

  def mother_id
    m = parents.female.first
    return m.id unless m.blank?
    nil
  end

  def father_id
    p = parents.male.first
    return p.id unless p.blank?
    nil
  end

  def backgroundable
    return pictures.where.not(id: avatar.id) unless avatar.blank?
    pictures
  end

  def to_param
    "#{id}-#{fullname.parameterize}"
  end
  
end