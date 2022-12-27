################################################################################
# Real Core - Version 0.0.1
# Created by realAfonso
################################################################################

module Real
  def self.color(color)
    return Color.new(0, 0, 0) if color == :BLACK
    return Color.new(255, 115, 115) if color == :LIGHTRED
    return Color.new(245, 11, 11) if color == :RED
    return Color.new(164, 3, 3) if color == :DARKRED
    return Color.new(47, 46, 46) if color == :DARKGREY
    return Color.new(100, 92, 92) if color == :LIGHTGREY
    return Color.new(226, 104, 250) if color == :PINK
    return Color.new(243, 154, 154) if color == :PINKTWO
    return Color.new(255, 160, 50) if color == :GOLD
    return Color.new(255, 186, 107) if color == :LIGHTORANGE
    return Color.new(95, 54, 6) if color == :BROWN
    return Color.new(122, 76, 24) if color == :LIGHTBROWN
    return Color.new(255, 246, 152) if color == :LIGHTYELLOW
    return Color.new(242, 222, 42) if color == :YELLOW
    return Color.new(80, 111, 6) if color == :DARKGREEN
    return Color.new(154, 216, 8) if color == :GREEN
    return Color.new(197, 252, 70) if color == :LIGHTGREEN
    return Color.new(74, 146, 91) if color == :FADEDGREEN
    return Color.new(6, 128, 92) if color == :DARKLIGHTBLUE
    return Color.new(18, 235, 170) if color == :LIGHTBLUE
    return Color.new(139, 247, 215) if color == :SUPERLIGHTBLUE
    return Color.new(35, 203, 255) if color == :BLUE
    return Color.new(3, 44, 114) if color == :DARKBLUE
    return Color.new(7, 3, 114) if color == :SUPERDARKBLUE
    return Color.new(63, 6, 121) if color == :DARKPURPLE
    return Color.new(113, 16, 209) if color == :PURPLE
    return Color.new(219, 183, 37) if color == :ORANGE
    return Color.new(255, 255, 255) # if color == :WHITE
  end

  def self.debugMessage(message)
    if DEBUG_MODE
      echoln message
    end
  end

  def self.debugTitle(title, message = "")
    messageToDebug = title.mark_green
    messageToDebug += " - #{message.green}" if message != ""
    debugMessage(messageToDebug)
  end

  def self.debugError(title, message = "")
    messageToDebug = title.mark_red
    messageToDebug += " - #{message.red}" if message != ""
    debugMessage(messageToDebug)
  end

  def self.debugEnd(message = "")
    debugMessage("#{message} \n\n")
  end

  def self.species(specieId)
    return GameData::Species.get(specieId)
  end
end
