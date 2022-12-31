################################################################################
# Real Core - Version 0.0.1
# Created by realAfonso
################################################################################

################################################################################
# SPRITE OF DEFAULT TEXT
################################################################################

class RealDefaultText < Sprite
  attr_reader :name

  TEXT_BASE_DARK_COLOR = Color.new(52, 52, 63)
  TEXT_BASE_LIGHT_COLOR = Color.new(248, 248, 248)
  TEXT_BASE_SHADOW = Color.new(0, 0, 0)

  def initialize(command, x, y, viewport = nil, textColor = nil, maxWidth = 200, maxHeight = 20, useEssentialsTextStyle = false)
    super(viewport)
    @image = command[0]
    @name = command[1]
    @textColor = textColor
    @useEssentialsTextStyle = useEssentialsTextStyle

    @contents = BitmapWrapper.new(maxWidth, maxHeight)
    self.bitmap = @contents
    self.x = x
    self.y = y

    textSize = useEssentialsTextStyle ? 20 : 0
    Real.setOptionsFontStyle(self.bitmap, textSize, useEssentialsTextStyle)

    refresh
  end

  def dispose
    @contents.dispose
    super
  end

  def selected=(val)
    oldsel = @selected
    @selected = val
    refresh if oldsel != val
  end

  def refresh
    self.bitmap.clear

    baseColor = @useEssentialsTextStyle ? TEXT_BASE_LIGHT_COLOR : TEXT_BASE_DARK_COLOR

    textpos = [
      [
        @name,                                                # Text
        self.bitmap.text_size(@name).width + 26,              # Horizontal position
        @useEssentialsTextStyle ? 3 : 8,                      # Vertical position
        1,                                                    # Right align (1) or center align (2)
        @textColor ? @textColor : baseColor,                  # Text color
        @useEssentialsTextStyle ? TEXT_BASE_SHADOW : nil,     # Text shadow color
      ],
    ]

    pbDrawTextPositions(self.bitmap, textpos)

    old_style = "/Old Sprites" if @useEssentialsTextStyle

    imagepos = [
      [sprintf("Graphics/Plugins/Real Core#{old_style}/" + @image), 0, 0],
    ]

    pbDrawImagePositions(self.bitmap, imagepos)
  end
end

################################################################################
# SPRITE OF DEFAULT TEXT WITH MULTIPLE LINES
################################################################################

class RealDefaultTextMultiline < Sprite
  attr_reader :text

  TEXT_BASE_DARK_COLOR = Color.new(52, 52, 63)
  TEXT_BASE_LIGHT_COLOR = Color.new(248, 248, 248)
  TEXT_BASE_SHADOW = Color.new(72, 80, 88)

  def initialize(text, x, y, viewport = nil, textColor = nil, maxWidth = 200, maxHeight = 20, useEssentialsTextStyle = false)
    super(viewport)
    @maxWidth = maxWidth
    @text = text
    @textColor = textColor

    @contents = BitmapWrapper.new(maxWidth, maxHeight)
    self.bitmap = @contents
    self.x = x
    self.y = y

    textSize = useEssentialsTextStyle ? 20 : 0
    Real.setOptionsFontStyle(self.bitmap, textSize, useEssentialsTextStyle)

    refresh
  end

  def dispose
    @contents.dispose
    super
  end

  def selected=(val)
    oldsel = @selected
    @selected = val
    refresh if oldsel != val
  end

  def refresh
    self.bitmap.clear

    baseColor = @useEssentialsTextStyle ? TEXT_BASE_LIGHT_COLOR : TEXT_BASE_DARK_COLOR

    Real.drawLongText(
      self.bitmap,                                            # Overlay
      self.x,                                                 # Horizontal position
      self.y,                                                 # Vertical position
      @maxWidth,                                              # Max Width
      5,                                                      # Max line number
      @text,                                                  # Text to draw
      @textColor ? @textColor : baseColor,                    # Text color
      @useEssentialsTextStyle ? TEXT_BASE_SHADOW : nil,       # Text shadow color
    )
  end
end
