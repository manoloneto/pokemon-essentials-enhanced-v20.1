################################################################################
# Real Quest System - Version 1.0.0
# Created by realAfonso
################################################################################

################################################################################
# CREATING CLASS QUEST
################################################################################

class Quest
  attr_accessor :id
  attr_accessor :title
  attr_accessor :description
  attr_accessor :requester
  attr_accessor :sprite
  attr_accessor :location
  attr_accessor :color
  attr_accessor :time
  attr_accessor :completed

  def initialize(id, title, description, requester, sprite, location, color = :WHITE)
    self.id = id
    self.title = title
    self.description = description
    self.requester = requester
    self.sprite = sprite
    self.location = location
    self.color = Real.color(color)
    self.time = Time.now
    self.completed = false
  end
end

################################################################################
# ADDING QUESTS TO TRAINER
################################################################################

class Trainer
  attr_accessor :quests
end
