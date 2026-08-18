#===============================================================================
#
#===============================================================================
module Battle::AbilityEffects
  SpeedCalc                        = AbilityHandlerHash.new
  WeightCalc                       = AbilityHandlerHash.new
  # Battler's HP changed
  OnHPDroppedBelowHalf             = AbilityHandlerHash.new
  # Battler's status condition
  StatusCheckNonIgnorable          = AbilityHandlerHash.new   # Comatose
  StatusImmunity                   = AbilityHandlerHash.new
  StatusImmunityNonIgnorable       = AbilityHandlerHash.new
  StatusImmunityFromAlly           = AbilityHandlerHash.new
  OnStatusInflicted                = AbilityHandlerHash.new   # Synchronize
  OnDealingStatus                  = AbilityHandlerHash.new   # Poison Puppeteer
  StatusCure                       = AbilityHandlerHash.new
  # Battler's stat stages
  StatLossImmunity                 = AbilityHandlerHash.new
  StatLossImmunityNonIgnorable     = AbilityHandlerHash.new   # Full Metal Body
  StatLossImmunityFromAlly         = AbilityHandlerHash.new   # Flower Veil
  OnStatGain                       = AbilityHandlerHash.new   # None!
  OnStatLoss                       = AbilityHandlerHash.new
  CopyStatChanges                  = AbilityHandlerHash.new
  # Priority and turn order
  PriorityChange                   = AbilityHandlerHash.new
  PriorityBracketChange            = AbilityHandlerHash.new   # Stall
  PriorityBracketUse               = AbilityHandlerHash.new   # None!
  # Move usage failures
  OnFlinch                         = AbilityHandlerHash.new   # Steadfast
  MoveBlocking                     = AbilityHandlerHash.new
  MoveImmunity                     = AbilityHandlerHash.new
  # Move usage
  ModifyMoveBaseType               = AbilityHandlerHash.new
  # Accuracy calculation
  AccuracyCalcFromUser             = AbilityHandlerHash.new
  AccuracyCalcFromAlly             = AbilityHandlerHash.new   # Victory Star
  AccuracyCalcFromTarget           = AbilityHandlerHash.new
  # Damage calculation
  DamageCalcFromUser               = AbilityHandlerHash.new
  DamageCalcFromAlly               = AbilityHandlerHash.new
  DamageCalcFromTarget             = AbilityHandlerHash.new
  DamageCalcFromTargetNonIgnorable = AbilityHandlerHash.new
  DamageCalcFromTargetAlly         = AbilityHandlerHash.new
  CriticalCalcFromUser             = AbilityHandlerHash.new
  CriticalCalcFromTarget           = AbilityHandlerHash.new
  # Upon a move hitting a target
  OnTargetedForHit                 = AbilityHandlerHash.new   # Tera Shell
  OnBeingHit                       = AbilityHandlerHash.new
  OnDealingHit                     = AbilityHandlerHash.new   # Poison Touch
  # Abilities that trigger at the end of using a move
  OnEndOfUsingMove                 = AbilityHandlerHash.new
  AfterMoveUseFromTarget           = AbilityHandlerHash.new
  # End Of Round
  EndOfRoundWeather                = AbilityHandlerHash.new
  EndOfRoundHealing                = AbilityHandlerHash.new
  EndOfRoundEffect                 = AbilityHandlerHash.new
  EndOfRoundGainItem               = AbilityHandlerHash.new
  # Switching and fainting
  CertainSwitching                 = AbilityHandlerHash.new   # None!
  TrappingByTarget                 = AbilityHandlerHash.new
  OnSwitchIn                       = AbilityHandlerHash.new
  OnSwitchOut                      = AbilityHandlerHash.new
  ChangeOnBattlerFainting          = AbilityHandlerHash.new
  OnBattlerFainting                = AbilityHandlerHash.new   # Soul-Heart
  OnWeatherChange                  = AbilityHandlerHash.new
  OnTerrainChange                  = AbilityHandlerHash.new   # Mimicry
  OnIntimidated                    = AbilityHandlerHash.new   # Rattled (Gen 8)
  # Running from battle
  CertainEscapeFromBattle          = AbilityHandlerHash.new   # Run Away

  #-----------------------------------------------------------------------------

  def self.trigger(hash, *args, ret: false)
    new_ret = hash.trigger(*args)
    return (!new_ret.nil?) ? new_ret : ret
  end

  #-----------------------------------------------------------------------------

  def self.triggerSpeedCalc(ability, battler, mult)
    return trigger(SpeedCalc, ability, battler, mult, ret: mult)
  end

  def self.triggerWeightCalc(ability, battler, weight)
    return trigger(WeightCalc, ability, battler, weight, ret: weight)
  end

  #-----------------------------------------------------------------------------

  def self.triggerOnHPDroppedBelowHalf(ability, user, move_user, battle)
    return trigger(OnHPDroppedBelowHalf, ability, user, move_user, battle)
  end

  #-----------------------------------------------------------------------------

  def self.triggerStatusCheckNonIgnorable(ability, battler, status)
    return trigger(StatusCheckNonIgnorable, ability, battler, status)
  end

  def self.triggerStatusImmunity(ability, battler, status)
    return trigger(StatusImmunity, ability, battler, status)
  end

  def self.triggerStatusImmunityNonIgnorable(ability, battler, status)
    return trigger(StatusImmunityNonIgnorable, ability, battler, status)
  end

  def self.triggerStatusImmunityFromAlly(ability, battler, status)
    return trigger(StatusImmunityFromAlly, ability, battler, status)
  end

  def self.triggerOnStatusInflicted(ability, battler, user, status)
    OnStatusInflicted.trigger(ability, battler, user, status)
  end

  def self.triggerOnDealingStatus(ability, user, target, status)
    OnDealingStatus.trigger(ability, user, target, status)
  end

  def self.triggerStatusCure(ability, battler)
    return trigger(StatusCure, ability, battler)
  end

  #-----------------------------------------------------------------------------

  def self.triggerStatLossImmunity(ability, battler, stat, battle, show_messages)
    return trigger(StatLossImmunity, ability, battler, stat, battle, show_messages)
  end

  def self.triggerStatLossImmunityNonIgnorable(ability, battler, stat, battle, show_messages)
    return trigger(StatLossImmunityNonIgnorable, ability, battler, stat, battle, show_messages)
  end

  def self.triggerStatLossImmunityFromAlly(ability, bearer, battler, stat, battle, show_messages)
    return trigger(StatLossImmunityFromAlly, ability, bearer, battler, stat, battle, show_messages)
  end

  def self.triggerOnStatGain(ability, battler, stat, user)
    OnStatGain.trigger(ability, battler, stat, user)
  end

  def self.triggerOnStatLoss(ability, battler, stat, user)
    OnStatLoss.trigger(ability, battler, stat, user)
  end

  def self.triggerCopyStatChanges(ability, battler, battle)
    CopyStatChanges.trigger(ability, battler, battle)
  end

  #-----------------------------------------------------------------------------

  def self.triggerPriorityChange(ability, battler, move, priority)
    return trigger(PriorityChange, ability, battler, move, priority, ret: priority)
  end

  def self.triggerPriorityBracketChange(ability, battler, battle)
    return trigger(PriorityBracketChange, ability, battler, battle, ret: 0)
  end

  def self.triggerPriorityBracketUse(ability, battler, battle)
    PriorityBracketUse.trigger(ability, battler, battle)
  end

  #-----------------------------------------------------------------------------

  def self.triggerOnFlinch(ability, battler, battle)
    OnFlinch.trigger(ability, battler, battle)
  end

  def self.triggerMoveBlocking(ability, bearer, user, targets, move, battle)
    return trigger(MoveBlocking, ability, bearer, user, targets, move, battle)
  end

  def self.triggerMoveImmunity(ability, user, target, move, type, battle, show_message)
    return trigger(MoveImmunity, ability, user, target, move, type, battle, show_message)
  end

  #-----------------------------------------------------------------------------

  def self.triggerModifyMoveBaseType(ability, user, move, type)
    return trigger(ModifyMoveBaseType, ability, user, move, type, ret: type)
  end

  #-----------------------------------------------------------------------------

  def self.triggerAccuracyCalcFromUser(ability, mods, user, target, move, type)
    AccuracyCalcFromUser.trigger(ability, mods, user, target, move, type)
  end

  def self.triggerAccuracyCalcFromAlly(ability, mods, user, target, move, type)
    AccuracyCalcFromAlly.trigger(ability, mods, user, target, move, type)
  end

  def self.triggerAccuracyCalcFromTarget(ability, mods, user, target, move, type)
    AccuracyCalcFromTarget.trigger(ability, mods, user, target, move, type)
  end

  #-----------------------------------------------------------------------------

  def self.triggerDamageCalcFromUser(ability, user, target, move, mults, power, type)
    DamageCalcFromUser.trigger(ability, user, target, move, mults, power, type)
  end

  def self.triggerDamageCalcFromAlly(ability, user, target, move, mults, power, type)
    DamageCalcFromAlly.trigger(ability, user, target, move, mults, power, type)
  end

  def self.triggerDamageCalcFromTarget(ability, user, target, move, mults, power, type)
    DamageCalcFromTarget.trigger(ability, user, target, move, mults, power, type)
  end

  def self.triggerDamageCalcFromTargetNonIgnorable(ability, user, target, move, mults, power, type)
    DamageCalcFromTargetNonIgnorable.trigger(ability, user, target, move, mults, power, type)
  end

  def self.triggerDamageCalcFromTargetAlly(ability, user, target, move, mults, power, type)
    DamageCalcFromTargetAlly.trigger(ability, user, target, move, mults, power, type)
  end

  def self.triggerCriticalCalcFromUser(ability, user, target, move, crit_stage)
    return trigger(CriticalCalcFromUser, ability, user, target, move, crit_stage, ret: crit_stage)
  end

  def self.triggerCriticalCalcFromTarget(ability, user, target, move, crit_stage)
    return trigger(CriticalCalcFromTarget, ability, user, target, move, crit_stage, ret: crit_stage)
  end

  #-----------------------------------------------------------------------------

  def self.triggerOnTargetedForHit(ability, user, target, move, hit_num, battle)
    OnTargetedForHit.trigger(ability, user, target, move, hit_num, battle)
  end

  def self.triggerOnBeingHit(ability, user, target, move, battle)
    OnBeingHit.trigger(ability, user, target, move, battle)
  end

  def self.triggerOnDealingHit(ability, user, target, move, battle)
    OnDealingHit.trigger(ability, user, target, move, battle)
  end

  #-----------------------------------------------------------------------------

  def self.triggerOnEndOfUsingMove(ability, user, targets, move, battle)
    OnEndOfUsingMove.trigger(ability, user, targets, move, battle)
  end

  def self.triggerAfterMoveUseFromTarget(ability, target, user, move, switched_battlers, battle)
    AfterMoveUseFromTarget.trigger(ability, target, user, move, switched_battlers, battle)
  end

  #-----------------------------------------------------------------------------

  def self.triggerEndOfRoundWeather(ability, weather, battler, battle)
    EndOfRoundWeather.trigger(ability, weather, battler, battle)
  end

  def self.triggerEndOfRoundHealing(ability, battler, battle)
    EndOfRoundHealing.trigger(ability, battler, battle)
  end

  def self.triggerEndOfRoundEffect(ability, battler, battle)
    EndOfRoundEffect.trigger(ability, battler, battle)
  end

  def self.triggerEndOfRoundGainItem(ability, battler, battle)
    EndOfRoundGainItem.trigger(ability, battler, battle)
  end

  #-----------------------------------------------------------------------------

  def self.triggerCertainSwitching(ability, switcher, battle)
    return trigger(CertainSwitching, ability, switcher, battle)
  end

  def self.triggerTrappingByTarget(ability, switcher, bearer, battle)
    return trigger(TrappingByTarget, ability, switcher, bearer, battle)
  end

  def self.triggerOnSwitchIn(ability, battler, battle, switch_in = false)
    OnSwitchIn.trigger(ability, battler, battle, switch_in)
  end

  def self.triggerOnSwitchOut(ability, battler, end_of_battle)
    OnSwitchOut.trigger(ability, battler, end_of_battle)
  end

  def self.triggerChangeOnBattlerFainting(ability, battler, fainted, battle)
    ChangeOnBattlerFainting.trigger(ability, battler, fainted, battle)
  end

  def self.triggerOnBattlerFainting(ability, battler, fainted, battle)
    OnBattlerFainting.trigger(ability, battler, fainted, battle)
  end

  def self.triggerOnWeatherChange(ability, battler, battle, old_weather, ability_changed)
    OnWeatherChange.trigger(ability, battler, battle, old_weather, ability_changed)
  end

  def self.triggerOnTerrainChange(ability, battler, battle, old_terrain, ability_changed)
    OnTerrainChange.trigger(ability, battler, battle, old_terrain, ability_changed)
  end

  def self.triggerOnIntimidated(ability, battler, battle)
    OnIntimidated.trigger(ability, battler, battle)
  end

  #-----------------------------------------------------------------------------

  def self.triggerCertainEscapeFromBattle(ability, battler)
    return trigger(CertainEscapeFromBattle, ability, battler)
  end
end

#===============================================================================
# SpeedCalc handlers
#===============================================================================

Battle::AbilityEffects::SpeedCalc.add(:CHLOROPHYLL,
  proc { |ability, battler, mult|
    next mult * 2 if [:Sun, :HarshSun].include?(battler.effectiveWeather)
  }
)

Battle::AbilityEffects::SpeedCalc.add(:PROTOSYNTHESIS,
  proc { |ability, battler, mult|
    next mult * 1.5 if !battler.effects[PBEffects::Transform] &&
                       battler.effects[PBEffects::ProtosynthesisStat] == :SPEED
  }
)

Battle::AbilityEffects::SpeedCalc.copy(:PROTOSYNTHESIS, :QUARKDRIVE)

Battle::AbilityEffects::SpeedCalc.add(:QUICKFEET,
  proc { |ability, battler, mult|
    next mult * 1.5 if battler.pbHasAnyStatus?
  }
)

Battle::AbilityEffects::SpeedCalc.add(:SANDRUSH,
  proc { |ability, battler, mult|
    next mult * 2 if [:Sandstorm].include?(battler.effectiveWeather)
  }
)

Battle::AbilityEffects::SpeedCalc.add(:SLOWSTART,
  proc { |ability, battler, mult|
    next mult / 2 if battler.effects[PBEffects::SlowStart] > 0
  }
)

Battle::AbilityEffects::SpeedCalc.add(:SLUSHRUSH,
  proc { |ability, battler, mult|
    next mult * 2 if [:Hail, :Snowstorm].include?(battler.effectiveWeather)
  }
)

Battle::AbilityEffects::SpeedCalc.add(:SURGESURFER,
  proc { |ability, battler, mult|
    next mult * 2 if battler.battle.field.terrain == :Electric
  }
)

Battle::AbilityEffects::SpeedCalc.add(:SWIFTSWIM,
  proc { |ability, battler, mult|
    next mult * 2 if [:Rain, :HeavyRain].include?(battler.effectiveWeather)
  }
)

Battle::AbilityEffects::SpeedCalc.add(:UNBURDEN,
  proc { |ability, battler, mult|
    next mult * 2 if battler.effects[PBEffects::Unburden] && !battler.item
  }
)

#===============================================================================
# WeightCalcy handlers
#===============================================================================

Battle::AbilityEffects::WeightCalc.add(:HEAVYMETAL,
  proc { |ability, battler, w|
    next w * 2
  }
)

Battle::AbilityEffects::WeightCalc.add(:LIGHTMETAL,
  proc { |ability, battler, w|
    next [w / 2, 1].max
  }
)

#===============================================================================
# OnHPDroppedBelowHalf handlers
#===============================================================================

Battle::AbilityEffects::OnHPDroppedBelowHalf.add(:ANGERSHELL,
  proc { |ability, battler, move_user, battle|
    next false if !move_user   # Not triggered if damage wasn't from a move
    next false if move_user.index == battler.index   # Not triggered by self-injury
    stat_up   = [:ATTACK, 1, :SPECIAL_ATTACK, 1, :SPEED, 1]
    stat_down = [:DEFENSE, 1, :SPECIAL_DEFENSE, 1]
    # Check if it will have any effect
    failed = true
    (stat_down.length / 2).times do |i|
      next if !battler.pbCanLowerStatStage?(stat_down[i * 2], battler)
      failed = false
      break
    end
    (stat_up.length / 2).times do |i|
      next if !battler.pbCanRaiseStatStage?(stat_up[i * 2], battler)
      failed = false
      break
    end
    next false if failed
    # Ability will have an effect; do it
    battle.pbShowAbilitySplash(battler)
    # Lower stats
    show_anim = true
    (stat_down.length / 2).times do |i|
      next if !battler.pbCanLowerStatStage?(stat_down[i * 2], battler)
      if Battle::Scene::USE_ABILITY_SPLASH
        if battler.pbLowerStatStage(stat_down[i * 2], stat_down[(i * 2) + 1], battler, show_anim)
          show_anim = false
        end
      else
        if battler.pbLowerStatStageByCause(stat_down[i * 2], stat_down[(i * 2) + 1], battler, battler.abilityName, show_anim)
          show_anim = false
        end
      end
    end
    # Raise stats
    show_anim = true
    (stat_up.length / 2).times do |i|
      next if !battler.pbCanRaiseStatStage?(stat_up[i * 2], battler)
      if Battle::Scene::USE_ABILITY_SPLASH
        if battler.pbRaiseStatStage(stat_up[i * 2], stat_up[(i * 2) + 1], battler, show_anim)
          show_anim = false
        end
      else
        if battler.pbRaiseStatStageByCause(stat_up[i * 2], stat_up[(i * 2) + 1], battler, battler.abilityName, show_anim)
          show_anim = false
        end
      end
    end
    battle.pbHideAbilitySplash(battler)
    next false
  }
)

Battle::AbilityEffects::OnHPDroppedBelowHalf.add(:EMERGENCYEXIT,
  proc { |ability, battler, move_user, battle|
    next false if battler.effects[PBEffects::SkyDrop] >= 0 ||
                  battler.inTwoTurnAttack?("TwoTurnAttackInvulnerableInSkyTargetCannotAct")   # Sky Drop
    # In wild battles
    if battle.wildBattle?
      next false if battler.opposes? && battle.pbSideBattlerCount(battler.index, true) > 1
      next false if !battle.pbCanRun?(battler.index)
      battle.pbShowAbilitySplash(battler, true)
      battle.pbHideAbilitySplash(battler)
      pbSEPlay("Battle flee")
      battle.pbDisplay(_INTL("{1}脱离了战斗！", battler.pbThis))
      battle.decision = Battle::Outcome::FLEE
      next true
    end
    # In trainer battles
    next false if battle.pbAllFainted?(battler.idxOpposingSide)
    next false if !battle.pbCanSwitchOut?(battler.index)   # Battler can't switch out
    next false if !battle.pbCanChooseNonActive?(battler.index)   # No Pokémon can switch in
    battle.pbShowAbilitySplash(battler, true)
    if !Battle::Scene::USE_ABILITY_SPLASH
      battle.pbDisplay(_INTL("{1}{2}发动了！", battler.pbOfThis, battler.abilityName))
    end
    battle.pbHideAbilitySplash(battler)
    battle.pbDisplay(_INTL("{1}要回到{2}的身边了！",
                           battler.pbThis, battle.pbGetOwnerName(battler.index)))
    if battle.endOfRound   # Just switch out
      battle.scene.pbRecall(battler.index) if !battler.fainted?
      battler.pbAbilitiesOnSwitchOut   # Inc. primordial weather check
      next true
    end
    newPkmn = battle.pbGetReplacementPokemonIndex(battler.index)   # Owner chooses
    next false if newPkmn < 0   # Shouldn't ever do this
    battle.pbRecallAndReplace(battler.index, newPkmn)
    battle.pbClearChoice(battler.index)   # Replacement Pokémon does nothing this round
    battle.moldBreaker = false if move_user && battler.index == move_user.index
    battle.pbOnBattlerEnteringBattle(battler.index)
    next true
  }
)

