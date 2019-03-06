class Image < ApplicationRecord
  belongs_to :dog, inverse_of: :pictures

  has_one_attached :file
end
