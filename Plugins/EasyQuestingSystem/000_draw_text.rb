################################################################################
# Easy Questing System - Version 1.1.0
# Created by Marin
# Ported to plugin by Manoel Afonso
################################################################################

def renderMultiLine(bitmap, xDst, yDst, normtext, maxheight, baseColor, shadowColor)
  for i in 0...normtext.length
    width = normtext[i][3]
    textx = normtext[i][1] + xDst
    texty = normtext[i][2] + yDst
    if shadowColor
      height = normtext[i][4]
      text = normtext[i][0]
      bitmap.font.color = shadowColor
      bitmap.draw_text(textx - 2, texty - 2, width, height, text, 0)
      bitmap.draw_text(textx, texty - 2, width, height, text, 0)
      bitmap.draw_text(textx + 2, texty - 2, width, height, text, 0)
      bitmap.draw_text(textx - 2, texty, width, height, text, 0)
      bitmap.draw_text(textx + 2, texty, width, height, text, 0)
      bitmap.draw_text(textx - 2, texty + 2, width, height, text, 0)
      bitmap.draw_text(textx, texty + 2, width, height, text, 0)
      bitmap.draw_text(textx + 2, texty + 2, width, height, text, 0)
    end
    if baseColor
      height = normtext[i][4]
      text = normtext[i][0]
      bitmap.font.color = baseColor
      bitmap.draw_text(textx, texty, width, height, text, 0)
    end
  end
end

def drawTextExMulti(bitmap, x, y, width, numlines, text, baseColor, shadowColor)
  normtext = getLineBrokenChunks(bitmap, text, width, nil, true)
  renderMultiLine(bitmap, x, y, normtext, numlines * 32, baseColor, shadowColor)
end
