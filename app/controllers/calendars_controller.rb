class CalendarsController < ApplicationController
  before_action :set_calendar, only: %i[ show update destroy ]

  # GET /calendars
  # GET /calendars.json
  def index
    @calendars = Calendar.all
  end

  # GET /calendars/1
  # GET /calendars/1.json
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
    def set_calendar
      @calendar = Calendar.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def calendar_params
      params.require(:calendar).permit(:user_id, :access_role, :background_color, :color_id, :description, :default_reminders, :conference_properties, :etag, :foreground_color, :remote_id, :kind, :selected, :summary, :summary_override, :primary, :deleted, :hidden, :time_zone, :notification_settings, :location, :can_edit, :can_share, :can_view_private_items, :change_key, :allowed_online_meeting_providers, :web_link, :default_online_meeting_provider, :is_tallying_responses, :is_default_calendar, :is_removable, :owner_name, :owner_email, :status)
    end
end
