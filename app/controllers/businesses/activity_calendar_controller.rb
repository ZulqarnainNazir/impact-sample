class Businesses::ActivityCalendarController < Businesses::BaseController
  # before_action -> { confirm_module_activated(0) }, except: :timeline
  def index
    @events = service.calendar_events
  end

  def timeline
    params[:future] ||= true unless params[:past]

    @events = service.timeline_events(params[:page], params[:future], params[:past])
  end

  private

  def service
    @service ||= ActivityCalendar.new(business: @business)
  end
end
