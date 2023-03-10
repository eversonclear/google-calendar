class GoogleEventsController < ApplicationController
  before_action :set_google_event, only: %i[ show update destroy ]

  # GET /google_events
  # GET /google_events.json
  def index
    events = service_google_calendar.get_all_events
    render json: { calendars: events}
  end

  # GET /google_events/1
  # GET /google_events/1.json
  def show
  end

  # POST /google_events
  # POST /google_events.json
  def create
    @google_event = GoogleEvent.new(google_event_params)

    if @google_event.save
      render :show, status: :created, location: @google_event
    else
      render json: @google_event.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /google_events/1
  # PATCH/PUT /google_events/1.json
  def update
    if @google_event.update(google_event_params)
      render :show, status: :ok, location: @google_event
    else
      render json: @google_event.errors, status: :unprocessable_entity
    end
  end

  # DELETE /google_events/1
  # DELETE /google_events/1.json
  def destroy
    @google_event.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_google_event
      @google_event = GoogleEvent.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def google_event_params
      params.require(:google_event).permit(:organizer, :starts_at, :finishes_at, :title, :status, :description, :participants)
    end

    def service_google_calendar
      auth = AccessTokenService.new current_user.google_token
      @service_google_calendar ||= GoogleCalendarService.new(auth)
    end
end
