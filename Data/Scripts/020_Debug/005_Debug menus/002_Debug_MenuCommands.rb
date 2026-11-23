#===============================================================================
# Field options.
#===============================================================================

MenuHandlers.add(:debug_menu, :field_menu, {
  "name"        => _INTL("地图选项..."),
  "parent"      => :main,
  "description" => _INTL("传送到地图、编辑开关或变量、使用电脑、编辑培育屋等。"),
  "always_show" => false
})

MenuHandlers.add(:debug_menu, :warp, {
  "name"        => _INTL("传送到地图"),
  "parent"      => :field_menu,
  "description" => _INTL("立即传送到你选择的另一张地图。"),
  "effect"      => proc { |sprites, viewport|
    map = pbWarpToMap
    next false if !map
    pbFadeOutAndHide(sprites)
    pbDisposeMessageWindow(sprites["textbox"])
    pbDisposeSpriteHash(sprites)
    viewport.dispose
    if $scene.is_a?(Scene_Map)
      $game_temp.player_new_map_id    = map[0]
      $game_temp.player_new_x         = map[1]
      $game_temp.player_new_y         = map[2]
      $game_temp.player_new_direction = 2
      $scene.transfer_player
    else
      pbCancelVehicles
      $map_factory.setup(map[0])
      $game_player.moveto(map[1], map[2])
      $game_player.turn_down
      $game_map.update
      $game_map.autoplay
    end
    $game_map.refresh
    next true   # Closes the debug menu to allow the warp
  }
})

MenuHandlers.add(:debug_menu, :use_pc, {
  "name"        => _INTL("使用电脑"),
  "parent"      => :field_menu,
  "description" => _INTL("使用电脑访问宝可梦寄放系统和玩家的电脑。"),
  "effect"      => proc {
    pbPokeCenterPC
  }
})

MenuHandlers.add(:debug_menu, :switches, {
  "name"        => _INTL("开关"),
  "parent"      => :field_menu,
  "description" => _INTL("编辑所有游戏开关（脚本开关除外）。"),
  "effect"      => proc {
    pbDebugVariables(0)
  }
})

MenuHandlers.add(:debug_menu, :variables, {
  "name"        => _INTL("变量"),
  "parent"      => :field_menu,
  "description" => _INTL("编辑所有游戏变量。可以将它们设置为数字或文本。"),
  "effect"      => proc {
    pbDebugVariables(1)
  }
})

MenuHandlers.add(:debug_menu, :safari_zone_and_bug_contest, {
  "name"        => _INTL("狩猎地带和捕虫大赛"),
  "parent"      => :field_menu,
  "description" => _INTL("编辑步数、剩余时间和可用狩猎球的数量。"),
  "effect"      => proc {
    if pbInSafari?
      safari = pbSafariState
      cmd = 0
      loop do
        cmds = [_INTL("剩余步数：{1}", (Settings::SAFARI_STEPS > 0) ? safari.steps : _INTL("无限")),
                GameData::Item.get(:SAFARIBALL).name_plural + ": " + safari.ballcount.to_s]
        cmd = pbShowCommands(nil, cmds, -1, cmd)
        break if cmd < 0
        case cmd
        when 0   # Steps remaining
          if Settings::SAFARI_STEPS > 0
            params = ChooseNumberParams.new
            params.setRange(0, 99_999)
            params.setDefaultValue(safari.steps)
            safari.steps = pbMessageChooseNumber(_INTL("设置本次狩猎游戏中剩余的步数。"), params)
          end
        when 1   # Safari Balls
          params = ChooseNumberParams.new
          params.setRange(0, 99_999)
          params.setDefaultValue(safari.ballcount)
          safari.ballcount = pbMessageChooseNumber(
            _INTL("设置{1}的数量。", GameData::Item.get(:SAFARIBALL).name_plural), params)
        end
      end
    elsif pbInBugContest?
      contest = pbBugContestState
      cmd = 0
      loop do
        cmds = []
        if Settings::BUG_CONTEST_TIME > 0
          time_left = Settings::BUG_CONTEST_TIME - (System.uptime - contest.timer_start).to_i
          time_left = 0 if time_left < 0
          min = time_left / 60
          sec = time_left % 60
          time_string = _ISPRINTF("{1:02d}m {2:02d}s", min, sec)
        else
          time_string = _INTL("无限")
        end
        cmds.push(_INTL("剩余时间：{1}", time_string))
        cmds.push(GameData::Item.get(:SPORTBALL).name_plural + ": " + contest.ballcount.to_s)
        cmd = pbShowCommands(nil, cmds, -1, cmd)
        break if cmd < 0
        case cmd
        when 0   # Steps remaining
          if Settings::BUG_CONTEST_TIME > 0
            params = ChooseNumberParams.new
            params.setRange(0, 99_999)
            params.setDefaultValue(min)
            new_time = pbMessageChooseNumber(_INTL("设置本次捉虫大赛的剩余时间（以分钟为单位）。"), params)
            contest.timer_start += (new_time - min) * 60
            $scene.spriteset.usersprites.each do |sprite|
              next if !sprite.is_a?(TimerDisplay)
              sprite.start_time = contest.timer_start
              break
            end
          end
        when 1   # Sport Balls
          params = ChooseNumberParams.new
          params.setRange(0, 99_999)
          params.setDefaultValue(contest.ballcount)
          contest.ballcount = pbMessageChooseNumber(
            _INTL("设置{1}的数量。", GameData::Item.get(:SPORTBALL).name_plural), params)
        end
      end
    else
      pbMessage(_INTL("你不在狩猎地带或捕虫大赛中！"))
    end
  }
})

MenuHandlers.add(:debug_menu, :edit_field_effects, {
  "name"        => _INTL("更改场地效果"),
  "parent"      => :field_menu,
  "description" => _INTL("编辑喷雾剩余步数、怪力与闪光的使用状态，以及黑/白笛效果。"),
  "effect"      => proc {
    cmd = 0
    loop do
      cmds = []
      cmds.push(_INTL("喷雾剩余步数：{1}", $PokemonGlobal.repel))
      cmds.push((($PokemonMap.strengthUsed) ? "[是]" : "[  ]") + " " + _INTL("已使用怪力"))
      cmds.push((($PokemonGlobal.flashUsed) ? "[是]" : "[  ]") + " " + _INTL("已使用闪光"))
      cmds.push((($PokemonMap.lower_encounter_rate) ? "[是]" : "[  ]") + " " + _INTL("遭遇率较低"))
      cmds.push((($PokemonMap.higher_encounter_rate) ? "[是]" : "[  ]") + " " + _INTL("遭遇率更高"))
      cmds.push((($PokemonMap.lower_level_wild_pokemon) ? "[是]" : "[  ]") + " " + _INTL("低等级野生宝可梦"))
      cmds.push((($PokemonMap.higher_level_wild_pokemon) ? "[是]" : "[  ]") + " " + _INTL("高等级野生宝可梦"))
      cmd = pbShowCommands(nil, cmds, -1, cmd)
      break if cmd < 0
      case cmd
      when 0   # Repel steps
        params = ChooseNumberParams.new
        params.setRange(0, 99_999)
        params.setDefaultValue($PokemonGlobal.repel)
        $PokemonGlobal.repel = pbMessageChooseNumber(_INTL("设置剩余步数。"), params)
      when 1   # Strength used
        $PokemonMap.strengthUsed = !$PokemonMap.strengthUsed
      when 2   # Flash used
        if $game_map.metadata&.dark_map && $scene.is_a?(Scene_Map)
          $PokemonGlobal.flashUsed = !$PokemonGlobal.flashUsed
          darkness = $game_temp.darkness_sprite
          darkness.dispose if darkness && !darkness.disposed?
          $game_temp.darkness_sprite = DarknessSprite.new
          $scene.spriteset&.addUserSprite($game_temp.darkness_sprite)
          if $PokemonGlobal.flashUsed
            $game_temp.darkness_sprite.radius = $game_temp.darkness_sprite.radiusMax
          end
        else
          pbMessage(_INTL("你不在黑暗地图中！"))
        end
      when 3   # Lower encounter rate
        $PokemonMap.lower_encounter_rate ||= false
        $PokemonMap.lower_encounter_rate = !$PokemonMap.lower_encounter_rate
      when 4   # Higher encounter rate
        $PokemonMap.higher_encounter_rate ||= false
        $PokemonMap.higher_encounter_rate = !$PokemonMap.higher_encounter_rate
      when 5   # Lower level wild Pokémon
        $PokemonMap.lower_level_wild_pokemon ||= false
        $PokemonMap.lower_level_wild_pokemon = !$PokemonMap.lower_level_wild_pokemon
      when 6   # Higher level wild Pokémon
        $PokemonMap.higher_level_wild_pokemon ||= false
        $PokemonMap.higher_level_wild_pokemon = !$PokemonMap.higher_level_wild_pokemon
      end
    end
  }
})

