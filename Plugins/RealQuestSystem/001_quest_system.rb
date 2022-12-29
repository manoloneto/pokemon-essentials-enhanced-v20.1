################################################################################
# Real Quest System - Version 1.0.0
# Created by realAfonso
################################################################################

module RQS # Real Quest System

  ################################################################################
  # Add a new quest to player
  ################################################################################

  def self.addQuest(questID)
    Real.debugTitle("Real Quest System", "Adding a quest to player")

    $player.quests = [] if $player.quests.class == NilClass

    Real.debugMessage("Current player quest list: #{$player.quests.size.to_s.cyan} quests")

    quest = QUEST_LIST.find { |q| q.id == questID }

    if quest
      Real.debugMessage("Quest added to player's list".green)
      $player.quests << quest
    else
      Real.debugError("ERROR", "Quest #{questID} not found in quest list")
    end

    Real.debugMessage("Current player quest list: #{$player.quests.size.to_s.cyan} quests")
    Real.debugEnd
  end

  ################################################################################
  # Complete a quest of player's list
  ################################################################################

  def self.completeQuest(questID)
    Real.debugTitle("Real Quest System", "Completing a quest of player's list")

    $player.quests = [] if $player.quests.class == NilClass

    Real.debugMessage("Current player quest list: #{$player.quests.size.to_s.cyan} quests")

    questIndex = $player.quests.find_index { |q| q.id == questID }

    if questIndex && questIndex >= 0
      Real.debugMessage("Quest #{questID} completed!".green)
      $player.quests[questIndex].completed = true
    else
      Real.debugError("ERROR", "Quest #{questID} not found in player's quest list")
    end

    Real.debugMessage("Current player quest list: #{$player.quests.size.to_s.cyan} quests")
    Real.debugEnd
  end

  ################################################################################
  # Remove a quest of player's list
  ################################################################################

  def self.removeQuest(questID)
    Real.debugTitle("Real Quest System", "Removing a quest of player's list")

    $player.quests = [] if $player.quests.class == NilClass

    Real.debugMessage("Current player quest list: #{$player.quests.size.to_s.cyan} quests")

    questIndex = $player.quests.find_index { |q| q.id == questID }

    if questIndex && questIndex >= 0
      Real.debugMessage("Quest removed of player's list".green)
      $player.quests.delete_at(questIndex)
    else
      Real.debugError("ERROR", "Quest #{questID} not found in player's quest list")
    end

    Real.debugMessage("Current player quest list: #{$player.quests.size.to_s.cyan} quests")
    Real.debugEnd
  end
end
