################################################################################
# Easy Questing System - Version 1.1.0
# Created by Marin
# Ported to plugin by Manoel Afonso
################################################################################
# Be aware of the following:
# * Every quest should have a unique ID;
# * Every quest should be unique (at least one field has to be different);
# * The "Name" field can't be very long;
# * The "Desc" field can be quite long;
# * The "NPC" field is JUST a name;
# * The "Sprite" field is the name of the sprite in "Graphics/Characters";
# * The "Location" field is JUST a name;
# * The "Color" field is a SYMBOL (starts with ':'). List under "pbColor";
# * You don't need to give a color to quest. It will default to White;
# * The "Time" field can be a random string for it to be "?????" in-game;
# * The "Completed" field can be pre-set, but is normally only changed in-game
################################################################################

QUESTS = [
  Quest.new(0, "Find a Super Rod!", "Find a Super Rod somewhere in the field. This item does not have to be handed over.", "Quest Master", "trchar039", "Queesting Town", :SUPERLIGHTBLUE),
  Quest.new(1, "Find a Pikachu!", "Find a Pikachu somewhere in the field.", "Quest Master", "trchar039", "Queesting Town"),
]