Battle::AbilityEffects::OnHPDroppedBelowHalf.copy(:EMERGENCYEXIT, :WIMPOUT)

#===============================================================================
# StatusCheckNonIgnorable handlers
#===============================================================================

Battle::AbilityEffects::StatusCheckNonIgnorable.add(:COMATOSE,
  proc { |ability, battler, status|
    next false if !battler.isSpecies?(:KOMALA)
    next true if status.nil? || status == :SLEEP
  }
)

#===============================================================================
# StatusImmunity handlers
#===============================================================================

Battle::AbilityEffects::StatusImmunity.add(:FLOWERVEIL,
  proc { |ability, battler, status|
    next true if battler.pbHasType?(:GRASS)
  }
)

Battle::AbilityEffects::StatusImmunity.add(:IMMUNITY,
  proc { |ability, battler, status|
    next true if status == :POISON
  }
)

Battle::AbilityEffects::StatusImmunity.copy(:IMMUNITY, :PASTELVEIL)

Battle::AbilityEffects::StatusImmunity.add(:INSOMNIA,
  proc { |ability, battler, status|
    next true if status == :SLEEP
  }
)

Battle::AbilityEffects::StatusImmunity.copy(:INSOMNIA, :SWEETVEIL, :VITALSPIRIT)

Battle::AbilityEffects::StatusImmunity.add(:LEAFGUARD,
  proc { |ability, battler, status|
    next true if [:Sun, :HarshSun].include?(battler.effectiveWeather)
  }
)

Battle::AbilityEffects::StatusImmunity.add(:LIMBER,
  proc { |ability, battler, status|
    next true if status == :PARALYSIS
  }
)

Battle::AbilityEffects::StatusImmunity.add(:MAGMAARMOR,
  proc { |ability, battler, status|
    next true if status == :FROZEN
  }
)

Battle::AbilityEffects::StatusImmunity.add(:PURIFYINGSALT,
  proc { |ability, battler, status|
    next true
  }
)

Battle::AbilityEffects::StatusImmunity.add(:WATERVEIL,
  proc { |ability, battler, status|
    next true if status == :BURN
  }
)

Battle::AbilityEffects::StatusImmunity.copy(:WATERVEIL, :THERMALEXCHANGE, :WATERBUBBLE)

#===============================================================================
# StatusImmunityNonIgnorable handlers
#===============================================================================

Battle::AbilityEffects::StatusImmunityNonIgnorable.add(:COMATOSE,
  proc { |ability, battler, status|
    next true if battler.isSpecies?(:KOMALA)
  }
)

Battle::AbilityEffects::StatusImmunityNonIgnorable.add(:SHIELDSDOWN,
  proc { |ability, battler, status|
    next true if battler.isSpecies?(:MINIOR) && battler.form < 7
  }
)

#===============================================================================
# StatusImmunityFromAlly handlers
#===============================================================================

Battle::AbilityEffects::StatusImmunityFromAlly.add(:FLOWERVEIL,
  proc { |ability, battler, status|
    next true if battler.pbHasType?(:GRASS)
  }
)

Battle::AbilityEffects::StatusImmunityFromAlly.add(:PASTELVEIL,
  proc { |ability, battler, status|
    next true if status == :POISON
  }
)

Battle::AbilityEffects::StatusImmunityFromAlly.add(:SWEETVEIL,
  proc { |ability, battler, status|
    next true if status == :SLEEP
  }
)

#===============================================================================
# OnStatusInflicted handlers
#===============================================================================

Battle::AbilityEffects::OnStatusInflicted.add(:SYNCHRONIZE,
  proc { |ability, battler, user, status|
    next if !user || user.index == battler.index
    case status
    when :POISON
      if user.pbCanPoisonSynchronize?(battler)
        battler.battle.pbShowAbilitySplash(battler)
        msg = nil
        if !Battle::Scene::USE_ABILITY_SPLASH
          msg = _INTL("{1}{2}让{3}中毒了！", battler.pbOfThis, battler.abilityName, user.pbThis(true))
        end
        user.pbPoison(nil, msg, (battler.statusCount > 0))
        battler.battle.pbHideAbilitySplash(battler)
      end
    when :BURN
      if user.pbCanBurnSynchronize?(battler)
        battler.battle.pbShowAbilitySplash(battler)
        msg = nil
        if !Battle::Scene::USE_ABILITY_SPLASH
          msg = _INTL("{1}{2}让{3}灼伤了！", battler.pbOfThis, battler.abilityName, user.pbThis(true))
        end
        user.pbBurn(nil, msg)
        battler.battle.pbHideAbilitySplash(battler)
      end
    when :PARALYSIS
      if user.pbCanParalyzeSynchronize?(battler)
        battler.battle.pbShowAbilitySplash(battler)
        msg = nil
        if !Battle::Scene::USE_ABILITY_SPLASH
          msg = _INTL("{1}{2}让{3}麻痹了！很难使出招式！",
                      battler.pbOfThis, battler.abilityName, user.pbThis(true))
        end
        user.pbParalyze(nil, msg)
        battler.battle.pbHideAbilitySplash(battler)
      end
    end
  }
)

#===============================================================================
# OnDealingStatus handlers
#===============================================================================

Battle::AbilityEffects::OnDealingStatus.add(:POISONPUPPETEER,
  proc { |ability, user, target, status|
    next if status != :POISON
    next if !user.isSpecies?(:PECHARUNT)
    next if !target.pbCanConfuse?(user, false)
    user.battle.pbShowAbilitySplash(user)
    msg = nil
    if !Battle::Scene::USE_ABILITY_SPLASH
      msg = _INTL("由于{2}{3}，{1}混乱了！", target.pbThis, user.pbOfThis(true), user.abilityName)
    end
    target.pbConfuse(msg)
    user.battle.pbHideAbilitySplash(user)
  }
)

#===============================================================================
# StatusCure handlers
#===============================================================================

Battle::AbilityEffects::StatusCure.add(:IMMUNITY,
  proc { |ability, battler|
    next if battler.status != :POISON
    battler.battle.pbShowAbilitySplash(battler)
    battler.pbCureStatus(Battle::Scene::USE_ABILITY_SPLASH)
    if !Battle::Scene::USE_ABILITY_SPLASH
      battler.battle.pbDisplay(_INTL("{1}{2}治愈了中毒！", battler.pbOfThis, battler.abilityName))
    end
    battler.battle.pbHideAbilitySplash(battler)
  }
)

Battle::AbilityEffects::StatusCure.copy(:IMMUNITY, :PASTELVEIL)

Battle::AbilityEffects::StatusCure.add(:INSOMNIA,
  proc { |ability, battler|
    next if battler.status != :SLEEP
    battler.battle.pbShowAbilitySplash(battler)
    battler.pbCureStatus(Battle::Scene::USE_ABILITY_SPLASH)
    if !Battle::Scene::USE_ABILITY_SPLASH
      battler.battle.pbDisplay(_INTL("{1}{2}让自己醒过来了！", battler.pbOfThis, battler.abilityName))
    end
    battler.battle.pbHideAbilitySplash(battler)
  }
)

Battle::AbilityEffects::StatusCure.copy(:INSOMNIA, :VITALSPIRIT)

Battle::AbilityEffects::StatusCure.add(:LIMBER,
  proc { |ability, battler|
    next if battler.status != :PARALYSIS
    battler.battle.pbShowAbilitySplash(battler)
    battler.pbCureStatus(Battle::Scene::USE_ABILITY_SPLASH)
    if !Battle::Scene::USE_ABILITY_SPLASH
      battler.battle.pbDisplay(_INTL("{1}{2}治愈了麻痹！", battler.pbOfThis, battler.abilityName))
    end
    battler.battle.pbHideAbilitySplash(battler)
  }
)

Battle::AbilityEffects::StatusCure.add(:MAGMAARMOR,
  proc { |ability, battler|
    next if battler.status != :FROZEN
    battler.battle.pbShowAbilitySplash(battler)
    battler.pbCureStatus(Battle::Scene::USE_ABILITY_SPLASH)
    if !Battle::Scene::USE_ABILITY_SPLASH
      battler.battle.pbDisplay(_INTL("{1}{2}治愈了冰冻状态！", battler.pbOfThis, battler.abilityName))
    end
    battler.battle.pbHideAbilitySplash(battler)
  }
)

Battle::AbilityEffects::StatusCure.add(:OBLIVIOUS,
  proc { |ability, battler|
    next if battler.effects[PBEffects::Attract] < 0 &&
            (battler.effects[PBEffects::Taunt] == 0 || Settings::MECHANICS_GENERATION <= 5)
    battler.battle.pbShowAbilitySplash(battler)
    if battler.effects[PBEffects::Attract] >= 0
      battler.pbCureAttract
      if Battle::Scene::USE_ABILITY_SPLASH
        battler.battle.pbDisplay(_INTL("{1}的着迷状态治愈了！", battler.pbThis))
      else
        battler.battle.pbDisplay(_INTL("{1}{2}治愈了着迷状态！",
                                       battler.pbOfThis, battler.abilityName))
      end
    end
    if battler.effects[PBEffects::Taunt] > 0 && Settings::MECHANICS_GENERATION >= 6
      battler.effects[PBEffects::Taunt] = 0
      if Battle::Scene::USE_ABILITY_SPLASH
        battler.battle.pbDisplay(_INTL("{1}的挑衅效果解除了！", battler.pbThis))
      else
        battler.battle.pbDisplay(_INTL("{1}{2}解除了挑衅效果！",
                                       battler.pbOfThis, battler.abilityName))
      end
    end
    battler.battle.pbHideAbilitySplash(battler)
  }
)

Battle::AbilityEffects::StatusCure.add(:OWNTEMPO,
  proc { |ability, battler|
    next if battler.effects[PBEffects::Confusion] == 0
    battler.battle.pbShowAbilitySplash(battler)
    battler.pbCureConfusion
    if Battle::Scene::USE_ABILITY_SPLASH
      battler.battle.pbDisplay(_INTL("{1}的混乱解除了！", battler.pbThis))
    else
      battler.battle.pbDisplay(_INTL("{1}{2}治愈了混乱！",
                                     battler.pbOfThis, battler.abilityName))
    end
    battler.battle.pbHideAbilitySplash(battler)
  }
)

Battle::AbilityEffects::StatusCure.add(:WATERVEIL,
  proc { |ability, battler|
    next if battler.status != :BURN
    battler.battle.pbShowAbilitySplash(battler)
    battler.pbCureStatus(Battle::Scene::USE_ABILITY_SPLASH)
    if !Battle::Scene::USE_ABILITY_SPLASH
      battler.battle.pbDisplay(_INTL("{1}{2}治愈了灼伤！", battler.pbOfThis, battler.abilityName))
    end
    battler.battle.pbHideAbilitySplash(battler)
  }
)

Battle::AbilityEffects::StatusCure.copy(:WATERVEIL, :THERMALEXCHANGE, :WATERBUBBLE)

#===============================================================================
# StatLossImmunity handlers
#===============================================================================

Battle::AbilityEffects::StatLossImmunity.add(:BIGPECKS,
  proc { |ability, battler, stat, battle, showMessages|
    next false if stat != :DEFENSE
    if showMessages
      battle.pbShowAbilitySplash(battler)
      if Battle::Scene::USE_ABILITY_SPLASH
        battle.pbDisplay(_INTL("{1}{2}不会降低！", battler.pbOfThis, GameData::Stat.get(stat).name))
      else
        battle.pbDisplay(_INTL("{1}{2}阻止了{3}降低！", battler.pbOfThis,
                               battler.abilityName, GameData::Stat.get(stat).name))
      end
      battle.pbHideAbilitySplash(battler)
    end
    next true
  }
)

Battle::AbilityEffects::StatLossImmunity.add(:CLEARBODY,
  proc { |ability, battler, stat, battle, showMessages|
    if showMessages
      battle.pbShowAbilitySplash(battler)
      if Battle::Scene::USE_ABILITY_SPLASH
        battle.pbDisplay(_INTL("{1}能力不会降低！", battler.pbOfThis))
      else
        battle.pbDisplay(_INTL("{1}{2}阻止了能力降低！", battler.pbOfThis, battler.abilityName))
      end
      battle.pbHideAbilitySplash(battler)
    end
    next true
  }
)

Battle::AbilityEffects::StatLossImmunity.copy(:CLEARBODY, :WHITESMOKE)

Battle::AbilityEffects::StatLossImmunity.add(:FLOWERVEIL,
  proc { |ability, battler, stat, battle, showMessages|
    next false if !battler.pbHasType?(:GRASS)
    if showMessages
      battle.pbShowAbilitySplash(battler)
      if Battle::Scene::USE_ABILITY_SPLASH
        battle.pbDisplay(_INTL("{1}能力不会降低！", battler.pbOfThis))
      else
        battle.pbDisplay(_INTL("{1}{2}阻止了能力降低！", battler.pbOfThis, battler.abilityName))
      end
      battle.pbHideAbilitySplash(battler)
    end
    next true
  }
)

Battle::AbilityEffects::StatLossImmunity.add(:HYPERCUTTER,
  proc { |ability, battler, stat, battle, showMessages|
    next false if stat != :ATTACK
    if showMessages
      battle.pbShowAbilitySplash(battler)
      if Battle::Scene::USE_ABILITY_SPLASH
        battle.pbDisplay(_INTL("{1}{2}不会降低！", battler.pbOfThis, GameData::Stat.get(stat).name))
      else
        battle.pbDisplay(_INTL("{1}{2}阻止了{3}降低！", battler.pbOfThis,
                               battler.abilityName, GameData::Stat.get(stat).name))
      end
      battle.pbHideAbilitySplash(battler)
    end
    next true
  }
)

Battle::AbilityEffects::StatLossImmunity.add(:KEENEYE,
  proc { |ability, battler, stat, battle, showMessages|
    next false if stat != :ACCURACY
    if showMessages
      battle.pbShowAbilitySplash(battler)
      if Battle::Scene::USE_ABILITY_SPLASH
        battle.pbDisplay(_INTL("{1}{2}不会降低！", battler.pbOfThis, GameData::Stat.get(stat).name))
      else
        battle.pbDisplay(_INTL("{1}{2}阻止了{3}降低！", battler.pbOfThis,
                               battler.abilityName, GameData::Stat.get(stat).name))
      end
      battle.pbHideAbilitySplash(battler)
    end
    next true
  }
)

Battle::AbilityEffects::StatLossImmunity.copy(:KEENEYE, :MINDSEYE)

if Settings::MECHANICS_GENERATION >= 9
  Battle::AbilityEffects::StatLossImmunity.copy(:KEENEYE, :ILLUMINATE)
end

#===============================================================================
# StatLossImmunityNonIgnorable handlers
#===============================================================================

Battle::AbilityEffects::StatLossImmunityNonIgnorable.add(:FULLMETALBODY,
  proc { |ability, battler, stat, battle, showMessages|
    if showMessages
      battle.pbShowAbilitySplash(battler)
      if Battle::Scene::USE_ABILITY_SPLASH
        battle.pbDisplay(_INTL("{1}能力不会降低！", battler.pbOfThis))
      else
        battle.pbDisplay(_INTL("{1}{2}阻止了能力降低！", battler.pbOfThis, battler.abilityName))
      end
      battle.pbHideAbilitySplash(battler)
    end
    next true
  }
)

#===============================================================================
# StatLossImmunityFromAlly handlers
#===============================================================================

Battle::AbilityEffects::StatLossImmunityFromAlly.add(:FLOWERVEIL,
  proc { |ability, bearer, battler, stat, battle, showMessages|
    next false if !battler.pbHasType?(:GRASS)
    if showMessages
      battle.pbShowAbilitySplash(bearer)
      if Battle::Scene::USE_ABILITY_SPLASH
        battle.pbDisplay(_INTL("{1}能力不会降低！", battler.pbOfThis))
      else
        battle.pbDisplay(_INTL("{1}{2}阻止了{3}能力降低！", bearer.pbOfThis, bearer.abilityName, battler.pbOfThis(true)))
      end
      battle.pbHideAbilitySplash(bearer)
    end
    next true
  }
)

#===============================================================================
# OnStatGain handlers
#===============================================================================

# There aren't any!

#===============================================================================
# OnStatLoss handlers
#===============================================================================

Battle::AbilityEffects::OnStatLoss.add(:COMPETITIVE,
  proc { |ability, battler, stat, user|
    next if user && !user.opposes?(battler)
    battler.pbRaiseStatStageByAbility(:SPECIAL_ATTACK, 2, battler)
  }
)

Battle::AbilityEffects::OnStatLoss.add(:DEFIANT,
  proc { |ability, battler, stat, user|
    next if user && !user.opposes?(battler)
    battler.pbRaiseStatStageByAbility(:ATTACK, 2, battler)
  }
)

#===============================================================================
# CopyStatChanges handlers
#===============================================================================

Battle::AbilityEffects::CopyStatChanges.add(:OPPORTUNIST,
  proc { |ability, battler, battle|
    raises = {}
    GameData::Stat.each_battle { |stat| raises[stat.id] = 0 }
    raises[:CRITICAL_HIT] = 0
    battler.allOpposing.each do |b|
      b.stagesChangeRecord[0].each_pair { |stat, increment| raises[stat] += increment }
    end
    next if raises.none? { |stat, increment| increment > 0 }
    battle.pbShowAbilitySplash(battler)
    raises.each_pair do |stat, increment|
      next if increment <= 0
      if stat == :CRITICAL_HIT
        battler.setCriticalHitRate(increment)
        battle.pbCommonAnimation("CriticalHitRateUp", battler)
        battle.pbDisplay(_INTL("{1}现在干劲十足！", battler.pbThis))
      else
        if Battle::Scene::USE_ABILITY_SPLASH
          battler.pbRaiseStatStage(stat, increment, battler)
        else
          battler.pbRaiseStatStageByCause(stat, increment, battler, battler.abilityName)
        end
      end
    end
    battle.pbHideAbilitySplash(battler)
  }
)

#===============================================================================
# PriorityChange handlers
#===============================================================================

Battle::AbilityEffects::PriorityChange.add(:GALEWINGS,
  proc { |ability, battler, move, pri|
    next pri + 1 if (Settings::MECHANICS_GENERATION <= 6 || battler.hp == battler.totalhp) &&
                    move.type == :FLYING
  }
)

Battle::AbilityEffects::PriorityChange.add(:PRANKSTER,
  proc { |ability, battler, move, pri|
    if move.statusMove?
      battler.effects[PBEffects::Prankster] = true
      next pri + 1
    end
  }
)

Battle::AbilityEffects::PriorityChange.add(:TRIAGE,
  proc { |ability, battler, move, pri|
    next pri + 3 if move.healingMove?
  }
)

#===============================================================================
# PriorityBracketChange handlers
#===============================================================================

Battle::AbilityEffects::PriorityBracketChange.add(:QUICKDRAW,
  proc { |ability, battler, battle|
    next 1 if battle.pbRandom(100) < 30
  }
)

Battle::AbilityEffects::PriorityBracketChange.add(:STALL,
  proc { |ability, battler, battle|
    next -1
  }
)

Battle::AbilityEffects::PriorityBracketChange.add(:MYCELIUMMIGHT,
  proc { |ability, battler, battle|
    next -1 if battle.choices[battler.index][2].statusMove?
  }
)

