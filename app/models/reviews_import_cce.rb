class ReviewsImportCce
  def self.import(business)
    if business.cce_id? && business.reviews_automation_cce == '1'
      new(business).import
    end
  end

  def initialize(business)
    @business = business
  end

  def import
    token = ConnectToken.encode(business_id: @business.cce_id)
    uri = URI(ENV['CONNECT_URL'] + '/reviews')
    uri.query = URI.encode_www_form({ token: token })
    response = Net::HTTP.get_response(uri)

    if response.is_a?(Net::HTTPSuccess)
      payload = ConnectToken.decode(response.body)

      payload[:reviews].each do |result|
        import_review(result[:review])
      end
    end
  end

  private

  def import_review(attributes)
    review = @business.reviews.where(external_type: 'cce', external_id: attributes[:id]).first_or_initialize
    review.assign_attributes(
      external_name: attributes[:site_name],
      external_url: attributes[:display_full_url],
      external_user_id: attributes[:user_id],
      external_user_name: attributes[:user_name],
      title: attributes[:title],
      description: attributes[:body],
      rating: attributes[:overall_rating],
      reviewed_at: attributes[:created_at],
    )
    review.save!
  end
end
