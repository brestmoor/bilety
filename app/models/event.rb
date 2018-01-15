class Event < ApplicationRecord
  validates :artist, presence: true
  validates :price_low, presence: true
  validates :price_low, presence: true
  validates :price_high, presence: true
  validates :event_date, presence: true
  validate :event_date_not_from_past, :max_not_smaller_than_min

  has_many :tickets

  def event_date_not_from_past
    puts 'TEST'
    if event_date < Date.today
      errors.add('Data wydarzenia', 'nie może być z przeszłości')
    end
  end

  def max_not_smaller_than_min
    if price_high < price_low
      errors.add('Cena max', 'musi być większa niż min')
    end
  end

end