#===============================================================================
# PriorityBracketUse handlers
#===============================================================================

Battle::AbilityEffects::PriorityBracketUse.add(:QUICKDRAW,
  proc { |ability, battler, battle|
    battle.pbShowAbilitySplash(battler)
    battle.pbDisplay(_INTL("{1}使{2}行动变快了！", battler.abilityName, battler.pbThis(true)))
    battle.pbHideAbilitySplash(battler)
  }
)

#===============================================================================
# OnFlinch handlers
#===============================================================================

Battle::AbilityEffects::OnFlinch.add(:STEADFAST,
  proc { |ability, battler, battle|
    battler.pbRaiseStatStageByAbility(:SPEED, 1, battler)
  }
)

#===============================================================================
# MoveBlocking handlers
#===============================================================================

Battle::AbilityEffects::MoveBlocking.add(:DAZZLING,
  proc { |ability, bearer, user, targets, move, battle|
    next false if battle.choices[user.index][4] <= 0
    next false if !bearer.opposes?(user)
    ret = false
    targets.each { |b| ret = true if b.opposes?(user) }
    next ret
  }
)

Battle::AbilityEffects::MoveBlocking.copy(:DAZZLING, :QUEENLYMAJESTY, :ARMORTAIL)

#===============================================================================
# MoveImmunity handlers
#===============================================================================

Battle::AbilityEffects::MoveImmunity.add(:BULLETPROOF,
  proc { |ability, user, target, move, type, battle, show_message|
    next false if !move.bombMove?
    if show_message
      battle.pbShowAbilitySplash(target)
      if Battle::Scene::USE_ABILITY_SPLASH
        battle.pbDisplay(_INTL("这对{1}，好像没有效果……", target.pbThis(true)))
      else
        battle.pbDisplay(_INTL("{1}{2}使{3}无效！", target.pbOfThis, target.abilityName, move.name))
      end
      battle.pbHideAbilitySplash(target)
    end
    next true
  }
)

Battle::AbilityEffects::MoveImmunity.add(:EARTHEATER,
  proc { |ability, user, target, move, type, battle, show_message|
    next target.pbMoveImmunityHealingAbility(user, move, type, :GROUND, show_message)
  }
)

Battle::AbilityEffects::MoveImmunity.add(:FLASHFIRE,
  proc { |ability, user, target, move, type, battle, show_message|
    next false if user.index == target.index
    next false if type != :FIRE
    if show_message
      battle.pbShowAbilitySplash(target)
      if !target.effects[PBEffects::FlashFire]
        target.effects[PBEffects::FlashFire] = true
        if Battle::Scene::USE_ABILITY_SPLASH
          battle.pbDisplay(_INTL("{1}火焰威力提高了！", target.pbOfThis(true)))
        else
          battle.pbDisplay(_INTL("因为{2}，{1}的火焰威力提高了！",
                                 target.pbOfThis(true), target.abilityName))
        end
      elsif Battle::Scene::USE_ABILITY_SPLASH
        battle.pbDisplay(_INTL("这对{1}，好像没有效果……", target.pbThis(true)))
      else
        battle.pbDisplay(_INTL("{1}{2}使{3}无效！", target.pbOfThis, target.abilityName, move.name))
      end
      battle.pbHideAbilitySplash(target)
    end
    next true
  }
)

Battle::AbilityEffects::MoveImmunity.add(:GOODASGOLD,
  proc { |ability, user, target, move, type, battle, show_message|
    next false if !move.statusMove?
    if show_message
      battle.pbShowAbilitySplash(target)
      if Battle::Scene::USE_ABILITY_SPLASH
        battle.pbDisplay(_INTL("It doesn't affect {1}...", target.pbThis(true)))
      else
        battle.pbDisplay(_INTL("{1} {2} made {3} ineffective!",
                               target.pbOfThis, target.abilityName, move.name))
      end
      battle.pbHideAbilitySplash(target)
    end
    next true
  }
)

Battle::AbilityEffects::MoveImmunity.add(:LIGHTNINGROD,
  proc { |ability, user, target, move, type, battle, show_message|
    next target.pbMoveImmunityStatRaisingAbility(user, move, type,
       :ELECTRIC, :SPECIAL_ATTACK, 1, show_message)
  }
)

Battle::AbilityEffects::MoveImmunity.add(:MOTORDRIVE,
  proc { |ability, user, target, move, type, battle, show_message|
    next target.pbMoveImmunityStatRaisingAbility(user, move, type,
       :ELECTRIC, :SPEED, 1, show_message)
  }
)

Battle::AbilityEffects::MoveImmunity.add(:SAPSIPPER,
  proc { |ability, user, target, move, type, battle, show_message|
    next target.pbMoveImmunityStatRaisingAbility(user, move, type,
       :GRASS, :ATTACK, 1, show_message)
  }
)

Battle::AbilityEffects::MoveImmunity.add(:SOUNDPROOF,
  proc { |ability, user, target, move, type, battle, show_message|
    next false if !move.soundMove?
    next false if Settings::MECHANICS_GENERATION >= 8 && user.index == target.index
    if show_message
      battle.pbShowAbilitySplash(target)
      if Battle::Scene::USE_ABILITY_SPLASH
        battle.pbDisplay(_INTL("这对{1}，好像没有效果……", target.pbThis(true)))
      else
        battle.pbDisplay(_INTL("{1}{2}抵挡了{3}！", target.pbOfThis, target.abilityName, move.name))
      end
      battle.pbHideAbilitySplash(target)
    end
    next true
  }
)

Battle::AbilityEffects::MoveImmunity.add(:STORMDRAIN,
  proc { |ability, user, target, move, type, battle, show_message|
    next target.pbMoveImmunityStatRaisingAbility(user, move, type,
       :WATER, :SPECIAL_ATTACK, 1, show_message)
  }
)

Battle::AbilityEffects::MoveImmunity.add(:TELEPATHY,
  proc { |ability, user, target, move, type, battle, show_message|
    next false if move.statusMove?
    next false if user.index == target.index || target.opposes?(user)
    if show_message
      battle.pbShowAbilitySplash(target)
      if Battle::Scene::USE_ABILITY_SPLASH
        battle.pbDisplay(_INTL("{1}避免了来自我方宝可梦的攻击！", target.pbThis(true)))
      else
        battle.pbDisplay(_INTL("{1}的{2}避免了来自我方宝可梦的攻击！",
                               target.pbThis, target.abilityName))
      end
      battle.pbHideAbilitySplash(target)
    end
    next true
  }
)

Battle::AbilityEffects::MoveImmunity.add(:VOLTABSORB,
  proc { |ability, user, target, move, type, battle, show_message|
    next target.pbMoveImmunityHealingAbility(user, move, type, :ELECTRIC, show_message)
  }
)

Battle::AbilityEffects::MoveImmunity.add(:WATERABSORB,
  proc { |ability, user, target, move, type, battle, show_message|
    next target.pbMoveImmunityHealingAbility(user, move, type, :WATER, show_message)
  }
)

Battle::AbilityEffects::MoveImmunity.copy(:WATERABSORB, :DRYSKIN)

Battle::AbilityEffects::MoveImmunity.add(:WELLBAKEDBODY,
  proc { |ability, user, target, move, type, battle, show_message|
    next target.pbMoveImmunityStatRaisingAbility(user, move, type,
       :FIRE, :DEFENSE, 2, show_message)
  }
)

Battle::AbilityEffects::MoveImmunity.add(:WINDRIDER,
  proc { |ability, user, target, move, type, battle, show_message|
    next false if user.index == target.index
    next false if !move.windMove?
    if show_message
      battle.pbShowAbilitySplash(target)
      if target.pbCanRaiseStatStage?(:ATTACK, target)
        if Battle::Scene::USE_ABILITY_SPLASH
          target.pbRaiseStatStage(:ATTACK, 1, target)
        else
          target.pbRaiseStatStageByCause(:ATTACK, 1, target, target.abilityName)
        end
      elsif Battle::Scene::USE_ABILITY_SPLASH
        battle.pbDisplay(_INTL("这对{1}，好像没有效果……", target.pbThis(true)))
      else
        battle.pbDisplay(_INTL("{1}{2}使{3}无效！", target.pbOfThis, target.abilityName, move.name))
      end
      battle.pbHideAbilitySplash(target)
    end
    next true
  }
)

Battle::AbilityEffects::MoveImmunity.add(:WONDERGUARD,
  proc { |ability, user, target, move, type, battle, show_message|
    next false if move.statusMove?
    next false if !type || Effectiveness.super_effective?(target.damageState.typeMod)
    if show_message
      battle.pbShowAbilitySplash(target)
      if Battle::Scene::USE_ABILITY_SPLASH
        battle.pbDisplay(_INTL("这对{1}，好像没有效果……", target.pbThis(true)))
      else
        battle.pbDisplay(_INTL("{1}的{2}避免了伤害！", target.pbThis, target.abilityName))
      end
      battle.pbHideAbilitySplash(target)
    end
    next true
  }
)

#===============================================================================
# ModifyMoveBaseType handlers
#===============================================================================

Battle::AbilityEffects::ModifyMoveBaseType.add(:AERILATE,
  proc { |ability, user, move, type|
    next if type != :NORMAL || !GameData::Type.exists?(:FLYING)
    move.powerBoost = true
    next :FLYING
  }
)

Battle::AbilityEffects::ModifyMoveBaseType.add(:DRAGONIZE,
  proc { |ability, user, move, type|
    next if type != :NORMAL || !GameData::Type.exists?(:DRAGON)
    move.powerBoost = true
    next :DRAGON
  }
)

Battle::AbilityEffects::ModifyMoveBaseType.add(:GALVANIZE,
  proc { |ability, user, move, type|
    next if type != :NORMAL || !GameData::Type.exists?(:ELECTRIC)
    move.powerBoost = true
    next :ELECTRIC
  }
)

Battle::AbilityEffects::ModifyMoveBaseType.add(:LIQUIDVOICE,
  proc { |ability, user, move, type|
    next :WATER if GameData::Type.exists?(:WATER) && move.soundMove?
  }
)

Battle::AbilityEffects::ModifyMoveBaseType.add(:NORMALIZE,
  proc { |ability, user, move, type|
    next if !GameData::Type.exists?(:NORMAL)
    move.powerBoost = true if Settings::MECHANICS_GENERATION >= 7
    next :NORMAL
  }
)

Battle::AbilityEffects::ModifyMoveBaseType.add(:PIXILATE,
  proc { |ability, user, move, type|
    next if type != :NORMAL || !GameData::Type.exists?(:FAIRY)
    move.powerBoost = true
    next :FAIRY
  }
)

Battle::AbilityEffects::ModifyMoveBaseType.add(:REFRIGERATE,
  proc { |ability, user, move, type|
    next if type != :NORMAL || !GameData::Type.exists?(:ICE)
    move.powerBoost = true
    next :ICE
  }
)

#===============================================================================
# AccuracyCalcFromUser handlers
#===============================================================================

Battle::AbilityEffects::AccuracyCalcFromUser.add(:COMPOUNDEYES,
  proc { |ability, mods, user, target, move, type|
    mods[:accuracy_multiplier] *= 1.3
  }
)

Battle::AbilityEffects::AccuracyCalcFromUser.add(:HUSTLE,
  proc { |ability, mods, user, target, move, type|
    mods[:accuracy_multiplier] *= 0.8 if move.physicalMove?
  }
)

Battle::AbilityEffects::AccuracyCalcFromUser.add(:KEENEYE,
  proc { |ability, mods, user, target, move, type|
    mods[:evasion_stage] = 0 if mods[:evasion_stage] > 0 && Settings::MECHANICS_GENERATION >= 6
  }
)

Battle::AbilityEffects::AccuracyCalcFromUser.copy(:KEENEYE, :MINDSEYE)

if Settings::MECHANICS_GENERATION >= 9
  Battle::AbilityEffects::AccuracyCalcFromUser.copy(:KEENEYE, :ILLUMINATE)
end

Battle::AbilityEffects::AccuracyCalcFromUser.add(:NOGUARD,
  proc { |ability, mods, user, target, move, type|
    mods[:base_accuracy] = 0
  }
)

Battle::AbilityEffects::AccuracyCalcFromUser.add(:UNAWARE,
  proc { |ability, mods, user, target, move, type|
    mods[:evasion_stage] = 0 if move.damagingMove?
  }
)

Battle::AbilityEffects::AccuracyCalcFromUser.add(:VICTORYSTAR,
  proc { |ability, mods, user, target, move, type|
    mods[:accuracy_multiplier] *= 1.1
  }
)

#===============================================================================
# AccuracyCalcFromAlly handlers
#===============================================================================

Battle::AbilityEffects::AccuracyCalcFromAlly.add(:VICTORYSTAR,
  proc { |ability, mods, user, target, move, type|
    mods[:accuracy_multiplier] *= 1.1
  }
)

#===============================================================================
# AccuracyCalcFromTarget handlers
#===============================================================================

Battle::AbilityEffects::AccuracyCalcFromTarget.add(:LIGHTNINGROD,
  proc { |ability, mods, user, target, move, type|
    mods[:base_accuracy] = 0 if type == :ELECTRIC
  }
)

Battle::AbilityEffects::AccuracyCalcFromTarget.add(:NOGUARD,
  proc { |ability, mods, user, target, move, type|
    mods[:base_accuracy] = 0
  }
)

Battle::AbilityEffects::AccuracyCalcFromTarget.add(:SANDVEIL,
  proc { |ability, mods, user, target, move, type|
    mods[:evasion_multiplier] *= 1.25 if target.effectiveWeather == :Sandstorm
  }
)

Battle::AbilityEffects::AccuracyCalcFromTarget.add(:SNOWCLOAK,
  proc { |ability, mods, user, target, move, type|
    mods[:evasion_multiplier] *= 1.25 if [:Hail, :Snowstorm].include?(target.effectiveWeather)
  }
)

Battle::AbilityEffects::AccuracyCalcFromTarget.add(:STORMDRAIN,
  proc { |ability, mods, user, target, move, type|
    mods[:base_accuracy] = 0 if type == :WATER
  }
)

Battle::AbilityEffects::AccuracyCalcFromTarget.add(:TANGLEDFEET,
  proc { |ability, mods, user, target, move, type|
    mods[:accuracy_multiplier] /= 2 if target.effects[PBEffects::Confusion] > 0
  }
)

Battle::AbilityEffects::AccuracyCalcFromTarget.add(:UNAWARE,
  proc { |ability, mods, user, target, move, type|
    mods[:accuracy_stage] = 0 if move.damagingMove?
  }
)

Battle::AbilityEffects::AccuracyCalcFromTarget.add(:WONDERSKIN,
  proc { |ability, mods, user, target, move, type|
    if move.statusMove? && user.opposes?(target) && mods[:base_accuracy] > 50
      mods[:base_accuracy] = 50
    end
  }
)

#===============================================================================
# DamageCalcFromUser handlers
#===============================================================================

Battle::AbilityEffects::DamageCalcFromUser.add(:AERILATE,
  proc { |ability, user, target, move, mults, power, type|
    mults[:power_multiplier] *= 1.2 if move.powerBoost
  }
)

Battle::AbilityEffects::DamageCalcFromUser.copy(:AERILATE,
                                                :DRAGONIZE, :GALVANIZE, :NORMALIZE,
                                                :PIXILATE, :REFRIGERATE)

Battle::AbilityEffects::DamageCalcFromUser.add(:ANALYTIC,
  proc { |ability, user, target, move, mults, power, type|
    # NOTE: In the official games, if another battler faints earlier in the
    #       round but it would have moved after the user, then Analytic does not
    #       power up the move. However, this makes the determination so much
    #       more complicated (involving pbPriority and counting or not counting
    #       speed/priority modifiers depending on which Generation's mechanics
    #       are being used), so I'm choosing to ignore it. The effect is thus:
    #       "power up the move if all other battlers on the field right now have
    #       already moved".
    if move.pbMoveFailedLastInRound?(user, false)
      mults[:power_multiplier] *= 1.3
    end
  }
)

Battle::AbilityEffects::DamageCalcFromUser.add(:BLAZE,
  proc { |ability, user, target, move, mults, power, type|
    if user.hp <= user.totalhp / 3 && type == :FIRE
      mults[:attack_multiplier] *= 1.5
    end
  }
)

Battle::AbilityEffects::DamageCalcFromUser.add(:DEFEATIST,
  proc { |ability, user, target, move, mults, power, type|
    mults[:attack_multiplier] /= 2 if user.hp <= user.totalhp / 2
  }
)

Battle::AbilityEffects::DamageCalcFromUser.add(:DRAGONSMAW,
  proc { |ability, user, target, move, mults, power, type|
    mults[:attack_multiplier] *= 1.5 if type == :DRAGON
  }
)

Battle::AbilityEffects::DamageCalcFromUser.add(:FIREMANE,
  proc { |ability, user, target, move, mults, power, type|
    mults[:attack_multiplier] *= 1.5 if type == :FIRE
  }
)

Battle::AbilityEffects::DamageCalcFromUser.add(:FLAREBOOST,
  proc { |ability, user, target, move, mults, power, type|
    mults[:power_multiplier] *= 1.5 if user.burned? && move.specialMove?
  }
)

Battle::AbilityEffects::DamageCalcFromUser.add(:FLASHFIRE,
  proc { |ability, user, target, move, mults, power, type|
    if user.effects[PBEffects::FlashFire] && type == :FIRE
      mults[:attack_multiplier] *= 1.5
    end
  }
)

Battle::AbilityEffects::DamageCalcFromUser.add(:FLOWERGIFT,
  proc { |ability, user, target, move, mults, power, type|
    if move.physicalMove? && [:Sun, :HarshSun].include?(user.effectiveWeather)
      mults[:attack_multiplier] *= 1.5
    end
  }
)

Battle::AbilityEffects::DamageCalcFromUser.add(:GORILLATACTICS,
  proc { |ability, user, target, move, mults, power, type|
    mults[:attack_multiplier] *= 1.5 if move.physicalMove?
  }
)

Battle::AbilityEffects::DamageCalcFromUser.add(:GUTS,
  proc { |ability, user, target, move, mults, power, type|
    if user.pbHasAnyStatus? && move.physicalMove?
      mults[:attack_multiplier] *= 1.5
    end
  }
)

Battle::AbilityEffects::DamageCalcFromUser.add(:HADRONENGINE,
  proc { |ability, user, target, move, mults, power, type|
    if move.specialMove? && user.battle.field.terrain == :Electric
      mults[:attack_multiplier] *= 4 / 3.0
    end
  }
)

Battle::AbilityEffects::DamageCalcFromUser.add(:HUGEPOWER,
  proc { |ability, user, target, move, mults, power, type|
    mults[:attack_multiplier] *= 2 if move.physicalMove?
  }
)

Battle::AbilityEffects::DamageCalcFromUser.copy(:HUGEPOWER, :PUREPOWER)

Battle::AbilityEffects::DamageCalcFromUser.add(:HUSTLE,
  proc { |ability, user, target, move, mults, power, type|
    mults[:attack_multiplier] *= 1.5 if move.physicalMove?
  }
)

Battle::AbilityEffects::DamageCalcFromUser.add(:IRONFIST,
  proc { |ability, user, target, move, mults, power, type|
    mults[:power_multiplier] *= 1.2 if move.punchingMove?
  }
)

Battle::AbilityEffects::DamageCalcFromUser.add(:MEGALAUNCHER,
  proc { |ability, user, target, move, mults, power, type|
    mults[:power_multiplier] *= 1.5 if move.pulseMove?
  }
)

