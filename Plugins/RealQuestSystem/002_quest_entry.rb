#===============================================================================
#
#===============================================================================
class Window_Quest < Window_DrawableCommand
  TEXT_BASE_COLOR = Color.new(248, 248, 248)

  def initialize(x, y, width, height, viewport, justCompleted = false)
    @sprites = {}
    @commands = []
    super(x, y, width, height, viewport)
    @justCompleted = justCompleted
    @selarrow = AnimatedBitmap.new("Graphics/Pictures/Real Quest System/cursor")
    @iconCompleted = AnimatedBitmap.new("Graphics/Pictures/Real Quest System/icon_completed")
    @iconInProgress = AnimatedBitmap.new("Graphics/Pictures/Real Quest System/icon_in_progress")
    self.baseColor = Color.new(88, 88, 80)
    self.shadowColor = Color.new(168, 184, 184)
    self.windowskin = nil
  end

  def commands=(value)
    @commands = value
    refresh
  end

  def dispose
    @iconCompleted.dispose
    @iconInProgress.dispose
    super
  end

  def sprite
    return (@commands.length == 0) ? 0 : @commands[self.index].sprite
  end

  def itemCount
    return @commands.length
  end

  def page_item_max; return 9; end

  def drawCharacter(char)
    @sprites["character"].dispose if @sprites["character"]
    @sprites["character"] = IconSprite.new(0, 0, @viewport)
    @sprites["character"].setBitmap("Graphics/Characters/#{char}")
    @sprites["character"].x = 40 # Horizontal
    @sprites["character"].y = 270 # Vertical
    @sprites["character"].src_rect.height = (@sprites["character"].bitmap.height / 4).round
    @sprites["character"].src_rect.width = (@sprites["character"].bitmap.width / 4).round
  end

  def drawCursor(index, rect)
    if self.index == index
      pbCopyBitmap(self.contents, @selarrow.bitmap, rect.x, rect.y + 8)
      if @commands.length > 0
        @sprites["requester"].dispose if @sprites["requester"]
        @sprites["location"].dispose if @sprites["location"]
        @sprites["description"].dispose if @sprites["description"]
        @sprites["description"] = RealDefaultTextMultiline.new(@commands[index].description, 22, 37, @viewport, TEXT_BASE_COLOR, 200, 208)
        @sprites["requester"] = RealDefaultText.new(["", @commands[index].requester], 52, 274, @viewport, TEXT_BASE_COLOR)
        @sprites["location"] = RealDefaultText.new(["", @commands[index].location], 52, 297, @viewport, TEXT_BASE_COLOR)
        drawCharacter(@commands[index].sprite)
      end
    end
    return Rect.new(rect.x, rect.y, rect.width, rect.height)
  end

  def drawItem(index, _count, rect)
    return if index >= self.top_row + self.page_item_max
    rect = Rect.new(rect.x + 16, rect.y, rect.width - 16, rect.height)
    quest = @commands[index]
    if quest.completed
      pbCopyBitmap(self.contents, @iconCompleted.bitmap, rect.x - 4, rect.y + 10)
    else
      pbCopyBitmap(self.contents, @iconInProgress.bitmap, rect.x - 4, rect.y + 10)
    end
    text = sprintf(@commands[index].title)
    Real.setDefaultFontStyle(self.contents, 22)
    pbDrawShadowText(self.contents, rect.x + 36, rect.y + 19, rect.width, rect.height,
                     text, TEXT_BASE_COLOR, nil)
  end

  def refresh
    @item_max = itemCount
    dwidth = self.width - self.borderX
    dheight = self.height - self.borderY
    self.contents = pbDoEnsureBitmap(self.contents, dwidth, dheight)
    self.contents.clear
    @item_max.times do |i|
      next if i < self.top_item || i > self.top_item + self.page_item_max
      drawItem(i, @item_max, itemRect(i))
    end
    drawCursor(self.index, itemRect(self.index))
  end

  def update
    super
    @uparrow.visible = false
    @downarrow.visible = false
  end
end

#===============================================================================
# Pokédex main screen
#===============================================================================
class RealQuestEntry_Scene
  def pbUpdate
    pbUpdateSpriteHash(@sprites)
  end

  def pbStartScene(justCompleted = false)
    @justCompleted = justCompleted
    @cursor = AnimatedBitmap.new("Graphics/Pictures/Real Quest System/cursor")

    @sprites = {}
    @viewport = Viewport.new(0, 0, Graphics.width, Graphics.height)
    @viewport.z = 99999

    addBackgroundPlane(@sprites, "background", "Real Quest System/entry_background", @viewport)

    @sprites["questList"] = Window_Quest.new(226, 28, 280, 340, @viewport)

    @sprites["overlay"] = BitmapSprite.new(Graphics.width, Graphics.height, @viewport)

    @sprites["screen_title"] = RealDefaultText.new(["title", "TO-DO List"], 30, 12, @viewport)
    @sprites["button_back"] = RealDefaultText.new(["key_x", "Exit"], Graphics.width - 82, 352, @viewport)

    Real.setDefaultFontStyle(@sprites["overlay"].bitmap)

    pbRefreshQuestList
    pbDeactivateWindows(@sprites)
    pbFadeInAndShow(@sprites)
  end

  def pbEndScene
    pbFadeOutAndHide(@sprites)
    pbDisposeSpriteHash(@sprites)
    @cursor.dispose
    @viewport.dispose
  end

  def pbRefreshQuestList(index = 0)
    if $player.quests
      questList = $player.quests
      questList = questList.sort { |a, b| a.title <=> b.title }
      @questList = questList

      @sprites["questList"].commands = @questList.select { |q| q.completed == @justCompleted }
      @sprites["questList"].index = index
      @sprites["questList"].refresh
      @sprites["background"].setBitmap("Graphics/Pictures/Real Quest System/entry_background")

      pbRefresh
    end
  end

  def pbRefresh
    overlay = @sprites["overlay"].bitmap
    overlay.clear
    Real.setDefaultFontStyle(overlay)
  end

  def setIconBitmap(species)
    gender, form, shiny = $player.pokedex.last_form_seen(species)
    shiny = false
    @sprites["icon"].setSpeciesBitmap(species, gender, form, shiny)
  end

  def realQuestEntryScene
    pbActivateWindow(@sprites, "questList") {
      loop do
        Graphics.update
        Input.update
        oldindex = @sprites["questList"].index
        pbUpdate
        if oldindex != @sprites["questList"].index
          pbRefresh
        end
        if Input.trigger?(Input::BACK)
          pbPlayCloseMenuSE
          break
        end
      end
    }
  end
end

#===============================================================================
#
#===============================================================================
class RealQuestEntry_Screen
  def initialize(scene, justCompleted = false)
    @scene = scene
    @justCompleted = justCompleted
  end

  def pbStartScreen
    @scene.pbStartScene(@justCompleted)
    @scene.realQuestEntryScene
    @scene.pbEndScene
  end
end
