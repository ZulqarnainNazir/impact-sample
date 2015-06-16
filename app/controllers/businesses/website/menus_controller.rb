class Businesses::Website::MenusController < Businesses::Website::BaseController
  include RequiresWebPlanConcern

  before_action do
    params[:website] ||= {}
    params[:website][:nav_links_attributes] ||= {}
  end

  def update
    update_resource @website, nav_links_params, location: [:edit, @business, :website_menus] do |success|
      if success
        fix_nav_links_parent_ids(@website.nav_links)
        intercom_event 'edited-website-navigation'
      end
    end
  end

  private

  def nav_links_params
    params.require(:website).permit(
      nav_links_attributes: [
        :id,
        :key,
        :parent_key,
        :position,
        :kind,
        :location,
        :label,
        :url,
        :internal_value,
      ]
    ).tap do |safe_params|
      existing_ids = @website.nav_link_ids
      provided_ids = safe_params[:nav_links_attributes].map { |_, attr| attr[:id] }.reject(&:blank?).map(&:to_i)

      (existing_ids - provided_ids).each do |removed_id|
        safe_params[:nav_links_attributes][rand*10**10] = { id: removed_id, _destroy: '1' }
      end
    end
  end

  def fix_nav_links_parent_ids(nav_links)
    nav_links.each do |nav_link|
      if nav_link.parent_key.present?
        parent = nav_links.find { |s| s.key == nav_link.parent_key }
        if parent
          nav_link.update! parent_id: parent.id
        end
      else
        nav_link.update! parent_id: nil
      end
    end
  end
end
