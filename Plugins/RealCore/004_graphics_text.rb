################################################################################
# Real Core - Version 0.0.1
# Created by realAfonso
################################################################################

class RealDefaultText < Sprite
  attr_reader :name

  TEXT_BASE_COLOR = Color.new(52, 52, 63)

  def initialize(command, x, y, viewport = nil, textColor = nil, maxWidth = 200, maxHeight = 20)
    super(viewport)
    @image = command[0]
    @name = command[1]
    @textColor = textColor

    @contents = BitmapWrapper.new(maxWidth, maxHeight)
    self.bitmap = @contents
    self.x = x
    self.y = y
    Real.setOptionsFontStyle(self.bitmap)
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
    textpos = [
      [
        @name,                                                # Text
        self.bitmap.text_size(@name).width + 26,              # Horizontal position
        8,                                                    # Vertical position
        1,                                                    # Right align (1) or center align (2)
        @textColor ? @textColor : TEXT_BASE_COLOR,            # Text color
      ],
    ]
    pbDrawTextPositions(self.bitmap, textpos)
    imagepos = [
      [sprintf("Graphics/Pictures/Real Quest System/" + @image), 0, 0],
    ]
    pbDrawImagePositions(self.bitmap, imagepos)
  end
end

class RealDefaultTextMultiline < Sprite
  attr_reader :text

  TEXT_BASE_COLOR = Color.new(52, 52, 63)

  def initialize(text, x, y, viewport = nil, textColor = nil, maxWidth = 200, maxHeight = 20)
    super(viewport)
    @maxWidth = maxWidth
    @text = text
    @textColor = textColor

    @contents = BitmapWrapper.new(maxWidth, maxHeight)
    self.bitmap = @contents
    self.x = x
    self.y = y
    Real.setOptionsFontStyle(self.bitmap)
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
    Real.drawLongText(
      self.bitmap,                                            # Overlay
      self.x,                                                 # Horizontal position
      self.y,                                                 # Vertical position
      @maxWidth,                                              # Max Width
      5,                                                      # Max line number
      @text,                                                  # Text to draw
      @textColor ? @textColor : TEXT_BASE_COLOR,              # Text color
    )
  end
end
