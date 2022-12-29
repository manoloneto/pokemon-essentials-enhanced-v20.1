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

  def self.getLinesOfText(bitmap, value, width, dims, plain = false)
    x = 0
    y = 0
    ret = []
    if dims
      dims[0] = 0
      dims[1] = 0
    end
    re = /<c=([^>]+)>/
    reNoMatch = /<c=[^>]+>/
    return ret if !bitmap || bitmap.disposed? || width <= 0
    textmsg = value.clone
    color = Font.default_color
    while (c = textmsg.slice!(/\n|[^ \r\t\f\n\-]*\-+|(\S*([ \r\t\f]?))/)) != nil
      break if c == ""
      ccheck = c
      if ccheck == "\n"
        x = 0
        y += 22
        next
      end
      textcols = []
      if ccheck[/</] && !plain
        ccheck.scan(re) { textcols.push(rgbToColor($1)) }
        words = ccheck.split(reNoMatch) # must have no matches because split can include match
      else
        words = [ccheck]
      end
      words.length.times do |i|
        word = words[i]
        if word && word != ""
          textSize = bitmap.text_size(word)
          textwidth = textSize.width
          if x > 0 && x + textwidth > width
            minTextSize = bitmap.text_size(word.gsub(/\s*/, ""))
            if x > 0 && x + minTextSize.width > width
              x = 0
              y += 22
            end
          end
          ret.push([word, x, y, textwidth, 32, color])
          x += textwidth
          dims[0] = x if dims && dims[0] < x
        end
        if textcols[i]
          color = textcols[i]
        end
      end
    end
    dims[1] = y + 22 if dims
    return ret
  end

  def self.drawLongText(bitmap, x, y, width, numlines, text, baseColor, shadowColor = nil)
    normtext = Real.getLinesOfText(bitmap, text, width, nil, true)
    if shadowColor
      renderLineBrokenChunksWithShadow(bitmap, x, y, normtext, numlines * 32, baseColor, shadowColor)
    else
      renderLineBrokenChunks(bitmap, x, y, normtext, numlines * 32)
    end
  end
end
