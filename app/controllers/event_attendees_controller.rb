class EventAttendeesController < ApplicationController
  before_action :set_event_attendee, only: %i[ show update destroy ]

  # GET /event_attendees
  # GET /event_attendees.json
  def index
    @event_attendees = EventAttendee.all
  end

  # GET /event_attendees/1
  # GET /event_attendees/1.json
  def show
  end

  # POST /event_attendees
  # POST /event_attendees.json
  def create
    @event_attendee = EventAttendee.new(event_attendee_params)

    if @event_attendee.save
      render :show, status: :created, location: @event_attendee
    else
      render json: @event_attendee.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /event_attendees/1
  # PATCH/PUT /event_attendees/1.json
  def update
    if @event_attendee.update(event_attendee_params)
      render :show, status: :ok, location: @event_attendee
    else
      render json: @event_attendee.errors, status: :unprocessable_entity
    end
  end

  # DELETE /event_attendees/1
  # DELETE /event_attendees/1.json
  def destroy
    @event_attendee.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event_attendee
      @event_attendee = EventAttendee.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def event_attendee_params
      params.require(:event_attendee).permit(:event_id, :remote_id, :email, :organizer, :response_status, :is_self, :comment, :resource, :optional, :additional_guests, :display_name, :type, :response_status_time)
    end
end
