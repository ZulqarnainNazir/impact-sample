SitemapGenerator::Sitemap.adapter = SitemapGenerator::S3Adapter.new(
  fog_provider: 'AWS',
  fog_region: ENV['AWS_S3_REGION'],
  fog_directory: ENV['AWS_S3_BUCKET'],
  aws_access_key_id: ENV['AWS_ACCESS_KEY_ID'],
  aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
)
SitemapGenerator::Sitemap.public_path = 'tmp/'
SitemapGenerator::Sitemap.sitemaps_host = "http://#{ENV['AWS_S3_BUCKET']}.s3-#{ENV['AWS_S3_REGION']}.amazonaws.com/sitemap_generator"

Website.find_each do |website|
  webhost = website.webhosts.try(:find_by, :primary => true).try(:name)
  if subdomain.nil?
    SitemapGenerator::Sitemap.default_host = "http://#{website.subdomain}.#{Rails.application.secrets.host}"
  end
  SitemapGenerator::Sitemap.default_host = "http://#{webhost}"
  SitemapGenerator::Sitemap.sitemaps_path = "sitemaps/#{website.id}"


  SitemapGenerator::Sitemap.create do
    add website_root_path(website), :lastmod => website.updated_at unless website.home_page.try(:settings).try(:no_index)
    add website_about_page_path(website), :lastmod => website.updated_at unless website.about_page.try(:settings).try(:no_index)
    add website_blog_page_path(website), :lastmod => website.updated_at unless website.blog_page.try(:settings).try(:no_index)
    add website_contact_page_path(website), :lastmod => website.updated_at unless website.contact_page.try(:settings).try(:no_index)
    add new_website_feedback_path(website), :lastmod => website.updated_at unless website.blog_page.try(:settings).try(:no_index)
    add website_share_path(website), :lastmod => website.updated_at
    add website_events_path(website), :lastmod => website.updated_at unless website.blog_page.try(:settings).try(:no_index)
    add website_galleries_path(website), :lastmod => website.updated_at unless website.blog_page.try(:settings).try(:no_index)
    add website_reviews_path(website), :lastmod => website.updated_at unless website.blog_page.try(:settings).try(:no_index)
    add new_website_review_path(website), :lastmod => website.updated_at unless website.blog_page.try(:settings).try(:no_index)

    website.business.before_afters.find_each do |before_after|
      add website_before_after_path(before_after), :lastmod => before_after.updated_at
    end

    website.custom_pages.find_each do |page|
      add website_custom_page_path(page), :lastmod => page.updated_at
    end

    website.business.categories.find_each do |content_category|
      add website_content_category_path(content_category), :lastmod => content_category.updated_at
    end
    website.business.events.find_each do |event|
      add website_event_path(event), :lastmod => event.updated_at
    end
    website.business.offers.find_each do |offer|
      add website_offer_path(offer), :lastmod => offer.updated_at
    end
    website.business.posts.find_each do |post|
      add website_post_path(post), :lastmod => post.updated_at
    end
    website.business.quick_posts.find_each do |quick_post|
      add website_quick_post_path(quick_post), :lastmod => quick_post.updated_at
    end
    website.business.reviews.find_each do |review|
      add website_review_path(review), :lastmod => review.updated_at
    end
    website.business.galleries.find_each do |gallery|
      add website_gallery_path(gallery), :lastmod => gallery.updated_at
      gallery.gallery_images.find_each do |image|
        add website_gallery_gallery_image_path(gallery, image), :lastmod => image.updated_at
      end
    end
  end
end