Battle::AbilityEffects::DamageCalcFromUser.add(:MINUS,
  proc { |ability, user, target, move, mults, power, type|
    next if !move.specialMove?
    if user.allAllies.any? { |b| b.hasActiveAbility?([:MINUS, :PLUS]) }
      mults[:attack_multiplier] *= 1.5
    end
  }
)

Battle::AbilityEffects::DamageCalcFromUser.copy(:MINUS, :PLUS)

Battle::AbilityEffects::DamageCalcFromUser.add(:NEUROFORCE,
  proc { |ability, user, target, move, mults, power, type|
    if Effectiveness.super_effective?(target.damageState.typeMod)
      mults[:final_damage_multiplier] *= 1.25
    end
  }
)

Battle::AbilityEffects::DamageCalcFromUser.add(:ORICHALCUMPULSE,
  proc { |ability, user, target, move, mults, power, type|
    # NOTE: Utility Umbrella prevents this boost even though the official games
    #       may show messages to the contrary.
    if move.physicalMove? && [:Sun, :HarshSun].include?(user.effectiveWeather)
      mults[:attack_multiplier] *= 4 / 3.0
    end
  }
)

Battle::AbilityEffects::DamageCalcFromUser.add(:OVERGROW,
  proc { |ability, user, target, move, mults, power, type|
    if user.hp <= user.totalhp / 3 && type == :GRASS
      mults[:attack_multiplier] *= 1.5
    end
  }
)

Battle::AbilityEffects::DamageCalcFromUser.add(:PROTOSYNTHESIS,
  proc { |ability, user, target, move, mults, power, type|
    next if user.effects[PBEffects::Transform]
    next if !user.effects[PBEffects::ProtosynthesisStat]
    stat = user.effects[PBEffects::ProtosynthesisStat]
    case stat
    when :ATTACK
      if move.physicalMove? || move.function_code == "UseTargetDefenseInsteadOfTargetSpDef"   # Psyshock
        mults[:attack_multiplier] *= 1.3
      end
    when :SPECIAL_ATTACK
      if move.specialMove? && move.function_code != "UseTargetDefenseInsteadOfTargetSpDef"   # Psyshock
        mults[:attack_multiplier] *= 1.3
      end
    end
  }
)

Battle::AbilityEffects::DamageCalcFromUser.copy(:PROTOSYNTHESIS, :QUARKDRIVE)

Battle::AbilityEffects::DamageCalcFromUser.add(:PUNKROCK,
  proc { |ability, user, target, move, mults, power, type|
    mults[:attack_multiplier] *= 1.3 if move.soundMove?
  }
)

Battle::AbilityEffects::DamageCalcFromUser.add(:RECKLESS,
  proc { |ability, user, target, move, mults, power, type|
    mults[:power_multiplier] *= 1.2 if move.recoilMove?
  }
)

Battle::AbilityEffects::DamageCalcFromUser.add(:RIVALRY,
  proc { |ability, user, target, move, mults, power, type|
    if user.gender != 2 && target.gender != 2
      if user.gender == target.gender
        mults[:power_multiplier] *= 1.25
      else
        mults[:power_multiplier] *= 0.75
      end
    end
  }
)

Battle::AbilityEffects::DamageCalcFromUser.add(:ROCKYPAYLOAD,
  proc { |ability, user, target, move, mults, power, type|
    mults[:attack_multiplier] *= 1.5 if type == :ROCK
  }
)

Battle::AbilityEffects::DamageCalcFromUser.add(:SANDFORCE,
  proc { |ability, user, target, move, mults, power, type|
    if user.effectiveWeather == :Sandstorm &&
       [:ROCK, :GROUND, :STEEL].include?(type)
      mults[:power_multiplier] *= 1.3
    end
  }
)

Battle::AbilityEffects::DamageCalcFromUser.add(:SHARPNESS,
  proc { |ability, user, target, move, mults, power, type|
    mults[:power_multiplier] *= 1.5 if move.slicingMove?
  }
)

Battle::AbilityEffects::DamageCalcFromUser.add(:SHEERFORCE,
  proc { |ability, user, target, move, mults, power, type|
    mults[:power_multiplier] *= 1.3 if move.addlEffect > 0
  }
)

Battle::AbilityEffects::DamageCalcFromUser.add(:SLOWSTART,
  proc { |ability, user, target, move, mults, power, type|
    mults[:attack_multiplier] /= 2 if user.effects[PBEffects::SlowStart] > 0 && move.physicalMove?
  }
)

Battle::AbilityEffects::DamageCalcFromUser.add(:SNIPER,
  proc { |ability, user, target, move, mults, power, type|
    mults[:final_damage_multiplier] *= 1.5 if target.damageState.critical
  }
)

Battle::AbilityEffects::DamageCalcFromUser.add(:SOLARPOWER,
  proc { |ability, user, target, move, mults, power, type|
    if move.specialMove? && [:Sun, :HarshSun].include?(user.effectiveWeather)
      mults[:attack_multiplier] *= 1.5
    end
  }
)

Battle::AbilityEffects::DamageCalcFromUser.add(:STAKEOUT,
  proc { |ability, user, target, move, mults, power, type|
    mults[:attack_multiplier] *= 2 if target.battle.choices[target.index][0] == :SwitchOut
  }
)

Battle::AbilityEffects::DamageCalcFromUser.add(:STEELWORKER,
  proc { |ability, user, target, move, mults, power, type|
    mults[:attack_multiplier] *= 1.5 if type == :STEEL
  }
)

Battle::AbilityEffects::DamageCalcFromUser.add(:STEELYSPIRIT,
  proc { |ability, user, target, move, mults, power, type|
    mults[:final_damage_multiplier] *= 1.5 if type == :STEEL
  }
)

Battle::AbilityEffects::DamageCalcFromUser.add(:STRONGJAW,
  proc { |ability, user, target, move, mults, power, type|
    mults[:power_multiplier] *= 1.5 if move.bitingMove?
  }
)

Battle::AbilityEffects::DamageCalcFromUser.add(:SUPREMEOVERLORD,
  proc { |ability, user, target, move, mults, power, type|
    mults[:power_multiplier] *= 1.0 + (0.1 * [user.effects[PBEffects::SupremeOverlord], 5].min)
  }
)

Battle::AbilityEffects::DamageCalcFromUser.add(:SWARM,
  proc { |ability, user, target, move, mults, power, type|
    if user.hp <= user.totalhp / 3 && type == :BUG
      mults[:attack_multiplier] *= 1.5
    end
  }
)

Battle::AbilityEffects::DamageCalcFromUser.add(:TECHNICIAN,
  proc { |ability, user, target, move, mults, power, type|
    if user.index != target.index && move && move.function_code != "Struggle" &&
       power * mults[:power_multiplier] <= 60
      mults[:power_multiplier] *= 1.5
    end
  }
)

Battle::AbilityEffects::DamageCalcFromUser.add(:TINTEDLENS,
  proc { |ability, user, target, move, mults, power, type|
    mults[:final_damage_multiplier] *= 2 if Effectiveness.resistant?(target.damageState.typeMod)
  }
)

Battle::AbilityEffects::DamageCalcFromUser.add(:TORRENT,
  proc { |ability, user, target, move, mults, power, type|
    if user.hp <= user.totalhp / 3 && type == :WATER
      mults[:attack_multiplier] *= 1.5
    end
  }
)

Battle::AbilityEffects::DamageCalcFromUser.add(:TOUGHCLAWS,
  proc { |ability, user, target, move, mults, power, type|
    mults[:power_multiplier] *= 1.3 if move.pbContactMove?(user)
  }
)

Battle::AbilityEffects::DamageCalcFromUser.add(:TOXICBOOST,
  proc { |ability, user, target, move, mults, power, type|
    if user.poisoned? && move.physicalMove?
      mults[:power_multiplier] *= 1.5
    end
  }
)

Battle::AbilityEffects::DamageCalcFromUser.add(:TRANSISTOR,
  proc { |ability, user, target, move, mults, power, type|
    mults[:attack_multiplier] *= 1.5 if type == :ELECTRIC
  }
)

Battle::AbilityEffects::DamageCalcFromUser.add(:WATERBUBBLE,
  proc { |ability, user, target, move, mults, power, type|
    mults[:attack_multiplier] *= 2 if type == :WATER
  }
)

#===============================================================================
# DamageCalcFromAlly handlers
#===============================================================================

Battle::AbilityEffects::DamageCalcFromAlly.add(:BATTERY,
  proc { |ability, user, target, move, mults, power, type|
    next if !move.specialMove?
    mults[:final_damage_multiplier] *= 1.3
  }
)

Battle::AbilityEffects::DamageCalcFromAlly.add(:FLOWERGIFT,
  proc { |ability, user, target, move, mults, power, type|
    if move.physicalMove? && [:Sun, :HarshSun].include?(user.effectiveWeather)
      mults[:attack_multiplier] *= 1.5
    end
  }
)

Battle::AbilityEffects::DamageCalcFromAlly.add(:POWERSPOT,
  proc { |ability, user, target, move, mults, power, type|
    mults[:final_damage_multiplier] *= 1.3
  }
)

Battle::AbilityEffects::DamageCalcFromAlly.add(:STEELYSPIRIT,
  proc { |ability, user, target, move, mults, power, type|
    mults[:final_damage_multiplier] *= 1.5 if type == :STEEL
  }
)

#===============================================================================
# DamageCalcFromTarget handlers
#===============================================================================

Battle::AbilityEffects::DamageCalcFromTarget.add(:DRYSKIN,
  proc { |ability, user, target, move, mults, power, type|
    mults[:power_multiplier] *= 1.25 if type == :FIRE
  }
)

Battle::AbilityEffects::DamageCalcFromTarget.add(:FILTER,
  proc { |ability, user, target, move, mults, power, type|
    if Effectiveness.super_effective?(target.damageState.typeMod)
      mults[:final_damage_multiplier] *= 0.75
    end
  }
)

Battle::AbilityEffects::DamageCalcFromTarget.copy(:FILTER, :SOLIDROCK)

Battle::AbilityEffects::DamageCalcFromTarget.add(:FLOWERGIFT,
  proc { |ability, user, target, move, mults, power, type|
    if move.specialMove? && move.function_code != "UseTargetDefenseInsteadOfTargetSpDef" &&  # Psyshock
       [:Sun, :HarshSun].include?(target.effectiveWeather)
      mults[:defense_multiplier] *= 1.5
    end
  }
)

Battle::AbilityEffects::DamageCalcFromTarget.add(:FLUFFY,
  proc { |ability, user, target, move, mults, power, type|
    mults[:final_damage_multiplier] *= 2 if move.calcType == :FIRE
    mults[:final_damage_multiplier] /= 2 if move.pbContactMove?(user)
  }
)

Battle::AbilityEffects::DamageCalcFromTarget.add(:FURCOAT,
  proc { |ability, user, target, move, mults, power, type|
    if move.physicalMove? || move.function_code == "UseTargetDefenseInsteadOfTargetSpDef"   # Psyshock
      mults[:defense_multiplier] *= 2
    end
  }
)

Battle::AbilityEffects::DamageCalcFromTarget.add(:GRASSPELT,
  proc { |ability, user, target, move, mults, power, type|
    if (move.physicalMove? || move.function_code == "UseTargetDefenseInsteadOfTargetSpDef") &&   # Psyshock
       user.battle.field.terrain == :Grassy
      mults[:defense_multiplier] *= 1.5
    end
  }
)

Battle::AbilityEffects::DamageCalcFromTarget.add(:HEATPROOF,
  proc { |ability, user, target, move, mults, power, type|
    mults[:power_multiplier] /= 2 if type == :FIRE
  }
)

Battle::AbilityEffects::DamageCalcFromTarget.add(:ICESCALES,
  proc { |ability, user, target, move, mults, power, type|
    mults[:final_damage_multiplier] /= 2 if move.specialMove?
  }
)

Battle::AbilityEffects::DamageCalcFromTarget.add(:MARVELSCALE,
  proc { |ability, user, target, move, mults, power, type|
    if target.pbHasAnyStatus? &&
       (move.physicalMove? || move.function_code == "UseTargetDefenseInsteadOfTargetSpDef")   # Psyshock
      mults[:defense_multiplier] *= 1.5
    end
  }
)

Battle::AbilityEffects::DamageCalcFromTarget.add(:MULTISCALE,
  proc { |ability, user, target, move, mults, power, type|
    mults[:final_damage_multiplier] /= 2 if target.hp == target.totalhp
  }
)

Battle::AbilityEffects::DamageCalcFromTarget.add(:PUNKROCK,
  proc { |ability, user, target, move, mults, power, type|
    mults[:final_damage_multiplier] /= 2 if move.soundMove?
  }
)

Battle::AbilityEffects::DamageCalcFromTarget.add(:PURIFYINGSALT,
  proc { |ability, user, target, move, mults, power, type|
    mults[:attack_multiplier] /= 2 if move.calcType == :GHOST
  }
)

Battle::AbilityEffects::DamageCalcFromTarget.add(:THICKFAT,
  proc { |ability, user, target, move, mults, power, type|
    mults[:power_multiplier] /= 2 if [:FIRE, :ICE].include?(type)
  }
)

Battle::AbilityEffects::DamageCalcFromTarget.add(:WATERBUBBLE,
  proc { |ability, user, target, move, mults, power, type|
    mults[:final_damage_multiplier] /= 2 if type == :FIRE
  }
)

#===============================================================================
# DamageCalcFromTargetNonIgnorable handlers
#===============================================================================

Battle::AbilityEffects::DamageCalcFromTargetNonIgnorable.add(:PRISMARMOR,
  proc { |ability, user, target, move, mults, power, type|
    if Effectiveness.super_effective?(target.damageState.typeMod)
      mults[:final_damage_multiplier] *= 0.75
    end
  }
)

Battle::AbilityEffects::DamageCalcFromTargetNonIgnorable.add(:PROTOSYNTHESIS,
  proc { |ability, user, target, move, mults, power, type|
    next if target.effects[PBEffects::Transform]
    next if !target.effects[PBEffects::ProtosynthesisStat]
    stat = target.effects[PBEffects::ProtosynthesisStat]
    case stat
    when :DEFENSE
      if move.physicalMove? || move.function_code == "UseTargetDefenseInsteadOfTargetSpDef"   # Psyshock
        mults[:defense_multiplier] *= 1.3
      end
    when :SPECIAL_DEFENSE
      if move.specialMove? && move.function_code != "UseTargetDefenseInsteadOfTargetSpDef"   # Psyshock
        mults[:defense_multiplier] *= 1.3
      end
    end
  }
)

Battle::AbilityEffects::DamageCalcFromTargetNonIgnorable.copy(:PROTOSYNTHESIS, :QUARKDRIVE)

Battle::AbilityEffects::DamageCalcFromTargetNonIgnorable.add(:SHADOWSHIELD,
  proc { |ability, user, target, move, mults, power, type|
    mults[:final_damage_multiplier] /= 2 if target.hp == target.totalhp
  }
)

#===============================================================================
# DamageCalcFromTargetAlly handlers
#===============================================================================

Battle::AbilityEffects::DamageCalcFromTargetAlly.add(:FLOWERGIFT,
  proc { |ability, user, target, move, mults, power, type|
    if move.specialMove? && move.function_code != "UseTargetDefenseInsteadOfTargetSpDef" &&   # Psyshock
       [:Sun, :HarshSun].include?(target.effectiveWeather)
      mults[:defense_multiplier] *= 1.5
    end
  }
)

Battle::AbilityEffects::DamageCalcFromTargetAlly.add(:FRIENDGUARD,
  proc { |ability, user, target, move, mults, power, type|
    mults[:final_damage_multiplier] *= 0.75
  }
)

#===============================================================================
# CriticalCalcFromUser handlers
#===============================================================================

Battle::AbilityEffects::CriticalCalcFromUser.add(:MERCILESS,
  proc { |ability, user, target, move, c|
    next 99 if target.poisoned?
  }
)

Battle::AbilityEffects::CriticalCalcFromUser.add(:SUPERLUCK,
  proc { |ability, user, target, move, c|
    next c + 1
  }
)

#===============================================================================
# CriticalCalcFromTarget handlers
#===============================================================================

Battle::AbilityEffects::CriticalCalcFromTarget.add(:BATTLEARMOR,
  proc { |ability, user, target, move, c|
    next -1
  }
)

Battle::AbilityEffects::CriticalCalcFromTarget.copy(:BATTLEARMOR, :SHELLARMOR)

#===============================================================================
# OnTargetedForHit handlers
#===============================================================================
Battle::AbilityEffects::OnTargetedForHit.add(:TERASHELL,
  proc { |ability, user, target, move, hit_num, battle|
    next if !target.isSpecies?(:TERAPAGOS) || target.form != 1 || target.hp < target.totalhp
    next if hit_num != 0 || target.beingMoldBroken?
    next if !move.pbDamagingMove? || move.is_a?(Battle::Move::FixedDamageMove)
    next if Effectiveness.not_very_effective?(target.damageState.typeMod) ||
            Effectiveness.ineffective?(target.damageState.typeMod)
    target.damageState.typeMod = Effectiveness::NOT_VERY_EFFECTIVE_MULTIPLIER
    battle.pbDisplay(_INTL("{1}让甲壳发出光辉，使属性相克发生扭曲！！", target.pbThis))
  }
)

#===============================================================================
# OnBeingHit handlers
#===============================================================================

Battle::AbilityEffects::OnBeingHit.add(:AFTERMATH,
  proc { |ability, user, target, move, battle|
    next if !target.fainted?
    next if !move.pbContactMove?(user)
    next if !user.takesIndirectDamage? || !user.affectedByContactEffect?
    next if battle.pbCheckGlobalAbility(:DAMP, true)
    battle.pbShowAbilitySplash(target)
    battle.scene.pbDamageAnimation(user)
    user.pbReduceHP(user.totalhp / 4, false)
    battle.pbDisplay(_INTL("{1}被引爆伤害了！", user.pbThis))
    battle.pbHideAbilitySplash(target)
  }
)

Battle::AbilityEffects::OnBeingHit.add(:ANGERPOINT,
  proc { |ability, user, target, move, battle|
    next if !target.damageState.critical
    next if !target.pbCanRaiseStatStage?(:ATTACK, target)
    battle.pbShowAbilitySplash(target)
    target.stagesChangeRecord[0][:ATTACK] ||= 0
    target.stagesChangeRecord[0][:ATTACK] += Battle::Battler::STAT_STAGE_MAXIMUM - target.stages[:ATTACK]
    target.statsRaisedThisRound = true
    target.stages[:ATTACK] = Battle::Battler::STAT_STAGE_MAXIMUM
    battle.pbCommonAnimation("StatUp", target)
    if Battle::Scene::USE_ABILITY_SPLASH
      battle.pbDisplay(_INTL("{1}的{2}被提高到了最大！", target.pbThis, GameData::Stat.get(:ATTACK).name))
    else
      battle.pbDisplay(_INTL("{1}的{2}使{3}被提高到了最大！",
                             target.pbThis, target.abilityName, GameData::Stat.get(:ATTACK).name))
    end
    battle.pbHideAbilitySplash(target)
  }
)

Battle::AbilityEffects::OnBeingHit.add(:COTTONDOWN,
  proc { |ability, user, target, move, battle|
    next if battle.allBattlers.none? { |b| b.index != target.index && b.pbCanLowerStatStage?(:SPEED, target) }
    battle.pbShowAbilitySplash(target)
    battle.allBattlers.each do |b|
      b.pbLowerStatStageByAbility(:SPEED, 1, target, false) if b.index != target.index
    end
    battle.pbHideAbilitySplash(target)
  }
)

