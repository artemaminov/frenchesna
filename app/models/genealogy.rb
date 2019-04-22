class Genealogy < ApplicationRecord
  belongs_to :parent, class_name: "Dog", inverse_of: :parent_genealogies
  belongs_to :child, class_name: "Dog", inverse_of: :child_genealogies
end
