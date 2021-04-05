class Breed < ApplicationRecord
  has_many :dogs

  active_admin_translates :title, :description do
    validates_presence_of :title
  end

  translates :title, :info
end
