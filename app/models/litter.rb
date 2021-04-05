class Litter < ApplicationRecord
  has_many :dogs

  translates :title
end
