SitemapGenerator::Sitemap.adapter = SitemapGenerator::S3Adapter.new(
  fog_provider: 'AWS',
  fog_region: Rails.application.secrets.aws_s3_region,
  fog_directory: Rails.application.secrets.aws_s3_bucket,
  aws_access_key_id: Rails.application.secrets.aws_access_key_id,
  aws_secret_access_key: Rails.application.secrets.aws_secret_access_key,
)
#http://s3-us-east-1.amazonaws.com/impact-staging/sitemaps/10/sitemap.xml.gz
SitemapGenerator::Sitemap.public_path = 'tmp/'
SitemapGenerator::Sitemap.sitemaps_host = "https://s3.amazonaws.com/#{Rails.application.secrets.aws_s3_bucket}/"
#{}"https://#{Rails.application.secrets.aws_s3_bucket}.s3-us-west-2.amazonaws.com/sitemap_generator"
#https://s3.amazonaws.com/impact-staging/sitemaps/3/sitemap.xml.gz
#SitemapGenerator::Sitemap.sitemaps_path = "sitemaps/"
Business.find_each do |business|
  website = business.try(:website)
  next if website.nil?

  webhost = website.webhosts.first
  if webhost.present?
  #   @map = SitemapGenerator::Sitemap.default_host = "http://#{website.subdomain}.#{Rails.application.secrets.host}"
  # else
    SitemapGenerator::Sitemap.sitemaps_path = "sitemaps/" + business.id.to_s+"/"
    SitemapGenerator::Sitemap.default_host = "http://#{webhost.name}"
    # SitemapGenerator::Sitemap.namer = SitemapGenerator::SimpleNamer.new(business.sitemap_name)
    SitemapGenerator::Sitemap.create do

      SitemapGenerator::Interpreter.send :include, ExternalUrlHelper
      SitemapGenerator::Interpreter.send :include, WebsiteHelper

      add website_root_path, :lastmod => website.updated_at unless website.home_page.try(:settings).try(:no_index)
      add website_about_page_path, :lastmod => website.updated_at unless website.about_page.try(:settings).try(:no_index)
      add website_blog_page_path, :lastmod => website.updated_at unless website.blog_page.try(:settings).try(:no_index)
      add website_contact_page_path, :lastmod => website.updated_at unless website.contact_page.try(:settings).try(:no_index)
      add website_galleries_path, :lastmod => website.updated_at unless website.blog_page.try(:settings).try(:no_index)
      add website_reviews_path, :lastmod => website.updated_at unless website.blog_page.try(:settings).try(:no_index)
      
      website.business.before_afters.find_each do |before_after|
        next if website.business.before_afters.empty?
        add "/#{path_to_external_content(before_after)}", :lastmod => before_after.updated_at
        #add website_before_after_path(before_after), :lastmod => before_after.updated_at
      end

      website.custom_pages.find_each do |page|
        next if website.custom_pages.empty?
        add "/#{page.pathname}", :lastmod => page.updated_at
      end

      website.business.categories.find_each do |content_category|
        next if website.business.categories.empty?
        add website_content_category_path(content_category), :lastmod => content_category.updated_at
      end
      website.business.events.find_each do |event|
        next if website.business.events.empty?
        add "/#{path_to_external_content(event)}", :lastmod => event.updated_at  
        #add website_event_path(event), :lastmod => event.updated_at
      end
      website.business.offers.find_each do |offer|
        next if website.business.offers.empty?
        add "/#{path_to_external_content(offer)}", :lastmod => offer.updated_at   
        #add website_offer_path(offer), :lastmod => offer.updated_at
      end
      website.business.posts.find_each do |post|
        next if website.business.posts.empty?
        add "/#{path_to_external_content(post)}", :lastmod => post.updated_at   
        #add website_post_path(post), :lastmod => post.updated_at
      end
      website.business.quick_posts.find_each do |quick_post|
        next if website.business.quick_posts.empty?
        add "/#{path_to_external_content(quick_post)}", :lastmod => quick_post.updated_at   
        #add website_quick_post_path(quick_post), :lastmod => quick_post.updated_at
      end
      website.business.reviews.find_each do |review|
        next if website.business.reviews.empty?  
        add website_review_path(review), :lastmod => review.updated_at
      end
      website.business.galleries.find_each do |gallery|
        next if website.business.galleries.empty?
        add "/#{path_to_external_content(gallery)}", :lastmod => gallery.updated_at   
        #add website_gallery_path(gallery), :lastmod => gallery.updated_at
        gallery.gallery_images.find_each do |image|
          next if gallery.gallery_images.empty?  
          add website_gallery_gallery_image_path(gallery, image), :lastmod => image.updated_at
        end
      end
    end
    SitemapGenerator::Sitemap.ping_search_engines
  end
end
