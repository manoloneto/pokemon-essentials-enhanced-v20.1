################################################################################
# Real Quest System - Version 1.0.0
# Created by realAfonso
################################################################################

module Real # Real Quest System

  ################################################################################
  # CREATING THE QUEST LIST WINDOW
  ################################################################################

  class QuestListWindow < Window_DrawableCommand
    TEXT_BASE_COLOR = Color.new(248, 248, 248)

    def initialize(x, y, width, height, viewport, justCompleted = false)
      @sprites = {}
      @commands = []
      super(x, y, width, height, viewport)
      @justCompleted = justCompleted

      old_style = "/Old Sprites" if USE_GENERATION_IV_STYLE

      @selarrow = AnimatedBitmap.new("Graphics/Plugins/Real Quest System#{old_style}/cursor")
      @iconCompleted = AnimatedBitmap.new("Graphics/Plugins/Real Quest System#{old_style}/icon_completed")
      @iconInProgress = AnimatedBitmap.new("Graphics/Plugins/Real Quest System#{old_style}/icon_in_progress")

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

    def drawSelection(index, rect)
      if self.index == index
        pbCopyBitmap(self.contents, @selarrow.bitmap, rect.x, rect.y + 8)
        if @commands.length > 0
          @sprites["requester"].dispose if @sprites["requester"]
          @sprites["location"].dispose if @sprites["location"]
          @sprites["description"].dispose if @sprites["description"]

          @sprites["description"] = RealDefaultTextMultiline.new(
            @commands[index].description, 20, 35,
            @viewport, TEXT_BASE_COLOR, 203, 200,
            USE_GENERATION_IV_STYLE,
          )

          positionMod = USE_GENERATION_IV_STYLE ? 3 : 0

          @sprites["requester"] = RealDefaultText.new(
            ["", @commands[index].requester], 52, 274 + positionMod,
            @viewport, TEXT_BASE_COLOR, 200, 20,
            USE_GENERATION_IV_STYLE,
          )

          @sprites["location"] = RealDefaultText.new(
            ["", @commands[index].location], 52, 297 + positionMod,
            @viewport, TEXT_BASE_COLOR, 200, 20,
            USE_GENERATION_IV_STYLE,
          )

          drawCharacter(@commands[index].sprite)
        end
      end
      return Rect.new(rect.x, rect.y, rect.width, rect.height)
    end

    def drawItem(index, _count, rect)
      return if index >= self.top_row + self.page_item_max
      rect = Rect.new(rect.x + 16, rect.y, rect.width - 16, rect.height + 15)
      quest = @commands[index]

      iconBitmap = @iconCompleted.bitmap
      iconBitmap = @iconInProgress.bitmap if !quest.completed

      iconPosition = USE_GENERATION_IV_STYLE ? 27 : 22
      pbCopyBitmap(self.contents, iconBitmap, rect.x + 5, rect.y + iconPosition)

      text = sprintf(@commands[index].title)

      shadowColor = USE_GENERATION_IV_STYLE ? Color.new(72, 80, 88) : nil
      pbDrawShadowText(self.contents,
                       rect.x + 36, # Horizontal position
                       rect.y + 30, # Vertical position
                       rect.width,
                       rect.height,
                       text, TEXT_BASE_COLOR, shadowColor)

      textSize = USE_GENERATION_IV_STYLE ? 20 : 22
      Real.setDefaultFontStyle(self.contents, textSize, USE_GENERATION_IV_STYLE)
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
      drawSelection(self.index, itemRect(self.index))

      textSize = USE_GENERATION_IV_STYLE ? 20 : 22
      Real.setDefaultFontStyle(self.contents, textSize, USE_GENERATION_IV_STYLE)
    end

    def update
      super
      @uparrow.visible = false
      @downarrow.visible = false
    end
  end

  ################################################################################
  # CREATING THE QUEST LIST SCENE
  ################################################################################

  class QuestList_Scene
    def pbUpdate
      pbUpdateSpriteHash(@sprites)
    end

    def startScene(justCompleted = false)
      @justCompleted = justCompleted

      old_style = "/Old Sprites" if USE_GENERATION_IV_STYLE

      @cursor = AnimatedBitmap.new("Graphics/Plugins/Real Quest System#{old_style}/cursor")

      @sprites = {}
      @viewport = Viewport.new(0, 0, Graphics.width, Graphics.height)
      @viewport.z = 99999

      addBackgroundPlane(@sprites, "background", "Real Quest System#{old_style}/entry_background", @viewport)

      @sprites["questList"] = QuestListWindow.new(226, 18, 350, 350, @viewport)

      @sprites["overlay"] = BitmapSprite.new(Graphics.width, Graphics.height, @viewport)

      @sprites["screen_title"] = RealDefaultText.new(
        ["title_search", "TO-DO List"],
        30, 12, @viewport, nil,
        200, 20, USE_GENERATION_IV_STYLE,
      )

      @sprites["button_back"] = RealDefaultText.new(
        ["key_x", "Exit"],
        Graphics.width - 82, 352, @viewport,
        nil, 200, 20, USE_GENERATION_IV_STYLE,
      )

      textSize = USE_GENERATION_IV_STYLE ? 16 : 0
      Real.setDefaultFontStyle(@sprites["overlay"].bitmap, textSize, useEssentialsTextStyle: USE_GENERATION_IV_STYLE)

      pbRefreshQuestList
      pbDeactivateWindows(@sprites)
      pbFadeInAndShow(@sprites)
    end

    def endScene
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

        old_style = "/Old Sprites" if USE_GENERATION_IV_STYLE

        @sprites["questList"].commands = @questList.select { |q| q.completed == @justCompleted }
        @sprites["questList"].index = index
        @sprites["questList"].refresh
        @sprites["background"].setBitmap("Graphics/Plugins/Real Quest System#{old_style}/entry_background")

        pbRefresh
      end
    end

    def pbRefresh
      overlay = @sprites["overlay"].bitmap
      overlay.clear

      textSize = USE_GENERATION_IV_STYLE ? 16 : 0
      Real.setDefaultFontStyle(overlay, textSize, useEssentialsTextStyle: USE_GENERATION_IV_STYLE)
    end

    def setIconBitmap(species)
      gender, form, shiny = $player.pokedex.last_form_seen(species)
      shiny = false
      @sprites["icon"].setSpeciesBitmap(species, gender, form, shiny)
    end

    def questListScene
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

  ################################################################################
  # CREATING THE QUEST LIST SCREEN
  ################################################################################

  class QuestList_Screen
    def initialize(scene, justCompleted = false)
      @scene = scene
      @justCompleted = justCompleted
    end

    def startScreen
      @scene.startScene(@justCompleted)
      @scene.questListScene
      @scene.endScene
    end
  end
end
