#===============================================================================
#
#===============================================================================
module GameData
  class PlayerMetadata
    attr_reader :id
    attr_reader :trainer_type
    attr_reader :walk_charset
    attr_reader :home
    attr_reader :pbs_file_suffix

    DATA = {}
    DATA_FILENAME = "player_metadata.dat"
    SCHEMA = {
      "SectionName"     => [:id,                "u"],
      "TrainerType"     => [:trainer_type,      "e", :TrainerType],
      "WalkCharset"     => [:walk_charset,      "s"],
      "RunCharset"      => [:run_charset,       "s"],
      "CycleCharset"    => [:cycle_charset,     "s"],
      "SurfCharset"     => [:surf_charset,      "s"],
      "DiveCharset"     => [:dive_charset,      "s"],
      "FishCharset"     => [:fish_charset,      "s"],
      "SurfFishCharset" => [:surf_fish_charset, "s"],
      "Home"            => [:home,              "vuuu"]
    }

    extend ClassMethodsIDNumbers
    include InstanceMethods

    def self.editor_properties
      return [
        ["ID",              ReadOnlyProperty,        _INTL("玩家的ID编号。")],
        ["TrainerType",     TrainerTypeProperty,     _INTL("此玩家的训练家类型。")],
        ["WalkCharset",     CharacterProperty,       _INTL("玩家静止或行走时使用的行走图。")],
        ["RunCharset",      CharacterProperty,       _INTL("玩家跑步时使用的行走图。未定义时使用WalkCharset。")],
        ["CycleCharset",    CharacterProperty,       _INTL("玩家骑自行车时使用的行走图。未定义时使用RunCharset。")],
        ["SurfCharset",     CharacterProperty,       _INTL("玩家冲浪时使用的行走图。未定义时使用CycleCharset。")],
        ["DiveCharset",     CharacterProperty,       _INTL("玩家潜水时使用的行走图。未定义时使用SurfCharset。")],
        ["FishCharset",     CharacterProperty,       _INTL("玩家钓鱼时使用的行走图。未定义时使用WalkCharset。")],
        ["SurfFishCharset", CharacterProperty,       _INTL("玩家冲浪时钓鱼使用的行走图。未定义时使用FishCharset。")],
        ["Home",            MapCoordsFacingProperty, _INTL("玩家在失败后未访问过宝可梦中心时前往的地点的地图ID和X/Y坐标。")]
      ]
    end

    # @param player_id [Integer]
    # @return [self, nil]
    def self.get(player_id = 1)
      validate player_id => Integer
      return self::DATA[player_id] if self::DATA.has_key?(player_id)
      return self::DATA[1]
    end

    #---------------------------------------------------------------------------

    def initialize(hash)
      @id                = hash[:id]
      @trainer_type      = hash[:trainer_type]
      @walk_charset      = hash[:walk_charset]
      @run_charset       = hash[:run_charset]
      @cycle_charset     = hash[:cycle_charset]
      @surf_charset      = hash[:surf_charset]
      @dive_charset      = hash[:dive_charset]
      @fish_charset      = hash[:fish_charset]
      @surf_fish_charset = hash[:surf_fish_charset]
      @home              = hash[:home]
      @pbs_file_suffix   = hash[:pbs_file_suffix] || ""
    end

    def run_charset
      return @run_charset || @walk_charset
    end

    def cycle_charset
      return @cycle_charset || run_charset
    end

    def surf_charset
      return @surf_charset || cycle_charset
    end

    def dive_charset
      return @dive_charset || surf_charset
    end

    def fish_charset
      return @fish_charset || @walk_charset
    end

    def surf_fish_charset
      return @surf_fish_charset || fish_charset
    end

    alias __orig__get_property_for_PBS get_property_for_PBS unless method_defined?(:__orig__get_property_for_PBS)
    def get_property_for_PBS(key)
      key = "SectionName" if key == "ID"
      return __orig__get_property_for_PBS(key)
    end
  end
end