MenuHandlers.add(:debug_menu, :refresh_map, {
  "name"        => _INTL("刷新地图"),
  "parent"      => :field_menu,
  "description" => _INTL("刷新这张地图上的所有事件以及公共事件。"),
  "effect"      => proc {
    $game_map.need_refresh = true
    pbMessage(_INTL("地图将刷新。"))
  }
})

MenuHandlers.add(:debug_menu, :day_care, {
  "name"        => _INTL("培育屋"),
  "parent"      => :field_menu,
  "description" => _INTL("在培育屋查看并编辑宝可梦。"),
  "effect"      => proc {
    pbDebugDayCare
  }
})

MenuHandlers.add(:debug_menu, :storage_wallpapers, {
  "name"        => _INTL("切换寄放系统壁纸"),
  "parent"      => :field_menu,
  "description" => _INTL("解锁和锁定宝可梦寄放系统中使用的特殊壁纸。"),
  "effect"      => proc {
    w = $PokemonStorage.allWallpapers
    if w.length <= PokemonStorage::BASIC_WALLPAPER_COUNT
      pbMessage(_INTL("没有定义特殊壁纸。"))
      next
    end
    paperscmd = 0
    unlockarray = $PokemonStorage.unlockedWallpapers
    loop do
      paperscmds = []
      paperscmds.push(_INTL("全部解锁"))
      paperscmds.push(_INTL("全部锁定"))
      (PokemonStorage::BASIC_WALLPAPER_COUNT...w.length).each do |i|
        paperscmds.push(((unlockarray[i]) ? "[是]" : "[  ]") + " " + w[i])
      end
      paperscmd = pbShowCommands(nil, paperscmds, -1, paperscmd)
      break if paperscmd < 0
      case paperscmd
      when 0   # Unlock all
        (PokemonStorage::BASIC_WALLPAPER_COUNT...w.length).each do |i|
          unlockarray[i] = true
        end
      when 1   # Lock all
        (PokemonStorage::BASIC_WALLPAPER_COUNT...w.length).each do |i|
          unlockarray[i] = false
        end
      else
        paperindex = paperscmd - 2 + PokemonStorage::BASIC_WALLPAPER_COUNT
        unlockarray[paperindex] = !$PokemonStorage.unlockedWallpapers[paperindex]
      end
    end
  }
})

MenuHandlers.add(:debug_menu, :skip_credits, {
  "name"        => _INTL("跳过片尾制作人员名单"),
  "parent"      => :field_menu,
  "description" => _INTL("切换是否可以通过按键提前结束片尾制作人员名单。"),
  "effect"      => proc {
    $PokemonGlobal.creditsPlayed = !$PokemonGlobal.creditsPlayed
    pbMessage(_INTL("以后播放时可以跳过片尾制作人员名单。")) if $PokemonGlobal.creditsPlayed
    pbMessage(_INTL("下次播放时无法跳过片尾制作人员名单。")) if !$PokemonGlobal.creditsPlayed
  }
})

#===============================================================================
# Battle options.
#===============================================================================

MenuHandlers.add(:debug_menu, :battle_menu, {
  "name"        => _INTL("战斗选项..."),
  "parent"      => :main,
  "description" => _INTL("开始对战、重置地图训练家、准备再战、编辑漫游宝可梦等。"),
  "always_show" => false
})

MenuHandlers.add(:debug_menu, :test_wild_battle, {
  "name"        => _INTL("测试野生对战"),
  "parent"      => :battle_menu,
  "description" => _INTL("与野生宝可梦开始一场对战。由你选择物种和等级。"),
  "effect"      => proc {
    species = pbChooseSpeciesList
    if species
      params = ChooseNumberParams.new
      params.setRange(1, GameData::GrowthRate.max_level)
      params.setInitialValue(5)
      params.setCancelValue(0)
      level = pbMessageChooseNumber(_INTL("设置野生{1}的等级。",
                                          GameData::Species.get(species).name), params)
      if level > 0
        $game_temp.encounter_type = nil
        setBattleRule("canLose")
        WildBattle.start(species, level)
      end
    end
    next false
  }
})

MenuHandlers.add(:debug_menu, :test_wild_battle_advanced, {
  "name"        => _INTL("高级野生对战测试"),
  "parent"      => :battle_menu,
  "description" => _INTL("与 1 只或更多野生宝可梦开始对战。战斗规模由你选择。"),
  "effect"      => proc {
    pkmn = []
    size0 = 1
    pkmnCmd = 0
    loop do
      pkmnCmds = []
      pkmn.each { |p| pkmnCmds.push(_INTL("{1} 等级 {2}", p.name, p.level)) }
      pkmnCmds.push(_INTL("[添加宝可梦]"))
      pkmnCmds.push(_INTL("[设置我方人数]"))
      pkmnCmds.push(_INTL("[开始 {1} 对 {2} 对战]", size0, pkmn.length))
      pkmnCmd = pbShowCommands(nil, pkmnCmds, -1, pkmnCmd)
      break if pkmnCmd < 0
      if pkmnCmd == pkmnCmds.length - 1      # Start battle
        if pkmn.length == 0
          pbMessage(_INTL("没有选择宝可梦，无法开始对战。"))
          next
        end
        setBattleRule(sprintf("%dv%d", size0, pkmn.length))
        setBattleRule("canLose")
        $game_temp.encounter_type = nil
        WildBattle.start(*pkmn)
        break
      elsif pkmnCmd == pkmnCmds.length - 2   # Set player side size
        if !pbCanDoubleBattle?
          pbMessage(_INTL("你只有一只宝可梦。"))
          next
        end
        maxVal = (pbCanTripleBattle?) ? 3 : 2
        params = ChooseNumberParams.new
        params.setRange(1, maxVal)
        params.setInitialValue(size0)
        params.setCancelValue(0)
        newSize = pbMessageChooseNumber(
          _INTL("选择我方的参战人数（最多 {1}）。", maxVal), params
        )
        size0 = newSize if newSize > 0
      elsif pkmnCmd == pkmnCmds.length - 3   # Add Pokémon
        species = pbChooseSpeciesList
        if species
          params = ChooseNumberParams.new
          params.setRange(1, GameData::GrowthRate.max_level)
          params.setInitialValue(5)
          params.setCancelValue(0)
          level = pbMessageChooseNumber(_INTL("设置野生{1}的等级。",
                                              GameData::Species.get(species).name), params)
          if level > 0
            pkmn.push(pbGenerateWildPokemon(species, level))
            size0 = pkmn.length
          end
        end
      else                                   # Edit a Pokémon
        if pbConfirmMessage(_INTL("要更换这只宝可梦吗？"))
          scr = UI::PartyDebug.new
          scr.pokemon_debug_menu(pkmn[pkmnCmd], -1, true)
          scr.silent_end_screen
        elsif pbConfirmMessage(_INTL("要删除这只宝可梦吗？"))
          pkmn.delete_at(pkmnCmd)
          size0 = [pkmn.length, 1].max
        end
      end
    end
    next false
  }
})

MenuHandlers.add(:debug_menu, :test_trainer_battle, {
  "name"        => _INTL("测试训练家对战"),
  "parent"      => :battle_menu,
  "description" => _INTL("与所选训练家开始一场对战。"),
  "effect"      => proc {
    trainerdata = pbListScreen(_INTL("单个训练家"), TrainerBattleLister.new(0, false))
    if trainerdata
      setBattleRule("canLose")
      TrainerBattle.start(trainerdata[0], trainerdata[1], trainerdata[2])
    end
    next false
  }
})

