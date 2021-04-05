class Dog < ApplicationRecord
  validate :kid_to_be_parent

  attr_accessor :mother_id, :father_id, :viewable_id

  has_one :avatar, -> { where viewable_type_scope: 'Avatar' }, class_name: "Image", dependent: :destroy, foreign_key: :viewable_id, inverse_of: :viewable, as: :viewable
  has_one :background, -> { where viewable_type_scope: 'Background' }, class_name: "Image", dependent: :destroy, foreign_key: :viewable_id, inverse_of: :viewable, as: :viewable
  has_many :gallery_pictures, -> { where viewable_type_scope: 'Gallery' }, class_name: "Image", dependent: :destroy, foreign_key: :viewable_id, inverse_of: :viewable, as: :viewable
  has_many :pictures, class_name: "Image", dependent: :destroy, foreign_key: :viewable_id, inverse_of: :viewable, as: :viewable

  has_many :child_genealogies, class_name: "Genealogy", foreign_key: "parent_id", dependent: :destroy
  has_many :parent_genealogies, class_name: "Genealogy", foreign_key: "child_id", dependent: :destroy
  has_many :parents, through: :parent_genealogies, source: :parent
  has_many :kids, through: :child_genealogies, source: :child

  belongs_to :breed
  belongs_to :litter, optional: true
  # , ->(dog) { unscope(:joins).joins('INNER JOIN "genealogies" ON "dogs"."id" = "genealogies"."child_id" WHERE "genealogies"."father_id" = "dog"."id" OR "genealogies"."mother_id" = "dog"."id"').where('"genealogies"."father_id" = "dog"."id" OR "genealogies"."mother_id" = "dog"."id"') }
  # has_many :genealogies, foreign_key: :father

  accepts_nested_attributes_for :avatar, :background, :gallery_pictures, :pictures, allow_destroy: true
  accepts_nested_attributes_for :kids, :parents, :child_genealogies, :parent_genealogies, :litter, :breed

  enum gender: { male: 1, female: 0 }

  scope :alive, -> { where(rip: false) }
  scope :archived, -> { where(rip: true) }
  scope :puppies, -> { where(puppy: true) }
  scope :adults, -> { where(puppy: false) }
  scope :females, -> { where(gender: 'female') }
  scope :males, -> { where(gender: 'male') }
  scope :mother, -> { females.first }
  scope :father, -> { males.first }
  scope :not_itself, ->(self_id) { where.not(id: self_id) }
  scope :parentable, -> { adults.alive }

  scope :sort_by_breed, -> { joins(:breed).order('breeds.order ASC') }
  scope :sort_by_name, -> { order('fullname ASC') }
  scope :sort_by_birth, -> { order('birthdate DESC') }

  validates_presence_of :fullname, :nickname, :awards, :about, :birthdate
  validates_inclusion_of :gender, in: %w(male female)
  validates_inclusion_of :rip, in: [true, false]

  translates :fullname, :nickname, :about, :awards
  active_admin_translates :fullname, :nickname, :about, :awards

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
    pictures.where.not(viewable_type_scope: 'Avatar')
  end

  def to_param
    "#{id}-#{fullname.parameterize}"
  end

  private

  def kid_to_be_parent
    if (kids & parents).count > 0
      errors.add(:base, "У собаки не может быть детей одновременно являющимися ее родителями!")
    end
  end

end