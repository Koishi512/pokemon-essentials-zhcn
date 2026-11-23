#===============================================================================
# Effect values that can be edited via the battle debug menu.
#===============================================================================
module Battle::DebugVariables
  BATTLER_EFFECTS = {
    PBEffects::AllySwitchRate => {name: "交换场地成功率（1/x）",                  default: 1, max: 999},
    PBEffects::AquaRing       => {name: "水流环生效",                               default: false},
    PBEffects::Attract        => {name: "使自己着迷的战斗者",               default: -1},   # Battler index
    PBEffects::BanefulBunker  => {name: "本回合碉堡生效",               default: false},
#    PBEffects::BeakBlast - only applies to use of specific move, not suitable for setting via debug
    PBEffects::Bide           => {name: "忍忍剩余回合数",                 default: 0},
    PBEffects::BideDamage     => {name: "忍忍累积伤害",                         default: 0, max: 999},
    PBEffects::BideTarget     => {name: "忍忍最后伤害自己的战斗者",                  default: -1},   # Battler index
    PBEffects::BoosterEnergy  => {name: "驱劲能量效果生效",                 default: false},
    PBEffects::BurningBulwark => {name: "本回合火焰守护生效",              default: false},
    PBEffects::BurnUp         => {name: "燃尽已移除自身火属性",            default: false},
    PBEffects::Charge         => {name: "充电剩余回合数",               default: 0},
    PBEffects::ChoiceBand     => {name: "被讲究类道具锁定的招式",                default: nil, type: :move},
#    PBEffects::CommandedBy - not suitable for setting via debug
#    PBEffects::Commanding - not suitable for setting via debug
    PBEffects::Confusion      => {name: "混乱剩余回合数",            default: 0},
#    PBEffects::Counter - not suitable for setting via debug
#    PBEffects::CounterTarget - not suitable for setting via debug
    PBEffects::CudChewBerry   => {name: "反刍要吃的道具",                    default: nil, type: :item},
    PBEffects::CudChewCounter => {name: "反刍剩余回合数",             default: 0},
    PBEffects::Curse          => {name: "诅咒伤害效果生效",                          default: false},
#    PBEffects::Dancer - only used while Dancer is running, not suitable for setting via debug
    PBEffects::DefenseCurl    => {name: "已使用变圆",                               default: false},
#    PBEffects::DestinyBond - not suitable for setting via debug
#    PBEffects::DestinyBondPrevious - not suitable for setting via debug
#    PBEffects::DestinyBondTarget - not suitable for setting via debug
    PBEffects::Disable        => {name: "定身法剩余回合数",              default: 0},
    PBEffects::DisableMove    => {name: "被定身法的招式",                                   default: nil, type: :move},
    PBEffects::DoubleShock    => {name: "电光双击已移除自身电属性",   default: false},
    PBEffects::Electrify      => {name: "输电使招式变为电属性",                 default: false},
    PBEffects::Embargo        => {name: "查封剩余回合数",              default: 0},
    PBEffects::Encore         => {name: "再来一次剩余回合数",               default: 0},
    PBEffects::EncoreMove     => {name: "被再来一次的招式",                                    default: nil, type: :move},
    PBEffects::Endure         => {name: "本回合挺住所有致命伤害",            default: false},
#    PBEffects::ExtraType - set elsewhere
#    PBEffects::FirstPledge - only applies to use of specific move, not suitable for setting via debug
    PBEffects::FlashFire      => {name: "引火强化火属性招式",               default: false},
    PBEffects::Flinch         => {name: "本回合会畏缩",                          default: false},
    PBEffects::FocusEnergy    => {name: "聚气击中要害等级（0-4）",          default: 0, max: 4},
#    PBEffects::FocusPunch - only applies to use of specific move, not suitable for setting via debug
    PBEffects::FollowMe       => {name: "看我嘛吸引攻击（1以上）",            default: 0},   # Order of use, lowest takes priority
    PBEffects::Foresight      => {name: "识破生效（幽灵属性失去免疫）",      default: false},
    PBEffects::FuryCutter     => {name: "连斩威力倍率 2**x（0-4）",         default: 0, max: 4},
    PBEffects::GastroAcid     => {name: "胃液使自身特性无效",          default: false},
#    PBEffects::GemConsumed - only applies during use of move, not suitable for setting via debug
    PBEffects::GigatonHammer  => {name: "巨力锤/血月是最后使用的招式", default: false},
    PBEffects::Grudge         => {name: "自身倒下时怨念生效",                default: false},
    PBEffects::HealBlock      => {name: "回复封锁剩余回合数",           default: 0},
    PBEffects::HelpingHand    => {name: "帮助将强化自身招式",          default: 0},
    PBEffects::HyperBeam      => {name: "破坏光线无法行动的剩余回合数",            default: 0},
#    PBEffects::Illusion - is a Pokémon object, too complex to be worth bothering with
    PBEffects::Imprison       => {name: "封印使对手无法使用自身会的招式",   default: false},
    PBEffects::Ingrain        => {name: "扎根生效",                                 default: false},
#    PBEffects::Instruct - only used while Instruct is running, not suitable for setting via debug
#    PBEffects::Instructed - only used while Instruct is running, not suitable for setting via debug
    PBEffects::JawLock        => {name: "用紧咬不放束缚自己的战斗者",             default: -1},   # Battler index
    PBEffects::KingsShield    => {name: "本回合王者盾牌生效",                default: false},
    PBEffects::LaserFocus     => {name: "磨砺必定击中要害的持续回合",        default: 0},
    PBEffects::LeechSeed      => {name: "对自己使用寄生种子的战斗者",            default: -1},   # Battler index
    PBEffects::LockOn         => {name: "锁定剩余回合数",              default: 0},
    PBEffects::LockOnPos      => {name: "自身用锁定指定的战斗者",     default: -1},   # Battler index
#    PBEffects::MagicBounce - only applies during use of move, not suitable for setting via debug
#    PBEffects::MagicCoat - only applies to use of specific move, not suitable for setting via debug
    PBEffects::MagnetRise     => {name: "电磁飘浮剩余回合数",          default: 0},
    PBEffects::MeanLook       => {name: "用黑色目光等束缚自己的战斗者",      default: -1},   # Battler index
#    PBEffects::MeFirst - only applies to use of specific move, not suitable for setting via debug
    PBEffects::Metronome      => {name: "节拍器道具威力倍率 1 + 0.2*x（0-5）", default: 0, max: 5},
    PBEffects::MicleBerry     => {name: "通通果提升下一招命中率",       default: false},
    PBEffects::Minimize       => {name: "已使用变小",                                   default: false},
    PBEffects::MiracleEye     => {name: "奇迹之眼生效（恶属性失去免疫）",     default: false},
#    PBEffects::MirrorCoat - not suitable for setting via debug
#    PBEffects::MirrorCoatTarget - not suitable for setting via debug
#    PBEffects::MoveNext - not suitable for setting via debug
    PBEffects::MudSport       => {name: "已使用玩泥巴（第5世代及以前）",                default: false},
    PBEffects::Nightmare      => {name: "受到恶梦伤害",                         default: false},
    PBEffects::NoRetreat      => {name: "背水一战使自身无法替换",              default: false},
    PBEffects::Obstruct       => {name: "本回合拦堵生效",                     default: false},
    PBEffects::Octolock       => {name: "用蛸固束缚自己的战斗者",             default: -1},   # Battler index
    PBEffects::Outrage        => {name: "逆鳞剩余回合数",              default: 0},
#    PBEffects::ParentalBond - only applies during use of move, not suitable for setting via debug
    PBEffects::PerishSong     => {name: "灭亡之歌剩余回合数",          default: 0},
    PBEffects::PerishSongUser => {name: "对自己使用灭亡之歌的战斗者",           default: -1},   # Battler index
    PBEffects::PickupItem     => {name: "可被捡拾拾取的道具",                      default: nil, type: :item},
    PBEffects::PickupUse      => {name: "捡拾道具的消耗时间（数值越大越新）",  default: 0},
    PBEffects::Pinch          => {name: "（对战宫殿）HP低于50%时行动方式改变",     default: false},
    PBEffects::Powder         => {name: "本回合粉尘会使自身火属性招式爆炸", default: false},
#    PBEffects::PowerTrick - doesn't actually swap the stats therefore does nothing, not suitable for setting via debug
#    PBEffects::Prankster - not suitable for setting via debug
#    PBEffects::PriorityAbility - not suitable for setting via debug
#    PBEffects::PriorityItem - not suitable for setting via debug
    PBEffects::Protect        => {name: "本回合守住生效",                      default: false},
    PBEffects::ProtectRate    => {name: "守住成功率（1/x）",                      default: 1, max: 999},
#    PBEffects::ProtosynthesisStat - TODO: code doesn't support choosing a stat
#    PBEffects::Quash - not suitable for setting via debug
#    PBEffects::Rage - only applies to use of specific move, not suitable for setting via debug
    PBEffects::RagePowder     => {name: "愤怒粉生效（与看我嘛配合）",        default: false},
    PBEffects::Rollout        => {name: "滚动剩余回合数（数值越小威力越高）",       default: 0},
    PBEffects::Roost          => {name: "本回合羽栖移除飞行属性",           default: false},
    PBEffects::SaltCure       => {name: "盐腌生效（每回合受到伤害）",     default: false},
#    PBEffects::ShedTail - only applies while switching with Shed Tail, not suitable for setting via debug
#    PBEffects::ShellTrap - only applies to use of specific move, not suitable for setting via debug
    PBEffects::SilkTrap       => {name: "本回合线阱生效",                    default: false},
#    PBEffects::SkyDrop - only applies to use of specific move, not suitable for setting via debug
    PBEffects::SlowStart      => {name: "慢启动剩余回合数",                     default: 0},
    PBEffects::SmackDown      => {name: "击落使自身接地",                    default: false},
#    PBEffects::Snatch - only applies to use of specific move, not suitable for setting via debug
    PBEffects::SpikyShield    => {name: "本回合尖刺防守生效",                 default: false},
    PBEffects::Spotlight      => {name: "聚光灯吸引攻击（1以上）",            default: 0},
    PBEffects::Stockpile      => {name: "蓄力次数（0-3）",                           default: 0, max: 3},
    PBEffects::StockpileDef   => {name: "蓄力获得的防御等级（0-12）",           default: 0, max: 12},
    PBEffects::StockpileSpDef => {name: "蓄力获得的特防等级（0-12）",       default: 0, max: 12},
    PBEffects::Substitute     => {name: "替身的HP",                                 default: 0, max: 999},
    PBEffects::SyrupBomb      => {name: "糖浆炸弹剩余回合数",           default: 0},
    PBEffects::SyrupBombUser  => {name: "对自己使用糖浆炸弹的战斗者",            default: -1},   # Battler index
    PBEffects::TarShot        => {name: "沥青射击使自身更容易受到火属性伤害",                 default: false},
    PBEffects::Taunt          => {name: "挑衅剩余回合数",                default: 0},
    PBEffects::Telekinesis    => {name: "意念移物剩余回合数",          default: 0},
    PBEffects::ThroatChop     => {name: "深渊突刺剩余回合数",          default: 0},
    PBEffects::Torment        => {name: "无理取闹使自身无法连续使用招式",              default: false},
#    PBEffects::Toxic - set elsewhere
#    PBEffects::Transform - too complex to be worth bothering with
#    PBEffects::TransformSpecies - too complex to be worth bothering with
    PBEffects::Trapping       => {name: "束缚剩余回合数",             default: 0},
    PBEffects::TrappingMove   => {name: "束缚自身的招式",                      default: nil, type: :move},
    PBEffects::TrappingUser   => {name: "束缚自身的战斗者（用于紧绑束带）",        default: -1},   # Battler index
    PBEffects::Truant         => {name: "懒惰在本回合偷懒",              default: false},
#    PBEffects::TwoTurnAttack - only applies to use of specific moves, not suitable for setting via debug
    PBEffects::Unburden       => {name: "自身失去了道具（用于轻装）",               default: false},
    PBEffects::Uproar         => {name: "吵闹剩余回合数",               default: 0},
    PBEffects::Vulnerable     => {name: "攻击必定命中自身（巨剑突击）",       default: false},
    PBEffects::WaterSport     => {name: "已使用玩水（第5世代及以前）",              default: false},
    PBEffects::WeightChange   => {name: "体重变化 +0.1*x kg",                         default: 0, min: -99_999, max: 99_999},
    PBEffects::Yawn           => {name: "哈欠剩余回合数（之后陷入睡眠）",      default: 0}
  }

  POSITION_EFFECTS = {
#    PBEffects::FutureSightCounter - too complex to be worth bothering with
#    PBEffects::FutureSightMove - too complex to be worth bothering with
#    PBEffects::FutureSightUserIndex - too complex to be worth bothering with
#    PBEffects::FutureSightUserPartyIndex - too complex to be worth bothering with
    PBEffects::HealingWish => {name: "治愈之愿是否等待生效", default: false},
    PBEffects::LunarDance  => {name: "新月舞是否等待生效",  default: false}
#    PBEffects::Wish - too complex to be worth bothering with
#    PBEffects::WishAmount - too complex to be worth bothering with
#    PBEffects::WishMaker - too complex to be worth bothering with
  }

  SIDE_EFFECTS = {
    PBEffects::AuroraVeil         => {name: "极光幕持续回合",                   default: 0},
    PBEffects::CraftyShield       => {name: "本回合戏法防守生效",       default: false},
    PBEffects::EchoedVoiceCounter => {name: "回声已使用回合数（最多5）",      default: 0, max: 5},
    PBEffects::EchoedVoiceUsed    => {name: "本回合已使用回声",           default: false},
    PBEffects::LastRoundFainted   => {name: "该方战斗者最后倒下的回合", default: -2},   # Treated as -1, isn't a battler index
    PBEffects::LightScreen        => {name: "光墙持续回合",                  default: 0},
    PBEffects::LuckyChant         => {name: "幸运咒语持续回合",                   default: 0},
    PBEffects::MatBlock           => {name: "本回合掀榻榻米生效",           default: false},
    PBEffects::Mist               => {name: "白雾持续回合",                          default: 0},
    PBEffects::QuickGuard         => {name: "本回合快速防守生效",         default: false},
    PBEffects::Rainbow            => {name: "彩虹持续回合",                       default: 0},
    PBEffects::Reflect            => {name: "反射壁持续回合",                       default: 0},
    PBEffects::Round              => {name: "本回合已使用轮唱",              default: false},
    PBEffects::Safeguard          => {name: "神秘守护持续回合",                     default: 0},
    PBEffects::SeaOfFire          => {name: "火海持续回合",                   default: 0},
    PBEffects::Spikes             => {name: "撒菱层数（0-3）",                    default: 0, max: 3},
    PBEffects::StealthRock        => {name: "隐形岩存在",                    default: false},
    PBEffects::StickyWeb          => {name: "黏黏网存在",                      default: false},
    PBEffects::Swamp              => {name: "沼泽持续回合",                         default: 0},
    PBEffects::Tailwind           => {name: "顺风持续回合",                      default: 0},
    PBEffects::ToxicSpikes        => {name: "毒菱层数（0-2）",              default: 0, max: 2},
    PBEffects::WideGuard          => {name: "本回合广域防守生效",          default: false}
  }

  FIELD_EFFECTS = {
    PBEffects::AmuletCoin      => {name: "护符金币使奖金翻倍", default: false},
    PBEffects::FairyLock       => {name: "妖精之锁束缚持续回合",     default: 0},
    PBEffects::FusionBolt      => {name: "已使用交错闪电",             default: false},
    PBEffects::FusionFlare     => {name: "已使用交错火焰",            default: false},
    PBEffects::Gravity         => {name: "重力持续回合",                 default: 0},
    PBEffects::HappyHour       => {name: "庆祝使奖金翻倍",  default: false},
    PBEffects::IonDeluge       => {name: "等离子浴使招式变为电属性", default: false},
    PBEffects::MagicRoom       => {name: "魔法空间持续回合",              default: 0},
    PBEffects::MudSportField   => {name: "玩泥巴持续回合（第6世代及以后）",      default: 0},
    PBEffects::PayDay          => {name: "聚宝功追加奖金",   default: 0, max: Settings::MAX_MONEY},
    PBEffects::TrickRoom       => {name: "戏法空间持续回合",              default: 0},
    PBEffects::WaterSportField => {name: "玩水持续回合（第6世代及以后）",    default: 0},
    PBEffects::WonderRoom      => {name: "奇妙空间持续回合",             default: 0}
  }
