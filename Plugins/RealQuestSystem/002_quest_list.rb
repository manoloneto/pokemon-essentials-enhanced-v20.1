################################################################################
# Real Quest System - Version 1.0.0
# Created by realAfonso
################################################################################

QUEST_LIST = [
  Quest.new(:BUG_CATCHER_001,                         # Quest ID
            "Find a Carterpie!",                      # Quest title
            "Find a Carterpie somewhere in town.",    # Quest description
            "Bug Catcher John",                       # The name of the requester
            "trchar039",                              # The name of the sprite in "Graphics/Characters"
            "Queesting Town",                         # The name of city, town or route
            :SUPERLIGHTBLUE),                         # The color of quest, this is not mandatory

  Quest.new(:BUG_CATCHER_002,
            "Find a Pikachu!",
            "Find a Pikachu somewhere in town.",
            "Bug Catcher John",
            "trchar039",
            "Queesting Town"),

  Quest.new(:GYM_CERULEAN_001,
            "Find a Sunflora!",
            "Find a Sunflora somewhere in town.",
            "GYM Leader Mist",
            "trchar040",
            "Cerulean Town"),
]
