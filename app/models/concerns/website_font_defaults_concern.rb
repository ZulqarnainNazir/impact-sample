module WebsiteFontDefaultsConcern
  extend ActiveSupport::Concern

  def h1_font_desk_size_value
    self.h1_font_desk_size.blank? ? '36' : self.h1_font_desk_size
  end

  def h1_font_mobile_size_value
    self.h1_font_mobile_size.blank? ? '36' : self.h1_font_mobile_size
  end

  def h2_font_desk_size_value
    self.h2_font_desk_size.blank? ? '30' : self.h2_font_desk_size
  end

  def h2_font_mobile_size_value
    self.h2_font_mobile_size.blank? ? '30' : self.h2_font_mobile_size
  end

  def h3_font_desk_size_value
    self.h3_font_desk_size.blank? ? '24' : self.h3_font_desk_size
  end

  def h3_font_mobile_size_value
    self.h3_font_mobile_size.blank? ? '24' : self.h3_font_mobile_size
  end

  def h4_font_desk_size_value
    self.h4_font_desk_size.blank? ? '18' : self.h4_font_desk_size
  end

  def h4_font_mobile_size_value
    self.h4_font_mobile_size.blank? ? '18' : self.h4_font_mobile_size
  end

  def h5_font_desk_size_value
    self.h5_font_desk_size.blank? ? '14' : self.h5_font_desk_size
  end

  def h5_font_mobile_size_value
    self.h5_font_mobile_size.blank? ? '14' : self.h5_font_mobile_size
  end

  def h6_font_desk_size_value
    self.h6_font_desk_size.blank? ? '12' : self.h6_font_desk_size
  end

  def h6_font_mobile_size_value
    self.h6_font_mobile_size.blank? ? '12' : self.h6_font_mobile_size
  end

  def paragraph_font_desk_size_value
    self.paragraph_font_desk_size.blank? ? '16' : self.paragraph_font_desk_size
  end

  def paragraph_font_mobile_size_value
    self.paragraph_font_mobile_size.blank? ? '16' : self.paragraph_font_mobile_size
  end

  def blockquote_font_desk_size_value
    self.blockquote_font_desk_size.blank? ? '18' : self.blockquote_font_desk_size
  end

  def blockquote_font_mobile_size_value
    self.blockquote_font_mobile_size.blank? ? '18' : self.blockquote_font_mobile_size
  end

  def lead_font_desk_size_value
    self.lead_font_desk_size.blank? ? '21' : self.lead_font_desk_size
  end

  def lead_font_mobile_size_value
    self.lead_font_mobile_size.blank? ? '20' : self.lead_font_mobile_size
  end
end
