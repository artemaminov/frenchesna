class Breed < ApplicationRecord
  has_many :dogs

  validates_presence_of :title
end