Battle::AbilityEffects::OnBeingHit.add(:CURSEDBODY,
  proc { |ability, user, target, move, battle|
    next if user.fainted?
    next if user.effects[PBEffects::Disable] > 0
    regularMove = nil
    user.eachMove do |m|
      next if m.id != user.lastRegularMoveUsed
      regularMove = m
      break
    end
    next if !regularMove || (regularMove.pp == 0 && regularMove.total_pp > 0)
    next if move.pbMoveFailedAromaVeil?(target, user, false)
    next if battle.pbRandom(100) >= 30
    battle.pbShowAbilitySplash(target)
    user.effects[PBEffects::Disable]     = 3
    user.effects[PBEffects::DisableMove] = regularMove.id
    if Battle::Scene::USE_ABILITY_SPLASH
      battle.pbDisplay(_INTL("封住了{1}{2}！", user.pbOfThis, regularMove.name))
    else
      battle.pbDisplay(_INTL("{3}{4}封住了{1}{2}！",
                             user.pbOfThis, regularMove.name, target.pbOfThis(true), target.abilityName))
    end
    battle.pbHideAbilitySplash(target)
    user.pbItemStatusCureCheck
  }
)

Battle::AbilityEffects::OnBeingHit.add(:CUTECHARM,
  proc { |ability, user, target, move, battle|
    next if target.fainted?
    next if !move.pbContactMove?(user) || !user.affectedByContactEffect?
    next if !user.pbCanAttract?(target, false)
    next if battle.pbRandom(100) >= 30
    battle.pbShowAbilitySplash(target)
    msg = nil
    if !Battle::Scene::USE_ABILITY_SPLASH
      msg = _INTL("{1}{2}让{3}着迷了！",
                  target.pbOfThis, target.abilityName, user.pbThis(true))
    end
    user.pbAttract(target, msg)
    battle.pbHideAbilitySplash(target)
  }
)

# NOTE: This ability has a 30% chance of triggering, not a 30% chance of
#       inflicting a status condition. It can try (and fail) to inflict a status
#       condition that the user is immune to.
Battle::AbilityEffects::OnBeingHit.add(:EFFECTSPORE,
  proc { |ability, user, target, move, battle|
    next if !move.pbContactMove?(user) || !user.affectedByContactEffect?
    next if !user.affectedByPowder?
    next if battle.pbRandom(100) >= 30
    r = battle.pbRandom(3)
    next if r == 0 && (user.asleep? || !user.pbCanSleep?(target, false))
    next if r == 1 && (user.poisoned? || !user.pbCanPoison?(target, false))
    next if r == 2 && (user.paralyzed? || !user.pbCanParalyze?(target, false))
    battle.pbShowAbilitySplash(target)
    msg = nil
    case r
    when 0
      if !Battle::Scene::USE_ABILITY_SPLASH
        msg = _INTL("{1}{2}让{3}睡着了！",
                    target.pbOfThis, target.abilityName, user.pbThis(true))
      end
      user.pbSleep(target, msg)
    when 1
      if !Battle::Scene::USE_ABILITY_SPLASH
        msg = _INTL("{1}{2}让{3}中毒了！",
                    target.pbOfThis, target.abilityName, user.pbThis(true))
      end
      user.pbPoison(target, msg)
    when 2
      if !Battle::Scene::USE_ABILITY_SPLASH
        msg = _INTL("{1}{2}使{3}麻痹了！它可能无法行动！",
                    target.pbOfThis, target.abilityName, user.pbThis(true))
      end
      user.pbParalyze(target, msg)
    end
    battle.pbHideAbilitySplash(target)
  }
)

Battle::AbilityEffects::OnBeingHit.add(:ELECTROMORPHOSIS,
  proc { |ability, user, target, move, battle|
    next if target.effects[PBEffects::Charge] > 0
    battle.pbShowAbilitySplash(target)
    target.effects[PBEffects::Charge] = 2
    battle.pbDisplay(_INTL("{2}受到{1}而充电了！", move.name, target.pbThis(true)))
    battle.pbHideAbilitySplash(target)
  }
)

Battle::AbilityEffects::OnBeingHit.add(:FLAMEBODY,
  proc { |ability, user, target, move, battle|
    next if !move.pbContactMove?(user) || !user.affectedByContactEffect?
    next if user.burned? || !user.pbCanBurn?(target, false)
    next if battle.pbRandom(100) >= 30
    battle.pbShowAbilitySplash(target)
    msg = nil
    if !Battle::Scene::USE_ABILITY_SPLASH
      msg = _INTL("{1}{2}让{3}灼伤了！", target.pbOfThis, target.abilityName, user.pbThis(true))
    end
    user.pbBurn(target, msg)
    battle.pbHideAbilitySplash(target)
  }
)

Battle::AbilityEffects::OnBeingHit.add(:GOOEY,
  proc { |ability, user, target, move, battle|
    next if !move.pbContactMove?(user)
    user.pbLowerStatStageByAbility(:SPEED, 1, target, true, true)
  }
)

Battle::AbilityEffects::OnBeingHit.copy(:GOOEY, :TANGLINGHAIR)

Battle::AbilityEffects::OnBeingHit.add(:ILLUSION,
  proc { |ability, user, target, move, battle|
    # NOTE: This intentionally doesn't show the ability splash.
    next if !target.effects[PBEffects::Illusion]
    target.effects[PBEffects::Illusion] = nil
    battle.scene.pbChangePokemon(target, target.pokemon)
    battle.pbDisplay(_INTL("{1}造成的幻觉被解除了！", target.pbOfThis))
    battle.pbSetSeen(target)
  }
)

Battle::AbilityEffects::OnBeingHit.add(:INNARDSOUT,
  proc { |ability, user, target, move, battle|
    next if !target.fainted? || user.dummy
    next if !user.takesIndirectDamage?
    battle.pbShowAbilitySplash(target)
    battle.scene.pbDamageAnimation(user)
    user.pbReduceHP(target.damageState.hpLost, false)
    if Battle::Scene::USE_ABILITY_SPLASH
      battle.pbDisplay(_INTL("{1}受伤了！", user.pbThis))
    else
      battle.pbDisplay(_INTL("{1}受到了{2}{3}伤害！",
                             user.pbThis, target.pbOfThis(true), target.abilityName))
    end
    battle.pbHideAbilitySplash(target)
  }
)

Battle::AbilityEffects::OnBeingHit.add(:IRONBARBS,
  proc { |ability, user, target, move, battle|
    next if !move.pbContactMove?(user) || !user.affectedByContactEffect?
    next if !user.takesIndirectDamage?
    battle.pbShowAbilitySplash(target)
    battle.scene.pbDamageAnimation(user)
    user.pbReduceHP(user.totalhp / 8, false)
    if Battle::Scene::USE_ABILITY_SPLASH
      battle.pbDisplay(_INTL("{1}受伤了！", user.pbThis))
    else
      battle.pbDisplay(_INTL("{1}受到了{2}{3}伤害！",
                             user.pbThis, target.pbOfThis(true), target.abilityName))
    end
    battle.pbHideAbilitySplash(target)
  }
)

Battle::AbilityEffects::OnBeingHit.copy(:IRONBARBS, :ROUGHSKIN)

Battle::AbilityEffects::OnBeingHit.add(:JUSTIFIED,
  proc { |ability, user, target, move, battle|
    next if move.calcType != :DARK
    target.pbRaiseStatStageByAbility(:ATTACK, 1, target)
  }
)

Battle::AbilityEffects::OnBeingHit.add(:MUMMY,
  proc { |ability, user, target, move, battle|
    next if user.fainted?
    next if !move.pbContactMove?(user) || !user.affectedByContactEffect?
    next if user.unlosableAbility? || [:LINGERINGAROMA, :MUMMY].include?(user.ability_id)
    next if user.ability == ability
    battle.pbShowAbilitySplash(target)
    battle.pbShowAbilitySplash(user, true, false) if user.opposes?(target)
    old_ability = user.ability
    user.ability = ability
    battle.pbReplaceAbilitySplash(user) if user.opposes?(target)
    if Battle::Scene::USE_ABILITY_SPLASH
      battle.pbDisplay(_INTL("{1}的特性变成了{2}！", user.pbOfThis, user.abilityName))
    else
      battle.pbDisplay(_INTL("由于{3}，{1}的特性变成了{2}！",
                             user.pbOfThis, user.abilityName, target.pbThis(true)))
    end
    battle.pbHideAbilitySplash(user) if user.opposes?(target)
    battle.pbHideAbilitySplash(target)
    user.pbOnLosingAbility(old_ability)
    user.pbTriggerAbilityOnGainingIt
  }
)

Battle::AbilityEffects::OnBeingHit.copy(:MUMMY, :LINGERINGAROMA)

Battle::AbilityEffects::OnBeingHit.add(:PERISHBODY,
  proc { |ability, user, target, move, battle|
    next if user.fainted?
    next if !move.pbContactMove?(user) || !user.affectedByContactEffect?
    next if user.effects[PBEffects::PerishSong] > 0 || target.effects[PBEffects::PerishSong] > 0
    battle.pbShowAbilitySplash(target)
    [user, target].each do |battler|
      battler.effects[PBEffects::PerishSong]     = 4
      battler.effects[PBEffects::PerishSongUser] = target.index
    end
    if Battle::Scene::USE_ABILITY_SPLASH
      battle.pbDisplay(_INTL("双方将在3回合后灭亡！"))
    else
      battle.pbDisplay(_INTL("由于{1}的{2}，双方将在3回合后灭亡！",
                             target.pbOfThis(true), target.abilityName))
    end
    battle.pbHideAbilitySplash(target)
  }
)

Battle::AbilityEffects::OnBeingHit.add(:POISONPOINT,
  proc { |ability, user, target, move, battle|
    next if !move.pbContactMove?(user) || !user.affectedByContactEffect?
    next if user.poisoned? || !user.pbCanPoison?(target, false)
    next if battle.pbRandom(100) >= 30
    battle.pbShowAbilitySplash(target)
    msg = nil
    if !Battle::Scene::USE_ABILITY_SPLASH
      msg = _INTL("{1}{2}让{3}中毒了！", target.pbOfThis, target.abilityName, user.pbThis(true))
    end
    user.pbPoison(target, msg)
    battle.pbHideAbilitySplash(target)
  }
)

Battle::AbilityEffects::OnBeingHit.add(:RATTLED,
  proc { |ability, user, target, move, battle|
    next if ![:BUG, :DARK, :GHOST].include?(move.calcType)
    target.pbRaiseStatStageByAbility(:SPEED, 1, target)
  }
)

Battle::AbilityEffects::OnBeingHit.add(:SANDSPIT,
  proc { |ability, user, target, move, battle|
    battle.pbStartWeatherAbility(:Sandstorm, target)
  }
)

Battle::AbilityEffects::OnBeingHit.add(:STAMINA,
  proc { |ability, user, target, move, battle|
    target.pbRaiseStatStageByAbility(:DEFENSE, 1, target)
  }
)

Battle::AbilityEffects::OnBeingHit.add(:SEEDSOWER,
  proc { |ability, user, target, move, battle|
    battle.pbStartTerrainAbility(:Grassy, target)
  }
)

Battle::AbilityEffects::OnBeingHit.add(:SPICYSPRAY,
  proc { |ability, user, target, move, battle|
    next if user.burned? || !user.pbCanBurn?(target, false)
    battle.pbShowAbilitySplash(target)
    msg = nil
    if !Battle::Scene::USE_ABILITY_SPLASH
      msg = _INTL("{1}{2}让{3}灼伤了！", target.pbOfThis, target.abilityName, user.pbThis(true))
    end
    user.pbBurn(target, msg)
    battle.pbHideAbilitySplash(target)
  }
)

Battle::AbilityEffects::OnBeingHit.add(:STATIC,
  proc { |ability, user, target, move, battle|
    next if !move.pbContactMove?(user) || !user.affectedByContactEffect?
    next if user.paralyzed? || !user.pbCanParalyze?(target, false)
    next if battle.pbRandom(100) >= 30
    battle.pbShowAbilitySplash(target)
    msg = nil
    if !Battle::Scene::USE_ABILITY_SPLASH
      msg = _INTL("{1}{2}让{3}麻痹了！很难使出招式！",
                  target.pbOfThis, target.abilityName, user.pbThis(true))
    end
    user.pbParalyze(target, msg)
    battle.pbHideAbilitySplash(target)
  }
)

Battle::AbilityEffects::OnBeingHit.add(:THERMALEXCHANGE,
  proc { |ability, user, target, move, battle|
    next if move.calcType != :FIRE
    target.pbRaiseStatStageByAbility(:ATTACK, 1, target)
  }
)

Battle::AbilityEffects::OnBeingHit.add(:TOXICDEBRIS,
  proc { |ability, user, target, move, battle|
    next if !move.physicalMove?
    next if target.pbOpposingSide.effects[PBEffects::ToxicSpikes] >= 2
    battle.pbShowAbilitySplash(target)
    target.pbOpposingSide.effects[PBEffects::ToxicSpikes] += 1
    if Battle::Scene::USE_ABILITY_SPLASH
      battle.pbDisplay(_INTL("{1}脚下散落着毒菱！",
                             target.pbOfOpposingTeam(true)))
    else
      battle.pbDisplay(_INTL("{1}{2}在{3}脚下散落毒菱！",
                             target.pbOfThis, target.abilityName, target.pbOfOpposingTeam(true)))
    end
    battle.pbHideAbilitySplash(target)
  }
)

Battle::AbilityEffects::OnBeingHit.add(:WANDERINGSPIRIT,
  proc { |ability, user, target, move, battle|
    next if !move.pbContactMove?(user) || !user.affectedByContactEffect?
    next if user.unlosableAbility? || target.ungainableAbility?(user.ability_id)
    # NOTE: target has Wandering Spirit which can be swapped, so no need to
    #       check that.
    oldUserAbil   = nil
    oldTargetAbil = nil
    battle.pbShowAbilitySplash(target, !user.opposes?(target))
    battle.pbShowAbilitySplash(user, true, false) if user.opposes?(target)
    oldUserAbil   = user.ability
    oldTargetAbil = target.ability
    user.ability   = oldTargetAbil
    target.ability = oldUserAbil
    battle.pbReplaceAbilitySplash(target)
    battle.pbReplaceAbilitySplash(user) if user.opposes?(target)
    if Battle::Scene::USE_ABILITY_SPLASH
      battle.pbDisplay(_INTL("{1}与{2}互换了各自的特性！", target.pbThis, user.pbThis(true)))
    else
      battle.pbDisplay(_INTL("{1}的{2}与{3}{4}特性互换了！",
                             target.pbThis, user.abilityName, user.pbOfThis(true), target.abilityName))
    end
    battle.pbHideAbilitySplash(target)
    if user.opposes?(target)
      battle.pbHideAbilitySplash(user)
    elsif Battle::Scene::USE_ABILITY_SPLASH
      newUserAbil = user.ability
      user.ability = oldUserAbil
      battle.pbShowAbilitySplash(user, true, false)
      user.ability = newUserAbil
      battle.pbReplaceAbilitySplash(user)
      battle.pbHideAbilitySplash(user)
    end
    user.pbOnLosingAbility(oldUserAbil)
    target.pbOnLosingAbility(oldTargetAbil)
    user.pbTriggerAbilityOnGainingIt
    target.pbTriggerAbilityOnGainingIt
  }
)

Battle::AbilityEffects::OnBeingHit.add(:WATERCOMPACTION,
  proc { |ability, user, target, move, battle|
    next if move.calcType != :WATER
    target.pbRaiseStatStageByAbility(:DEFENSE, 2, target)
  }
)

Battle::AbilityEffects::OnBeingHit.add(:WEAKARMOR,
  proc { |ability, user, target, move, battle|
    next if !move.physicalMove?
    next if !target.pbCanLowerStatStage?(:DEFENSE, target) &&
            !target.pbCanRaiseStatStage?(:SPEED, target)
    battle.pbShowAbilitySplash(target)
    target.pbLowerStatStageByAbility(:DEFENSE, 1, target, false)
    target.pbRaiseStatStageByAbility(:SPEED, (Settings::MECHANICS_GENERATION >= 7) ? 2 : 1, target, false)
    battle.pbHideAbilitySplash(target)
  }
)

# NOTE: This only triggers if hit by a damaging wind move, not a status one.
#       Tailwind triggers it manually in its own move effect. There are no other
#       wind status moves that should trigger it, at least for now.
Battle::AbilityEffects::OnBeingHit.add(:WINDPOWER,
  proc { |ability, user, target, move, battle|
    next if !move.windMove?
    next if target.effects[PBEffects::Charge] > 0
    battle.pbShowAbilitySplash(target)
    target.effects[PBEffects::Charge] = 2
    battle.pbDisplay(_INTL("{2}受到{1}而充电了！", move.name, target.pbThis(true)))
    battle.pbHideAbilitySplash(target)
  }
)

#===============================================================================
# OnDealingHit handlers
#===============================================================================

Battle::AbilityEffects::OnDealingHit.add(:POISONTOUCH,
  proc { |ability, user, target, move, battle|
    next if !move.pbContactMove?(user)
    next if !target.affectedByAdditionalEffects?
    next if !target.pbCanPoison?(user, false)
    next if target.hasActiveAbility?(:SHIELDDUST) && !target.beingMoldBroken?
    next if battle.pbRandom(100) >= 30
    battle.pbShowAbilitySplash(user)
    msg = nil
    if !Battle::Scene::USE_ABILITY_SPLASH
      msg = _INTL("{1}{2}让{3}中毒了！", user.pbOfThis, user.abilityName, target.pbThis(true))
    end
    target.pbPoison(user, msg)
    battle.pbHideAbilitySplash(user)
  }
)

Battle::AbilityEffects::OnDealingHit.add(:TOXICCHAIN,
  proc { |ability, user, target, move, battle|
    next if !target.affectedByAdditionalEffects?
    next if !target.pbCanPoison?(user, false)
    next if target.hasActiveAbility?(:SHIELDDUST) && !target.beingMoldBroken?
    next if battle.pbRandom(100) >= 30
    battle.pbShowAbilitySplash(user)
    msg = nil
    if !Battle::Scene::USE_ABILITY_SPLASH
      msg = _INTL("{1}{2}让{3}中剧毒了！", user.pbOfThis, user.abilityName, target.pbThis(true))
    end
    target.pbPoison(user, msg, true)
    battle.pbHideAbilitySplash(user)
  }
)

#===============================================================================
# OnEndOfUsingMove handlers
#===============================================================================

Battle::AbilityEffects::OnEndOfUsingMove.add(:BATTLEBOND,
  proc { |ability, user, targets, move, battle|
    next if !Settings::GRENINJA_BATTLE_BOND_RAISES_STATS
    next if user.abilityUsedOnce?
    next if battle.pbAllFainted?(user.idxOpposingSide)
    next if targets.none? { |b| b.damageState.fainted }
    raised_stats = [:ATTACK, :SPECIAL_ATTACK, :SPEED]
    next if raised_stats.none? { |stat| !user.pbCanRaiseStatStage?(stat, user) }
    user.markAbilityUsedOnce
    battle.pbShowAbilitySplash(user)
    show_anim = true
    raised_stats.each do |stat|
      next if !user.pbCanRaiseStatStage?(stat, user)
      if user.pbRaiseStatStage(stat, 1, user, show_anim)
        show_anim = false
      end
    end
    battle.pbHideAbilitySplash(user)
  }
)

