class CalendarsController < ApplicationController
  before_action :set_calendar, only: %i[ show update destroy ]
  before_action :refresh_token_if_invalid
  before_action :set_google_calendar_service

  # GET /calendars
  # GET /calendars.json
  def index
      google_calendars
  end

  # GET /calendars/1
  # GET /calendars/1.json
  def google_calendars
    calendars = @google_calendar_service.list_calendar_lists
    render json: calendars.items.to_json
  end

  def import_google_calendar
    PullUserGoogleCalendarsWorker.perform_sync(current_user.id, params[:calendar_ids])
  end

  def show
  end

  # POST /calendars
  # POST /calendars.json
  def create
    @calendar = Calendar.new(calendar_params)

    if @calendar.save
      render :show, status: :created, location: @calendar
    else
      render json: @calendar.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /calendars/1
  # PATCH/PUT /calendars/1.json
  def update
    if @calendar.update(calendar_params)
      render :show, status: :ok, location: @calendar
    else
      render json: @calendar.errors, status: :unprocessable_entity
    end
  end

  # DELETE /calendars/1
  # DELETE /calendars/1.json
  def destroy
    @calendar.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.

    def set_google_calendar_service
      token = AccessTokenService.new current_user.google_token

      @google_calendar_service = Google::Apis::CalendarV3::CalendarService.new
      @google_calendar_service.authorization = token
    end

    def set_calendar
      @calendar = Calendar.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def calendar_params
      params.require(:calendar).permit(:user_id, :access_role, :background_color, :color_id, :description, :default_reminders, :conference_properties, :etag, :foreground_color, :remote_id, :kind, :selected, :summary, :summary_override, :primary, :deleted, :hidden, :time_zone, :notification_settings, :location, :can_edit, :can_share, :can_view_private_items, :change_key, :allowed_online_meeting_providers, :web_link, :default_online_meeting_provider, :is_tallying_responses, :is_default_calendar, :is_removable, :owner_name, :owner_email, :status, :should_sync)
    end
end
