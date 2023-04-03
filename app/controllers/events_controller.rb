class EventsController < ApplicationController
  before_action :set_event, only: %i[ show update destroy ]

  # GET /events
  # GET /events.json
  def index
    @events = Event.where(user_id: current_user.id)
  end

  # GET /events/1
  # GET /events/1.json
  def show
  end

  # POST /events
  # POST /events.json
  def create
    @event = Event.new(event_params)
    @event.recurrence = TreatRecurrenceService.to_ical_format(@event.recurrence, @event.starts_at, @event.finishes_at)

    if @event.save
      SyncGoogleUserEventsWorker.perform_async(current_user.id, @event.calendar_id, @event.id, 'create')
      render :show, status: :created, location: @event
    else
      render json: @event.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /events/1
  # PATCH/PUT /events/1.json
  def update
    if @event.update(event_params)
      SyncGoogleUserEventsWorker.perform_async(current_user.id, @event.calendar_id, @event.id, 'update')
      render :show, status: :ok, location: @event
    else
      render json: @event.errors, status: :unprocessable_entity
    end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    @event.destroy
    SyncGoogleUserEventsWorker.perform_async(current_user.id, @event.calendar_id, @event.id, 'delete')
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def event_params
      params.require(:event).permit(:user_id, :calendar_id, :remote_created_at, :remote_updated_at, :starts_at, :starts_at_timezone, :finishes_at, :finishes_at_timezone, :self_sequence, :location, :description, :creator_email, :creator_id, :creator_display_name, :self_created, :etag, :event_type, :web_link, :i_cal_uid, :remote_id, :kind, :organizer_email, :organizer_id, :organizer_display_name, :self_organized, :reminders, :status, :summary, :transparency, :allow_new_time_proposals, :body_content_type, :body_content, :categories, :change_key, :has_attachments, :importance, :is_all_day, :is_cancelled, :is_draft, :is_online_meeting, :is_organizer, :end_time_unspecified, :is_reminder_on, :locations, :online_meeting, :online_meeting_provider, :online_meeting_url, :original_starts_at, :original_timezone_starts_at, :reminder_minutes_before_start, :series_master_id, :response_status_text, :response_status_time, :response_requested, :show_as, :transaction_id, :visibility, :attendees_omitted, :extended_properties, :hangout_link, :conference_data, :gadget, :anyone_can_add_self, :guests_can_invite_others, :guests_can_modify, :guests_can_see_other_guests, :private_copy, :locked, :source_url, :source_title, :color_id, :working_location_properties, :attachments, :original_finishes_at_timezone, event_attendees_attributes: [:email, :display_name, :comment, :resource, :optional, :response_status, :is_self, :organizer], :recurrence => {})
    end
end
