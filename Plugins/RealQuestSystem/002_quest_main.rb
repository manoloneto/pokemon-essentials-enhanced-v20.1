################################################################################
# Real Quest System - Version 1.0.0
# Created by realAfonso
################################################################################

module RQS # Real Quest System

  ################################################################################
  # Button class of Quest System
  ################################################################################

  class RealQuestButton < Sprite
    attr_reader :index
    attr_reader :name
    attr_reader :selected

    TEXT_BASE_COLOR = Color.new(248, 248, 248)
    TEXT_SHADOW_COLOR = Color.new(40, 40, 40)

    def initialize(command, x, y, viewport = nil)
      super(viewport)
      @image = command[0]
      @name = command[1]
      @selected = false
      if $player.female? && pbResolveBitmap(sprintf("Graphics/Pictures/Pokegear/icon_button_f"))
        @button = AnimatedBitmap.new("Graphics/Pictures/Pokegear/icon_button_f")
      else
        @button = AnimatedBitmap.new("Graphics/Pictures/Pokegear/icon_button")
      end
      @contents = BitmapWrapper.new(@button.width, @button.height)
      self.bitmap = @contents
      self.x = x - (@button.width / 2)
      self.y = y
      pbSetSystemFont(self.bitmap)
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
      textpos = [
        [@name, rect.width / 2, (rect.height / 2) - 10, 2, TEXT_BASE_COLOR, TEXT_SHADOW_COLOR],
      ]
      pbDrawTextPositions(self.bitmap, textpos)
      imagepos = [
        [sprintf("Graphics/Pictures/Pokegear/icon_" + @image), 18, 10],
      ]
      pbDrawImagePositions(self.bitmap, imagepos)
    end
  end

  ################################################################################
  # Scene class of Quest System
  ################################################################################

  class RealQuestMain_Scene
    def pbUpdate
      @commands.length.times do |i|
        @sprites["button#{i}"].selected = (i == @index)
      end
      pbUpdateSpriteHash(@sprites)
    end

    def pbStartScene(commands)
      @commands = commands
      @index = 0
      @viewport = Viewport.new(0, 0, Graphics.width, Graphics.height)
      @viewport.z = 99999
      @sprites = {}
      @sprites["background"] = IconSprite.new(0, 0, @viewport)
      @sprites["background"].setBitmap("Graphics/Pictures/Real Quest System/background")
      @commands.length.times do |i|
        @sprites["button#{i}"] = RealQuestButton.new(@commands[i], Graphics.width / 2, 0, @viewport)
        button_height = @sprites["button#{i}"].bitmap.height / 2
        @sprites["button#{i}"].y = ((Graphics.height - (@commands.length * button_height)) / 2) + (i * button_height)
      end

      @sprites["screen_title"] = RealDefaultText.new(["title", "TO-DO List"], 30, 12, @viewport)
      @sprites["button_back"] = RealDefaultText.new(["key_x", "Exit"], Graphics.width - 82, 352, @viewport)
      @sprites["button_back"] = RealDefaultText.new(["key_c", "Select"], Graphics.width - 182, 352, @viewport)

      pbFadeInAndShow(@sprites) { pbUpdate }
    end

    def pbScene
      ret = -1
      loop do
        Graphics.update
        Input.update
        pbUpdate
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

    def pbEndScene
      pbFadeOutAndHide(@sprites) { pbUpdate }
      dispose
    end

    def dispose
      pbDisposeSpriteHash(@sprites)
      @viewport.dispose
    end
  end

  ################################################################################
  # Real Quest Main Screen Class
  ################################################################################

  class RealQuestMain_Screen
    def initialize(scene)
      @scene = scene
    end

    def pbStartScreen
      # Get all commands
      command_list = []
      commands = []
      MenuHandlers.each_available(:rqs_menu) do |option, hash, name|
        command_list.push([hash["icon_name"] || "", name])
        commands.push(hash)
      end
      @scene.pbStartScene(command_list)
      # Main loop
      end_scene = false
      loop do
        choice = @scene.pbScene
        if choice < 0
          end_scene = true
          break
        end
        break if commands[choice]["effect"].call(@scene)
      end
      @scene.pbEndScene if end_scene
    end
  end

  ################################################################################
  # Menu items to quest main screen
  ################################################################################

  MenuHandlers.add(:rqs_menu, :rqs_ongoing, {
    "name" => _INTL("Ongoing"),
    "order" => 0,
    "effect" => proc { |menu|
      pbPlayDecisionSE
      pbFadeOutIn {
        scene = RealQuestEntry_Scene.new
        screen = RealQuestEntry_Screen.new(scene)
        screen.pbStartScreen
      }
      next false
    },
  })

  MenuHandlers.add(:rqs_menu, :rqs_completed, {
    "name" => _INTL("Completed"),
    "order" => 1,
    "effect" => proc { |menu|
      next false
    },
  })

  ################################################################################
  # Handler to show quest main screen on press key
  ################################################################################

  EventHandlers.add(:on_frame_update, :real_quest_scene_caller, proc {
    if Input.triggerex?(:O)
      pbPlayDecisionSE
      pbFadeOutIn {
        scene = RealQuestMain_Scene.new
        screen = RealQuestMain_Screen.new(scene)
        screen.pbStartScreen
      }
    end
  })
end