MenuHandlers.add(:debug_menu, :test_trainer_battle_advanced, {
  "name"        => _INTL("高级训练家对战测试"),
  "parent"      => :battle_menu,
  "description" => _INTL("与 1 名或多名训练家开始对战，并自行选择对战规模。"),
  "effect"      => proc {
    trainers = []
    size0 = 1
    size1 = 1
    trainerCmd = 0
    loop do
      trainerCmds = []
      trainers.each { |t| trainerCmds.push(_INTL("{1} ×{2}", t[1].full_name, t[1].party_count)) }
      trainerCmds.push(_INTL("[添加训练家]"))
      trainerCmds.push(_INTL("[设置我方人数]"))
      trainerCmds.push(_INTL("[设置对手人数]"))
      trainerCmds.push(_INTL("[开始 {1} 对 {2} 对战]", size0, size1))
      trainerCmd = pbShowCommands(nil, trainerCmds, -1, trainerCmd)
      break if trainerCmd < 0
      if trainerCmd == trainerCmds.length - 1      # Start battle
        if trainers.length == 0
          pbMessage(_INTL("未选择训练家，无法开始对战。"))
          next
        elsif size1 < trainers.length
          pbMessage(_INTL("对手人数无效，至少应为 {1}。", trainers.length))
          next
        elsif size1 > trainers.length && trainers[0][1].party_count == 1
          pbMessage(
            _INTL("对手人数不能为 {1}，因为第一位训练家至少需要 2 只宝可梦，但其不满足条件。",
                  size1)
          )
          next
        end
        setBattleRule(sprintf("%dv%d", size0, size1))
        setBattleRule("canLose")
        battleArgs = []
        trainers.each { |t| battleArgs.push(t[1]) }
        TrainerBattle.start(*battleArgs)
        break
      elsif trainerCmd == trainerCmds.length - 2   # Set opponent side size
        if trainers.length == 0 || (trainers.length == 1 && trainers[0][1].party_count == 1)
          pbMessage(_INTL("未选择训练家，或该训练家只有 1 只宝可梦。"))
          next
        end
        maxVal = 2
        maxVal = 3 if trainers.length >= 3 ||
                      (trainers.length == 2 && trainers[0][1].party_count >= 2) ||
                      trainers[0][1].party_count >= 3
        params = ChooseNumberParams.new
        params.setRange(1, maxVal)
        params.setInitialValue(size1)
        params.setCancelValue(0)
        newSize = pbMessageChooseNumber(
          _INTL("选择对手方的参战人数（最多 {1}）。", maxVal), params
        )
        size1 = newSize if newSize > 0
      elsif trainerCmd == trainerCmds.length - 3   # Set player side size
        if !pbCanDoubleBattle?
          pbMessage(_INTL("你只有一只宝可梦。"))
          next
        end
        maxVal = (pbCanTripleBattle?) ? 3 : 2
        params = ChooseNumberParams.new
        params.setRange(1, maxVal)
        params.setInitialValue(size0)
        params.setCancelValue(0)
        newSize = pbMessageChooseNumber(
          _INTL("选择我方的参战人数（最多 {1}）。", maxVal), params
        )
        size0 = newSize if newSize > 0
      elsif trainerCmd == trainerCmds.length - 4   # Add trainer
        trainerdata = pbListScreen(_INTL("选择训练家"), TrainerBattleLister.new(0, false))
        if trainerdata
          tr = pbLoadTrainer(trainerdata[0], trainerdata[1], trainerdata[2])
          EventHandlers.trigger(:on_trainer_load, tr)
          trainers.push([0, tr])
          size0 = trainers.length
          size1 = trainers.length
        end
      else                                         # Edit a trainer
        if pbConfirmMessage(_INTL("要更换这名训练家吗？"))
          trainerdata = pbListScreen(_INTL("选择训练家"),
                                     TrainerBattleLister.new(trainers[trainerCmd][0], false))
          if trainerdata
            tr = pbLoadTrainer(trainerdata[0], trainerdata[1], trainerdata[2])
            EventHandlers.trigger(:on_trainer_load, tr)
            trainers[trainerCmd] = [0, tr]
          end
        elsif pbConfirmMessage(_INTL("要删除这名训练家吗？"))
          trainers.delete_at(trainerCmd)
          size0 = [trainers.length, 1].max
          size1 = [trainers.length, 1].max
        end
      end
    end
    next false
  }
})

MenuHandlers.add(:debug_menu, :set_battle_rules, {
  "name"        => _INTL("设置下一场战斗的规则"),
  "parent"      => :battle_menu,
  "description" => _INTL("设置将应用于下一场战斗的战斗规则。"),
  "effect"      => proc {
    applied_rules = $game_temp.battle_rules
    duplicate_rules = ["battleback", "environ", "outcomevar"]
    rule_names = {
      "backdrop"            => _INTL("战斗背景"),
      "base"                => _INTL("战斗场地"),
      "outcome"             => _INTL("结果变量"),
      "environment"         => _INTL("环境"),
      "weather"             => _INTL("天气"),
      "terrain"             => _INTL("地形"),
      "anims"               => _INTL("战斗动画"),
      "noanims"             => _INTL("关闭战斗动画"),
      "canrun"              => _INTL("可以逃跑"),
      "cannotrun"           => _INTL("不能逃跑"),
      "canswitch"           => _INTL("可以替换"),
      "cannotswitch"        => _INTL("不能替换"),
      "switchstyle"         => _INTL("替换风格"),
      "setstyle"            => _INTL("设置风格"),
      "disablebag"          => _INTL("禁用背包"),
      "disablepokeballs"    => _INTL("禁用精灵球"),
      "autobattle"          => _INTL("自动战斗"),
      "nopartner"           => _INTL("无搭档训练家"),
      "roamerflees"         => _INTL("漫游宝可梦逃跑"),
      "certaincapture"      => _INTL("必定捕获"),
      "forcecatchintoparty" => _INTL("捕获后加入队伍"),
      "canlose"             => _INTL("可以失败"),
      "cannotlose"          => _INTL("不能失败"),
      "noexp"               => _INTL("不获得经验值"),
      "nomoney"             => _INTL("不获得零花钱")
    }
    side_size_names = {
      "single" => _INTL("单打"),
      "1v1"    => _INTL("1 对 1"),
      "1v2"    => _INTL("1 对 2"),
      "2v1"    => _INTL("2 对 1"),
      "1v3"    => _INTL("1 对 3"),
      "3v1"    => _INTL("3 对 1"),
      "double" => _INTL("双打"),
      "2v2"    => _INTL("2 对 2"),
      "2v3"    => _INTL("2 对 3"),
      "3v2"    => _INTL("3 对 2"),
      "triple" => _INTL("三打"),
      "3v3"    => _INTL("3 对 3")
    }
    cmd = 0
    loop do
      # Create list of rules to display
      rules = [_INTL("[全部清除]")]
      rules_syms = [[:clear_all], [nil]]
      Game_Temp::BATTLE_RULES.each_key do |rule|
        next if duplicate_rules.include?(rule)
        rule_sym = Game_Temp::BATTLE_RULES[rule][0]
        case rule_sym
        when :side_sizes
          next if rules_syms[0].include?(rule_sym)
          rules.push(_INTL("双方人数：{1}", side_size_names[applied_rules[rule_sym]] || applied_rules[rule_sym] || "-"))
        when :backdrop_name, :base_name, :outcome_variable
          rules.push(_INTL("{1}：{2}", rule_names[rule] || rule.to_s, applied_rules[rule_sym] || "-"))
        when :environment
          rules.push(_INTL("{1}：{2}", rule_names[rule] || rule.to_s, GameData::Environment.try_get(applied_rules[rule_sym])&.name || "-"))
        when :default_weather
          rules.push(_INTL("{1}：{2}", rule_names[rule] || rule.to_s, GameData::BattleWeather.try_get(applied_rules[rule_sym])&.name || "-"))
        when :default_terrain
          rules.push(_INTL("{1}：{2}", rule_names[rule] || rule.to_s, GameData::BattleTerrain.try_get(applied_rules[rule_sym])&.name || "-"))
        else
          ticked = applied_rules[rule_sym]
          ticked = !ticked if ["anims", "canrun", "canswitch", "switchstyle", "cannotlose"].include?(rule) && !applied_rules[rule_sym].nil?
          rules.push(((ticked) ? "[是]" : "[  ]") + " " + (rule_names[rule] || rule.to_s))
        end
        rules_syms[0].push(rule_sym)
        rules_syms[1].push(rule)
      end
      # Show rules and choose one
      cmd = pbShowCommands(nil, rules, -1, cmd)
      break if cmd < 0
      # Toggle/set rule
      rule_sym = rules_syms[0][cmd]
      rule = rules_syms[1][cmd]
      case rule_sym
      when :clear_all
        applied_rules.clear
      when :side_sizes
        side_sizes = Game_Temp::BATTLE_RULES.keys.select { |key| Game_Temp::BATTLE_RULES[key][0] == :side_sizes }
        side_sizes.map! { |val| val.dup }
        side_size_cmds = side_sizes.map { |val| side_size_names[val] || val }
        side_size_cmds.prepend(_INTL("[未设置]"))
        current_size = applied_rules[rule_sym]
        current_size_idx = (current_size) ? side_sizes.index(current_size) : nil
        size_cmd = (current_size_idx) ? current_size_idx + 1 : 0
        size_cmd = pbShowCommands(nil, side_size_cmds, -1, size_cmd)
        if size_cmd >= 0
          applied_rules[rule_sym] = (size_cmd == 0) ? nil : side_sizes[size_cmd - 1]
        end
      when :backdrop_name, :base_name
        text = pbMessageFreeText(_INTL("输入战斗规则“{1}”的值。", rule_names[rule] || rule),
                                 applied_rules[rule_sym] || "", false, 100, Graphics.width)
        applied_rules[rule_sym] = (text && text != "") ? text : nil
      when :outcome_variable
        params = ChooseNumberParams.new
        params.setRange(1, 99)
        params.setInitialValue(applied_rules[rule_sym] || 1)
        params.setCancelValue(-1)
        value = pbMessageChooseNumber(_INTL("选择用于保存战斗结果的游戏变量。"), params)
        applied_rules[rule_sym] = (value > 0) ? value : nil
      when :environment, :default_weather, :default_terrain
        data_class = {
          :environment     => GameData::Environment,
          :default_weather => GameData::BattleWeather,
          :default_terrain => GameData::BattleTerrain
        }[rule_sym]
        data_cmds = [_INTL("[未设置]")]
        data_syms = [nil]
        data_class.each do |entry|
          data_cmds.push(entry.name)
          data_syms.push(entry.id)
        end
        data_cmd = data_syms.index(applied_rules[rule_sym]) || 0
        data_cmd = pbShowCommands(nil, data_cmds, -1, data_cmd)
        applied_rules[rule_sym] = data_syms[data_cmd] if data_cmd >= 0
      when :no_battle_animations, :cannot_run, :cannot_switch, :no_switch_style,
           :continue_if_lose
        if ["anims", "canrun", "canswitch", "switchstyle", "cannotlose"].include?(rule)
          case applied_rules[rule_sym]
          when true  then applied_rules[rule_sym] = nil
          when false then applied_rules[rule_sym] = true
          when nil   then applied_rules[rule_sym] = false
          end
        else
          case applied_rules[rule_sym]
          when true  then applied_rules[rule_sym] = false
          when false then applied_rules[rule_sym] = nil
          when nil   then applied_rules[rule_sym] = true
          end
        end
      else
        applied_rules[rule_sym] = (applied_rules[rule_sym]) ? nil : true
      end
    end
  }
})

