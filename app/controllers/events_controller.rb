class EventsController < ApplicationController
  before_action :check_logged_in, only: [:new, :create]
  before_action :set_event, only: [:show, :edit, :update]

  def index
    if user_signed_in? && current_user.admin
      @events = Event.all
    else
      @events = Event.where("event_date < ? and event_date >= ?", Utils.date_in_no_of_days(Date.today, 30), Date.today)
    end
  end

  def new
    @event = Event.new
  end

  def edit
    puts 'to event', @event
  end

  def update
    if @event.update(event_params.except(:rows, :seats_in_row))
      @event.rows = []
      build_seats(params['rows'].to_i, params['seats_in_row'].to_i, @event)
      redirect_to @event, notice: 'Event was successfully updated.'
    end
  end

  def create
    params = event_params
    @event = Event.new(params.except(:rows, :seats_in_row))

    build_seats(params['rows'].to_i, params['seats_in_row'].to_i, @event)

    if @event.save
      flash[:komunikat] = 'Event został poprawnie stworzony.'
      redirect_to "/events/#{@event.id}"
    else
      render 'new'
    end
  end

  def show
    if session[:errors] && !session[:errors].empty? && session[:ticket] && !session[:ticket].empty?
      errors = session[:errors]
      @ticket = Ticket.new(session[:ticket])
      errors.each {|key, value| value.each {|message| @ticket.errors[key] << message}}
      session[:ticket] = nil
      session[:errors] = nil
    else
      @ticket = Ticket.new(event_id: @event.id)
    end
  end

  private
  def build_seats(rows_no, seats_no, event)
    alphabet = ('a'..'z').to_a + ('A'..'Z').to_a
    for i in 0..rows_no - 1
      row = Row.new(row_number: alphabet[i])
      for j in 1..seats_no
        row.seats << Seat.new(occupied: false, seat_number: j)
      end
      event.rows << row
    end
  end

  def set_event
    @event = Event.find(params[:id])
  end

  def event_params
    params.require(:event).permit(:artist, :description, :price_low, :price_high, :event_date, :rows, :seats_in_row, :adults_only)
  end

  def check_logged_in
    authenticate_or_request_with_http_basic ("Ads") do |username, password|
      username == "admin" && password == "admin"
    end
  end

end
