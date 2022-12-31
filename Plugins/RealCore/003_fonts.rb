################################################################################
# Real Core - Version 0.0.1
# Created by realAfonso
################################################################################

module Real

  ################################################################################
  # DEFAULT FONT STYLE FOR REAL MODULE
  ################################################################################

  def self.setDefaultFontStyle(bitmap, size = 0, useEssentialsTextStyle = false)
    if useEssentialsTextStyle
      pbSetSystemFont(bitmap)
      bitmap.font.size = size if size && size != 0
    else
      bitmap.font.name = MessageConfig.pbTryFonts(OPTIONS_FONT_NAME)
      bitmap.font.size = size && size == 0 ? DEFAULT_FONT_SIZE : size
      bitmap.text_offset_y = DEFAULT_FONT_Y_OFFSET
    end
  end

  ################################################################################
  # DEFAULT FONT STYLE FOR OPTIONS (INFORMATION)
  ################################################################################

  def self.setOptionsFontStyle(bitmap, size = 0, useEssentialsTextStyle = false)
    if useEssentialsTextStyle
      pbSetSystemFont(bitmap)
      bitmap.font.size = size if size && size != 0
    else
      bitmap.font.name = MessageConfig.pbTryFonts(OPTIONS_FONT_NAME)
      bitmap.font.size = size && size == 0 ? OPTIONS_FONT_SIZE : size
      bitmap.text_offset_y = DEFAULT_FONT_Y_OFFSET
    end
  end
end
