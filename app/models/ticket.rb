class Ticket < ApplicationRecord
  validates :name, presence: true, length: {minimum: 1}, format: {with: /\p{L}/, message: "can only consist of letters."}
  validates :address, presence: true, length: {minimum: 5}
  validates :email_address, presence: true
  validates :price, presence: true, numericality: true, length: {minimum: 1}
  validates :seat_id_seq, presence: true

  belongs_to :event
  belongs_to :user

  def real_price
    if event
      event.event_date.to_date == Date.today ? event.price_high * 120.0 / 100 : price
    else
      puts "Returning just price in ticket"
      price
    end
  end
end
