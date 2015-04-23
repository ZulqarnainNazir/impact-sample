class BlogPage < Webpage
  store_accessor :settings, :per_page

  def per_page
    super.to_i > 5 ? super.to_i : 20
  end
end
