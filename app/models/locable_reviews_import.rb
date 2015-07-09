class LocableReviewsImport
  def self.import(business)
    if business.automated_import_locable_reviews == '1'
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
    @locable_business.reviews.map do |locable_review|
      @business.reviews.where(
        external_type: 'locable',
        external_id: locable_review.id,
      ).first_or_initialize.tap do |review|
        review.assign_attributes(
          external_name: @locable_business.site.name,
          external_url: "#{@locable_business.locable_url}/reviews/#{locable_review.id}",
          customer_name: locable_review.user.name,
          customer_email: locable_review.user.email,
          customer_phone: locable_review.user.phone,
          title: locable_review.title,
          description: locable_review.body,
          quality_rating: locable_review.quality_rating,
          value_rating: locable_review.value_rating,
          service_rating: locable_review.service_rating,
          overall_rating: locable_review.overall_rating,
          published: !!@business.automated_reviews_publishing && locable_review.overall_rating >= @business.automated_reviews_publishing,
          reviewed_at: locable_review.created_at,
          serviced_at: locable_review.date_of_service,
        )
        review.save
      end
    end
  end
end
