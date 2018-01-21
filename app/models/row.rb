class Row < ApplicationRecord
  has_many :seats
  belongs_to :event
end