Battle::AbilityEffects::OnEndOfUsingMove.add(:BEASTBOOST,
  proc { |ability, user, targets, move, battle|
    next if battle.pbAllFainted?(user.idxOpposingSide)
    numFainted = 0
    targets.each { |b| numFainted += 1 if b.damageState.fainted }
    next if numFainted == 0
    userStats = user.plainStats
    highestStatValue = 0
    userStats.each_value { |value| highestStatValue = value if highestStatValue < value }
    GameData::Stat.each_main_battle do |s|
      next if userStats[s.id] < highestStatValue
      if user.pbCanRaiseStatStage?(s.id, user)
        user.pbRaiseStatStageByAbility(s.id, numFainted, user)
      end
      break
    end
  }
)

Battle::AbilityEffects::OnEndOfUsingMove.copy(:BEASTBOOST, :EELEVATE)

Battle::AbilityEffects::OnEndOfUsingMove.add(:CHILLINGNEIGH,
  proc { |ability, user, targets, move, battle|
    next if battle.pbAllFainted?(user.idxOpposingSide)
    next if targets.none? { |b| b.damageState.fainted }
    next if !user.pbCanRaiseStatStage?(:ATTACK, user)
    user.ability_id = :CHILLINGNEIGH   # So the As One abilities can just copy this
    user.pbRaiseStatStageByAbility(:ATTACK, 1, user)
    user.ability_id = ability
  }
)

Battle::AbilityEffects::OnEndOfUsingMove.copy(:CHILLINGNEIGH, :ASONECHILLINGNEIGH)

Battle::AbilityEffects::OnEndOfUsingMove.add(:GRIMNEIGH,
  proc { |ability, user, targets, move, battle|
    next if battle.pbAllFainted?(user.idxOpposingSide)
    next if targets.none? { |b| b.damageState.fainted }
    next if !user.pbCanRaiseStatStage?(:SPECIAL_ATTACK, user)
    user.ability_id = :GRIMNEIGH   # So the As One abilities can just copy this
    user.pbRaiseStatStageByAbility(:SPECIAL_ATTACK, 1, user)
    user.ability_id = ability
  }
)

Battle::AbilityEffects::OnEndOfUsingMove.copy(:GRIMNEIGH, :ASONEGRIMNEIGH)

Battle::AbilityEffects::OnEndOfUsingMove.add(:MAGICIAN,
  proc { |ability, user, targets, move, battle|
    next if battle.futureSight
    next if !move.pbDamagingMove?
    next if user.item
    next if user.wild?
    valid_targets = []
    targets.each do |battler|
      next if battler.damageState.unaffected || battler.damageState.substitute
      next if !battler.item
      next if battler.unlosableItem?(battler.item) || user.unlosableItem?(battler.item)
      next if battler.hasActiveAbility?(:STICKYHOLD)
      valid_targets.push(battler)
    end
    next if valid_targets.empty?
    battle.pbShowAbilitySplash(user)
    battler = valid_targets.first
    battle.swapHeldItems(user, battler)
    if Battle::Scene::USE_ABILITY_SPLASH
      battle.pbDisplay(_INTL("{1}顺手牵羊走了{2}的{3}！", user.pbThis, battler.pbThis(true), user.itemName))
    else
      battle.pbDisplay(_INTL("{1}的{4}偷走了{2}的{3}！",
                             user.pbThis, battler.pbThis(true), user.itemName, user.abilityName))
    end
    battle.pbHideAbilitySplash(user)
    user.pbHeldItemTriggerCheck
  }
)

Battle::AbilityEffects::OnEndOfUsingMove.add(:MOXIE,
  proc { |ability, user, targets, move, battle|
    next if battle.pbAllFainted?(user.idxOpposingSide)
    numFainted = 0
    targets.each { |b| numFainted += 1 if b.damageState.fainted }
    next if numFainted == 0 || !user.pbCanRaiseStatStage?(:ATTACK, user)
    user.pbRaiseStatStageByAbility(:ATTACK, numFainted, user)
  }
)

#===============================================================================
# AfterMoveUseFromTarget handlers
#===============================================================================

Battle::AbilityEffects::AfterMoveUseFromTarget.add(:BERSERK,
  proc { |ability, target, user, move, switched_battlers, battle|
    next if !move.damagingMove?
    next if !target.droppedBelowHalfHP
    next if !target.pbCanRaiseStatStage?(:SPECIAL_ATTACK, target)
    target.pbRaiseStatStageByAbility(:SPECIAL_ATTACK, 1, target)
  }
)

Battle::AbilityEffects::AfterMoveUseFromTarget.add(:COLORCHANGE,
  proc { |ability, target, user, move, switched_battlers, battle|
    next if target.damageState.calcDamage == 0 || target.damageState.substitute
    next if !move.calcType || GameData::Type.get(move.calcType).pseudo_type
    next if target.pbHasType?(move.calcType) && !target.pbHasOtherType?(move.calcType)
    typeName = GameData::Type.get(move.calcType).name
    battle.pbShowAbilitySplash(target)
    target.pbChangeTypes(move.calcType)
    battle.pbDisplay(_INTL("由于{3}，{1}的属性变成了{2}！",
                           target.pbThis, typeName, target.abilityName))
    battle.pbHideAbilitySplash(target)
  }
)

# NOTE: According to Bulbapedia, this can still trigger to steal the user's item
#       even if it was switched out by a Red Card. That doesn't make sense, so
#       this code doesn't do it.
Battle::AbilityEffects::AfterMoveUseFromTarget.add(:PICKPOCKET,
  proc { |ability, target, user, move, switched_battlers, battle|
    next if target.wild?
    next if switched_battlers.include?(user.index)   # User was switched out
    next if !move.pbContactMove?(user)
    next if target.damageState.calcDamage == 0 || target.damageState.substitute
    next if user.effects[PBEffects::Substitute] > 0
    next if target.item || !user.item
    next if user.unlosableItem?(user.item) || target.unlosableItem?(user.item)
    battle.pbShowAbilitySplash(target)
    if user.hasActiveAbility?(:STICKYHOLD)
      battle.pbShowAbilitySplash(user) if target.opposes?(user)
      if Battle::Scene::USE_ABILITY_SPLASH
        battle.pbDisplay(_INTL("无法夺取{1}道具！", user.pbOfThis))
      end
      battle.pbHideAbilitySplash(user) if target.opposes?(user)
      battle.pbHideAbilitySplash(target)
      next
    end
    battle.swapHeldItems(user, target)
    battle.pbDisplay(_INTL("{1}顺手牵羊走了{2}{3}！", target.pbThis, user.pbOfThis(true), target.itemName))
    battle.pbHideAbilitySplash(target)
    target.pbHeldItemTriggerCheck
  }
)

#===============================================================================
# EndOfRoundWeather handlers
#===============================================================================

Battle::AbilityEffects::EndOfRoundWeather.add(:DRYSKIN,
  proc { |ability, weather, battler, battle|
    case weather
    when :Sun, :HarshSun
      if battler.takesIndirectDamage?
        battle.pbShowAbilitySplash(battler)
        battle.scene.pbDamageAnimation(battler)
        battler.pbReduceHP(battler.totalhp / 8, false)
        battle.pbDisplay(_INTL("{1}因日光受伤了！", battler.pbThis))
        battle.pbHideAbilitySplash(battler)
        battler.pbItemHPHealCheck
      end
    when :Rain, :HeavyRain
      next if !battler.canHeal?
      battle.pbShowAbilitySplash(battler)
      battler.pbRecoverHP(battler.totalhp / 8)
      if Battle::Scene::USE_ABILITY_SPLASH
        battle.pbDisplay(_INTL("{1}的体力回复了！", battler.pbThis))
      else
        battle.pbDisplay(_INTL("{1}{2}回复了体力！", battler.pbOfThis, battler.abilityName))
      end
      battle.pbHideAbilitySplash(battler)
    end
  }
)

Battle::AbilityEffects::EndOfRoundWeather.add(:ICEBODY,
  proc { |ability, weather, battler, battle|
    next if ![:Hail, :Snowstorm].include?(weather)
    next if !battler.canHeal?
    battle.pbShowAbilitySplash(battler)
    battler.pbRecoverHP(battler.totalhp / 16)
    if Battle::Scene::USE_ABILITY_SPLASH
      battle.pbDisplay(_INTL("{1}的体力回复了！", battler.pbThis))
    else
      battle.pbDisplay(_INTL("{1}{2}回复了体力！", battler.pbOfThis, battler.abilityName))
    end
    battle.pbHideAbilitySplash(battler)
  }
)

Battle::AbilityEffects::EndOfRoundWeather.add(:ICEFACE,
  proc { |ability, weather, battler, battle|
    next if !battler.isSpecies?(:EISCUE) || battler.form != 1 || battler.effects[PBEffects::Transform]
    next if ![:Hail, :Snowstorm].include?(weather)
    next if !battler.canRestoreIceFace
    battle.pbShowAbilitySplash(battler)
    if !Battle::Scene::USE_ABILITY_SPLASH
      battle.pbDisplay(_INTL("{1}{2}发动了！", battler.pbOfThis, battler.abilityName))
    end
    battler.pbChangeForm(0, _INTL("{1}变成其他样子了！", battler.pbThis))
    battle.pbHideAbilitySplash(battler)
  }
)

Battle::AbilityEffects::EndOfRoundWeather.add(:RAINDISH,
  proc { |ability, weather, battler, battle|
    next if ![:Rain, :HeavyRain].include?(weather)
    next if !battler.canHeal?
    battle.pbShowAbilitySplash(battler)
    battler.pbRecoverHP(battler.totalhp / 16)
    if Battle::Scene::USE_ABILITY_SPLASH
      battle.pbDisplay(_INTL("{1}的体力回复了！", battler.pbThis))
    else
      battle.pbDisplay(_INTL("{1}{2}回复了体力！", battler.pbOfThis, battler.abilityName))
    end
    battle.pbHideAbilitySplash(battler)
  }
)

Battle::AbilityEffects::EndOfRoundWeather.add(:SOLARPOWER,
  proc { |ability, weather, battler, battle|
    next if ![:Sun, :HarshSun].include?(weather)
    next if !battler.takesIndirectDamage?
    battle.pbShowAbilitySplash(battler)
    battle.scene.pbDamageAnimation(battler)
    battler.pbReduceHP(battler.totalhp / 8, false)
    battle.pbDisplay(_INTL("{1}因日光受伤了！", battler.pbThis))
    battle.pbHideAbilitySplash(battler)
    battler.pbItemHPHealCheck
  }
)

#===============================================================================
# EndOfRoundHealing handlers
#===============================================================================

Battle::AbilityEffects::EndOfRoundHealing.add(:HEALER,
  proc { |ability, battler, battle|
    next if battle.pbRandom(100) >= 30
    showing_splash = false
    battler.allAllies(true).each do |ally|
      next if ally.status == :NONE
      battle.pbShowAbilitySplash(battler) if !showing_splash
      showing_splash = true
      old_status = ally.status
      ally.pbCureStatus(Battle::Scene::USE_ABILITY_SPLASH)
      if !Battle::Scene::USE_ABILITY_SPLASH
        case old_status
        when :SLEEP
          battle.pbDisplay(_INTL("{1}{2}让队友醒过来了！", battler.pbOfThis, battler.abilityName))
        when :POISON
          battle.pbDisplay(_INTL("{1}{2}治愈了队友的中毒！", battler.pbOfThis, battler.abilityName))
        when :BURN
          battle.pbDisplay(_INTL("{1}{2}治愈了队友的灼伤！", battler.pbOfThis, battler.abilityName))
        when :PARALYSIS
          battle.pbDisplay(_INTL("{1}{2}治愈了队友的麻痹！", battler.pbOfThis, battler.abilityName))
        when :FROZEN
          battle.pbDisplay(_INTL("{1}{2}治愈了队友的冰冻！", battler.pbOfThis, battler.abilityName))
        end
      end
    end
    battle.pbHideAbilitySplash(battler) if showing_splash
  }
)

Battle::AbilityEffects::EndOfRoundHealing.add(:HYDRATION,
  proc { |ability, battler, battle|
    next if battler.status == :NONE
    next if ![:Rain, :HeavyRain].include?(battler.effectiveWeather)
    battle.pbShowAbilitySplash(battler)
    oldStatus = battler.status
    battler.pbCureStatus(Battle::Scene::USE_ABILITY_SPLASH)
    if !Battle::Scene::USE_ABILITY_SPLASH
      case oldStatus
      when :SLEEP
        battle.pbDisplay(_INTL("{1}{2}让自己醒过来了！", battler.pbOfThis, battler.abilityName))
      when :POISON
        battle.pbDisplay(_INTL("{1}{2}治愈了中毒！", battler.pbOfThis, battler.abilityName))
      when :BURN
        battle.pbDisplay(_INTL("{1}{2}治愈了灼伤！", battler.pbOfThis, battler.abilityName))
      when :PARALYSIS
        battle.pbDisplay(_INTL("{1}{2}治愈了麻痹！", battler.pbOfThis, battler.abilityName))
      when :FROZEN
        battle.pbDisplay(_INTL("{1}{2}治愈了冰冻！", battler.pbOfThis, battler.abilityName))
      end
    end
    battle.pbHideAbilitySplash(battler)
  }
)

Battle::AbilityEffects::EndOfRoundHealing.add(:SHEDSKIN,
  proc { |ability, battler, battle|
    next if battler.status == :NONE
    next if battle.pbRandom(100) >= 30
    battle.pbShowAbilitySplash(battler)
    oldStatus = battler.status
    battler.pbCureStatus(Battle::Scene::USE_ABILITY_SPLASH)
    if !Battle::Scene::USE_ABILITY_SPLASH
      case oldStatus
      when :SLEEP
        battle.pbDisplay(_INTL("{1}{2}让自己醒过来了！", battler.pbOfThis, battler.abilityName))
      when :POISON
        battle.pbDisplay(_INTL("{1}{2}治愈了中毒！", battler.pbOfThis, battler.abilityName))
      when :BURN
        battle.pbDisplay(_INTL("{1}{2}治愈了灼伤！", battler.pbOfThis, battler.abilityName))
      when :PARALYSIS
        battle.pbDisplay(_INTL("{1}{2}治愈了麻痹！", battler.pbOfThis, battler.abilityName))
      when :FROZEN
        battle.pbDisplay(_INTL("{1}{2}治愈了冰冻！", battler.pbOfThis, battler.abilityName))
      end
    end
    battle.pbHideAbilitySplash(battler)
  }
)

#===============================================================================
# EndOfRoundEffect handlers
#===============================================================================

Battle::AbilityEffects::EndOfRoundEffect.add(:BADDREAMS,
  proc { |ability, battler, battle|
    showing_splash = false
    battle.allOtherSideBattlers(battler.index, true).each do |b|
      next if !b.near?(battler) || !b.asleep?
      next if !b.takesIndirectDamage?
      battle.pbShowAbilitySplash(battler) if !showing_splash
      showing_splash = true
      b.pbTakeEffectDamage(b.totalhp / 8) do |hp_lost|
        if Battle::Scene::USE_ABILITY_SPLASH
          battle.pbDisplay(_INTL("{1}正被恶梦缠身！", b.pbThis))
        else
          battle.pbDisplay(_INTL("{1}正被{2}{3}缠身！", b.pbThis, battler.pbOfThis(true), battler.abilityName))
        end
      end
    end
    battle.pbHideAbilitySplash(battler) if showing_splash
  }
)

Battle::AbilityEffects::EndOfRoundEffect.add(:MOODY,
  proc { |ability, battler, battle|
    randomUp = []
    randomDown = []
    if Settings::MECHANICS_GENERATION >= 8
      GameData::Stat.each_main_battle do |s|
        randomUp.push(s.id) if battler.pbCanRaiseStatStage?(s.id, battler)
        randomDown.push(s.id) if battler.pbCanLowerStatStage?(s.id, battler)
      end
    else
      GameData::Stat.each_battle do |s|
        randomUp.push(s.id) if battler.pbCanRaiseStatStage?(s.id, battler)
        randomDown.push(s.id) if battler.pbCanLowerStatStage?(s.id, battler)
      end
    end
    next if randomUp.empty? && randomDown.empty?
    battle.pbShowAbilitySplash(battler)
    if randomUp.length > 0
      up_idx = battle.pbRandom(randomUp.length)
      battler.pbRaiseStatStageByAbility(randomUp[up_idx], 2, battler, false)
      randomDown.delete(randomUp[up_idx])
    end
    if randomDown.length > 0
      down_idx = battle.pbRandom(randomDown.length)
      battler.pbLowerStatStageByAbility(randomDown[down_idx], 1, battler, false)
    end
    battle.pbHideAbilitySplash(battler)
    battler.pbItemStatRestoreCheck if randomDown.length > 0   # White Herb
    battler.pbItemOnStatDropped   # Eject Pack
  }
)

Battle::AbilityEffects::EndOfRoundEffect.add(:SPEEDBOOST,
  proc { |ability, battler, battle|
    # A Pokémon's turnCount is 0 if it became active after the beginning of a
    # round
    if battler.turnCount > 0 && battle.choices[battler.index][0] != :Run &&
       battler.pbCanRaiseStatStage?(:SPEED, battler)
      battler.pbRaiseStatStageByAbility(:SPEED, 1, battler)
    end
  }
)

#===============================================================================
# EndOfRoundGainItem handlers
#===============================================================================

Battle::AbilityEffects::EndOfRoundGainItem.add(:BALLFETCH,
  proc { |ability, battler, battle|
    next if battler.item
    next if battle.first_poke_ball.nil?
    battle.pbShowAbilitySplash(battler)
    battler.item = battle.first_poke_ball
    battle.first_poke_ball = nil
    battle.pbDisplay(_INTL("{1}捡回了{2}！", battler.pbThis, battler.itemName))
    battle.pbHideAbilitySplash(battler)
    battler.pbHeldItemTriggerCheck
  }
)

Battle::AbilityEffects::EndOfRoundGainItem.add(:HARVEST,
  proc { |ability, battler, battle|
    next if battler.item
    next if !battler.recycleItem || !GameData::Item.get(battler.recycleItem).is_berry?
    if ![:Sun, :HarshSun].include?(battler.effectiveWeather)
      next if battle.pbRandom(100) >= 50
    end
    battle.pbShowAbilitySplash(battler)
    battler.item = battler.recycleItem
    battler.setRecycleItem(nil)
    battle.pbDisplay(_INTL("{1}收获了{2}！", battler.pbThis, battler.itemName))
    battle.pbHideAbilitySplash(battler)
    battler.pbHeldItemTriggerCheck
  }
)

Battle::AbilityEffects::EndOfRoundGainItem.add(:PICKUP,
  proc { |ability, battler, battle|
    next if battler.item
    foundItem = nil
    fromBattler = nil
    use = 0
    battle.allBattlers(true).each do |b|
      next if b.index == battler.index
      next if b.effects[PBEffects::PickupUse] <= use
      foundItem   = b.effects[PBEffects::PickupItem]
      fromBattler = b
      use         = b.effects[PBEffects::PickupUse]
    end
    next if !foundItem
    battle.pbShowAbilitySplash(battler)
    battler.item = foundItem
    fromBattler.effects[PBEffects::PickupItem] = nil
    fromBattler.effects[PBEffects::PickupUse]  = 0
    fromBattler.setRecycleItem(nil) if fromBattler.recycleItem == foundItem
    battle.pbDisplay(_INTL("{1}捡到了{2}！", battler.pbThis, battler.itemName))
    battle.pbHideAbilitySplash(battler)
    battler.pbHeldItemTriggerCheck
  }
)

#===============================================================================
# CertainSwitching handlers
#===============================================================================

# There aren't any!

#===============================================================================
# TrappingByTarget handlers
#===============================================================================

Battle::AbilityEffects::TrappingByTarget.add(:ARENATRAP,
  proc { |ability, switcher, bearer, battle|
    next true if !switcher.airborne?
  }
)

