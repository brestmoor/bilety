class Ticket < ApplicationRecord
  validates :name, :presence => true, :length => {:minimum => 1}
  validates :email_address, :presence => true
  validates :price, :presence => true
  validates :price, :length => {:minimum => 1}

  belongs_to :event


end