end

#===============================================================================
# Screen for listing the above battle variables for modifying.
#===============================================================================
class SpriteWindow_DebugBattleFieldEffects < Window_DrawableCommand
  BASE_TEXT_COLOR   = Color.new(96, 96, 96)
  RED_TEXT_COLOR    = Color.new(168, 48, 56)
  GREEN_TEXT_COLOR  = Color.new(0, 144, 0)
  TEXT_SHADOW_COLOR = Color.new(208, 208, 200)

  def initialize(viewport, battle, variables, variables_data)
    @battle         = battle
    @variables      = variables
    @variables_data = variables_data
    super(0, 0, Graphics.width, Graphics.height, viewport)
  end

  def itemCount
    return @variables_data.length
  end

  def shadowtext(x, y, w, h, t, align = 0, colors = 0)
    width = self.contents.text_size(t).width
    case align
    when 1   # Right aligned
      x += w - width
    when 2   # Centre aligned
      x += (w - width) / 2
    end
    base_color = BASE_TEXT_COLOR
    case colors
    when 1 then base_color = RED_TEXT_COLOR
    when 2 then base_color = GREEN_TEXT_COLOR
    end
    pbDrawShadowText(self.contents, x, y, [width, w].max, h, t, base_color, TEXT_SHADOW_COLOR)
  end

  def drawItem(index, _count, rect)
    pbSetNarrowFont(self.contents)
    variable_data = @variables_data[@variables_data.keys[index]]
    variable = @variables[@variables_data.keys[index]]
    # Variables which aren't their default value are colored differently
    default = variable_data[:default]
    default = -1 if default == -2
    different = (variable || default) != default
    color = (different) ? 2 : 0
    # Draw cursor
    rect = drawCursor(index, rect)
    # Get value's text to draw
    variable_text = variable.to_s
    case variable_data[:default]
    when -1   # Battler
      if variable >= 0
        battler_name = @battle.battlers[variable].name
        battler_name = "-" if nil_or_empty?(battler_name)
        variable_text = _INTL("[{1}] {2}", variable, battler_name)
      else
        variable_text = _INTL("[无]")
      end
    when nil   # Move, item
      variable_text = _INTL("[无]") if !variable
    end
    # Draw text
    total_width = rect.width
    name_width  = total_width * 80 / 100
    value_width = total_width * 20 / 100
    self.shadowtext(rect.x, rect.y + 8, name_width, rect.height, variable_data[:name], 0, color)
    self.shadowtext(rect.x + name_width, rect.y + 8, value_width, rect.height, variable_text, 1, color)
  end