Battle::AbilityEffects::TrappingByTarget.add(:MAGNETPULL,
  proc { |ability, switcher, bearer, battle|
    next true if switcher.near?(bearer) && switcher.pbHasType?(:STEEL)
  }
)

Battle::AbilityEffects::TrappingByTarget.add(:SHADOWTAG,
  proc { |ability, switcher, bearer, battle|
    next true if !switcher.hasActiveAbility?(:SHADOWTAG)
  }
)

#===============================================================================
# OnSwitchIn handlers
#===============================================================================

Battle::AbilityEffects::OnSwitchIn.add(:AIRLOCK,
  proc { |ability, battler, battle, switch_in|
    battle.pbShowAbilitySplash(battler)
    if !Battle::Scene::USE_ABILITY_SPLASH
      battle.pbDisplay(_INTL("{1}有{2}！", battler.pbThis, battler.abilityName))
    end
    battle.pbDisplay(_INTL("天气的影响消失了！"))
    battle.pbHideAbilitySplash(battler)
  }
)

Battle::AbilityEffects::OnSwitchIn.copy(:AIRLOCK, :CLOUDNINE)

Battle::AbilityEffects::OnSwitchIn.add(:ANTICIPATION,
  proc { |ability, battler, battle, switch_in|
    next if !battler.pbOwnedByPlayer?
    battlerTypes = battler.pbTypes(true)
    types = battlerTypes
    found = false
    battle.allOtherSideBattlers(battler.index).each do |b|
      b.eachMove do |m|
        next if m.statusMove?
        if types.length > 0
          moveType = m.type
          if Settings::MECHANICS_GENERATION >= 6 && m.function_code == "TypeDependsOnUserIVs"   # Hidden Power
            moveType = pbHiddenPower(b.pokemon)[0]
          end
          eff = Effectiveness.calculate(moveType, *types)
          next if Effectiveness.ineffective?(eff)
          next if !Effectiveness.super_effective?(eff) &&
                  !["OHKO", "OHKOIce", "OHKOHitsUndergroundTarget"].include?(m.function_code)
        elsif !["OHKO", "OHKOIce", "OHKOHitsUndergroundTarget"].include?(m.function_code)
          next
        end
        found = true
        break
      end
      break if found
    end
    next if !found
    battle.pbShowAbilitySplash(battler)
    battle.pbDisplay(_INTL("{1}发抖了！", battler.pbThis))
    battle.pbHideAbilitySplash(battler)
  }
)

Battle::AbilityEffects::OnSwitchIn.add(:ASONECHILLINGNEIGH,
  proc { |ability, battler, battle, switch_in|
    battle.pbShowAbilitySplash(battler)
    battle.pbDisplay(_INTL("{1}同时拥有了两种特性！", battler.pbThis))
    battle.pbHideAbilitySplash(battler)
    battler.ability_id = :UNNERVE
    battle.pbShowAbilitySplash(battler)
    battle.pbDisplay(_INTL("{1}因太紧张而无法食用树果！", battler.pbOpposingTeam))
    battle.pbHideAbilitySplash(battler)
    battler.ability_id = ability
  }
)

Battle::AbilityEffects::OnSwitchIn.copy(:ASONECHILLINGNEIGH, :ASONEGRIMNEIGH)

Battle::AbilityEffects::OnSwitchIn.add(:AURABREAK,
  proc { |ability, battler, battle, switch_in|
    battle.pbShowAbilitySplash(battler)
    battle.pbDisplay(_INTL("{1}压制了所有气场！", battler.pbThis))
    battle.pbHideAbilitySplash(battler)
  }
)

Battle::AbilityEffects::OnSwitchIn.add(:COMATOSE,
  proc { |ability, battler, battle, switch_in|
    battle.pbShowAbilitySplash(battler)
    battle.pbDisplay(_INTL("{1}处于半梦半醒状态！", battler.pbThis))
    battle.pbHideAbilitySplash(battler)
  }
)

Battle::AbilityEffects::OnSwitchIn.add(:COSTAR,
  proc { |ability, battler, battle, switch_in|
    allies = battler.allAllies
    next if allies.empty?
    # Determine which ally to copy the stats of
    if allies.length > 1
      target = nil
      target_stages = 0
      allies.each do |ally|
        if target.nil?
          target = ally
          GameData::Stat.each_battle { |s| target_stages += ally.stages[s.id] }
          target_stages += ally.criticalHitRate
        else
          stages = 0
          GameData::Stat.each_battle { |s| stages += ally.stages[s.id] }
          stages += ally.criticalHitRate
          next if stages < target_stages
          target = ally
          target_stages = stages
        end
      end
    else
      target = allies[0]
    end
    # Copy the stats
    battle.pbShowAbilitySplash(battler)
    GameData::Stat.each_battle { |s| battler.stages[s.id] = target.stages[s.id] }
    battler.setCriticalHitRate(target.criticalHitRate)
    battle.pbDisplay(_INTL("{1}复制了{2}的能力变化！", battler.pbThis, target.pbOfThis(true)))
    battle.pbHideAbilitySplash(battler)
  }
)

Battle::AbilityEffects::OnSwitchIn.add(:CURIOUSMEDICINE,
  proc { |ability, battler, battle, switch_in|
    next if battler.allAllies(true).none? { |b| b.hasAlteredStatStages? }
    battle.pbShowAbilitySplash(battler)
    battler.allAllies(true).each do |b|
      next if !b.hasAlteredStatStages?
      b.pbResetStatStages
      if Battle::Scene::USE_ABILITY_SPLASH
        battle.pbDisplay(_INTL("{1}能力变化消失了！", b.pbOfThis))
      else
        battle.pbDisplay(_INTL("由于{2}{3}，{1}能力变化消失了！",
                               b.pbOfThis, battler.pbOfThis(true), battler.abilityName))
      end
    end
    battle.pbHideAbilitySplash(battler)
  }
)

Battle::AbilityEffects::OnSwitchIn.add(:DARKAURA,
  proc { |ability, battler, battle, switch_in|
    battle.pbShowAbilitySplash(battler)
    battle.pbDisplay(_INTL("{1}正在释放暗黑气场！", battler.pbThis))
    battle.pbHideAbilitySplash(battler)
  }
)

Battle::AbilityEffects::OnSwitchIn.add(:DAUNTLESSSHIELD,
  proc { |ability, battler, battle, switch_in|
    next if battler.abilityUsedOnce?
    battler.pbRaiseStatStageByAbility(:DEFENSE, 1, battler)
    battler.markAbilityUsedOnce if Settings::MECHANICS_GENERATION >= 9
  }
)

Battle::AbilityEffects::OnSwitchIn.add(:DELTASTREAM,
  proc { |ability, battler, battle, switch_in|
    battle.pbStartWeatherAbility(:StrongWinds, battler, true)
  }
)

Battle::AbilityEffects::OnSwitchIn.add(:DESOLATELAND,
  proc { |ability, battler, battle, switch_in|
    battle.pbStartWeatherAbility(:HarshSun, battler, true)
  }
)

Battle::AbilityEffects::OnSwitchIn.add(:DOWNLOAD,
  proc { |ability, battler, battle, switch_in|
    oDef = oSpDef = 0
    battle.allOtherSideBattlers(battler.index).each do |b|
      oDef   += b.defense
      oSpDef += b.spdef
    end
    stat = (oDef < oSpDef) ? :ATTACK : :SPECIAL_ATTACK
    battler.pbRaiseStatStageByAbility(stat, 1, battler)
  }
)

Battle::AbilityEffects::OnSwitchIn.add(:DRIZZLE,
  proc { |ability, battler, battle, switch_in|
    battle.pbStartWeatherAbility(:Rain, battler)
  }
)

Battle::AbilityEffects::OnSwitchIn.add(:DROUGHT,
  proc { |ability, battler, battle, switch_in|
    battle.pbStartWeatherAbility(:Sun, battler)
  }
)

Battle::AbilityEffects::OnSwitchIn.add(:ELECTRICSURGE,
  proc { |ability, battler, battle, switch_in|
    battle.pbStartTerrainAbility(:Electric, battler)
  }
)

Battle::AbilityEffects::OnSwitchIn.add(:EMBODYASPECTATTACK,
  proc { |ability, battler, battle, switch_in|
    next if battler.abilityUsedOnce?
    next if !battler.isSpecies?(:OGERPON) || battler.effects[PBEffects::Transform]
    battle.pbDisplay(_INTL("{2}让{1}发出光辉！", battler.itemName, battler.pbThis(true)))
    battler.pbRaiseStatStageByAbility(:ATTACK, 1, battler)
    battler.markAbilityUsedOnce if Settings::MECHANICS_GENERATION >= 9
  }
)

Battle::AbilityEffects::OnSwitchIn.add(:EMBODYASPECTDEFENSE,
  proc { |ability, battler, battle, switch_in|
    next if battler.abilityUsedOnce?
    next if !battler.isSpecies?(:OGERPON) || battler.effects[PBEffects::Transform]
    battle.pbDisplay(_INTL("{2}让{1}发出光辉！", battler.itemName, battler.pbThis(true)))
    battler.pbRaiseStatStageByAbility(:DEFENSE, 1, battler)
    battler.markAbilityUsedOnce if Settings::MECHANICS_GENERATION >= 9
  }
)

Battle::AbilityEffects::OnSwitchIn.add(:EMBODYASPECTSPDEF,
  proc { |ability, battler, battle, switch_in|
    next if battler.abilityUsedOnce?
    next if !battler.isSpecies?(:OGERPON) || battler.effects[PBEffects::Transform]
    battle.pbDisplay(_INTL("{2}让{1}发出光辉！", battler.itemName, battler.pbThis(true)))
    battler.pbRaiseStatStageByAbility(:SPECIAL_DEFENSE, 1, battler)
    battler.markAbilityUsedOnce if Settings::MECHANICS_GENERATION >= 9
  }
)

Battle::AbilityEffects::OnSwitchIn.add(:EMBODYASPECTSPEED,
  proc { |ability, battler, battle, switch_in|
    next if battler.abilityUsedOnce?
    next if !battler.isSpecies?(:OGERPON) || battler.effects[PBEffects::Transform]
    battle.pbDisplay(_INTL("{2}让{1}发出光辉！", battler.itemName, battler.pbThis(true)))
    battler.pbRaiseStatStageByAbility(:SPEED, 1, battler)
    battler.markAbilityUsedOnce if Settings::MECHANICS_GENERATION >= 9
  }
)

Battle::AbilityEffects::OnSwitchIn.add(:FAIRYAURA,
  proc { |ability, battler, battle, switch_in|
    battle.pbShowAbilitySplash(battler)
    battle.pbDisplay(_INTL("{1}正在释放妖精气场！", battler.pbThis))
    battle.pbHideAbilitySplash(battler)
  }
)

Battle::AbilityEffects::OnSwitchIn.add(:FOREWARN,
  proc { |ability, battler, battle, switch_in|
    next if !battler.pbOwnedByPlayer?
    highestPower = 0
    forewarnMoves = []
    battle.allOtherSideBattlers(battler.index).each do |b|
      b.eachMove do |m|
        power = m.power
        power = 160 if ["OHKO", "OHKOIce", "OHKOHitsUndergroundTarget"].include?(m.function_code)
        power = 150 if ["PowerHigherWithUserHP"].include?(m.function_code)    # Eruption
        # Counter, Mirror Coat, Metal Burst
        power = 120 if ["CounterPhysicalDamage",
                        "CounterSpecialDamage",
                        "CounterDamagePlusHalf"].include?(m.function_code)
        # Sonic Boom, Dragon Rage, Night Shade, Endeavor, Psywave,
        # Return, Frustration, Crush Grip, Gyro Ball, Hidden Power,
        # Natural Gift, Trump Card, Flail, Grass Knot
        power = 80 if ["FixedDamage20",
                       "FixedDamage40",
                       "FixedDamageUserLevel",
                       "LowerTargetHPToUserHP",
                       "FixedDamageUserLevelRandom",
                       "PowerHigherWithUserHappiness",
                       "PowerLowerWithUserHappiness",
                       "PowerHigherWithUserHP",
                       "PowerHigherWithTargetFasterThanUser",
                       "TypeAndPowerDependOnUserBerry",
                       "PowerHigherWithLessPP",
                       "PowerLowerWithUserHP",
                       "PowerHigherWithTargetWeight"].include?(m.function_code)
        power = 80 if Settings::MECHANICS_GENERATION <= 5 && m.function_code == "TypeDependsOnUserIVs"
        next if power < highestPower
        forewarnMoves = [] if power > highestPower
        forewarnMoves.push(m.name)
        highestPower = power
      end
    end
    next if forewarnMoves.empty?
    battle.pbShowAbilitySplash(battler)
    forewarnMoveName = forewarnMoves[battle.pbRandom(forewarnMoves.length)]
    if Battle::Scene::USE_ABILITY_SPLASH
      battle.pbDisplay(_INTL("{1}读取了{2}！", battler.pbThis, forewarnMoveName))
    else
      battle.pbDisplay(_INTL("{1}预知梦读取了{2}！", battler.pbOfThis, forewarnMoveName))
    end
    battle.pbHideAbilitySplash(battler)
  }
)

Battle::AbilityEffects::OnSwitchIn.add(:FRISK,
  proc { |ability, battler, battle, switch_in|
    next if !battler.pbOwnedByPlayer?
    foes = battle.allOtherSideBattlers(battler.index).select { |b| b.item }
    next if foes.empty?
    battle.pbShowAbilitySplash(battler)
    if Settings::MECHANICS_GENERATION >= 6
      foes.each do |b|
        battle.pbDisplay(_INTL("{1}察觉到了{2}的{3}！", battler.pbThis, b.pbThis(true), b.itemName))
      end
    else
      foe = foes[battle.pbRandom(foes.length)]
      battle.pbDisplay(_INTL("{1}察觉到了对方的{2}！", battler.pbThis, foe.itemName))
    end
    battle.pbHideAbilitySplash(battler)
  }
)

Battle::AbilityEffects::OnSwitchIn.add(:GRASSYSURGE,
  proc { |ability, battler, battle, switch_in|
    battle.pbStartTerrainAbility(:Grassy, battler)
  }
)

Battle::AbilityEffects::OnSwitchIn.add(:HADRONENGINE,
  proc { |ability, battler, battle, switch_in|
    if battle.field.terrain == :Electric
      battle.pbShowAbilitySplash(battler)
      battle.pbDisplay(_INTL("{1}用电气场地使未来的机关跃动起来！！", battler.pbThis))
      battle.pbHideAbilitySplash(battler)
    elsif battle.pbCanStartTerrain?(:Electric)
      battle.pbStartTerrainAbility(:Electric, battler,
         _INTL("{1}布下电气场地使未来的机关跃动起来！！", battler.pbThis))
    end
  }
)

Battle::AbilityEffects::OnSwitchIn.add(:HOSPITALITY,
  proc { |ability, battler, battle, switch_in|
    allies = battler.allAllies
    allies.reject! { |ally| !ally.near?(battler) || !ally.canHeal? }
    next if allies.empty?
    battle.pbShowAbilitySplash(battler)
    allies.each do |ally|
      next if ally.pbRecoverHP(ally.totalhp / 4) == 0
      battle.pbDisplay(_INTL("{1}喝光了{2}泡的茶！", ally.pbThis, battler.pbThis(true)))
    end
    battle.pbHideAbilitySplash(battler)
  }
)

Battle::AbilityEffects::OnSwitchIn.add(:ICEFACE,
  proc { |ability, battler, battle, switch_in|
    next if !battler.isSpecies?(:EISCUE) || battler.form != 1 || battler.effects[PBEffects::Transform]
    next if ![:Hail, :Snowstorm].include?(battler.effectiveWeather)
    battle.pbShowAbilitySplash(battler)
    if !Battle::Scene::USE_ABILITY_SPLASH
      battle.pbDisplay(_INTL("{1}{2}发动了！", battler.pbOfThis, battler.abilityName))
    end
    battler.pbChangeForm(0, _INTL("{1}变成其他样子了！", battler.pbThis))
    battle.pbHideAbilitySplash(battler)
  }
)

Battle::AbilityEffects::OnSwitchIn.add(:IMPOSTER,
  proc { |ability, battler, battle, switch_in|
    next if !switch_in || battler.effects[PBEffects::Transform]
    choice = battler.pbDirectOpposing
    next if choice.fainted?
    next if choice.effects[PBEffects::Transform] ||
            choice.effects[PBEffects::Illusion] ||
            choice.effects[PBEffects::Substitute] > 0 ||
            choice.effects[PBEffects::SkyDrop] >= 0 ||
            choice.semiInvulnerable?
    battle.pbShowAbilitySplash(battler, true)
    battle.pbHideAbilitySplash(battler)
    battle.pbAnimation(:TRANSFORM, battler, choice)
    battle.scene.pbChangePokemon(battler, choice.pokemon)
    battler.pbTransform(choice)
  }
)

Battle::AbilityEffects::OnSwitchIn.add(:INTIMIDATE,
  proc { |ability, battler, battle, switch_in|
    battle.pbShowAbilitySplash(battler)
    battle.allOtherSideBattlers(battler.index, true).each do |b|
      next if !b.near?(battler)
      check_item = true
      if b.hasActiveAbility?(:CONTRARY)
        check_item = false if b.statStageAtMax?(:ATTACK)
      elsif b.statStageAtMin?(:ATTACK)
        check_item = false
      end
      check_ability = b.pbLowerAttackStatStageIntimidate(battler)
      b.pbAbilitiesOnIntimidated if check_ability
      b.pbItemOnIntimidatedCheck if check_item
    end
    battle.pbHideAbilitySplash(battler)
  }
)

Battle::AbilityEffects::OnSwitchIn.add(:INTREPIDSWORD,
  proc { |ability, battler, battle, switch_in|
    next if battler.abilityUsedOnce?
    battler.pbRaiseStatStageByAbility(:ATTACK, 1, battler)
    battler.markAbilityUsedOnce if Settings::MECHANICS_GENERATION >= 9
  }
)

Battle::AbilityEffects::OnSwitchIn.add(:MIMICRY,
  proc { |ability, battler, battle, switch_in|
    next if battle.field.terrain == :None
    Battle::AbilityEffects.triggerOnTerrainChange(ability, battler, battle, false)
  }
)

Battle::AbilityEffects::OnSwitchIn.add(:MISTYSURGE,
  proc { |ability, battler, battle, switch_in|
    battle.pbStartTerrainAbility(:Misty, battler)
  }
)

Battle::AbilityEffects::OnSwitchIn.add(:MOLDBREAKER,
  proc { |ability, battler, battle, switch_in|
    battle.pbShowAbilitySplash(battler)
    battle.pbDisplay(_INTL("{1}打破了常规！", battler.pbThis))
    battle.pbHideAbilitySplash(battler)
  }
)

