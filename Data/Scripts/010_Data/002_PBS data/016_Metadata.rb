#===============================================================================
#
#===============================================================================
module GameData
  class Metadata
    attr_reader :id
    attr_reader :start_money
    attr_reader :start_item_storage
    attr_reader :home
    attr_reader :real_storage_creator
    attr_reader :wild_battle_BGM
    attr_reader :trainer_battle_BGM
    attr_reader :wild_victory_BGM
    attr_reader :trainer_victory_BGM
    attr_reader :wild_capture_ME
    attr_reader :surf_BGM
    attr_reader :bicycle_BGM
    attr_reader :pbs_file_suffix

    DATA = {}
    DATA_FILENAME = "metadata.dat"
    PBS_BASE_FILENAME = "metadata"
    SCHEMA = {
      "SectionName"       => [:id,                   "u"],
      "StartMoney"        => [:start_money,          "u"],
      "StartItemStorage"  => [:start_item_storage,   "*e", :Item],
      "Home"              => [:home,                 "vuuu"],
      "StorageCreator"    => [:real_storage_creator, "s"],
      "WildBattleBGM"     => [:wild_battle_BGM,      "s"],
      "TrainerBattleBGM"  => [:trainer_battle_BGM,   "s"],
      "WildVictoryBGM"    => [:wild_victory_BGM,     "s"],
      "TrainerVictoryBGM" => [:trainer_victory_BGM,  "s"],
      "WildCaptureME"     => [:wild_capture_ME,      "s"],
      "SurfBGM"           => [:surf_BGM,             "s"],
      "BicycleBGM"        => [:bicycle_BGM,          "s"]
    }

    extend ClassMethodsIDNumbers
    include InstanceMethods

    def self.editor_properties
      return [
        ["StartMoney",        LimitProperty.new(Settings::MAX_MONEY), _INTL("玩家开始游戏时拥有的零花钱数量。")],
        ["StartItemStorage",  GameDataPoolProperty.new(:Item),        _INTL("玩家在游戏开始时已有的道具。")],
        ["Home",              MapCoordsFacingProperty, _INTL("玩家在失败后未访问过宝可梦中心时前往的地点的地图ID和X/Y坐标。")],
        ["StorageCreator",    StringProperty,          _INTL("宝可梦寄放系统创建者的名称（存储选项名为\"XXX的电脑\"）。")],
        ["WildBattleBGM",     BGMProperty,             _INTL("野生宝可梦战斗的默认BGM。")],
        ["TrainerBattleBGM",  BGMProperty,             _INTL("训练家战斗的默认BGM。")],
        ["WildVictoryBGM",    BGMProperty,             _INTL("玩家战胜野生宝可梦后播放的BGM。")],
        ["TrainerVictoryBGM", BGMProperty,             _INTL("玩家战胜训练家后播放的BGM。")],
        ["WildCaptureME",     MEProperty,              _INTL("捕捉宝可梦后播放的ME。")],
        ["SurfBGM",           BGMProperty,             _INTL("冲浪时播放的BGM。")],
        ["BicycleBGM",        BGMProperty,             _INTL("骑自行车时播放的BGM。")]
      ]
    end

    def self.get
      return DATA[0]
    end

    #---------------------------------------------------------------------------

    def initialize(hash)
      @id                   = hash[:id]                 || 0
      @start_money          = hash[:start_money]        || 3000
      @start_item_storage   = hash[:start_item_storage] || []
      @home                 = hash[:home]
      @real_storage_creator = hash[:real_storage_creator]
      @wild_battle_BGM      = hash[:wild_battle_BGM]
      @trainer_battle_BGM   = hash[:trainer_battle_BGM]
      @wild_victory_BGM     = hash[:wild_victory_BGM]
      @trainer_victory_BGM  = hash[:trainer_victory_BGM]
      @wild_capture_ME      = hash[:wild_capture_ME]
      @surf_BGM             = hash[:surf_BGM]
      @bicycle_BGM          = hash[:bicycle_BGM]
      @pbs_file_suffix      = hash[:pbs_file_suffix]    || ""
    end

    # @return [String] the translated name of the Pokémon Storage creator
    def storage_creator
      ret = pbGetMessageFromHash(MessageTypes::STORAGE_CREATOR_NAME, @real_storage_creator)
      return nil_or_empty?(ret) ? _INTL("正辉") : ret
    end
  end
end