end

#===============================================================================
#
#===============================================================================
class Battle::DebugSetEffects
  def initialize(battle, mode, side = 0)
    @battle = battle
    @mode = mode
    @side = side
    case @mode
    when :field
      @variables_data = Battle::DebugVariables::FIELD_EFFECTS
      @variables = @battle.field.effects
    when :side
      @variables_data = Battle::DebugVariables::SIDE_EFFECTS
      @variables = @battle.sides[@side].effects
    when :position
      @variables_data = Battle::DebugVariables::POSITION_EFFECTS
      @variables = @battle.positions[@side].effects
    when :battler
      @variables_data = Battle::DebugVariables::BATTLER_EFFECTS
      @variables = @battle.battlers[@side].effects
    end
    @viewport = Viewport.new(0, 0, Graphics.width, Graphics.height)
    @viewport.z = 99_999
    @window = SpriteWindow_DebugBattleFieldEffects.new(@viewport, @battle, @variables, @variables_data)
    @window.active = true
  end

  def dispose
    @window.dispose
    @viewport.dispose
  end

  def choose_number(default, min, max)
    params = ChooseNumberParams.new
    params.setRange(min, max)
    params.setDefaultValue(default)
    params.setNegativesAllowed(true) if min < 0
    return pbMessageChooseNumber(_INTL("设置值（{1}-{2}）。", min, max), params)
  end

  def choose_battler(default)
    commands = [_INTL("[无]")]
    cmds = [-1]
    cmd = 0
    @battle.battlers.each_with_index do |battler, i|
      next if battler.nil?   # Position doesn't exist
      name = battler.pbThis
      name = "-" if battler.fainted? || nil_or_empty?(name)
      commands.push(_INTL("[{1}] {2}", i, name))
      cmds.push(i)
      cmd = cmds.length - 1 if default == i
    end
    cmd = pbMessage("\\ts[]" + _INTL("选择一名战斗者/位置。"), commands, -1, nil, cmd)
    return (cmd >= 0) ? cmds[cmd] : default
  end

  def update_input_for_boolean(effect, variable_data)
    if Input.trigger?(Input::USE)
      pbPlayDecisionSE
      @variables[effect] = !@variables[effect]
      return true
    elsif Input.trigger?(Input::ACTION) && @variables[effect]
      pbPlayDecisionSE
      @variables[effect] = false
      return true
    elsif Input.repeat?(Input::LEFT) && @variables[effect]
      pbPlayCursorSE
      @variables[effect] = false
      return true
    elsif Input.repeat?(Input::RIGHT) && !@variables[effect]
      pbPlayCursorSE
      @variables[effect] = true
      return true
    end
    return false
  end

  def update_input_for_integer(effect, default, variable_data)
    true_default = (default == -2) ? -1 : default
    min = variable_data[:min] || true_default
    max = variable_data[:max] || 99
    if Input.trigger?(Input::USE)
      pbPlayDecisionSE
      new_value = choose_number(@variables[effect], min, max)
      if new_value != @variables[effect]
        @variables[effect] = new_value
        return true
      end
    elsif Input.trigger?(Input::ACTION) && @variables[effect] != true_default
      pbPlayDecisionSE
      @variables[effect] = true_default
      return true
    elsif Input.repeat?(Input::LEFT) && @variables[effect] > min
      pbPlayCursorSE
      @variables[effect] -= 1
      return true
    elsif Input.repeat?(Input::RIGHT) && @variables[effect] < max
      pbPlayCursorSE
      @variables[effect] += 1
      return true
    end
    return false
  end

  def update_input_for_battler_index(effect, variable_data)
    if Input.trigger?(Input::USE)
      pbPlayDecisionSE
      new_value = choose_battler(@variables[effect])
      if new_value != @variables[effect]
        @variables[effect] = new_value
        return true
      end
    elsif Input.trigger?(Input::ACTION) && @variables[effect] != -1
      pbPlayDecisionSE
      @variables[effect] = -1
      return true
    elsif Input.repeat?(Input::LEFT)
      if @variables[effect] > -1
        pbPlayCursorSE
        loop do
          @variables[effect] -= 1
          break if @variables[effect] == -1 || @battle.battlers[@variables[effect]]
        end
        return true
      end
    elsif Input.repeat?(Input::RIGHT)
      if @variables[effect] < @battle.battlers.length - 1
        pbPlayCursorSE
        loop do
          @variables[effect] += 1
          break if @battle.battlers[@variables[effect]]
        end
        return true
      end
    end
    return false
  end

  def update_input_for_move(effect, variable_data)
    if Input.trigger?(Input::USE)
      pbPlayDecisionSE
      new_value = pbChooseMoveList(@variables[effect])
      if new_value && new_value != @variables[effect]
        @variables[effect] = new_value
        return true
      end
    elsif Input.trigger?(Input::ACTION) && @variables[effect]
      pbPlayDecisionSE
      @variables[effect] = nil
      return true
    end
    return false
  end

  def update_input_for_item(effect, variable_data)
    if Input.trigger?(Input::USE)
      pbPlayDecisionSE
      new_value = pbChooseItemList(@variables[effect])
      if new_value && new_value != @variables[effect]
        @variables[effect] = new_value
        return true
      end
    elsif Input.trigger?(Input::ACTION) && @variables[effect]
      pbPlayDecisionSE
      @variables[effect] = nil
      return true
    end
    return false
  end

  def update
    loop do
      Graphics.update
      Input.update
      @window.update
      if Input.trigger?(Input::BACK)
        pbPlayCancelSE
        break
      end
      index = @window.index
      effect = @variables_data.keys[index]
      variable_data = @variables_data[effect]
      if variable_data[:default] == false
        @window.refresh if update_input_for_boolean(effect, variable_data)
      elsif [0, 1, -2].include?(variable_data[:default])
        @window.refresh if update_input_for_integer(effect, variable_data[:default], variable_data)
      elsif variable_data[:default] == -1
        @window.refresh if update_input_for_battler_index(effect, variable_data)
      elsif variable_data[:default].nil?
        case variable_data[:type]
        when :move
          @window.refresh if update_input_for_move(effect, variable_data)
        when :item
          @window.refresh if update_input_for_item(effect, variable_data)
        else
          raise "Unknown kind of variable!"
        end
      else
        raise "Unknown kind of variable!"
      end
    end
  end
end