MenuHandlers.add(:debug_menu, :partner_trainer, {
  "name"        => _INTL("设置搭档训练家"),
  "parent"      => :battle_menu,
  "description" => _INTL("选择一名训练家并肩作战。"),
  "effect"      => proc {
    if $PokemonGlobal.partner
      partner_name = sprintf("%s %s",
                             GameData::TrainerType.get($PokemonGlobal.partner[0]).name,
                             $PokemonGlobal.partner[1])
      if pbConfirmMessage(_INTL("当前搭档训练家是{1}。要移除吗？", partner_name))
        pbDeregisterPartner
        pbMessage(_INTL("已移除搭档训练家。"))
      end
    else
      if pbConfirmMessage(_INTL("当前没有搭档训练家。要设置一位吗？"))
        chosen = pbListScreen(_INTL("选择搭档训练家"), TrainerBattleLister.new(0, false))
        if chosen
          pbRegisterPartner(chosen[0], chosen[1], chosen[2])
          pbMessage(_INTL("已设置搭档训练家。"))
        end
      end
    end
  }
})

MenuHandlers.add(:debug_menu, :encounter_version, {
  "name"        => _INTL("设置野生遭遇版本"),
  "parent"      => :battle_menu,
  "description" => _INTL("选择要使用的野生遭遇版本。"),
  "effect"      => proc {
    params = ChooseNumberParams.new
    params.setRange(0, 99)
    params.setInitialValue($PokemonGlobal.encounter_version)
    params.setCancelValue(-1)
    value = pbMessageChooseNumber(_INTL("将遭遇版本设置为哪个值？"), params)
    $PokemonGlobal.encounter_version = value if value >= 0
  }
})

MenuHandlers.add(:debug_menu, :roamers, {
  "name"        => _INTL("漫游宝可梦"),
  "parent"      => :battle_menu,
  "description" => _INTL("切换并编辑所有漫游宝可梦。"),
  "effect"      => proc {
    pbDebugRoamers
  }
})

MenuHandlers.add(:debug_menu, :reset_trainers, {
  "name"        => _INTL("重置地图训练家"),
  "parent"      => :battle_menu,
  "description" => _INTL("关闭名称中包含“Trainer”的所有事件的独立开关 A 和 B。"),
  "effect"      => proc {
    if $game_map
      $game_map.events.each_value do |event|
        if event.name[/trainer/i]
          $game_self_switches[[$game_map.map_id, event.id, "A"]] = false
          $game_self_switches[[$game_map.map_id, event.id, "B"]] = false
        end
      end
      $game_map.need_refresh = true
      pbMessage(_INTL("该地图上的所有训练家均已重置。"))
    else
      pbMessage(_INTL("此处不能使用该命令。"))
    end
  }
})

MenuHandlers.add(:debug_menu, :toggle_exp_all, {
  "name"        => _INTL("切换经验值分享"),
  "parent"      => :battle_menu,
  "description" => _INTL("切换是否将经验值分配给未参战的宝可梦。"),
  "effect"      => proc {
    $player.has_exp_all = !$player.has_exp_all
    pbMessage(_INTL("已启用经验值分享。")) if $player.has_exp_all
    pbMessage(_INTL("已禁用经验值分享。")) if !$player.has_exp_all
  }
})

MenuHandlers.add(:debug_menu, :toggle_logging, {
  "name"        => _INTL("切换战斗调试日志"),
  "parent"      => :battle_menu,
  "description" => _INTL("将战斗调试日志记录到 Data/debuglog.txt 中。"),
  "effect"      => proc {
    $INTERNAL = !$INTERNAL
    pbMessage(_INTL("战斗调试日志将保存到 Data 文件夹中。")) if $INTERNAL
    pbMessage(_INTL("不会保存战斗调试日志。")) if !$INTERNAL
  }
})

#===============================================================================
# Pokémon options.
#===============================================================================

MenuHandlers.add(:debug_menu, :pokemon_menu, {
  "name"        => _INTL("宝可梦选项..."),
  "parent"      => :main,
  "description" => _INTL("治愈队伍、给予宝可梦、填充或清空电脑中的寄放系统等。"),
  "always_show" => false
})

MenuHandlers.add(:debug_menu, :heal_party, {
  "name"        => _INTL("治愈队伍"),
  "parent"      => :pokemon_menu,
  "description" => _INTL("完全恢复队伍中所有宝可梦的 HP、异常状态和 PP。"),
  "effect"      => proc {
    $player.party.each { |pkmn| pkmn.heal }
    pbMessage(_INTL("你的队伍已经完全恢复了。"))
  }
})

MenuHandlers.add(:debug_menu, :add_pokemon, {
  "name"        => _INTL("添加宝可梦"),
  "parent"      => :pokemon_menu,
  "description" => _INTL("获得一只指定物种和等级的宝可梦。如果队伍已满，则传送到电脑。"),
  "effect"      => proc {
    species = pbChooseSpeciesList
    if species
      params = ChooseNumberParams.new
      params.setRange(1, GameData::GrowthRate.max_level)
      params.setInitialValue(5)
      params.setCancelValue(0)
      level = pbMessageChooseNumber(_INTL("设置宝可梦的等级。"), params)
      if level > 0
        goes_to_party = !$player.party_full?
        if pbAddPokemonSilent(species, level)
          if goes_to_party
            pbMessage(_INTL("已将 {1} 添加到队伍中。", GameData::Species.get(species).name))
          else
            pbMessage(_INTL("已将 {1} 传送到宝可梦寄放系统。", GameData::Species.get(species).name))
          end
        else
          pbMessage(_INTL("无法添加宝可梦，因为队伍和寄放系统都已满。"))
        end
      end
    end
  }
})

MenuHandlers.add(:debug_menu, :fill_boxes, {
  "name"        => _INTL("填满盒子"),
  "parent"      => :pokemon_menu,
  "description" => _INTL("将每个物种各一只（等级 50）的宝可梦存入盒子。"),
  "effect"      => proc {
    added = 0
    box_qty = $PokemonStorage.maxPokemon(0)
    completed = true
    GameData::Species.each do |sp|
      species = sp.species
      form = sp.form
      # Record each form of each species as seen and owned
      if sp.single_gendered?   # Or genderless
        gender = (sp.gender_ratio == :AlwaysFemale) ? 1 : 0
        [false, true].each do |shiny|
          $player.pokedex.register(species, gender, form, shiny, false)
        end
      elsif form == 0 ||
            (sp.real_form_name && !sp.real_form_name.empty? && sp.pokedex_form == sp.form)
        2.times do |gender|
          [false, true].each do |shiny|
            $player.pokedex.register(species, gender, form, shiny, false)
          end
        end
      end
      $player.pokedex.set_owned(species, false)
      # Add Pokémon (if form 0, i.e. one of each species)
      next if form != 0
      if added >= Settings::NUM_STORAGE_BOXES * box_qty
        completed = false
        next
      end
      added += 1
      $PokemonStorage[(added - 1) / box_qty, (added - 1) % box_qty] = Pokemon.new(species, 50)
    end
    $player.pokedex.refresh_accessible_dexes
    pbMessage(_INTL("盒子中已装满每个物种各一只宝可梦。"))
    if !completed
      pbMessage(_INTL("注意：盒子的总容量（{1} 个盒子 × {2} 个位置）少于物种数量。",
                      Settings::NUM_STORAGE_BOXES, box_qty))
    end
  }
})

MenuHandlers.add(:debug_menu, :clear_boxes, {
  "name"        => _INTL("清空盒子"),
  "parent"      => :pokemon_menu,
  "description" => _INTL("移除寄放系统中的所有宝可梦。"),
  "effect"      => proc {
    $PokemonStorage.maxBoxes.times do |i|
      $PokemonStorage.maxPokemon(i).times do |j|
        $PokemonStorage[i, j] = nil
      end
    end
    pbMessage(_INTL("盒子已清空。"))
  }
})

