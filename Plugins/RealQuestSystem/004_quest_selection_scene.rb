################################################################################
# Real Quest System - Version 1.0.0
# Created by realAfonso
################################################################################

module Real # Real Quest System

  ################################################################################
  # BUTTON OF QUEST SELECTION SCENE
  ################################################################################

  class QuestButton < Sprite
    attr_reader :index
    attr_reader :name
    attr_reader :selected

    TEXT_BASE_COLOR = Color.new(248, 248, 248)

    def initialize(command, x, y, viewport = nil)
      super(viewport)
      @image = command[0]
      @name = command[1]
      @selected = false

      old_style = "/Old Sprites" if USE_GENERATION_IV_STYLE

      @button = AnimatedBitmap.new("Graphics/Plugins/Real Quest System#{old_style}/main_button")

      @contents = BitmapWrapper.new(@button.width, @button.height)
      self.bitmap = @contents
      self.x = x - (@button.width / 2)
      self.y = y

      textSize = USE_GENERATION_IV_STYLE ? 18 : 22
      Real.setDefaultFontStyle(self.bitmap, textSize, USE_GENERATION_IV_STYLE)

      refresh
    end

    def dispose
      @button.dispose
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

      rect = Rect.new(0, 0, @button.width, @button.height / 2)
      rect.y = @button.height / 2 if @selected

      self.bitmap.blt(0, 0, @button.bitmap, rect)

      shadowColor = USE_GENERATION_IV_STYLE ? Color.new(72, 80, 88) : nil

      textpos = [
        [@name, 70, 22, 0, TEXT_BASE_COLOR, shadowColor],
      ]

      pbDrawTextPositions(self.bitmap, textpos)

      old_style = "/Old Sprites" if USE_GENERATION_IV_STYLE

      iconPosition = USE_GENERATION_IV_STYLE ? 20 : 15

      imagepos = [
        [sprintf("Graphics/Plugins/Real Quest System#{old_style}/icon_" + @image), 35, iconPosition],
      ]

      pbDrawImagePositions(self.bitmap, imagepos)

      textSize = USE_GENERATION_IV_STYLE ? 18 : 22
      Real.setDefaultFontStyle(self.bitmap, textSize, USE_GENERATION_IV_STYLE)
    end
  end

  ################################################################################
  # CREATING THE QUEST SELECTION SCENE
  ################################################################################

  class QuestSelection_Scene
    def update
      @commands.length.times do |i|
        @sprites["button#{i}"].selected = (i == @index)
      end
      pbUpdateSpriteHash(@sprites)
    end

    def startScene(commands)
      @commands = commands
      @index = 0

      @viewport = Viewport.new(0, 0, Graphics.width, Graphics.height)
      @viewport.z = 99999

      old_style = "/Old Sprites" if USE_GENERATION_IV_STYLE

      @sprites = {}
      @sprites["background"] = IconSprite.new(0, 0, @viewport)
      @sprites["background"].setBitmap("Graphics/Plugins/Real Quest System#{old_style}/background")

      @commands.length.times do |i|
        @sprites["button#{i}"] = QuestButton.new(@commands[i], Graphics.width / 2, 0, @viewport)
        button_height = @sprites["button#{i}"].bitmap.height / 2
        @sprites["button#{i}"].y = ((Graphics.height - (@commands.length * button_height)) / 2) + (i * button_height)
      end

      iconPosition = USE_GENERATION_IV_STYLE ? 8 : 12

      @sprites["screen_title"] = RealDefaultText.new(
        ["title_search", "TO-DO List"],
        30, iconPosition, @viewport, nil,
        200, 20, USE_GENERATION_IV_STYLE,
      )

      iconPosition = USE_GENERATION_IV_STYLE ? 355 : 352

      @sprites["button_select"] = RealDefaultText.new(
        ["key_c", "Select"],
        Graphics.width - 182, iconPosition, @viewport,
        nil, 200, 20, USE_GENERATION_IV_STYLE,
      )

      @sprites["button_back"] = RealDefaultText.new(
        ["key_x", "Exit"],
        Graphics.width - 82, iconPosition, @viewport,
        nil, 200, 20, USE_GENERATION_IV_STYLE,
      )

      pbFadeInAndShow(@sprites) { update }
    end

    def scene
      ret = -1
      loop do
        Graphics.update
        Input.update
        update
        if Input.trigger?(Input::BACK)
          pbPlayCloseMenuSE
          break
        elsif Input.trigger?(Input::USE)
          pbPlayDecisionSE
          ret = @index
          break
        elsif Input.trigger?(Input::UP)
          pbPlayCursorSE if @commands.length > 1
          @index -= 1
          @index = @commands.length - 1 if @index < 0
        elsif Input.trigger?(Input::DOWN)
          pbPlayCursorSE if @commands.length > 1
          @index += 1
          @index = 0 if @index >= @commands.length
        end
      end
      return ret
    end

    def endScene
      pbFadeOutAndHide(@sprites) { update }
      dispose
    end

    def dispose
      pbDisposeSpriteHash(@sprites)
      @viewport.dispose
    end
  end

  ################################################################################
  # CREATING THE QUEST SELECTION SCREEN
  ################################################################################

  class QuestSelection_Screen
    def initialize(scene)
      @scene = scene
    end

    def startScreen
      # Get all commands
      command_list = []
      commands = []
      MenuHandlers.each_available(:rqs_menu) do |option, hash, name|
        command_list.push([hash["icon_name"] || "", name])
        commands.push(hash)
      end
      @scene.startScene(command_list)
      # Main loop
      end_scene = false
      loop do
        choice = @scene.scene
        if choice < 0
          end_scene = true
          break
        end
        break if commands[choice]["effect"].call(@scene)
      end
      @scene.endScene if end_scene
    end
  end

  ################################################################################
  # MENU ITEMS TO QUEST SELECTION SCREEN
  ################################################################################

  MenuHandlers.add(:rqs_menu, :rqs_ongoing, {
    "name" => _INTL("In Progress"),
    "icon_name" => "in_progress",
    "order" => 0,
    "effect" => proc { |menu|
      pbPlayDecisionSE
      pbFadeOutIn {
        scene = QuestList_Scene.new
        screen = QuestList_Screen.new(scene, false) # Just ongoing
        screen.startScreen
      }
      next false
    },
  })

  MenuHandlers.add(:rqs_menu, :rqs_completed, {
    "name" => _INTL("Completed"),
    "icon_name" => "completed",
    "order" => 1,
    "effect" => proc { |menu|
      pbPlayDecisionSE
      pbFadeOutIn {
        scene = QuestList_Scene.new
        screen = QuestList_Screen.new(scene, true) # Just completed
        screen.startScreen
      }
      next false
    },
  })

  ################################################################################
  # HANDLER TO SHOW QUEST SELECTION SCREEN ON PRESS KEY
  ################################################################################

  EventHandlers.add(:on_frame_update, :real_quest_scene_caller, proc {
    if Input.triggerex?(REAL_QUEST_KEY)
      pbPlayDecisionSE
      pbFadeOutIn {
        scene = QuestSelection_Scene.new
        screen = QuestSelection_Screen.new(scene)
        screen.startScreen
      }
    end
  })
end
