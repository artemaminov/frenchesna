class Image < ApplicationRecord
  belongs_to :viewable, polymorphic: true

  has_one_attached :file

  scope :join_dogs_on_ab, -> { joins('LEFT JOIN "dogs" ON "dogs"."id" = "images"."viewable_id"') }
  scope :avatar_not_null, -> { where.not(dogs: { avatar_id: nil }) }
  scope :background_not_null, -> { where.not(dogs: { background_id: nil }) }
  scope :pluck_id, -> { pluck :id }

  def self.total_images
    self.count
  end

  def self.avatars
    puts "AVATARS"
    where(viewable_type_scope: 'Avatar').length
  end

  def self.backgrounds
    puts "BACKGROUNDS"
    where(viewable_type_scope: 'Background').length
  end

  def self.avatars_lost
    puts "AVATARS LOST"
    join_dogs_on_ab.where(viewable_type_scope: 'Avatar', dogs: { id: nil }).pluck_id
  end

  def self.backgrounds_lost
    puts "BACKGROUNDS LOST"
    join_dogs_on_ab.where(viewable_type_scope: 'Background', dogs: { id: nil }).pluck_id
  end

  def self.photos
    puts "PHOTOS"
    where(viewable_type_scope: 'Gallery').length
  end

  def self.no_reverse_reference
    puts "NO REVERSE REFERENCE"
    join_dogs_on_ab.where(viewable_id: nil).pluck_id
  end

  def self.orphan_records
    puts "ORPHAN RECORDS"
    join_dogs_on_ab.where(viewable_id: nil).pluck_id
  end
end
