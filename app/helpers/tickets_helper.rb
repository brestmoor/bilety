module TicketsHelper
  def TicketsHelper.get_row_number(seat)
    seat[0]
  end

  def TicketsHelper.get_seat_number(seat)
    seat[1..seat.length - 1]
  end

  def TicketsHelper.age(date_of_birth)
    now = Time.now.utc.to_date
    now.year - date_of_birth.year - ((now.month > date_of_birth.month || (now.month == date_of_birth.month && now.day >= date_of_birth.day)) ? 0 : 1)
  end

  def TicketsHelper.number_of_seats(ticket)
    return ticket.seat_id_seq.split(',').count
  end
end