MenuHandlers.add(:debug_menu, :give_demo_party, {
  "name"        => _INTL("配置演示队伍"),
  "parent"      => :pokemon_menu,
  "description" => _INTL("获得 6 只预设宝可梦。它们会替换当前队伍。"),
  "effect"      => proc {
    party = []
    species = [:PIKACHU, :PIDGEOTTO, :KADABRA, :GYARADOS, :DIGLETT, :CHANSEY]
    species.each { |id| party.push(id) if GameData::Species.exists?(id) }
    $player.party.clear
    # Generate Pokémon of each species at level 20
    party.each do |spec|
      pkmn = Pokemon.new(spec, 20)
      $player.party.push(pkmn)
      $player.pokedex.register(pkmn)
      $player.pokedex.set_owned(spec)
      case spec
      when :PIDGEOTTO
        pkmn.learn_move(:FLY)
      when :KADABRA
        pkmn.learn_move(:FLASH)
        pkmn.learn_move(:TELEPORT)
      when :GYARADOS
        pkmn.learn_move(:SURF)
        pkmn.learn_move(:DIVE)
        pkmn.learn_move(:WATERFALL)
      when :DIGLETT
        pkmn.learn_move(:DIG)
        pkmn.learn_move(:CUT)
        pkmn.learn_move(:HEADBUTT)
        pkmn.learn_move(:ROCKSMASH)
      when :CHANSEY
        pkmn.learn_move(:SOFTBOILED)
        pkmn.learn_move(:STRENGTH)
        pkmn.learn_move(:SWEETSCENT)
      end
      pkmn.record_first_moves
    end
    pbMessage(_INTL("已配置演示队伍。"))
  }
})

MenuHandlers.add(:debug_menu, :quick_hatch_party_eggs, {
  "name"        => _INTL("快速孵化队伍中的蛋"),
  "parent"      => :pokemon_menu,
  "description" => _INTL("让队伍中所有蛋只需再走一步即可孵化。"),
  "effect"      => proc {
    $player.party.each { |pkmn| pkmn.steps_to_hatch = 1 if pkmn.egg? }
    pbMessage(_INTL("现在，队伍中所有蛋只需再走一步即可孵化。"))
  }
})

MenuHandlers.add(:debug_menu, :open_storage, {
  "name"        => _INTL("访问宝可梦寄放系统"),
  "parent"      => :pokemon_menu,
  "description" => _INTL("以整理盒子模式打开宝可梦寄放系统。"),
  "effect"      => proc {
    pbFadeOutIn do
      UI::PokemonStorage.new($PokemonStorage, mode: :organize).main
    end
  }
})

#===============================================================================
# Shadow Pokémon options.
#===============================================================================

MenuHandlers.add(:debug_menu, :shadow_pokemon_menu, {
  "name"        => _INTL("黑暗宝可梦选项..."),
  "parent"      => :pokemon_menu,
  "description" => _INTL("夺取机器和净化室。"),
  "always_show" => false
})

MenuHandlers.add(:debug_menu, :toggle_snag_machine, {
  "name"        => _INTL("切换夺取机器"),
  "parent"      => :shadow_pokemon_menu,
  "description" => _INTL("切换所有精灵球能否捕捉黑暗宝可梦。"),
  "effect"      => proc {
    $player.has_snag_machine = !$player.has_snag_machine
    pbMessage(_INTL("获得了夺取机器。")) if $player.has_snag_machine
    pbMessage(_INTL("失去了夺取机器。")) if !$player.has_snag_machine
  }
})

MenuHandlers.add(:debug_menu, :toggle_purify_chamber_access, {
  "name"        => _INTL("切换净化室访问权限"),
  "parent"      => :shadow_pokemon_menu,
  "description" => _INTL("切换是否可以通过电脑进入净化室。"),
  "effect"      => proc {
    $player.seen_purify_chamber = !$player.seen_purify_chamber
    pbMessage(_INTL("已解锁净化室。")) if $player.seen_purify_chamber
    pbMessage(_INTL("未解锁净化室。")) if !$player.seen_purify_chamber
  }
})

MenuHandlers.add(:debug_menu, :purify_chamber, {
  "name"        => _INTL("使用净化室"),
  "parent"      => :shadow_pokemon_menu,
  "description" => _INTL("打开净化室，净化黑暗宝可梦。"),
  "effect"      => proc {
    pbPurifyChamber
  }
})

MenuHandlers.add(:debug_menu, :relic_stone, {
  "name"        => _INTL("使用遗物石"),
  "parent"      => :shadow_pokemon_menu,
  "description" => _INTL("将黑暗宝可梦带到遗物石处进行净化。"),
  "effect"      => proc {
    pbRelicStone
  }
})

#===============================================================================
# Item options.
#===============================================================================

MenuHandlers.add(:debug_menu, :items_menu, {
  "name"        => _INTL("道具选项..."),
  "parent"      => :main,
  "description" => _INTL("给予和取走道具。"),
  "always_show" => false
})

MenuHandlers.add(:debug_menu, :add_item, {
  "name"        => _INTL("添加道具"),
  "parent"      => :items_menu,
  "description" => _INTL("选择要添加到背包中的道具及其数量。"),
  "effect"      => proc {
    pbListScreenBlock(_INTL("添加道具"), ItemLister.new) do |button, item|
      if button == Input::USE && item
        params = ChooseNumberParams.new
        params.setRange(1, PokemonBag::MAX_PER_SLOT)
        params.setInitialValue(1)
        params.setCancelValue(0)
        qty = pbMessageChooseNumber(_INTL("添加多少个{1}？",
                                          GameData::Item.get(item).name_plural), params)
        if qty > 0
          $bag.add(item, qty)
          pbMessage(_INTL("获得了 {1} 个 {2}。", qty, GameData::Item.get(item).name))
        end
      end
    end
  }
})

MenuHandlers.add(:debug_menu, :fill_bag, {
  "name"        => _INTL("填满背包"),
  "parent"      => :items_menu,
  "description" => _INTL("清空背包，然后将每种道具各装满一定数量。"),
  "effect"      => proc {
    params = ChooseNumberParams.new
    params.setRange(1, PokemonBag::MAX_PER_SLOT)
    params.setInitialValue(1)
    params.setCancelValue(0)
    qty = pbMessageChooseNumber(_INTL("选择每种道具的数量。"), params)
    if qty > 0
      $bag.clear
      # NOTE: This doesn't simply use $bag.add for every item in turn, because
      #       that's really slow when done in bulk.
      pocket_sizes = {}
      GameData::BagPocket.each { |pckt| pocket_sizes[pckt.id] = pckt.max_slots }
      bag = $bag.pockets   # Called here so that it only rearranges itself once
      GameData::Item.each do |i|
        bag_pocket = i.bag_pocket
        next if !pocket_sizes[bag_pocket] || pocket_sizes[bag_pocket] == 0
        next if pocket_sizes[bag_pocket] > 0 && bag[bag_pocket].length >= pocket_sizes[bag_pocket]
        item_qty = (i.is_important?) ? 1 : qty
        bag[bag_pocket].push([i.id, item_qty])
      end
      # NOTE: Auto-sorting pockets don't need to be sorted afterwards, because
      #       items are added in the same order they would be sorted into.
      pbMessage(_INTL("背包中已装满每种道具，各 {1} 个。", qty))
    end
  }
})

MenuHandlers.add(:debug_menu, :empty_bag, {
  "name"        => _INTL("清空背包"),
  "parent"      => :items_menu,
  "description" => _INTL("从背包中移除所有道具。"),
  "effect"      => proc {
    $bag.clear
    pbMessage(_INTL("背包已清空。"))
  }
})

#===============================================================================
# Player options.
#===============================================================================

MenuHandlers.add(:debug_menu, :player_menu, {
  "name"        => _INTL("玩家选项..."),
  "parent"      => :main,
  "description" => _INTL("设置零花钱、徽章、图鉴以及玩家的外貌和姓名等。"),
  "always_show" => false
})

MenuHandlers.add(:debug_menu, :set_money, {
  "name"        => _INTL("零花钱"),
  "parent"      => :player_menu,
  "description" => _INTL("编辑你拥有的零花钱、代币和战斗点数。"),
  "effect"      => proc {
    cmd = 0
    loop do
      cmds = [_INTL("零花钱：{1}", $player.money.to_s_formatted),
              _INTL("代币：{1}", $player.coins.to_s_formatted),
              _INTL("战斗点数：{1}", $player.battle_points.to_s_formatted)]
      cmd = pbShowCommands(nil, cmds, -1, cmd)
      break if cmd < 0
      case cmd
      when 0   # Money
        params = ChooseNumberParams.new
        params.setRange(0, Settings::MAX_MONEY)
        params.setDefaultValue($player.money)
        $player.money = pbMessageChooseNumber("\\ts[]" + _INTL("设置玩家的零花钱。"), params)
      when 1   # Coins
        params = ChooseNumberParams.new
        params.setRange(0, Settings::MAX_COINS)
        params.setDefaultValue($player.coins)
        $player.coins = pbMessageChooseNumber("\\ts[]" + _INTL("设置玩家的代币数量。"), params)
      when 2   # Battle Points
        params = ChooseNumberParams.new
        params.setRange(0, Settings::MAX_BATTLE_POINTS)
        params.setDefaultValue($player.battle_points)
        $player.battle_points = pbMessageChooseNumber("\\ts[]" + _INTL("设置玩家的战斗点数。"), params)
      end
    end
  }
})

