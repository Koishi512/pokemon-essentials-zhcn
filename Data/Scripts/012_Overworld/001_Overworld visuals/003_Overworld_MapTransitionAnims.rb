#===============================================================================
# Entering/exiting cave animations
#===============================================================================
def pbCaveEntranceEx(exiting)
  # Create bitmap
  sprite = BitmapSprite.new(Graphics.width, Graphics.height)
  sprite.z = 100000
  # Define values used for the animation
  duration = 0.4
  totalBands = 15
  bandheight = ((Graphics.height / 2.0) - 10) / totalBands
  bandwidth  = ((Graphics.width / 2.0) - 12) / totalBands
  start_gray = (exiting) ? 0 : 255
  end_gray = (exiting) ? 255 : 0
  # Create initial array of band colors (black if exiting, white if entering)
  grays = Array.new(totalBands) { |i| start_gray }
  # Animate bands changing color
  timer_start = System.uptime
  until System.uptime - timer_start >= duration
    x = 0
    y = 0
    # Calculate color of each band
    totalBands.times do |k|
      grays[k] = lerp(start_gray, end_gray, duration, timer_start + (k * duration / totalBands), System.uptime)
    end
    # Draw gray rectangles
    rectwidth  = Graphics.width
    rectheight = Graphics.height
    totalBands.times do |i|
      currentGray = grays[i]
      sprite.bitmap.fill_rect(Rect.new(x, y, rectwidth, rectheight),
                              Color.new(currentGray, currentGray, currentGray))
      x += bandwidth
      y += bandheight
      rectwidth  -= bandwidth * 2
      rectheight -= bandheight * 2
    end
    Graphics.update
    Input.update
  end
  # Set the tone at end of band animation
  if exiting
    pbToneChangeAll(Tone.new(255, 255, 255), 0)
  else
    pbToneChangeAll(Tone.new(-255, -255, -255), 0)
  end
  # Animate fade to white (if exiting) or black (if entering)
  timer_start = System.uptime
  loop do
    sprite.color = Color.new(end_gray, end_gray, end_gray,
                             lerp(0, 255, duration, timer_start, System.uptime))
    Graphics.update
    Input.update
    break if sprite.color.alpha >= 255
  end
  # Set the tone at end of fading animation
  pbToneChangeAll(Tone.new(0, 0, 0), 8)
  # Pause briefly
  timer_start = System.uptime
  until System.uptime - timer_start >= 0.1
    Graphics.update
    Input.update
  end
  sprite.dispose
end

def pbCaveEntrance
  pbSetEscapePoint
  pbCaveEntranceEx(false)
end

def pbCaveExit
  pbEraseEscapePoint
  pbCaveEntranceEx(true)
end

#===============================================================================
# Blacking out animation
#===============================================================================
def pbStartOver(game_over = false)
  if pbInBugContest?
    pbBugContestStartOver
    return
  end
  $stats.blacked_out_count += 1
  $player.heal_party
  if $PokemonGlobal.pokecenterMapId && $PokemonGlobal.pokecenterMapId >= 0
    if game_over
      pbMessage("\\w[]\\wm\\c[8]\\l[3]" +
                _INTL("不幸的战败后，你匆匆跑到一家宝可梦中心。"))
    elsif $player.all_fainted?
      pbMessage("\\w[]\\wm\\c[8]\\l[3]" +
                _INTL("你一边保护着精疲力尽动弹不得的宝可梦，一边急匆匆地赶往宝可梦中心……"))
    else   # Forfeited a trainer battle
      pbMessage("\\w[]\\wm\\c[8]\\l[3]" +
                _INTL("你为了重新制定战略而逃进了宝可梦中心……"))
    end
    pbCancelVehicles
    Followers.clear
    $game_switches[Settings::STARTING_OVER_SWITCH] = true
    $game_temp.player_new_map_id    = $PokemonGlobal.pokecenterMapId
    $game_temp.player_new_x         = $PokemonGlobal.pokecenterX
    $game_temp.player_new_y         = $PokemonGlobal.pokecenterY
    $game_temp.player_new_direction = $PokemonGlobal.pokecenterDirection
    pbDismountBike
    $scene.transfer_player if $scene.is_a?(Scene_Map)
    $game_map.refresh
  else
    homedata = GameData::PlayerMetadata.get($player.character_ID)&.home
    homedata = GameData::Metadata.get.home if !homedata
    if homedata && !Game_Map.map_data_exists?(homedata[0])
      if $DEBUG
        pbMessage(_ISPRINTF("在数据文件夹中找不到地图“Map{1:03d}”。游戏将在玩家所在的位置重新开始。", homedata[0]))
      end
      $player.heal_party
      return
    end
    if game_over
      pbMessage("\\w[]\\wm\\c[8]\\l[3]" +
                _INTL("不幸的战败后，你匆匆跑回了家。"))
    elsif $player.all_fainted?
      pbMessage("\\w[]\\wm\\c[8]\\l[3]" +
                _INTL("你匆匆跑回了家，保护着精疲力竭的宝可梦免受进一步的伤害……"))
    else   # Forfeited a trainer battle
      pbMessage("\\w[]\\wm\\c[8]\\l[3]" +
                _INTL("你为了重新制定战略而逃回了家……"))
    end
    if homedata
      pbCancelVehicles
      Followers.clear
      $game_switches[Settings::STARTING_OVER_SWITCH] = true
      $game_temp.player_new_map_id    = homedata[0]
      $game_temp.player_new_x         = homedata[1]
      $game_temp.player_new_y         = homedata[2]
      $game_temp.player_new_direction = homedata[3]
      pbDismountBike
      $scene.transfer_player if $scene.is_a?(Scene_Map)
      $game_map.refresh
    else
      $player.heal_party
    end
  end
  pbEraseEscapePoint
end
