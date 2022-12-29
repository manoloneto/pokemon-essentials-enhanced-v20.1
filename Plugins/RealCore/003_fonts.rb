################################################################################
# Real Core - Version 0.0.1
# Created by realAfonso
################################################################################

module Real
  def self.setDefaultFontStyle(bitmap, size = 0)
    bitmap.font.name = MessageConfig.pbTryFonts(DEFAULT_FONT_NAME)
    bitmap.font.size = size == 0 ? DEFAULT_FONT_SIZE : size
    bitmap.text_offset_y = DEFAULT_FONT_Y_OFFSET
  end

  def self.setOptionsFontStyle(bitmap, size = 0)
    bitmap.font.name = MessageConfig.pbTryFonts(OPTIONS_FONT_NAME)
    bitmap.font.size = size == 0 ? OPTIONS_FONT_SIZE : size
    bitmap.text_offset_y = DEFAULT_FONT_Y_OFFSET
  end
end
