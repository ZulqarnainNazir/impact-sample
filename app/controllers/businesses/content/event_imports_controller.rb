class Businesses::Content::EventImportsController < Businesses::Content::BaseController
  before_action do
    @locable_business = LocableBusiness.find_by_id(@business.cce_id) if @business.cce_id?
  end

  def import_all
    redirect_to [@business, :content_event_imports], alert: 'TODO'
  end

  def import
    redirect_to [@business, :content_event_imports], alert: 'TODO'
  end
end
