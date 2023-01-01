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
  attr_accessor :completed

  def initialize(id, title, description, requester, sprite, location)
    self.id = id
    self.title = title
    self.description = description
    self.requester = requester
    self.sprite = sprite
    self.location = location
    self.completed = false
  end

  def self.parse(array)
    quests = []
    array.each do |q|
      quest = Quest.new(
        q[0], # Quest ID
        q[1], # Title
        q[2], # Description
        q[3], # Requester name
        q[4], # Requester sprite
        q[5], # Location name
      )
      quests << quest
    end
    return quests
  end
end

################################################################################
# ADDING QUESTS TO TRAINER
################################################################################

class Trainer
  attr_accessor :quests
end