Battle::AbilityEffects::OnSwitchIn.add(:NEUTRALIZINGGAS,
  proc { |ability, battler, battle, switch_in|
    battle.pbShowAbilitySplash(battler, true)
    battle.pbHideAbilitySplash(battler)
    battle.pbDisplay(_INTL("周围充满了化学变化气体！"))
    battle.allBattlers(true).each do |b|
      # Slow Start - end all turn counts
      b.effects[PBEffects::SlowStart] = 0
      # Truant - let b move on its first turn after Neutralizing Gas disappears
      b.effects[PBEffects::Truant] = false
      # Gorilla Tactics - end choice lock
      if !b.hasActiveItem?([:CHOICEBAND, :CHOICESPECS, :CHOICESCARF])
        b.effects[PBEffects::ChoiceBand] = nil
      end
      # Illusion - end illusions
      if b.effects[PBEffects::Illusion]
        b.effects[PBEffects::Illusion] = nil
        if !b.effects[PBEffects::Transform]
          battle.scene.pbChangePokemon(b, b.pokemon)
          battle.pbDisplay(_INTL("{1}{2}被解除了！", b.pbOfThis, b.abilityName))
          battle.pbSetSeen(b)
        end
      end
    end
    # Trigger items upon Unnerve being negated
    battler.ability_id = nil   # Allows checking if Unnerve was active before
    had_unnerve = battle.pbCheckGlobalAbility([:UNNERVE, :ASONECHILLINGNEIGH, :ASONEGRIMNEIGH])
    battler.ability_id = :NEUTRALIZINGGAS
    if had_unnerve && !battle.pbCheckGlobalAbility([:UNNERVE, :ASONECHILLINGNEIGH, :ASONEGRIMNEIGH])
      battle.allBattlers(true).each { |b| b.pbItemsOnUnnerveEnding }
    end
  }
)

Battle::AbilityEffects::OnSwitchIn.add(:ORICHALCUMPULSE,
  proc { |ability, battler, battle, switch_in|
    if [:Sun, :HarshSun].include?(battle.field.weather)
      battle.pbShowAbilitySplash(battler)
      battle.pbDisplay(_INTL("{1}受到日照而激起了古代的脉动！！", battler.pbThis))
      battle.pbHideAbilitySplash(battler)
    elsif battle.pbCanStartWeather?(:Sun)
      battle.pbStartWeatherAbility(:Sun, battler, false,
         _INTL("{1}令日照变强，激起了古代的脉动！", battler.pbThis))
    end
  }
)

Battle::AbilityEffects::OnSwitchIn.add(:PASTELVEIL,
  proc { |ability, battler, battle, switch_in|
    next if battler.allAllies.none? { |ally| ally.status == :POISON }
    battle.pbShowAbilitySplash(battler)
    battler.allAllies.each do |ally|
      next if ally.status != :POISON
      ally.pbCureStatus(Battle::Scene::USE_ABILITY_SPLASH)
      if !Battle::Scene::USE_ABILITY_SPLASH
        battle.pbDisplay(_INTL("{1}{2}治愈了{3}中毒！",
                               battler.pbOfThis, battler.abilityName, ally.pbOfThis(true)))
      end
    end
    battle.pbHideAbilitySplash(battler)
  }
)

Battle::AbilityEffects::OnSwitchIn.add(:PRESSURE,
  proc { |ability, battler, battle, switch_in|
    battle.pbShowAbilitySplash(battler)
    battle.pbDisplay(_INTL("从{1}的身上感到了一种压迫感！", battler.pbThis))
    battle.pbHideAbilitySplash(battler)
  }
)

Battle::AbilityEffects::OnSwitchIn.add(:PRIMORDIALSEA,
  proc { |ability, battler, battle, switch_in|
    battle.pbStartWeatherAbility(:HeavyRain, battler, true)
  }
)

Battle::AbilityEffects::OnSwitchIn.add(:PROTOSYNTHESIS,
  proc { |ability, battler, battle, switch_in|
    next if battler.effects[PBEffects::ProtosynthesisStat]
    Battle::AbilityEffects.triggerOnWeatherChange(ability, battler, battle, battle.field.weather, false)
  }
)

Battle::AbilityEffects::OnSwitchIn.add(:PSYCHICSURGE,
  proc { |ability, battler, battle, switch_in|
    battle.pbStartTerrainAbility(:Psychic, battler)
  }
)

Battle::AbilityEffects::OnSwitchIn.add(:QUARKDRIVE,
  proc { |ability, battler, battle, switch_in|
    next if battler.effects[PBEffects::ProtosynthesisStat]
    Battle::AbilityEffects.triggerOnTerrainChange(ability, battler, battle, battle.field.terrain, false)
  }
)

Battle::AbilityEffects::OnSwitchIn.add(:SANDSTREAM,
  proc { |ability, battler, battle, switch_in|
    battle.pbStartWeatherAbility(:Sandstorm, battler)
  }
)

Battle::AbilityEffects::OnSwitchIn.add(:SCREENCLEANER,
  proc { |ability, battler, battle, switch_in|
    next if battler.pbOwnSide.effects[PBEffects::AuroraVeil] == 0 &&
            battler.pbOwnSide.effects[PBEffects::LightScreen] == 0 &&
            battler.pbOwnSide.effects[PBEffects::Reflect] == 0 &&
            battler.pbOpposingSide.effects[PBEffects::AuroraVeil] == 0 &&
            battler.pbOpposingSide.effects[PBEffects::LightScreen] == 0 &&
            battler.pbOpposingSide.effects[PBEffects::Reflect] == 0
    battle.pbShowAbilitySplash(battler)
    if battler.pbOpposingSide.effects[PBEffects::AuroraVeil] > 0
      battler.pbOpposingSide.effects[PBEffects::AuroraVeil] = 0
      battle.pbDisplay(_INTL("{1}极光幕消失了！", battler.pbOfOpposingTeam))
    end
    if battler.pbOpposingSide.effects[PBEffects::LightScreen] > 0
      battler.pbOpposingSide.effects[PBEffects::LightScreen] = 0
      battle.pbDisplay(_INTL("{1}光墙消失了！", battler.pbOfOpposingTeam))
    end
    if battler.pbOpposingSide.effects[PBEffects::Reflect] > 0
      battler.pbOpposingSide.effects[PBEffects::Reflect] = 0
      battle.pbDisplay(_INTL("{1}反射壁消失了！", battler.pbOfOpposingTeam))
    end
    if battler.pbOwnSide.effects[PBEffects::AuroraVeil] > 0
      battler.pbOwnSide.effects[PBEffects::AuroraVeil] = 0
      battle.pbDisplay(_INTL("{1}极光幕消失了！", battler.pbOfTeam))
    end
    if battler.pbOwnSide.effects[PBEffects::LightScreen] > 0
      battler.pbOwnSide.effects[PBEffects::LightScreen] = 0
      battle.pbDisplay(_INTL("{1}光墙消失了！", battler.pbOfTeam))
    end
    if battler.pbOwnSide.effects[PBEffects::Reflect] > 0
      battler.pbOwnSide.effects[PBEffects::Reflect] = 0
      battle.pbDisplay(_INTL("{1}反射壁消失了！", battler.pbOfTeam))
    end
    battle.pbHideAbilitySplash(battler)
  }
)

Battle::AbilityEffects::OnSwitchIn.add(:SLOWSTART,
  proc { |ability, battler, battle, switch_in|
    battle.pbShowAbilitySplash(battler)
    battler.effects[PBEffects::SlowStart] = 5
    if Battle::Scene::USE_ABILITY_SPLASH
      battle.pbDisplay(_INTL("{1}无法拿出平时的水平！", battler.pbThis))
    else
      battle.pbDisplay(_INTL("由于{2}，{1}无法拿出平时的水平！", battler.pbThis, battler.abilityName))
    end
    battle.pbHideAbilitySplash(battler)
  }
)

Battle::AbilityEffects::OnSwitchIn.add(:SNOWWARNING,
  proc { |ability, battler, battle, switch_in|
    battle.pbStartWeatherAbility((Settings::USE_SNOWSTORM_WEATHER_INSTEAD_OF_HAIL ? :Snowstorm : :Hail), battler)
  }
)

Battle::AbilityEffects::OnSwitchIn.add(:SUPERSWEETSYRUP,
  proc { |ability, battler, battle, switch_in|
    next if battler.abilityUsedOnce?
    battler.markAbilityUsedOnce
    battle.pbShowAbilitySplash(battler)
    battle.pbDisplay(_INTL("{1}的蜜散发出了甜甜香气！", battler.pbThis))
    battle.allOtherSideBattlers(battler.index).each do |b|
      next if !b.near?(battler)
      b.pbLowerEvasionStatStageSupersweetSyrup(battler)
    end
    battle.pbHideAbilitySplash(battler)
  }
)

Battle::AbilityEffects::OnSwitchIn.add(:SUPREMEOVERLORD,
  proc { |ability, battler, battle, switch_in|
    battler.effects[PBEffects::SupremeOverlord] = [battle.sideFaintCounts[battler.idxOwnSide], 5].min
    if battler.effects[PBEffects::SupremeOverlord] > 0
      battle.pbShowAbilitySplash(battler)
      battle.pbDisplay(_INTL("{1}从被打倒的同伴身上得到力量了！", battler.pbThis))
      battle.pbHideAbilitySplash(battler)
    end
  }
)

Battle::AbilityEffects::OnSwitchIn.add(:TERAFORMZERO,
  proc { |ability, battler, battle, switch_in|
    next if battler.abilityUsedOnce?
    battler.markAbilityUsedOnce
    next if (battle.field.weather == :None || battle.field.weather == battle.field.defaultWeather) &&
            (battle.field.terrain == :None || battle.field.terrain == battle.field.defaultTerrain)
    battle.pbShowAbilitySplash(battler)
    battle.pbEndWeather if ![:None, battle.field.defaultWeather].include?(battle.field.weather)
    battle.pbEndTerrain if ![:None, battle.field.defaultTerrain].include?(battle.field.terrain)
    battle.pbHideAbilitySplash(battler)
    # Start up the default weather/terrain
    battle.pbStartWeather(nil, battle.field.defaultWeather, false) if battle.field.defaultWeather != :None
    battle.pbStartTerrain(nil, battle.field.defaultTerrain, false) if battle.field.defaultTerrain != :None
  }
)

Battle::AbilityEffects::OnSwitchIn.add(:TERAVOLT,
  proc { |ability, battler, battle, switch_in|
    battle.pbShowAbilitySplash(battler)
    battle.pbDisplay(_INTL("{1}正在释放溅射气场！", battler.pbThis))
    battle.pbHideAbilitySplash(battler)
  }
)

Battle::AbilityEffects::OnSwitchIn.add(:TURBOBLAZE,
  proc { |ability, battler, battle, switch_in|
    battle.pbShowAbilitySplash(battler)
    battle.pbDisplay(_INTL("{1}正在释放炽焰气场！", battler.pbThis))
    battle.pbHideAbilitySplash(battler)
  }
)

Battle::AbilityEffects::OnSwitchIn.add(:UNNERVE,
  proc { |ability, battler, battle, switch_in|
    battle.pbShowAbilitySplash(battler)
    battle.pbDisplay(_INTL("{1}因太紧张而无法食用树果！", battler.pbOpposingTeam))
    battle.pbHideAbilitySplash(battler)
  }
)

Battle::AbilityEffects::OnSwitchIn.add(:WINDRIDER,
  proc { |ability, battler, battle, switch_in|
    next if battler.pbOwnSide.effects[PBEffects::Tailwind] == 0
    battler.pbRaiseStatStageByAbility(:ATTACK, 1, battler)
  }
)

#===============================================================================
# OnSwitchOut handlers
#===============================================================================

Battle::AbilityEffects::OnSwitchOut.add(:IMMUNITY,
  proc { |ability, battler, endOfBattle|
    next if battler.status != :POISON
    PBDebug.log("[Ability triggered] #{battler.pbOfThis} #{battler.abilityName}")
    battler.status = :NONE
  }
)

Battle::AbilityEffects::OnSwitchOut.add(:INSOMNIA,
  proc { |ability, battler, endOfBattle|
    next if battler.status != :SLEEP
    PBDebug.log("[Ability triggered] #{battler.pbOfThis} #{battler.abilityName}")
    battler.status = :NONE
  }
)

Battle::AbilityEffects::OnSwitchOut.copy(:INSOMNIA, :VITALSPIRIT)

Battle::AbilityEffects::OnSwitchOut.add(:LIMBER,
  proc { |ability, battler, endOfBattle|
    next if battler.status != :PARALYSIS
    PBDebug.log("[Ability triggered] #{battler.pbOfThis} #{battler.abilityName}")
    battler.status = :NONE
  }
)

Battle::AbilityEffects::OnSwitchOut.add(:MAGMAARMOR,
  proc { |ability, battler, endOfBattle|
    next if battler.status != :FROZEN
    PBDebug.log("[Ability triggered] #{battler.pbOfThis} #{battler.abilityName}")
    battler.status = :NONE
  }
)

Battle::AbilityEffects::OnSwitchOut.add(:NATURALCURE,
  proc { |ability, battler, endOfBattle|
    next if Settings::MECHANICS_GENERATION >= 8 && endOfBattle
    PBDebug.log("[Ability triggered] #{battler.pbOfThis} #{battler.abilityName}")
    battler.status = :NONE
  }
)

Battle::AbilityEffects::OnSwitchOut.add(:REGENERATOR,
  proc { |ability, battler, endOfBattle|
    next if endOfBattle
    PBDebug.log("[Ability triggered] #{battler.pbOfThis} #{battler.abilityName}")
    battler.pbRecoverHP(battler.totalhp / 3, false, false)
  }
)

Battle::AbilityEffects::OnSwitchOut.add(:WATERVEIL,
  proc { |ability, battler, endOfBattle|
    next if battler.status != :BURN
    PBDebug.log("[Ability triggered] #{battler.pbOfThis} #{battler.abilityName}")
    battler.status = :NONE
  }
)

Battle::AbilityEffects::OnSwitchOut.copy(:WATERVEIL, :WATERBUBBLE)

#===============================================================================
# ChangeOnBattlerFainting handlers
#===============================================================================

Battle::AbilityEffects::ChangeOnBattlerFainting.add(:POWEROFALCHEMY,
  proc { |ability, battler, fainted, battle|
    next if battler.opposes?(fainted)
    next if fainted.ungainableAbility? || [:WANDERINGSPIRIT].include?(fainted.ability_id)
    battle.pbShowAbilitySplash(battler, true)
    battler.ability = fainted.ability
    battle.pbReplaceAbilitySplash(battler)
    battle.pbDisplay(_INTL("继承了{1}{2}！", fainted.pbOfThis, fainted.abilityName))
    battle.pbHideAbilitySplash(battler)
  }
)

Battle::AbilityEffects::ChangeOnBattlerFainting.copy(:POWEROFALCHEMY, :RECEIVER)

#===============================================================================
# OnBattlerFainting handlers
#===============================================================================

Battle::AbilityEffects::OnBattlerFainting.add(:SOULHEART,
  proc { |ability, battler, fainted, battle|
    battler.pbRaiseStatStageByAbility(:SPECIAL_ATTACK, 1, battler)
  }
)

#===============================================================================
# OnWeatherChange handlers
#===============================================================================

Battle::AbilityEffects::OnWeatherChange.add(:PROTOSYNTHESIS,
  proc { |ability, battler, battle, old_weather, ability_changed|
    next if battler.effects[PBEffects::BoosterEnergy]
    triggered = false
    consume_item = false
    if !battler.effects[PBEffects::Transform]
      if [:Sun, :HarshSun].include?(battle.pbWeather)
        triggered = true
      elsif battler.hasActiveItem?(:BOOSTERENERGY)
        triggered = true
        battle.pbCommonAnimation("UseItem", battler)
        consume_item = true
      end
    end
    if triggered
      best = nil
      GameData::Stat.each_main_battle do |stat|
        value = battler.stat_with_stages(stat.id)
        best = [stat.id, value] if !best || value > best[1]
      end
      battler.effects[PBEffects::ProtosynthesisStat] = best[0]
      battle.pbShowAbilitySplash(battler)
      if consume_item
        battle.pbDisplay(_INTL("{1}通过{2}发动了{3}！", battler.pbThis(true), battler.itemName, battler.abilityName))
      else
        battle.pbDisplay(_INTL("{1}通过大晴天发动了{2}！", battler.pbThis(true), battler.abilityName))
      end
      battle.pbDisplay(_INTL("{1}{2}升高了！", battler.pbOfThis, GameData::Stat.get(best[0]).name))
      battle.pbHideAbilitySplash(battler)
      battler.pbHeldItemTriggered(battler.item) if consume_item
    elsif battler.effects[PBEffects::ProtosynthesisStat]
      battler.effects[PBEffects::ProtosynthesisStat] = nil
      battle.pbDisplay(_INTL("{1}的效果消失了……", battler.abilityName))
    end
  }
)

#===============================================================================
# OnTerrainChange handlers
#===============================================================================

Battle::AbilityEffects::OnTerrainChange.add(:MIMICRY,
  proc { |ability, battler, battle, old_terrain, ability_changed|
    # Revert to original typing
    if battle.field.terrain == :None
      battle.pbShowAbilitySplash(battler)
      battler.pbResetTypes
      battle.pbDisplay(_INTL("{1}变回了原来的属性！", battler.pbThis))
      battle.pbHideAbilitySplash(battler)
      next
    end
    # Change to new typing
    terrain_hash = {
      :Electric => :ELECTRIC,
      :Grassy   => :GRASS,
      :Misty    => :FAIRY,
      :Psychic  => :PSYCHIC
    }
    new_type = terrain_hash[battle.field.terrain]
    new_type_name = nil
    if new_type
      type_data = GameData::Type.try_get(new_type)
      new_type = nil if !type_data
      new_type_name = type_data.name if type_data
    end
    next if !new_type
    battle.pbShowAbilitySplash(battler)
    battler.pbChangeTypes(new_type)
    battle.pbDisplay(_INTL("{1}变成了{2}属性！", battler.pbThis, new_type_name))
    battle.pbHideAbilitySplash(battler)
  }
)

Battle::AbilityEffects::OnTerrainChange.add(:QUARKDRIVE,
  proc { |ability, battler, battle, old_terrain, ability_changed|
    next if battler.effects[PBEffects::BoosterEnergy]
    triggered = false
    consume_item = false
    if !battler.effects[PBEffects::Transform]
      if battle.field.terrain == :Electric
        triggered = true
      elsif battler.hasActiveItem?(:BOOSTERENERGY)
        triggered = true
        battle.pbCommonAnimation("UseItem", battler)
        consume_item = true
      end
    end
    if triggered
      best = nil
      GameData::Stat.each_main_battle do |stat|
        value = battler.stat_with_stages(stat.id)
        best = [stat.id, value] if !best || value > best[1]
      end
      battler.effects[PBEffects::ProtosynthesisStat] = best[0]
      battler.effects[PBEffects::BoosterEnergy] = true if consume_item
      battle.pbShowAbilitySplash(battler)
      if consume_item
        battle.pbDisplay(_INTL("{1}通过{2}发动了{3}！", battler.pbThis(true), battler.itemName, battler.abilityName))
      else
        battle.pbDisplay(_INTL("{1}通过电气场地发动了{2}！", battler.pbThis(true), battler.abilityName))
      end
      battle.pbDisplay(_INTL("{1}{2}升高了！", battler.pbOfThis, GameData::Stat.get(best[0]).name))
      battle.pbHideAbilitySplash(battler)
      battler.pbHeldItemTriggered(battler.item) if consume_item
    elsif battler.effects[PBEffects::ProtosynthesisStat]
      battler.effects[PBEffects::ProtosynthesisStat] = nil
      battle.pbDisplay(_INTL("{1}的效果消失了……", battler.abilityName))
    end
  }
)

#===============================================================================
# OnIntimidated handlers
#===============================================================================

Battle::AbilityEffects::OnIntimidated.add(:RATTLED,
  proc { |ability, battler, battle|
    next if Settings::MECHANICS_GENERATION < 8
    battler.pbRaiseStatStageByAbility(:SPEED, 1, battler)
  }
)

#===============================================================================
# CertainEscapeFromBattle handlers
#===============================================================================

Battle::AbilityEffects::CertainEscapeFromBattle.add(:RUNAWAY,
  proc { |ability, battler|
    next true
  }
)
