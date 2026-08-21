#==============================================================================#
#                              Pokémon Essentials                              #
#                                 Version 21.99                                #
#                https://github.com/Maruno17/pokemon-essentials                #
#==============================================================================#

module Settings
  # 你的游戏版本。需遵循MAJOR.MINOR.PATCH格式。
  GAME_VERSION = "1.0.0"

  # 战斗系统遵循的世代。用于整个对战脚本，以及其他一些用于战斗内外的设置
  # （当然，你可以更改这些设置以适应你的游戏）。
  # 请注意，这并不完美。Essentials并不能准确地复制每一个世代的机制。
  # 它被认为是足够好的。只有第5世代及之后的版本才得到合理支持。
  MECHANICS_GENERATION = 9

  # 玩家可用的保存槽选项。是以下之一：
  #   * :one       = 经典保存。只有一个保存文件，保存时会被替换。
  #   * :adventure = 每个冒险（即开始新游戏）都有自己的单个保存槽。
  #                  允许玩家保存多个冒险，但每个冒险在保存时都表现得像经典一样。
  #   * :multiple  = 无限数量的保存槽始终可用。玩家可以随时选择保存到空的保存槽，或者覆盖现有的保存槽。
  SAVE_SLOTS = :multiple

  #-----------------------------------------------------------------------------
  # 致谢
  #-----------------------------------------------------------------------------

  # 你的游戏的致谢名单，以数组形式呈现。
  # 你可以通过在 _INTL() 中包装某些行来允许它们被翻译。 空白行只是 ""。
  # 要将一行分成两列，可以在其中放置 "<s>"。插件致谢和
  # Essentials 引擎致谢会自动添加到这些致谢的末尾。
  # 这里的一切都只是示例！用你的致谢替换它们。
  def self.game_credits
    return [
      _INTL("游戏作者："),
      "Maruno",
      "",
      _INTL("也有以下人参与："),
      "A. Lee Uss<s>Anne O'Nymus",
      "Ecksam Pell<s>Jane Doe",
      "Joe Dan<s>Nick Nayme",
      "Sue Donnim<s>",
      "",
      _INTL("特别感谢："),
      "Pizza"
    ]
  end

  #-----------------------------------------------------------------------------
  # 玩家和NPC
  #-----------------------------------------------------------------------------

  # 玩家可拥有的零花钱的最大数量。
  MAX_MONEY            = 9_999_999
  # 玩家可拥有的游戏厅代币的最大数量。
  MAX_COINS            = 99_999
  # 玩家可拥有的战斗点数的最大数量。
  MAX_BATTLE_POINTS    = 9_999
  # 玩家可拥有的火山灰的最大数量。
  MAX_SOOT             = 9_999
  # 玩家姓名的最大长度（以字符为单位）。
  MAX_PLAYER_NAME_SIZE = 12
  # 包含训练家类型和游戏变量编号的数组集合。如果变量未设置为0，
  # 则所有该训练家类型的训练家都将被命名为该变量中的内容。
  RIVAL_NAMES = [
    [:RIVAL1,   12],
    [:RIVAL2,   12],
    [:CHAMPION, 12]
  ]

  #-----------------------------------------------------------------------------
  # 主世界
  #-----------------------------------------------------------------------------

  # 室外地图是否会根据时间不同改变色调。
  TIME_SHADING               = true
  # 玩家和事件的倒影是否会水平波动。
  ANIMATE_REFLECTIONS        = true
  # 种植的树果按照第四世代及之后的机制生长（true），还是按照第三世代及之前的机制生长（false）。
  NEW_BERRY_PLANT_MECHANICS  = (MECHANICS_GENERATION >= 4)
  # 钓鱼会自动钓上宝可梦，还是需要进行反应测试（false）。
  FISHING_AUTO_HOOK          = false
  # 玩家开始钓鱼时运行的公共事件的ID（运行而不是显示抛竿动画）。
  FISHING_BEGIN_COMMON_EVENT = -1
  # 玩家停止钓鱼时运行的公共事件的ID（运行而不是显示收竿动画）。
  FISHING_END_COMMON_EVENT   = -1
  # 在狩猎地带里最多允许行走的步数（0=无穷）。
  SAFARI_STEPS               = 600
  # 捕虫大会持续的秒数（0=无穷）。
  BUG_CONTEST_TIME           = 20 * 60   # 20 分钟
  # 在野外行走时，中毒的宝可梦是否会失去HP。
  POISON_IN_FIELD            = (MECHANICS_GENERATION <= 4)
  # 在野外行走时，中毒的宝可梦会倒下
  # (true)，还是在中毒后存活并保留1点HP (false)。
  POISON_FAINT_IN_FIELD      = (MECHANICS_GENERATION <= 3)

  #-----------------------------------------------------------------------------
  # 在主世界使用招式
  #-----------------------------------------------------------------------------
  # 使用秘传招式时，你需要至少一定数量的道馆徽章（true），还是需要特定的道馆徽章（false）。 
  # 需要的数量/特定的道馆徽章定义如下。
  FIELD_MOVES_COUNT_BADGES = true
  # 依据FIELD_MOVES_COUNT_BADGES，使用秘传招式需要的道馆徽章数，或需要的特定道馆徽章。
  # 记住，道馆徽章的编号是从0开始的。道馆徽章1是第二个道馆徽章，依此类推。
  #   例：需要第2枚道馆徽章时，填写false和1；
  #       需要至少2枚道馆徽章时，填写true和2。
  BADGE_FOR_CUT       = 1
  BADGE_FOR_FLASH     = 2
  BADGE_FOR_ROCKSMASH = 3
  BADGE_FOR_SURF      = 4
  BADGE_FOR_FLY       = 5
  BADGE_FOR_STRENGTH  = 6
  BADGE_FOR_DIVE      = 7
  BADGE_FOR_WATERFALL = 8

  #-----------------------------------------------------------------------------
  # 宝可梦
  #-----------------------------------------------------------------------------

  # 宝可梦可达到的最大等级。
  MAXIMUM_LEVEL                            = 100
  # 新孵化的宝可梦的等级。
  EGG_LEVEL                                = 1
  # 新产生的宝可梦为异色的概率（65536分之x）。
  SHINY_POKEMON_CHANCE                     = (MECHANICS_GENERATION >= 6) ? 16 : 8
  # 是否允许超异色（会显示不同的异色动画）。
  SUPER_SHINY                              = (MECHANICS_GENERATION == 8)
  # 拥有"Legendary"，"Mythical"或"Ultra Beast"标签的宝可梦是否至少有3个完美个体值。
  LEGENDARIES_HAVE_SOME_PERFECT_IVS        = (MECHANICS_GENERATION >= 6)
  # 野生宝可梦/孵化的蛋感染宝可病毒的概率（65536分之x）。
  POKERUS_CHANCE                           = 3
  # 计算宝可梦的能力值时，个体值和努力值是否视为0。
  # 个体值和努力值仍然存在，仍会正常用于觉醒力量和其他装饰性内容。
  DISABLE_IVS_AND_EVS                      = false
  # 招式回忆是否会教授宝可梦孵化时掌握的蛋招式和曾通过招式记录掌握的招式。
  # 宝可梦升级招式中小于等于宝可梦等级的招式也可以回忆。
  MOVE_RELEARNER_CAN_TEACH_MORE_MOVES      = (MECHANICS_GENERATION >= 6)
  # 招式回忆会教授宝可梦升级时掌握的所有招式（true），还是只教授通常在/低于
  # 宝可梦当前等级时掌握的招式（false）。
  MOVE_RELEARNER_CAN_TEACH_ANY_LEVEL_MOVES = (MECHANICS_GENERATION == 7)

  #-----------------------------------------------------------------------------
  # Breeding Pokémon and Day Care.
  #-----------------------------------------------------------------------------

  # Whether Pokémon in the Day Care gain Exp for each step the player takes.
  # This should be true for the Day Care and false for the Pokémon Nursery, both
  # of which use the same code in Essentials.
  DAY_CARE_POKEMON_GAIN_EXP_FROM_WALKING     = (MECHANICS_GENERATION <= 6)
  # Whether two Pokémon in the Day Care can learn egg moves from each other if
  # they are the same species.
  DAY_CARE_POKEMON_CAN_SHARE_EGG_MOVES       = (MECHANICS_GENERATION >= 8)
  # Whether a bred baby Pokémon can inherit any TM/TR/HM moves from its father.
  # It can never inherit TM/TR/HM moves from its mother.
  BREEDING_CAN_INHERIT_MACHINE_MOVES         = (MECHANICS_GENERATION <= 5)
  # Whether a bred baby Pokémon can inherit egg moves from its mother. It can
  # always inherit egg moves from its father.
  BREEDING_CAN_INHERIT_EGG_MOVES_FROM_MOTHER = (MECHANICS_GENERATION >= 6)

  #-----------------------------------------------------------------------------
  # Roaming Pokémon.
  #-----------------------------------------------------------------------------

  # A list of maps used by roaming Pokémon. Each map has an array of other maps
  # it can lead to.
  ROAMING_AREAS = {
    5  => [   21, 28, 31, 39, 41, 44, 47, 66, 69],
    21 => [5,     28, 31, 39, 41, 44, 47, 66, 69],
    28 => [5, 21,     31, 39, 41, 44, 47, 66, 69],
    31 => [5, 21, 28,     39, 41, 44, 47, 66, 69],
    39 => [5, 21, 28, 31,     41, 44, 47, 66, 69],
    41 => [5, 21, 28, 31, 39,     44, 47, 66, 69],
    44 => [5, 21, 28, 31, 39, 41,     47, 66, 69],
    47 => [5, 21, 28, 31, 39, 41, 44,     66, 69],
    66 => [5, 21, 28, 31, 39, 41, 44, 47,     69],
    69 => [5, 21, 28, 31, 39, 41, 44, 47, 66    ]
  }
  # A set of hashes, each containing the details of a roaming Pokémon. The
  # information within each hash is as follows:
  #   * :species
  #   * :level
  #   * :icon - Filename in Graphics/UI/Town Map/ of the roamer's Town Map icon.
  #   * :game_switch - The Pokémon roams if this is nil or <=0 or if that Game
  #                    Switch is ON. Optional.
  #   * :encounter_type - One of:
  #       :all     = grass, walking in cave, surfing (default)
  #       :land    = grass, walking in cave
  #       :water   = surfing, fishing
  #       :surfing = surfing
  #       :fishing = fishing
  #   * :bgm - The BGM to play for the encounter. Optional.
  #   * :areas - A hash of map IDs that determine where this Pokémon roams. Used
  #              instead of ROAMING_AREAS above. Optional.
  ROAMING_SPECIES = [
    {
      :species        => :LATIAS,
      :level          => 30,
      :icon           => "pin_latias",
      :game_switch    => 53,
      :encounter_type => :all,
      :bgm            => "Battle roaming"
    },
    {
      :species        => :LATIOS,
      :level          => 30,
      :icon           => "pin_latios",
      :game_switch    => 53,
      :encounter_type => :all,
      :bgm            => "Battle roaming"
    },
    {
      :species        => :KYOGRE,
      :level          => 40,
      :game_switch    => 54,
      :encounter_type => :surfing,
      :areas          => {
        2  => [   21, 31    ],
        21 => [2,     31, 69],
        31 => [2, 21,     69],
        69 => [   21, 31    ]
      }
    },
    {
      :species        => :ENTEI,
      :level          => 40,
      :icon           => "pin_entei",
      :game_switch    => 55,
      :encounter_type => :land
    }
  ]

  #-----------------------------------------------------------------------------
  # Party and Pokémon storage.
  #-----------------------------------------------------------------------------

  # The maximum number of Pokémon that can be in the party.
  MAX_PARTY_SIZE      = 6
  # The number of boxes in Pokémon storage.
  NUM_STORAGE_BOXES   = 40
  # Whether putting a Pokémon into Pokémon storage will heal it. If false, they
  # are healed by the Recover All: Entire Party event command (at Poké Centers).
  HEAL_STORED_POKEMON = (MECHANICS_GENERATION <= 7)

  #-----------------------------------------------------------------------------
  # Items.
  #-----------------------------------------------------------------------------

  # Whether various HP-healing items heal the amounts they do in Gen 7+ (true)
  # or in earlier Generations (false).
  REBALANCED_HEALING_ITEM_AMOUNTS      = (MECHANICS_GENERATION >= 7)
  # Whether vitamins can add EVs no matter how many that stat already has in it
  # (true), or whether they can't make that stat's EVs greater than 100 (false).
  NO_VITAMIN_EV_CAP                    = (MECHANICS_GENERATION >= 8)
  # Whether Rage Candy Bar acts as a Full Heal (true) or a Potion (false).
  RAGE_CANDY_BAR_CURES_STATUS_PROBLEMS = (MECHANICS_GENERATION >= 7)
  # Whether the Black/White Flutes will raise/lower the levels of wild Pokémon
  # respectively (true), or will lower/raise the wild encounter rate
  # respectively (false).
  FLUTES_CHANGE_WILD_ENCOUNTER_LEVELS  = (MECHANICS_GENERATION >= 6)
  # Whether Rare Candy can be used on a Pokémon that is already at its maximum
  # level if it is able to evolve by level-up (if so, triggers that evolution).
  RARE_CANDY_USABLE_AT_MAX_LEVEL       = (MECHANICS_GENERATION >= 8)
  # Whether the player can choose how many of an item to use at once on a
  # Pokémon. This applies to Exp-changing items (Rare Candy, Exp Candies) and
  # EV-changing items (vitamins, feathers, EV-lowering berries).
  USE_MULTIPLE_STAT_ITEMS_AT_ONCE      = (MECHANICS_GENERATION >= 8)
  # If a move taught by a TM/HM/TR replaces another move, this Setting is
  # whether the machine's move retains the replaced move's PP (true), or whether
  # the machine's move has full PP (false).
  TAUGHT_MACHINES_KEEP_OLD_PP          = (MECHANICS_GENERATION == 5)
  # Whether you get 1 Premier Ball for every 10 of any kind of Poké Ball bought
  # from a Mart at once (true), or 1 Premier Ball for buying 10+ regular Poké
  # Balls (false).
  MORE_BONUS_PREMIER_BALLS             = (MECHANICS_GENERATION >= 8)
  # The default sell price of an item to a Poké Mart is its buy price divided by
  # this number.
  ITEM_SELL_PRICE_DIVISOR              = (MECHANICS_GENERATION >= 9) ? 4 : 2

  #-----------------------------------------------------------------------------
  # Pokédex.
  #-----------------------------------------------------------------------------

  # The names of the Regional Pokédex lists, in the order they are defined in
  # the PBS file "regional_dexes.txt". The National Dex is (and must be) added
  # to the end of this array of names.
  # Each entry is either just a name, or is an array containing a name and a
  # number. If there is a number, it is a region number as defined in
  # town_map.txt. If there is no number, the number of the region the player is
  # currently in will be used. The region number determines which Town Map is
  # shown in the Area page when viewing that Pokédex list.
  def self.pokedex_names
    return [
      [_INTL("关都图鉴"), 0],
      [_INTL("城都图鉴"), 1],
      _INTL("全国图鉴")
    ]
  end
  # An array of numbers, where each number is that of a Dex list (in the same
  # order as above, except the National Dex is -1). All Dex lists included here
  # will begin their numbering at 0 rather than 1 (e.g. Victini in Unova's Dex).
  DEXES_WITH_OFFSETS                        = []
  # Whether the Pokédex entry of a newly owned species will be shown after it
  # hatches from an egg, after it evolves and after obtaining it from a trade,
  # in addition to after catching it in battle.
  SHOW_NEW_SPECIES_POKEDEX_ENTRY_MORE_OFTEN = (MECHANICS_GENERATION >= 7)

  #-----------------------------------------------------------------------------
  # Phone contact rematches.
  #-----------------------------------------------------------------------------

  # The default value of Phone.rematches_enabled, which determines whether
  # trainers registered in the Phone can become ready for a rematch. If false,
  # Phone.rematches_enabled = true will enable rematches at any point you want.
  PHONE_REMATCHES_POSSIBLE_FROM_BEGINNING = false

  #-----------------------------------------------------------------------------
  # Battle starting.
  #-----------------------------------------------------------------------------

  # Whether Repel uses the level of the first Pokémon in the party regardless of
  # its HP (true), or it uses the level of the first unfainted Pokémon (false).
  REPEL_COUNTS_FAINTED_POKEMON             = (MECHANICS_GENERATION >= 6)
  # Whether more abilities affect whether wild Pokémon appear, which Pokémon
  # they are, etc.
  MORE_ABILITIES_AFFECT_WILD_ENCOUNTERS    = (MECHANICS_GENERATION >= 8)
  # Whether shiny wild Pokémon are more likely to appear if the player has
  # previously defeated/caught lots of other Pokémon of the same species.
  HIGHER_SHINY_CHANCES_WITH_NUMBER_BATTLED = (MECHANICS_GENERATION == 8)
  # Whether overworld weather can set the default terrain effect in battle.
  # Storm weather sets Electric Terrain, and fog weather sets Misty Terrain.
  OVERWORLD_WEATHER_SETS_BATTLE_TERRAIN    = (MECHANICS_GENERATION >= 8)

  #-----------------------------------------------------------------------------
  # Game Switches.
  #-----------------------------------------------------------------------------

  # The Game Switch that is set to ON when the player blacks out.
  STARTING_OVER_SWITCH      = 1
  # The Game Switch that is set to ON when the player has seen Pokérus in the
  # Poké Center (and doesn't need to be told about it again).
  SEEN_POKERUS_SWITCH       = 2
  # The Game Switch which, while ON, makes all wild Pokémon created be shiny.
  SHINY_WILD_POKEMON_SWITCH = 31
  # The Game Switch which, while ON, makes all Pokémon created considered to be
  # met via a fateful encounter.
  FATEFUL_ENCOUNTER_SWITCH  = 32
  # The Game Switch which, while ON, disables the effect of the Pokémon Box Link
  # and prevents the player from accessing Pokémon storage via the party screen
  # with it.
  DISABLE_BOX_LINK_SWITCH   = 35

  #-----------------------------------------------------------------------------
  # Overworld animation IDs.
  #-----------------------------------------------------------------------------

  # ID of the animation played when the player steps on grass (grass rustling).
  GRASS_ANIMATION_ID           = 1
  # ID of the animation played when the player lands on the ground after hopping
  # over a ledge (shows a dust impact).
  DUST_ANIMATION_ID            = 2
  # ID of the animation played when the player finishes taking a step onto still
  # water (shows a water ripple).
  WATER_RIPPLE_ANIMATION_ID    = 8
  # ID of the animation played when a trainer notices the player (an exclamation
  # bubble).
  EXCLAMATION_ANIMATION_ID     = 3
  # ID of the animation played when a patch of grass rustles due to using the
  # Poké Radar.
  RUSTLE_NORMAL_ANIMATION_ID   = 1
  # ID of the animation played when a patch of grass rustles vigorously due to
  # using the Poké Radar. (Rarer species)
  RUSTLE_VIGOROUS_ANIMATION_ID = 5
  # ID of the animation played when a patch of grass rustles and shines due to
  # using the Poké Radar. (Shiny encounter)
  RUSTLE_SHINY_ANIMATION_ID    = 6
  # ID of the animation played when a berry tree grows a stage while the player
  # is on the map (for new plant growth mechanics only).
  PLANT_SPARKLE_ANIMATION_ID   = 7

  #-----------------------------------------------------------------------------
  # Files.
  #-----------------------------------------------------------------------------

  DEFAULT_WILD_BATTLE_BGM     = "Battle wild"
  DEFAULT_WILD_VICTORY_BGM    = "Battle victory"
  DEFAULT_WILD_CAPTURE_ME     = "Battle capture success"
  DEFAULT_TRAINER_BATTLE_BGM  = "Battle trainer"
  DEFAULT_TRAINER_VICTORY_BGM = "Battle victory"

  #-----------------------------------------------------------------------------
  # Languages.
  #-----------------------------------------------------------------------------

  # An array of available languages in the game. Each one is an array containing
  # the display name of the language in-game, and that language's filename
  # fragment. A language will use the language data files from the Data folder
  # called messages_FRAGMENT_core.dat and messages_FRAGMENT_game.dat (if they
  # exist).
  # NOTE: Some messages or parts of code are different depending on the selected
  #       language. These things depend on the display name of the language as
  #       defined here. See:
  #       - def self.more_possessive_messages?
  #       - def self.whitespace_separates_words?
  LANGUAGES = [
#    ["English", "english"],
#    ["Français", "francais"],
#    ["Deutsch", "deutsch"],
#    ["中文", "chinese"],
#    ["日本語", "japanese"],
#    ["한국어", "korean"]
  ]

  #-----------------------------------------------------------------------------
  # Screen size and zoom.
  #-----------------------------------------------------------------------------

  # The default screen width (at a scale of 1.0). You should also edit the
  # property "defScreenW" in mkxp.json to match.
  SCREEN_WIDTH  = 512
  # The default screen height (at a scale of 1.0). You should also edit the
  # property "defScreenH" in mkxp.json to match.
  SCREEN_HEIGHT = 384
  # The default screen scale factor. Possible values are 0.5, 1.0, 1.5 and 2.0.
  SCREEN_SCALE  = 1.0

  #-----------------------------------------------------------------------------
  # Debug helpers.
  #-----------------------------------------------------------------------------

  # Whether the game will ask you if you want to fully compile every time you
  # start the game (in Debug mode). You will not need to hold Ctrl/Shift to
  # compile anything.
  PROMPT_TO_COMPILE    = false
  # Whether the game will skip the intro splash screens and title screen, and go
  # straight to the Continue/New Game screen. Only applies to playing in Debug
  # mode.
  SKIP_TITLE_SCREEN    = true
  # Whether the game will skip the Continue/New Game screen and go straight into
  # a saved game (if there is one) or start a new game (if there isn't). Only
  # applies to playing in Debug mode.
  SKIP_CONTINUE_SCREEN = false
end

#===============================================================================
# DO NOT EDIT THESE!
#===============================================================================
module Essentials
  VERSION = "21.99"
  ERROR_TEXT = ""
  MKXPZ_VERSION = "2.4.2/826929e"
end
