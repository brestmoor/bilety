class Event < ApplicationRecord
  validates :artist, presence: true
  validates :price_low, presence: true
  validates :price_low, presence: true
  validates :price_high, presence: true
  validates :event_date, presence: true
  validate :event_date_not_from_past, :max_not_smaller_than_min

  has_many :tickets
  has_many :rows

  def event_date_not_from_past
    if event_date && event_date < Date.today
      errors.add('Data wydarzenia', 'nie może być z przeszłości')
    end
  end

  def max_not_smaller_than_min
    if price_high && price_low && price_high < price_low
      errors.add('Cena max', 'musi być większa niż min')
    end
  end

  def increased_price
    price_high * 120.0 / 100
  end

  def description_short
    return cut_text description
  end

  def cut_text(tekst)
    if !tekst || tekst.length <= 30
      tekst
    else
      cut(tekst)
    end
  end

  def cut(tekst)
    words = tekst.split(' ')

    length = 0
    final_word = ''
    for i in 0..words.length-1
      if length + 1 + words[i].length + 3 > 25;
        final_word << '...'
        break
      else
        final_word << ' ' + words[i]
        length += words[i].length + 1
      end
    end

    final_word
  end

  def empty
    if !rows || rows.empty?
      return true
    end
    for row in rows
      for seat in row.seats
        if seat.occupied
          return false
        end
      end
    end
    true
  end

end
