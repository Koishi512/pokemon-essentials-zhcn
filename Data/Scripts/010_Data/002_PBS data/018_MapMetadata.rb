#===============================================================================
#
#===============================================================================
module GameData
  class MapMetadata
    attr_reader :id
    attr_reader :real_name
    attr_reader :town_map_position
    attr_reader :town_map_size
    attr_reader :outdoor_map
    attr_reader :announce_location
    attr_reader :location_sign
    attr_reader :can_bicycle
    attr_reader :always_bicycle
    attr_reader :weather
    attr_reader :still_reflections
    attr_reader :dive_map_id
    attr_reader :teleport_destination
    attr_reader :dark_map
    attr_reader :safari_map
    attr_reader :random_dungeon
    attr_reader :snap_edges
    attr_reader :battle_background
    attr_reader :battle_environment
    attr_reader :wild_battle_BGM
    attr_reader :trainer_battle_BGM
    attr_reader :wild_victory_BGM
    attr_reader :trainer_victory_BGM
    attr_reader :wild_capture_ME
    attr_reader :flags
    attr_reader :pbs_file_suffix

    DATA = {}
    DATA_FILENAME = "map_metadata.dat"
    PBS_BASE_FILENAME = "map_metadata"
    SCHEMA = {
      "SectionName"       => [:id,                   "u"],
      "Name"              => [:real_name,            "s"],
      "MapPosition"       => [:town_map_position,    "uuu"],
      "MapSize"           => [:town_map_size,        "us"],
      "Outdoor"           => [:outdoor_map,          "b"],
      "ShowArea"          => [:announce_location,    "b"],
      "LocationSign"      => [:location_sign,        "s"],
      "Bicycle"           => [:can_bicycle,          "b"],
      "BicycleAlways"     => [:always_bicycle,       "b"],
      "Weather"           => [:weather,              "eu", :Weather],
      "StillReflections"  => [:still_reflections,    "b"],
      "DiveMap"           => [:dive_map_id,          "v"],
      "HealingSpot"       => [:teleport_destination, "vuu"],
      "DarkMap"           => [:dark_map,             "b"],
      "SafariMap"         => [:safari_map,           "b"],
      "Dungeon"           => [:random_dungeon,       "b"],
      "SnapEdges"         => [:snap_edges,           "b"],
      "BattleBack"        => [:battle_background,    "s"],
      "Environment"       => [:battle_environment,   "e", :Environment],
      "WildBattleBGM"     => [:wild_battle_BGM,      "s"],
      "TrainerBattleBGM"  => [:trainer_battle_BGM,   "s"],
      "WildVictoryBGM"    => [:wild_victory_BGM,     "s"],
      "TrainerVictoryBGM" => [:trainer_victory_BGM,  "s"],
      "WildCaptureME"     => [:wild_capture_ME,      "s"],
      "Flags"             => [:flags,                "*s"]
    }

    extend ClassMethodsIDNumbers
    include InstanceMethods

    def self.editor_properties
      return [
        ["ID",                ReadOnlyProperty,        _INTL("地图的ID编号。")],
        ["Name",              StringProperty,          _INTL("地图的名称，玩家可以看到。可以与RMXP中看到的地图名称不同。")],
        ["MapPosition",       RegionMapCoordsProperty, _INTL("标识此地图在区域地图上的位置。")],
        ["MapSize",           MapSizeProperty,         _INTL("地图在城镇地图方块中的宽度，以及指示哪些方块属于此地图的字符串。")],
        ["Outdoor",           BooleanProperty,         _INTL("如果为真，此地图是户外地图，并且会根据一天中的时间着色。")],
        ["ShowArea",          BooleanProperty,         _INTL("如果为真，进入此地图时游戏将显示地图名称。")],
        ["LocationSign",      StringProperty,          _INTL("'Graphics/UI/Location/'中用于地点标识的文件名。")],
        ["Bicycle",           BooleanProperty,         _INTL("如果为真，此地图上可以使用自行车。")],
        ["BicycleAlways",     BooleanProperty,         _INTL("如果为真，此地图上自行车将自动骑乘且无法下车。")],
        ["Weather",           WeatherEffectProperty,   _INTL("此地图的天气条件。")],
        ["StillReflections",  BooleanProperty,         _INTL("如果为真，事件和玩家的倒影不会水平波动。")],
        ["DiveMap",           MapProperty,             _INTL("指定此地图的水下图层。仅当此地图有深水时使用。")],
        ["HealingSpot",       MapCoordsProperty,       _INTL("此宝可梦中心所在城镇的地图ID，以及其在该城镇内的入口X和Y坐标。")],
        ["DarkMap",           BooleanProperty,         _INTL("如果为真，此地图是黑暗的，玩家周围会出现一个光圈。可以使用手电筒来扩大光圈。")],
        ["SafariMap",         BooleanProperty,         _INTL("如果为真，此地图是狩猎区的一部分（包括室内和室外）。不得在接待处使用。")],
        ["Dungeon",           BooleanProperty,         _INTL("如果为真，此地图具有随机生成的布局。更多信息请参见维基。")],
        ["SnapEdges",         BooleanProperty,         _INTL("如果为真，当玩家接近此地图的边缘时，游戏不会像往常一样将玩家居中。")],
        ["BattleBack",        StringProperty,          _INTL("在战斗背景文件夹中名为'XXX_bg'、'XXX_base0'、'XXX_base1'、'XXX_message'的PNG文件，其中XXX是此属性的值。")],
        ["Environment",       GameDataProperty.new(:Environment), _INTL("此地图上战斗的默认环境。")],
        ["WildBattleBGM",     BGMProperty,             _INTL("此地图上野生宝可梦战斗的默认BGM。")],
        ["TrainerBattleBGM",  BGMProperty,             _INTL("此地图上训练家战斗的默认BGM。")],
        ["WildVictoryBGM",    BGMProperty,             _INTL("玩家在此地图上战胜野生宝可梦后播放的默认BGM。")],
        ["TrainerVictoryBGM", BGMProperty,             _INTL("玩家在此地图上战胜训练家后播放的默认BGM。")],
        ["WildCaptureME",     MEProperty,              _INTL("玩家在此地图上捕捉野生宝可梦后播放的默认ME。")],
        ["Flags",             StringListProperty,      _INTL("用于区分此地图与其他地图的词语/短语。")]
      ]
    end

    #---------------------------------------------------------------------------

    def initialize(hash)
      @id                   = hash[:id]
      @real_name            = hash[:real_name]
      @town_map_position    = hash[:town_map_position]
      @town_map_size        = hash[:town_map_size]
      @outdoor_map          = hash[:outdoor_map]
      @announce_location    = hash[:announce_location]
      @location_sign        = hash[:location_sign]
      @can_bicycle          = hash[:can_bicycle]
      @always_bicycle       = hash[:always_bicycle]
      @weather              = hash[:weather]
      @still_reflections    = hash[:still_reflections]
      @dive_map_id          = hash[:dive_map_id]
      @teleport_destination = hash[:teleport_destination]
      @dark_map             = hash[:dark_map]
      @safari_map           = hash[:safari_map]
      @random_dungeon       = hash[:random_dungeon]
      @snap_edges           = hash[:snap_edges]
      @battle_background    = hash[:battle_background]
      @battle_environment   = hash[:battle_environment]
      @wild_battle_BGM      = hash[:wild_battle_BGM]
      @trainer_battle_BGM   = hash[:trainer_battle_BGM]
      @wild_victory_BGM     = hash[:wild_victory_BGM]
      @trainer_victory_BGM  = hash[:trainer_victory_BGM]
      @wild_capture_ME      = hash[:wild_capture_ME]
      @flags                = hash[:flags]           || []
      @pbs_file_suffix      = hash[:pbs_file_suffix] || ""
    end

    # @return [String] the translated name of this map
    def name
      ret = pbGetMessageFromHash(MessageTypes::MAP_NAMES, @real_name)
      ret = pbGetBasicMapNameFromId(@id) if nil_or_empty?(ret)
      ret.gsub!(/\\PN/, $player.name) if $player
      return ret
    end

    def has_flag?(flag)
      return @flags.any? { |f| f.downcase == flag.downcase }
    end

    alias __orig__get_property_for_PBS get_property_for_PBS unless method_defined?(:__orig__get_property_for_PBS)
    def get_property_for_PBS(key)
      key = "SectionName" if key == "ID"
      return __orig__get_property_for_PBS(key)
    end
  end
end
