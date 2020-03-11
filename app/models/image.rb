class Image < ApplicationRecord
  belongs_to :dog
  has_one_attached :file

  scope :join_dogs_on_ab, -> { joins('LEFT JOIN "dogs" ON "dogs"."avatar_id" = "images"."id" OR "dogs"."background_id" = "images"."id"') }
  scope :avatar_not_null, -> { where.not(dogs: { avatar_id: nil }) }
  scope :background_not_null, -> { where.not(dogs: { background_id: nil }) }
  scope :pluck_id, -> { pluck :id }

  def self.total_images
    self.count
  end

  def self.avatars
    puts "AVATARS"
    joins('JOIN "dogs" ON "dogs"."avatar_id" = "images"."id"').pluck_id.length
  end

  def self.backgrounds
    puts "BACKGROUNDS"
    joins('JOIN "dogs" ON "dogs"."background_id" = "images"."id"').pluck_id.length
  end

  def self.avatars_lost
    puts "AVATARS LOST"
    joins('RIGHT JOIN "dogs" ON "dogs"."avatar_id" = "images"."id"').where(id: nil).avatar_not_null.pluck('dogs.id AS dogs_id')
  end

  def self.backgrounds_lost
    puts "BACKGROUNDS LOST"
    joins('RIGHT JOIN "dogs" ON "dogs"."background_id" = "images"."id"').where(id: nil).background_not_null.pluck('dogs.id AS dogs_id')
  end

  def self.photos
    puts "PHOTOS"
    join_dogs_on_ab.where(dogs: { avatar_id: nil, background_id: nil }).pluck_id.length
  end

  def self.no_reverse_reference
    puts "NO REVERSE REFERENCE"
    orphan_records - where(dog_id: nil).pluck_id
  end

  def self.orphan_records
    puts "ORPHAN RECORDS"
    join_dogs_on_ab.where(dog_id: nil, dogs: { id: nil }).pluck_id
  end
end