MenuHandlers.add(:debug_menu, :set_badges, {
  "name"        => _INTL("设置道馆徽章"),
  "parent"      => :player_menu,
  "description" => _INTL("切换每枚道馆徽章的持有状态。"),
  "effect"      => proc {
    badgecmd = 0
    loop do
      badgecmds = []
      badgecmds.push(_INTL("全部给予"))
      badgecmds.push(_INTL("全部清空"))
      24.times do |i|
        badgecmds.push((($player.badges[i]) ? "[是]" : "[  ]") + " " + _INTL("徽章{1}", i + 1))
      end
      badgecmd = pbShowCommands(nil, badgecmds, -1, badgecmd)
      break if badgecmd < 0
      case badgecmd
      when 0   # Give all
        24.times { |i| $player.badges[i] = true }
      when 1   # Remove all
        24.times { |i| $player.badges[i] = false }
      else
        $player.badges[badgecmd - 2] = !$player.badges[badgecmd - 2]
      end
    end
  }
})

MenuHandlers.add(:debug_menu, :toggle_running_shoes, {
  "name"        => _INTL("切换跑步鞋"),
  "parent"      => :player_menu,
  "description" => _INTL("切换跑步鞋的持有状态。"),
  "effect"      => proc {
    $player.has_running_shoes = !$player.has_running_shoes
    pbMessage(_INTL("获得了跑步鞋。")) if $player.has_running_shoes
    pbMessage(_INTL("失去了跑步鞋。")) if !$player.has_running_shoes
  }
})

MenuHandlers.add(:debug_menu, :toggle_pokedex, {
  "name"        => _INTL("切换宝可梦图鉴与地区图鉴"),
  "parent"      => :player_menu,
  "description" => _INTL("切换宝可梦图鉴的持有状态，并编辑地区图鉴的解锁状态。"),
  "effect"      => proc {
    dexescmd = 0
    loop do
      dexescmds = []
      dexescmds.push(_INTL("拥有图鉴：{1}", ($player.has_pokedex) ? "[是]" : "[否]"))
      dex_names = Settings.pokedex_names
      dex_names.length.times do |i|
        name = (dex_names[i].is_a?(Array)) ? dex_names[i][0] : dex_names[i]
        unlocked = $player.pokedex.unlocked?(i)
        dexescmds.push(((unlocked) ? "[是]" : "[  ]") + " " + name)
      end
      dexescmd = pbShowCommands(nil, dexescmds, -1, dexescmd)
      break if dexescmd < 0
      dexindex = dexescmd - 1
      if dexindex < 0   # Toggle Pokédex ownership
        $player.has_pokedex = !$player.has_pokedex
      elsif $player.pokedex.unlocked?(dexindex)   # Toggle Regional Dex accessibility
        $player.pokedex.lock(dexindex)
      else
        $player.pokedex.unlock(dexindex)
      end
    end
  }
})

MenuHandlers.add(:debug_menu, :toggle_pokegear, {
  "name"        => _INTL("切换宝可装置"),
  "parent"      => :player_menu,
  "description" => _INTL("切换宝可装置的拥有状态。"),
  "effect"      => proc {
    $player.has_pokegear = !$player.has_pokegear
    pbMessage(_INTL("已获得宝可装置。")) if $player.has_pokegear
    pbMessage(_INTL("已失去宝可装置。")) if !$player.has_pokegear
  }
})

MenuHandlers.add(:debug_menu, :edit_phone_contacts, {
  "name"        => _INTL("编辑电话和联系人"),
  "parent"      => :player_menu,
  "description" => _INTL("编辑宝可装置中的电话及已登录联系人的属性。"),
  "effect"      => proc {
    if !$PokemonGlobal.phone
      pbMessage(_INTL("未定义电话。"))
      next
    end
    cmd = 0
    loop do
      cmds = []
      time = $PokemonGlobal.phone.time_to_next_call.to_i   # time is in seconds
      min = time / 60
      sec = time % 60
      cmds.push(_INTL("距下一次通话的时间：{1}分{2}秒", min, sec))
      cmds.push(((Phone.rematches_enabled) ? "[是]" : "[  ]") + " " + _INTL("可再战"))
      cmds.push(_INTL("最高再战版本：{1}", Phone.rematch_variant))
      if $PokemonGlobal.phone.contacts.length > 0
        cmds.push(_INTL("让所有联系人做好再战准备"))
        cmds.push(_INTL("编辑联系人：{1}", $PokemonGlobal.phone.contacts.length))
      end
      cmd = pbShowCommands(nil, cmds, -1, cmd)
      break if cmd < 0
      case cmd
      when 0   # Time until next call
        params = ChooseNumberParams.new
        params.setRange(0, 99_999)
        params.setDefaultValue(min)
        params.setCancelValue(-1)
        new_time = pbMessageChooseNumber(_INTL("设置距离下一次电话的时间（以分钟为单位）。"), params)
        $PokemonGlobal.phone.time_to_next_call = new_time * 60 if new_time >= 0
      when 1   # Rematches possible
        Phone.rematches_enabled = !Phone.rematches_enabled
      when 2   # Maximum rematch version
        params = ChooseNumberParams.new
        params.setRange(0, 99)
        params.setDefaultValue(Phone.rematch_variant)
        new_version = pbMessageChooseNumber(_INTL("设置训练家联系人可达到的最高版本号。"), params)
        Phone.rematch_variant = new_version
      when 3   # Make all contacts ready for a rematch
        $PokemonGlobal.phone.contacts.each do |contact|
          next if !contact.trainer?
          contact.rematch_flag = 1
          contact.set_trainer_event_ready_for_rematch
        end
        pbMessage(_INTL("宝可装置中的所有训练家现在都已准备好再次对战。"))
      when 4   # Edit individual contacts
        contact_cmd = 0
        loop do
          contact_cmds = []
          $PokemonGlobal.phone.contacts.each do |contact|
            visible_string = (contact.visible?) ? "[是]" : "[  ]"
            if contact.trainer?
              contact_cmds.push(_INTL("{1} {2}（{3}{4}）", visible_string, contact.display_name, contact.variant,
                                     (contact.can_rematch?) ? _INTL("，可再战") : ""))
            else
              contact_cmds.push(_INTL("{1} {2}", visible_string, contact.display_name))
            end
          end
          contact_cmd = pbShowCommands(nil, contact_cmds, -1, contact_cmd)
          break if contact_cmd < 0
          contact = $PokemonGlobal.phone.contacts[contact_cmd]
          edit_cmd = 0
          loop do
            edit_cmds = []
            edit_cmds.push(((contact.visible?) ? "[是]" : "[  ]") + " " + _INTL("联系方式可见"))
            if contact.trainer?
              edit_cmds.push(((contact.can_rematch?) ? "[是]" : "[  ]") + " " + _INTL("可以战斗"))
              ready_time = contact.time_to_ready   # time is in seconds
              ready_min = ready_time / 60
              ready_sec = ready_time % 60
              edit_cmds.push(_INTL("备战时间：{1}分{2}秒", ready_min, ready_sec))
              edit_cmds.push(_INTL("上次击败的版本：{1}", contact.variant))
            end
            break if edit_cmds.length == 0
            edit_cmd = pbShowCommands(nil, edit_cmds, -1, edit_cmd)
            break if edit_cmd < 0
            case edit_cmd
            when 0   # Visibility
              contact.visible = !contact.visible if contact.can_hide?
            when 1   # Can battle
              contact.rematch_flag = (contact.can_rematch?) ? 0 : 1
              contact.time_to_ready = 0 if contact.can_rematch?
            when 2   # Time until ready to battle
              params = ChooseNumberParams.new
              params.setRange(0, 99_999)
              params.setDefaultValue(ready_min)
              params.setCancelValue(-1)
              new_time = pbMessageChooseNumber(_INTL("设置该训练家再次对战的等待时间（分钟）。"), params)
              contact.time_to_ready = new_time * 60 if new_time >= 0
            when 3   # Last defeated version
              params = ChooseNumberParams.new
              params.setRange(0, 99)
              params.setDefaultValue(contact.variant)
              new_version = pbMessageChooseNumber(_INTL("设置上次击败该训练家时的版本号。"), params)
              contact.version = contact.start_version + new_version
            end
          end
        end
      end
    end
  }
})

