class CallToActionGroup < Group
  def max_blocks
    max = super
    max.to_i >= 2 && max.to_i <= 4 ? max : 3
  end
end
