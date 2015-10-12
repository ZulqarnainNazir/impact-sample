class FacebookReviewsExportJob < ApplicationJob
  include Rails.application.routes.url_helpers

  def perform(business)
    if business.facebook_id? && business.facebook_token? && business.automated_export_facebook_reviews == '1'
      graph = Koala::Facebook::API.new(business.facebook_token)

      business.reviews.published.each do |review|
        if review.facebook_id?
          begin
            graph.put_connections review.facebook_id, review_data(review)
          rescue Koala::Facebook::ServerError => e
            if e.fb_error_code == 100 && e.fb_error_subcode == 1607025
              graph.put_connections review.facebook_id, review_data(review).except(:backdated_time)
            end
          end
        else
          begin
            result = graph.put_connections business.facebook_id, 'feed', review_data(review)
            review.update_column :facebook_id, result['id']
          rescue Koala::Facebook::ServerError => e
            if e.fb_error_code == 100 && e.fb_error_subcode == 1607025
              result = graph.put_connections business.facebook_id, 'feed', review_data(review).except(:backdated_time)
              review.update_column :facebook_id, result['id']
            end
          end
        end
      end
    end
  end

  def review_data(review)
    {
      backdated_time: review.created_at,
      caption: Sanitize.fragment(review.description, Sanitize::Config::DEFAULT),
      link: website_review_url(review, host: website_host(review.business.website)),
      name: review_stars(review.overall_rating) + review.title,
    }
  end

  def review_stars(rating)
    case rating.to_i
    when 0
      '☆☆☆☆☆ '
    when 1
      '★☆☆☆☆ '
    when 2
      '★★☆☆☆ '
    when 3
      '★★★☆☆ '
    when 4
      '★★★★☆ '
    when 5
      '★★★★★ '
    else
      ''
    end
  end
end