MenuHandlers.add(:debug_menu, :toggle_box_link, {
  "name"        => _INTL("从队伍画面访问寄放系统"),
  "parent"      => :player_menu,
  "description" => _INTL("切换“盒子链接”功能：通过队伍画面访问宝可梦寄放系统。"),
  "effect"      => proc {
    $player.has_box_link = !$player.has_box_link
    pbMessage(_INTL("允许从队伍画面访问宝可梦寄放系统。")) if $player.has_box_link
    pbMessage(_INTL("禁止从队伍画面访问宝可梦寄放系统。")) if !$player.has_box_link
  }
})

MenuHandlers.add(:debug_menu, :set_player_character, {
  "name"        => _INTL("设置玩家角色"),
  "parent"      => :player_menu,
  "description" => _INTL("依据 metadata.txt 中的定义编辑玩家角色。"),
  "effect"      => proc {
    index = 0
    cmds = []
    ids = []
    GameData::PlayerMetadata.each do |player|
      index = cmds.length if player.id == $player.character_ID
      cmds.push(player.id.to_s)
      ids.push(player.id)
    end
    if cmds.length == 1
      pbMessage(_INTL("仅定义了一个玩家角色。"))
      break
    end
    cmd = pbShowCommands(nil, cmds, -1, index)
    if cmd >= 0 && cmd != index
      pbChangePlayer(ids[cmd])
      pbMessage(_INTL("玩家角色已更改。"))
    end
  }
})

MenuHandlers.add(:debug_menu, :change_outfit, {
  "name"        => _INTL("设置玩家服装"),
  "parent"      => :player_menu,
  "description" => _INTL("编辑玩家的服装编号。"),
  "effect"      => proc {
    oldoutfit = $player.outfit
    params = ChooseNumberParams.new
    params.setRange(0, 99)
    params.setDefaultValue(oldoutfit)
    $player.outfit = pbMessageChooseNumber(_INTL("设置玩家的服装。"), params)
    pbMessage(_INTL("玩家的服装已更改。")) if $player.outfit != oldoutfit
  }
})

MenuHandlers.add(:debug_menu, :rename_player, {
  "name"        => _INTL("设置玩家名称"),
  "parent"      => :player_menu,
  "description" => _INTL("更改玩家的名字。"),
  "effect"      => proc {
    trname = pbEnterPlayerName(_INTL("你的名字？"), 0, Settings::MAX_PLAYER_NAME_SIZE, $player.name)
    if nil_or_empty?(trname) && pbConfirmMessage(_INTL("要使用默认名字吗？"))
      trainertype = $player.trainer_type
      gender      = pbGetTrainerTypeGender(trainertype)
      trname      = pbSuggestTrainerName(gender)
    end
    if nil_or_empty?(trname)
      pbMessage(_INTL("玩家的名字仍为{1}。", $player.name))
    else
      $player.name = trname
      pbMessage(_INTL("玩家的名字已更改为{1}。", $player.name))
    end
  }
})

MenuHandlers.add(:debug_menu, :random_id, {
  "name"        => _INTL("随机化玩家ID"),
  "parent"      => :player_menu,
  "description" => _INTL("为玩家生成一个新的随机 ID。"),
  "effect"      => proc {
    $player.id = rand(2**16) | (rand(2**16) << 16)
    pbMessage(_INTL("玩家的 ID 已更改为 {1}（完整 ID：{2}）。", $player.public_ID, $player.id))
  }
})

#===============================================================================
# PBS file editors.
#===============================================================================

MenuHandlers.add(:debug_menu, :pbs_editors_menu, {
  "name"        => _INTL("PBS 文件编辑器..."),
  "parent"      => :main,
  "description" => _INTL("编辑 PBS 文件中的信息。")
})

MenuHandlers.add(:debug_menu, :set_map_connections, {
  "name"        => _INTL("编辑 map_connections.txt"),
  "parent"      => :pbs_editors_menu,
  "description" => _INTL("使用可视化界面连接地图。还可以编辑地图遭遇和元数据。"),
  "effect"      => proc {
    pbFadeOutIn { pbConnectionsEditor }
  }
})

MenuHandlers.add(:debug_menu, :set_encounters, {
  "name"        => _INTL("编辑 encounters.txt"),
  "parent"      => :pbs_editors_menu,
  "description" => _INTL("编辑可以在地图上找到的野生宝可梦及其遭遇方式。"),
  "effect"      => proc {
    pbFadeOutIn { pbEncountersEditor }
  }
})

MenuHandlers.add(:debug_menu, :set_trainers, {
  "name"        => _INTL("编辑 trainers.txt"),
  "parent"      => :pbs_editors_menu,
  "description" => _INTL("编辑各个训练家及其宝可梦和持有的道具。"),
  "effect"      => proc {
    pbFadeOutIn { pbTrainerBattleEditor }
  }
})

MenuHandlers.add(:debug_menu, :set_trainer_types, {
  "name"        => _INTL("编辑 trainer_types.txt"),
  "parent"      => :pbs_editors_menu,
  "description" => _INTL("编辑训练家类型的数据。"),
  "effect"      => proc {
    pbFadeOutIn { pbTrainerTypeEditor }
  }
})

MenuHandlers.add(:debug_menu, :set_map_metadata, {
  "name"        => _INTL("编辑 map_metadata.txt"),
  "parent"      => :pbs_editors_menu,
  "description" => _INTL("编辑地图元数据。"),
  "effect"      => proc {
    pbMapMetadataScreen(pbDefaultMap)
  }
})

MenuHandlers.add(:debug_menu, :set_metadata, {
  "name"        => _INTL("编辑 metadata.txt"),
  "parent"      => :pbs_editors_menu,
  "description" => _INTL("编辑全局元数据和玩家角色元数据。"),
  "effect"      => proc {
    pbMetadataScreen
  }
})

MenuHandlers.add(:debug_menu, :set_items, {
  "name"        => _INTL("编辑 items.txt"),
  "parent"      => :pbs_editors_menu,
  "description" => _INTL("编辑道具数据。"),
  "effect"      => proc {
    pbFadeOutIn { pbItemEditor }
  }
})

MenuHandlers.add(:debug_menu, :set_species, {
  "name"        => _INTL("编辑 pokemon.txt"),
  "parent"      => :pbs_editors_menu,
  "description" => _INTL("编辑宝可梦物种数据。"),
  "effect"      => proc {
    pbFadeOutIn { pbPokemonEditor }
  }
})

MenuHandlers.add(:debug_menu, :position_sprites, {
  "name"        => _INTL("编辑 pokemon_metrics.txt"),
  "parent"      => :pbs_editors_menu,
  "description" => _INTL("在战斗中重新定位宝可梦的精灵图。"),
  "effect"      => proc {
    pbFadeOutIn do
      sp = SpritePositioner.new
      sps = SpritePositionerScreen.new(sp)
      sps.pbStart
    end
  }
})

MenuHandlers.add(:debug_menu, :auto_position_sprites, {
  "name"        => _INTL("自动设置 pokemon_metrics.txt"),
  "parent"      => :pbs_editors_menu,
  "description" => _INTL("自动重新调整战斗中所有宝可梦的精灵图位置。请谨慎使用。"),
  "effect"      => proc {
    if pbConfirmMessage(_INTL("确定要重新定位所有宝可梦的精灵图吗？"))
      msgwindow = pbCreateMessageWindow
      pbMessageDisplay(msgwindow, _INTL("正在重新定位所有宝可梦的精灵图，请稍等。"), false)
      Graphics.update
      pbAutoPositionAll
      pbDisposeMessageWindow(msgwindow)
    end
  }
})

MenuHandlers.add(:debug_menu, :set_pokedex_lists, {
  "name"        => _INTL("编辑 regional_dexes.txt"),
  "parent"      => :pbs_editors_menu,
  "description" => _INTL("创建、重新排列和删除地区图鉴列表。"),
  "effect"      => proc {
    pbFadeOutIn { pbRegionalDexEditorMain }
  }
})

#===============================================================================
# Other editors.
#===============================================================================

MenuHandlers.add(:debug_menu, :editors_menu, {
  "name"        => _INTL("其他编辑器..."),
  "parent"      => :main,
  "description" => _INTL("编辑战斗动画、地形标签、地图数据等。")
})

MenuHandlers.add(:debug_menu, :animation_editor, {
  "name"        => _INTL("战斗动画编辑器"),
  "parent"      => :editors_menu,
  "description" => _INTL("编辑战斗动画。"),
  "effect"      => proc {
    pbBGMStop
    Graphics.resize_screen(AnimationEditor::WINDOW_WIDTH, AnimationEditor::WINDOW_HEIGHT)
    pbSetResizeFactor(1)
    screen = AnimationEditor::AnimationSelector.new
    screen.run
    Graphics.resize_screen(Settings::SCREEN_WIDTH, Settings::SCREEN_HEIGHT)
    pbSetResizeFactor($PokemonSystem.screensize)
    $game_map&.autoplay
  }
})

