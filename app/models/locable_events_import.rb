class LocableEventsImport
  def self.import(business)
    if business.automated_import_locable_events == '1'
      locable_business = LocableBusiness.find_by_id(business.cce_id)
      if locable_business
        new(business, locable_business).import
      end
    end
  end

  def initialize(business, locable_business)
    @business = business
    @locable_business = locable_business
  end

  def import
  end
end
