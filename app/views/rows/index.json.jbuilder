json.rows @rows do |row|
  json.id = row.id
  json.event_id = row.event_id
  json.row_number = row.row_number

  json.seats row.seats do |seat|
    json.id = seat.id
    json.row_id = seat.row_id
    json.occupied = seat.occupied
    json.seat_number = seat.seat_number
  end
end