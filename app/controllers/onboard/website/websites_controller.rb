class Onboard::Website::WebsitesController < Onboard::Website::BaseController
  before_action do
    @business = current_user.authorized_businesses.find(params[:business_id])

    unless @business.location && @business.website
      redirect_to [@website, :dashboard], alert: 'No Location or Website Found'
    end

    unless @business.website.home_page
      @business.website.create_home_page!(
        active: true,
        name: 'Homepage',
        pathname: '',
        title: @business.name,
      )
    end

    unless @business.website.about_page
      @business.website.create_about_page!(
        active: true,
        name: 'About',
        pathname: 'about',
        title: "About #{@business.name}",
        about_block_attributes: {
          heading: @business.name,
          text: [
            @business.values,
            @business.history,
            @business.vision,
          ].reject(&:blank?).join("\n\n"),
        },
      )
    end

    unless @business.website.blog_page
      @business.website.create_blog_page!(
        active: true,
        name: 'Blog',
        pathname: 'blog',
        title: "#{@business.name} Blog",
        feed_block_attributes: { items_limit: 3 },
      )
    end

    unless @business.website.contact_page
      @business.website.create_contact_page!(
        active: true,
        name: 'Contact',
        pathname: 'contact',
        title: "Contact #{@business.name}",
      )
    end

    @business.lines.each do |line|
      unless @business.website.webpages.find { |page| page.external_line_id == line.id }
        ActiveRecord::Base.transaction do
          images = line.line_images.map(&:line_image)
          image = images.first
          line_page = @business.website.webpages.create!(
            active: true,
            type: 'CustomPage',
            title: line.title,
            external_line_id: line.id,
            hero_block_attributes: {
              heading: line.title,
              text: line.description,
              hero_block_image_placement_attributes: {
                image_id: image.try(:id),
              },
            },
            specialty_blocks_attributes: [
              heading: line.delivery_experience,
              text: line.delivery_process,
            ],
            content_blocks_attributes: [
              line.customer_description,
              line.customer_problem,
              line.customer_benefit,
              line.uniqueness,
            ].reject(&:blank?).map { |text| { text: text }},
          )
          @business.website.home_page.update! call_to_action_blocks_attributes: [
            {
              heading: line.title,
              text: line.description,
              link_version: 1,
              link: line_page,
              link_label: 'Learn More',
              call_to_action_block_image_placement_attributes: {
                image_id: image.try(:id),
              },
            },
          ]
          offer = @business.offers.new(
            title: "20% off your next purchase of #{line.title}",
            offer: "#{line.customer_description? ? line.customer_description : 'The ideal customer'} will love saving on #{line.title}",
            description: line.customer_benefit,
            terms: 'Not to be combined with any other offer. No Cash Value. Always Awesome.',
            offer_image_placement_attributes: { image_id: image.try(:id) },
          )
          offer.save!(validate: false)
          if images.length > 4
            @business.galleries.create!(
              title: line.title,
              gallery_images_attributes: images.map do |image|
                {
                  gallery_image_placement_attributes: {
                    image_id: image.id,
                  },
                }
              end,
            )
          end
        end
      end
    end

    update_nav_links
  end

  def update
    update_resource @business.website, website_params, location: [:edit_onboard_website, @business, :theme] do |success|
      update_nav_links if success
    end
  end

  private

  def website_params
    params.require(:website).permit(
      webpages_attributes: [
        :type,
        :title,
        :_destroy,
      ],
    )
  end

  def update_nav_links
    @business.website.webpages.each do  |webpage|
      unless webpage.is_a?(HomePage)
        header_link = @business.website.nav_links.header.where(webpage_id: webpage.id).first
        footer_link = @business.website.nav_links.footer.where(webpage_id: webpage.id).first
        @business.website.nav_links.create(location: 'header', kind: 'internal', webpage_id: webpage.id, position: @business.website.nav_links.header.roots.count + 1) unless header_link
        @business.website.nav_links.create(location: 'footer', kind: 'internal', webpage_id: webpage.id, position: @business.website.nav_links.footer.roots.count + 1) unless footer_link
      end
    end
  end
end
