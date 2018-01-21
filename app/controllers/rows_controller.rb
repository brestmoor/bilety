class RowsController < ApplicationController
  def index
    event_id = params.require(:event_id)
    @rows = Row.where(event_id: event_id)
    puts @rows
  end
end
