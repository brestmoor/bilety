class TicketsController < ApplicationController
  before_action :set_ticket, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [:index, :show]
  before_action :correct_user, only: [:edit, :update, :destroy]
  # GET /tickets
  # GET /tickets.json
  def index
    date_from = params['date_from']
    date_to = params['date_to']

    if date_from != nil && date_to != nil && date_from != '' && date_to != ''
      @tickets = Ticket.joins(:event).where("event_date <= ? and event_date >= ?", date_to, date_from)
    elsif date_from != nil && date_from != ''
      @tickets =  Ticket.joins(:event).where("event_date >= ?", date_from)
    elsif date_to != nil && date_to != ''
      @tickets = Ticket.joins(:event).where("event_date <= ?", date_to)
    else
      @tickets = Ticket.all
    end
  end

  # GET /tickets/1
  # GET /tickets/1.json
  def show
  end

  # GET /tickets/new
  def new
    @ticket = Ticket.new
  end

  # GET /tickets/1/edit
  def edit
  end

  # POST /tickets
  # POST /tickets.json
  def create
    params = ticket_params
    @ticket = Ticket.new(params)
    @ticket.user = current_user

    if age_invalid(current_user)
      redirect_go_back('Event available only for adults.')
      return
    end

    if !@ticket.valid?
      if request.env['HTTP_REFERER'].include? 'events'
        session[:ticket] = @ticket
        session[:errors] = @ticket.errors.messages
        redirect_to request.env['HTTP_REFERER']
        return
      end
      render :new
      return
    end

    no_of_tickets = params['seat_id_seq'].split(',').count

    if no_of_tickets_invalid(no_of_tickets)
      redirect_go_back('Limit of tickets per person is 5.')
      return
    end

    if Date.today != @ticket.event.event_date.to_date
      if amount_invalid(@ticket.price, @ticket.event)
        redirect_go_back('Price needs to be between price low and price high')
        return
      end
    end

    if balance_invalid(current_user, calculate_price_for_purchase(no_of_tickets, @ticket))
      redirect_go_back('Not enough funds.')
      return
    end

    for seat in params['seat_id_seq'].split(', ')
      row = @ticket.event.rows.find_by(row_number: TicketsHelper.get_row_number(seat))
      seat = row.seats.find_by(seat_number: TicketsHelper.get_seat_number(seat))

      if seat == nil
        redirect_go_back('Provided seat number is out of range.')
        return
      end

      if seat.occupied
        redirect_go_back('Chosen seat is already taken.')
        return
      end

      seat.occupied = true
      seat.save
    end

    respond_to do |format|
      if @ticket.save
        take_from_account (calculate_price_for_purchase(no_of_tickets, @ticket)), current_user
        make_seats_occupied(@ticket, ticket_params['seat_id_seq'])

        format.html {redirect_to @ticket, notice: 'Ticket was successfully created.'}
        format.json {render :show, status: :created, location: @ticket}
      else
        format.html {render :new}
        format.json {render json: @ticket.errors, status: :unprocessable_entity}
      end
    end
  end

  def amount_invalid(price, event)
    price > event.price_high || price < event.price_low
  end

  def take_from_account(amount, user)
    user.account.balance -= amount
    user.account.save
  end

  # PATCH/PUT /tickets/1
  # PATCH/PUT /tickets/1.json
  def update
    respond_to do |format|
      prev_price = @ticket.price

      if amount_invalid(ticket_params['price'].to_f, @ticket.event)
        redirect_go_back('Price needs to be between price low and price high')
        return
      end

      if balance_invalid(current_user, -(prev_price - ticket_params['price'].to_f))
        redirect_go_back('Not enough funds.')
        return
      end

      if @ticket.update(ticket_params)
        current_user.account.balance += (prev_price - ticket_params['price'].to_f) * ticket_params['seat_id_seq'].split(',').count
        current_user.account.save
        format.html {redirect_to @ticket, notice: 'Ticket was successfully updated.'}
        format.json {render :show, status: :ok, location: @ticket}
      else
        format.html {render :edit}
        format.json {render json: @ticket.errors, status: :unprocessable_entity}
      end
    end
  end

  # DELETE /tickets/1
  # DELETE /tickets/1.json
  def destroy
    @ticket.destroy
    day_diff = Utils.days_til_now(@ticket.event.event_date)
    prev_balance = @ticket.user.account.balance.to_i
    @ticket.user.account.balance += @ticket.price * @ticket.seat_id_seq.split(',').count * (-day_diff / 30.0) * 60.0 / 100
    @ticket.user.account.save
    make_seats_free(@ticket, @ticket.seat_id_seq)
    respond_to do |format|
      format.html {redirect_back fallback_location: '', notice: "Ticket was successfully destroyed. Returned #{@ticket.user.account.balance - prev_balance}"}
      format.json {head :no_content}
    end
  end

  private
  def redirect_go_back(message)
    flash[:komunikat] = message
    flash[:class] = 'alert alert-danger'

    if request.env['HTTP_REFERER'].include? 'events'
      redirect_back fallback_location: ''
    else
      render :new
    end

  end

  def balance_invalid(user, price)
    user.account.balance - price < 0
  end

  def calculate_price_for_purchase(no_of_tickets, ticket)
    ticket.real_price * no_of_tickets
  end

  def no_of_tickets_invalid(no_of_tickets)
    get_total_no_of_tickets(@ticket.event, no_of_tickets) > 5
  end

  def get_total_no_of_tickets(event, no_of_tickets)
    tickets_already_bought = event.tickets.where(user_id: current_user.id)
    no_of_tickets_already_bought = tickets_already_bought
                                       .map {|ticket| TicketsHelper.number_of_seats(ticket)}
                                       .reduce {|first, second| first + second}

    total_no_of_tickets = no_of_tickets + (no_of_tickets_already_bought || 0)
  end

  def age_invalid(user)
    TicketsHelper.age(user.date_of_birth) < 18
  end

  def make_seats_occupied(ticket, seat_id_seq)
    for seat in seat_id_seq.split(', ')
      row = ticket.event.rows.find_by(row_number: TicketsHelper.get_row_number(seat))
      seat = row.seats.find_by(seat_number: TicketsHelper.get_seat_number(seat))
      seat.occupied = true
      seat.save
    end
  end

  def make_seats_free(ticket, id_seat_seq)
    for seat in id_seat_seq.split(', ')
      row = ticket.event.rows.find_by(row_number: TicketsHelper.get_row_number(seat))
      seat = row.seats.find_by(seat_number: TicketsHelper.get_seat_number(seat))
      seat.occupied = false
      seat.save
    end
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_ticket
    @ticket = Ticket.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def ticket_params
    params.require(:ticket).permit(:name, :seat_id_seq, :address, :price, :email_address, :phone, :event_id)
  end

  def correct_user
    if !current_user.admin
      @ticket = current_user.tickets.find_by(id: params[:id])
      redirect_to tickets_path, notice: "Nie jesteś uprawniony do edycji tego biletu" if @ticket.nil?
    end
  end
end
