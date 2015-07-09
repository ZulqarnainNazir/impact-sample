class LocableEventsExport
  def self.export(business)
    if business.automated_export_locable_events == '1'
      locable_business = LocableBusiness.find_by_id(business.cce_id)
      if locable_business
        new(business, locable_business).export
      end
    end
  end

  def initialize(business, locable_business)
    @business = business
    @locable_business = locable_business
  end

  def export
    @business.event_definitions.map do |event_definition|
    end
  end
end