MenuHandlers.add(:debug_menu, :old_animation_editor_menu, {
  "name"        => _INTL("旧版战斗动画编辑器..."),
  "parent"      => :editors_menu,
  "description" => _INTL("编辑 Essentials v22 之前的旧版战斗动画。")
})


MenuHandlers.add(:debug_menu, :set_terrain_tags, {
  "name"        => _INTL("编辑地形标签"),
  "parent"      => :editors_menu,
  "description" => _INTL("编辑图块组中图块的地形标签。8 号及以上的标签需要使用此功能。"),
  "effect"      => proc {
    pbFadeOutIn { pbTilesetScreen }
  }
})

MenuHandlers.add(:debug_menu, :fix_invalid_tiles, {
  "name"        => _INTL("修复无效图块"),
  "parent"      => :editors_menu,
  "description" => _INTL("扫描所有地图并删除不存在的图块。"),
  "effect"      => proc {
    pbDebugFixInvalidTiles
  }
})

#===============================================================================
# Old battle animation editor and related functions.
#===============================================================================

MenuHandlers.add(:debug_menu, :old_animation_editor, {
  "name"        => _INTL("旧版战斗动画编辑器"),
  "parent"      => :old_animation_editor_menu,
  "description" => _INTL("编辑旧式战斗动画。如无必要，请勿使用。"),
  "effect"      => proc {
    pbFadeOutIn { pbAnimationEditor }
  }
})

MenuHandlers.add(:debug_menu, :old_animation_organiser, {
  "name"        => _INTL("旧版战斗动画管理器"),
  "parent"      => :old_animation_editor_menu,
  "description" => _INTL("重新排列、添加或删除旧式战斗动画。"),
  "effect"      => proc {
    pbFadeOutIn { pbAnimationsOrganiser }
  }
})

MenuHandlers.add(:debug_menu, :import_old_animations, {
  "name"        => _INTL("导入所有旧版战斗动画"),
  "parent"      => :old_animation_editor_menu,
  "description" => _INTL("从“Animations”文件夹导入所有旧式战斗动画。"),
  "effect"      => proc {
    pbImportAllAnimations
  }
})

MenuHandlers.add(:debug_menu, :export_old_animations, {
  "name"        => _INTL("导出所有旧版战斗动画"),
  "parent"      => :old_animation_editor_menu,
  "description" => _INTL("将所有旧式战斗动画逐个导出到“Animations”文件夹。"),
  "effect"      => proc {
    pbExportAllAnimations
  }
})

#===============================================================================
# Other options.
#===============================================================================

MenuHandlers.add(:debug_menu, :files_menu, {
  "name"        => _INTL("文件选项..."),
  "parent"      => :main,
  "description" => _INTL("编译、生成 PBS 文件、翻译、神秘礼物等。")
})

MenuHandlers.add(:debug_menu, :compile_data, {
  "name"        => _INTL("编译数据"),
  "parent"      => :files_menu,
  "description" => _INTL("编译所有游戏数据。"),
  "effect"      => proc {
    msgwindow = pbCreateMessageWindow
    Compiler.compile_all(true)
    pbMessageDisplay(msgwindow, _INTL("所有游戏数据均已编译完成。"))
    pbDisposeMessageWindow(msgwindow)
  }
})

MenuHandlers.add(:debug_menu, :create_pbs_files, {
  "name"        => _INTL("创建 PBS 文件"),
  "parent"      => :files_menu,
  "description" => _INTL("选择要创建的一个或所有 PBS 文件。"),
  "effect"      => proc {
    cmd = 0
    cmds = [
      _INTL("[全部创建]"),
      "abilities.txt",
      "battle_facility_lists.txt",
      "berry_plants.txt",
      "dungeon_parameters.txt",
      "dungeon_tilesets.txt",
      "encounters.txt",
      "items.txt",
      "map_connections.txt",
      "map_metadata.txt",
      "metadata.txt",
      "moves.txt",
      "phone.txt",
      "pokemon.txt",
      "pokemon_forms.txt",
      "pokemon_metrics.txt",
      "regional_dexes.txt",
      "ribbons.txt",
      "shadow_pokemon.txt",
      "town_map.txt",
      "trainer_types.txt",
      "trainers.txt",
      "types.txt"
    ]
    loop do
      cmd = pbShowCommands(nil, cmds, -1, cmd)
      case cmd
      when 0  then Compiler.write_all_pbs_files
      when 1  then Compiler.write_abilities
      when 2  then Compiler.write_trainer_lists
      when 3  then Compiler.write_berry_plants
      when 4  then Compiler.write_dungeon_parameters
      when 5  then Compiler.write_dungeon_tilesets
      when 6  then Compiler.write_encounters
      when 7  then Compiler.write_items
      when 8  then Compiler.write_connections
      when 9  then Compiler.write_map_metadata
      when 10 then Compiler.write_metadata
      when 11 then Compiler.write_moves
      when 12 then Compiler.write_phone
      when 13 then Compiler.write_pokemon
      when 14 then Compiler.write_pokemon_forms
      when 15 then Compiler.write_pokemon_metrics
      when 16 then Compiler.write_regional_dexes
      when 17 then Compiler.write_ribbons
      when 18 then Compiler.write_shadow_pokemon
      when 19 then Compiler.write_town_map
      when 20 then Compiler.write_trainer_types
      when 21 then Compiler.write_trainers
      when 22 then Compiler.write_types
      else break
      end
      pbMessage(_INTL("文件已写入。"))
    end
  }
})

MenuHandlers.add(:debug_menu, :extract_text, {
  "name"        => _INTL("提取文本进行翻译"),
  "parent"      => :files_menu,
  "description" => _INTL("将游戏中的所有文本提取到文本文件中进行翻译。"),
  "effect"      => proc {
    if Settings::LANGUAGES.length == 0
      pbMessage(_INTL("设置中的 LANGUAGES 数组未定义任何语言。"))
      pbMessage(_INTL("你需要先在 LANGUAGES 中添加至少一种语言，才能选择要提取文本的语言。"))
      next
    end
    # Choose a language from Settings to name the extraction folder after
    cmds = []
    Settings::LANGUAGES.each { |val| cmds.push(val[0]) }
    cmds.push(_INTL("取消"))
    language_index = pbMessage(_INTL("选择要提取文本的语言。"), cmds, cmds.length)
    next if language_index == cmds.length - 1
    language_name = Settings::LANGUAGES[language_index][1]
    # Choose whether to extract core text or game text
    text_type = pbMessage(_INTL("选择要提取的文本类型。"),
                          [_INTL("游戏特定文本"), _INTL("核心文本"), _INTL("取消")], 3)
    next if text_type == 2
    # If game text, choose whether to extract map texts to map-specific files or
    # to one big file
    map_files = 0
    if text_type == 0
      map_files = pbMessage(_INTL("地图事件文本应提取到多少个文本文件中？"),
                            [_INTL("一个大文件"), _INTL("每个地图一个文件"), _INTL("取消")], 3)
      next if map_files == 2
    end
    # Extract the chosen set of text for the chosen language
    Translator.extract_text(language_name, text_type == 1, map_files == 1)
  }
})

MenuHandlers.add(:debug_menu, :compile_text, {
  "name"        => _INTL("编译翻译文本"),
  "parent"      => :files_menu,
  "description" => _INTL("导入文本文件并将其转换为语言文件。"),
  "effect"      => proc {
    # Find all folders with a particular naming convention
    cmds = Dir.glob("Text_*_*")
    if cmds.length == 0
      pbMessage(_INTL("找不到可编译的语言文件夹。"))
      pbMessage(_INTL("语言文件夹必须命名为“Text_SOMETHING_core”或“Text_SOMETHING_game”并位于根文件夹中。"))
      next
    end
    cmds.push(_INTL("取消"))
    # Ask which folder to compile into a .dat file
    folder_index = pbMessage(_INTL("选择要编译的语言文件夹。"), cmds, cmds.length)
    next if folder_index == cmds.length - 1
    # Compile the text files in the chosen folder
    dat_filename = cmds[folder_index].gsub!(/^Text_/, "")
    Translator.compile_text(cmds[folder_index], dat_filename)
  }
})

MenuHandlers.add(:debug_menu, :mystery_gift, {
  "name"        => _INTL("管理神秘礼物"),
  "parent"      => :files_menu,
  "description" => _INTL("编辑神秘礼物，并启用或禁用它。"),
  "effect"      => proc {
    pbManageMysteryGifts
  }
})

MenuHandlers.add(:debug_menu, :reload_system_cache, {
  "name"        => _INTL("重新加载系统缓存"),
  "parent"      => :files_menu,
  "description" => _INTL("刷新系统的文件缓存。如果在游戏运行时更改了文件，请使用此功能。"),
  "effect"      => proc {
    System.reload_cache
    pbMessage(_INTL("系统缓存已重新加载。"))
  }
})
