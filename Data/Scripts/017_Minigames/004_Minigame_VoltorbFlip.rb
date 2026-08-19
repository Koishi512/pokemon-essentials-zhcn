#===============================================================================
# "Voltorb Flip" mini-game.
# By KitsuneKouta.
#-------------------------------------------------------------------------------
# Run with:      pbVoltorbFlip
#===============================================================================
class VoltorbFlip
  GRAPHICS_DIRECTORY = "Graphics/UI/Voltorb Flip/"
  NUM_ROWS           = 5
  NUM_COLUMNS        = 5
  NUM_TILES          = NUM_ROWS * NUM_COLUMNS
  TILE_DISTRIBUTIONS = [   # Voltorbs, Twos, Threes, MaxFreePerRowOrCol, MaxFreeTotal
    # NOTE: The MaxFree values are not inclusive. The board will only be valid
    #       if the corresponding counts are strictly less than these values.
    # Level 1
    [
      [6, 3, 1, 3, 3],
      [6, 0, 3, 2, 2],
      [6, 5, 0, 3, 4],
      [6, 2, 2, 3, 3],
      [6, 4, 1, 3, 4]
    ],
    # Level 2
    [
      [7, 1, 3, 2, 3],
      [7, 6, 0, 3, 4],
      [7, 3, 2, 2, 3],
      [7, 0, 4, 2, 3],
      [7, 5, 1, 3, 4],
      [7, 1, 3, 2, 2],
      [7, 6, 0, 3, 3],
      [7, 3, 2, 2, 2],
      [7, 0, 4, 2, 2],
      [7, 5, 1, 3, 3]
    ],
    # Level 3
    [
      [8, 2, 3, 2, 3],
      [8, 7, 0, 3, 4],
      [8, 4, 2, 3, 4],
      [8, 1, 4, 2, 3],
      [8, 6, 1, 4, 3],
      [8, 2, 3, 2, 2],
      [8, 7, 0, 3, 3],
      [8, 4, 2, 3, 3],
      [8, 1, 4, 2, 2],
      [8, 6, 1, 3, 3]
    ],
    # Level 4
    [
      [8, 3, 3, 4, 3],
      [8, 0, 5, 2, 3],
      [10, 8, 0, 4, 5],
      [10, 5, 2, 3, 4],
      [10, 2, 4, 3, 4],
      [8, 3, 3, 3, 3],
      [8, 0, 5, 2, 2],
      [10, 8, 0, 4, 4],
      [10, 5, 2, 3, 3],
      [10, 2, 4, 3, 3]
    ],
    # Level 5
    [
      [10, 7, 1, 4, 5],
      [10, 4, 3, 3, 4],
      [10, 1, 5, 3, 4],
      [10, 9, 0, 4, 5],
      [10, 6, 2, 4, 5],
      [10, 7, 1, 4, 4],
      [10, 4, 3, 3, 3],
      [10, 1, 5, 3, 3],
      [10, 9, 0, 4, 4],
      [10, 6, 2, 4, 4]
    ],
    # Level 6
    [
      [10, 3, 4, 3, 4],
      [10, 0, 6, 3, 4],
      [10, 8, 1, 4, 5],
      [10, 5, 3, 4, 5],
      [10, 2, 5, 3, 4],
      [10, 3, 4, 3, 3],
      [10, 0, 6, 3, 3],
      [10, 8, 1, 4, 4],
      [10, 5, 3, 4, 4],
      [10, 2, 5, 3, 3]
    ],
    # Level 7
    [
      [10, 7, 2, 4, 5],
      [10, 4, 4, 4, 5],
      [13, 1, 6, 3, 4],
      [13, 9, 1, 5, 6],
      [10, 6, 3, 4, 5],
      [10, 7, 2, 4, 4],
      [10, 4, 4, 4, 4],
      [13, 1, 6, 3, 3],
      [13, 9, 1, 5, 5],
      [10, 6, 3, 4, 4]
    ],
    # Level 8
    [
      [10, 0, 7, 3, 4],
      [10, 8, 2, 5, 6],
      [10, 5, 4, 4, 5],
      [10, 2, 6, 4, 5],
      [10, 7, 3, 5, 6],
      [10, 0, 7, 3, 3],
      [10, 8, 2, 5, 5],
      [10, 5, 4, 4, 4],
      [10, 2, 6, 4, 4],
      [10, 7, 3, 5, 5]
    ]
  ]

  def update
    pbUpdateSpriteHash(@sprites)
  end

  def pbStart
    @level = 1
    @firstRound = true
    pbNewGame
  end

  def generate_board
    ret = []
    1000.times do |attempt|
      board_distro = TILE_DISTRIBUTIONS[@level - 1].sample
      # Randomly distribute tiles
      ret = [1] * NUM_TILES
      index = 0
      [0, 2, 3].each do |value|
        qty = board_distro[[value - 1, 0].max]
        qty.times do |i|
          ret[index] = value
          index += 1
        end
      end
      ret.shuffle!
      # Find how many Voltorbs are in each row/column
      row_voltorbs = [0] * NUM_ROWS
      col_voltorbs = [0] * NUM_COLUMNS
      ret.each_with_index do |val, i|
        next if val != 0
        row_voltorbs[i / NUM_COLUMNS] += 1
        col_voltorbs[i % NUM_COLUMNS] += 1
      end
      # Count the number of x2 and x3 tiles are free (i.e. no Voltorbs in its row/column)
      free_multipliers = 0
      free_row = [0] * NUM_ROWS
      free_col = [0] * NUM_COLUMNS
      ret.each_with_index do |val, i|
        next if val <= 1
        next if row_voltorbs[i / NUM_COLUMNS] > 0 && col_voltorbs[i % NUM_COLUMNS] > 0
        free_multipliers += 1
        free_row[i / NUM_COLUMNS] += 1
        free_col[i % NUM_COLUMNS] += 1
      end
      # Regnerate board if there are too many free multiplier tiles
      next if free_multipliers >= board_distro[4]
      next if free_row.any? { |i| i >= board_distro[3] }
      next if free_col.any? { |i| i >= board_distro[3] }
      # Board is valid; use it
      break
    end
    return ret
  end

  def pbNewGame
    # Initialize variables
    @sprites = {}
    @cursor = []
    @marks = []
    @coins = []
    @numbers = []
    @voltorbNumbers = []
    @points = 0
    @index = [0, 0]
    @squares = []   # Each square is [x, y, points, revealed]
    # Generate a board
    squareValues = generate_board
    # Apply the generated board
    squareValues.each_with_index do |val, i|
      @squares[i] = [((i % NUM_COLUMNS) * 64) + 128, (i / NUM_COLUMNS).abs * 64, val, false]
    end
    pbCreateSprites
    # Display numbers (all zeroes, as no values have been calculated yet)
    NUM_ROWS.times { |i| pbUpdateRowNumbers(0, 0, i) }
    NUM_COLUMNS.times { |i| pbUpdateColumnNumbers(0, 0, i) }
    pbDrawShadowText(@sprites["text"].bitmap, 8, 22, 118, 26,
                     _INTL("你的代币"), Color.new(60, 60, 60), Color.new(150, 190, 170), 1)
    pbDrawShadowText(@sprites["text"].bitmap, 8, 88, 118, 26,
                     _INTL("奖励代币"), Color.new(60, 60, 60), Color.new(150, 190, 170), 1)
    # Draw current level
    pbDrawShadowText(@sprites["level"].bitmap, 8, 154, 118, 28,
                     _INTL("等级{1}", @level.to_s), Color.new(60, 60, 60), Color.new(150, 190, 170), 1)
    # Displays total and current coins
    pbUpdateCoins
    # Draw curtain effect
    if @firstRound
      curtain_duration = 0.5
      timer_start = System.uptime
      loop do
        @sprites["curtainL"].angle = lerp(-90, -180, curtain_duration, timer_start, System.uptime)
        @sprites["curtainR"].angle = lerp(0, 90, curtain_duration, timer_start, System.uptime)
        Graphics.update
        Input.update
        update
        break if @sprites["curtainL"].angle <= -180
      end
    end
    @sprites["curtainL"].visible = false
    @sprites["curtainR"].visible = false
    @sprites["curtain"].opacity = 100
    if $player.coins >= Settings::MAX_COINS
      pbMessage(_INTL("你已得到{1}枚代币，无法继续获得了。", Settings::MAX_COINS.to_s_formatted))
      $player.coins = Settings::MAX_COINS   # As a precaution
      @quit = true
    else
      loop do
        case pbMessage(_INTL("要玩{1}级翻霹雳电球卡牌吗？", @level), [_INTL("游玩"), _INTL("游戏信息"), _INTL("退出")], 3)
        when 0 # Play
          break
        when 1 # Game Info
          display_game_info
        else # Quit
          @quit = true
          return
        end
      end
      @sprites["curtain"].opacity = 0
      # Erase 0s to prepare to replace with values
      @sprites["numbers"].bitmap.clear
      # Reset arrays to empty
      @voltorbNumbers = []
      @numbers = []
      # Draw numbers for each row (precautionary)
      NUM_ROWS.times do |j|
        num = 0
        voltorbs = 0
        NUM_COLUMNS.times do |i|
          val = @squares[i + (j * NUM_COLUMNS)][2]
          num += val
          voltorbs += 1 if val == 0
        end
        pbUpdateRowNumbers(num, voltorbs, j)
      end
      # Reset arrays to empty
      @voltorbNumbers = []
      @numbers = []
      # Draw numbers for each column
      NUM_COLUMNS.times do |i|
        num = 0
        voltorbs = 0
        NUM_ROWS.times do |j|
          val = @squares[i + (j * NUM_COLUMNS)][2]
          num += val
          voltorbs += 1 if val == 0
        end
        pbUpdateColumnNumbers(num, voltorbs, i)
      end
    end
  end

  def display_game_info
    loop do
      case pbMessage(_INTL("要查看哪组信息？"), [_INTL("游戏说明"), _INTL("提示!"),_INTL("关于备忘录"),_INTL("返回")], 4)
      when 0
        pbMessage(_INTL("翻霹雳电球卡牌是一款翻开卡片来找到隐藏在下面的数字的游戏。"))
        pbMessage(_INTL("这些卡片隐藏着数字1到3...以及霹雳电球。"))
        pbMessage(_INTL("你翻开的第一张卡片会给你相应数量的代币。"))
        pbMessage(_INTL("从那以后，你找到的下一个数字会将你已收集的代币总数乘以该数字。"))
        pbMessage(_INTL("如果是2，你的总数将乘以\"×2\"。"))
        pbMessage(_INTL("如果是3，你的总数将乘以\"×3\"。"))
        pbMessage(_INTL("但如果翻开的是霹雳电球，游戏就结束了。"))
        pbMessage(_INTL("当这种情况发生时，你会失去在当前游戏中收集的所有代币。"))
        pbMessage(_INTL("如果你选择\"退出\"，你将退出游戏。"))
        pbMessage(_INTL("如果你到了一个困难的地方，你可能想要提前结束游戏。"))
        pbMessage(_INTL("一旦你找到了所有隐藏的2和3卡片，你就清除了游戏。"))
        pbMessage(_INTL("一旦你翻开了所有这些卡片，你就会进入下一个等级。"))
        pbMessage(_INTL("随着你在等级上的提升，你将能够获得更多的代币。"))
        pbMessage(_INTL("尽你最大的努力！"))
      when 1
        pbMessage(_INTL("棋盘侧面的数字能为你提供关于面板背面隐藏数字的线索。"))
        pbMessage(_INTL("数字越大，该行或该列中隐藏着许多大数字的可能性就越大。"))
        pbMessage(_INTL("同样地，你也可以判断出行或列中隐藏的霹雳电球数量。"))
        pbMessage(_INTL("在翻开面板时，要仔细考虑隐藏数字的总数和霹雳电球的总数。"))
      when 2
        pbMessage(_INTL("使用行动按钮在卡片上标记霹雳电球符号。"))
        pbMessage(_INTL("当你对卡片背面是否隐藏着霹雳电球有想法时，就标记这张卡片。"))
        pbMessage(_INTL("如果想要移除标记，再次标记该卡片，它就会消失。"))
      else
        return
      end
    end
  end

  def pbCreateSprites
    @viewport = Viewport.new(0, 0, Graphics.width, Graphics.height)
    @viewport.z = 99999
    @sprites["bg"] = Sprite.new(@viewport)
    @sprites["bg"].bitmap = RPG::Cache.load_bitmap(GRAPHICS_DIRECTORY, _INTL("Voltorb Flip bg"))
    @sprites["text"] = BitmapSprite.new(Graphics.width, Graphics.height, @viewport)
    pbSetSystemFont(@sprites["text"].bitmap)
    @sprites["level"] = BitmapSprite.new(Graphics.width, Graphics.height, @viewport)
    pbSetSystemFont(@sprites["level"].bitmap)
    @sprites["curtain"] = BitmapSprite.new(Graphics.width, Graphics.height, @viewport)
    @sprites["curtain"].z = 99999
    @sprites["curtain"].bitmap.fill_rect(0, 0, Graphics.width, Graphics.height, Color.black)
    @sprites["curtain"].opacity = 0
    @sprites["curtainL"] = BitmapSprite.new(Graphics.width, Graphics.height, @viewport)
    @sprites["curtainL"].z = 99999
    @sprites["curtainL"].x = Graphics.width / 2
    @sprites["curtainL"].angle = -90
    @sprites["curtainL"].bitmap.fill_rect(0, 0, Graphics.width, Graphics.height, Color.black)
    @sprites["curtainR"] = BitmapSprite.new(Graphics.width, Graphics.height * 2, @viewport)
    @sprites["curtainR"].z = 99999
    @sprites["curtainR"].x = Graphics.width / 2
    @sprites["curtainR"].bitmap.fill_rect(0, 0, Graphics.width, Graphics.height * 2, Color.black)
    @sprites["cursor"] = BitmapSprite.new(Graphics.width, Graphics.height, @viewport)
    @sprites["cursor"].z = 99998
    @sprites["icon"] = BitmapSprite.new(Graphics.width, Graphics.height, @viewport)
    @sprites["icon"].z = 99997
    @sprites["mark"] = BitmapSprite.new(Graphics.width, Graphics.height, @viewport)
    @sprites["memo"] = Sprite.new(@viewport)
    @sprites["memo"].bitmap = RPG::Cache.load_bitmap(GRAPHICS_DIRECTORY, _INTL("memo"))
    @sprites["memo"].x = 10
    @sprites["memo"].y = 244
    @sprites["memo"].visible = false
    @sprites["numbers"] = BitmapSprite.new(Graphics.width, Graphics.height, @viewport)
    @sprites["totalCoins"] = BitmapSprite.new(Graphics.width, Graphics.height, @viewport)
    @sprites["currentCoins"] = BitmapSprite.new(Graphics.width, Graphics.height, @viewport)
    @sprites["animation"] = BitmapSprite.new(Graphics.width, Graphics.height, @viewport)
    @sprites["animation"].z = 99999
    6.times do |i|
      @sprites[i] = BitmapSprite.new(Graphics.width, Graphics.height, @viewport)
      @sprites[i].z = 99996
      @sprites[i].visible = false
    end
    # Creates images ahead of time for the display-all animation (reduces lag)
    icons = []
    points = 0
    3.times do |i|
      NUM_TILES.times do |j|
        points = @squares[j][2] if i == 2
        icons[j] = [GRAPHICS_DIRECTORY + "tiles", @squares[j][0], @squares[j][1], 320 + (i * 64) + (points * 64), 0, 64, 64]
      end
      icons.compact!
      pbDrawImagePositions(@sprites[i].bitmap, icons)
    end
    icons = []
    NUM_TILES.times do |i|
      icons[i] = [GRAPHICS_DIRECTORY + "tiles", @squares[i][0], @squares[i][1], @squares[i][2] * 64, 0, 64, 64]
    end
    pbDrawImagePositions(@sprites[5].bitmap, icons)
    # Default cursor image
    @cursor[0] = [GRAPHICS_DIRECTORY + "cursor", 0 + 128, 0, 0, 0, 64, 64]
  end

  def getInput
    if Input.trigger?(Input::UP)
      pbPlayCursorSE
      if @index[1] > 0
        @index[1] -= 1
        @sprites["cursor"].y -= 64
      else
        @index[1] = 4
        @sprites["cursor"].y = 256
      end
    elsif Input.trigger?(Input::DOWN)
      pbPlayCursorSE
      if @index[1] < 4
        @index[1] += 1
        @sprites["cursor"].y += 64
      else
        @index[1] = 0
        @sprites["cursor"].y = 0
      end
    elsif Input.trigger?(Input::LEFT)
      pbPlayCursorSE
      if @index[0] > 0
        @index[0] -= 1
        @sprites["cursor"].x -= 64
      else
        @index[0] = 4
        @sprites["cursor"].x = 256
      end
    elsif Input.trigger?(Input::RIGHT)
      pbPlayCursorSE
      if @index[0] < 4
        @index[0] += 1
        @sprites["cursor"].x += 64
      else
        @index[0] = 0
        @sprites["cursor"].x = 0
      end
    elsif Input.trigger?(Input::USE)
      if @cursor[0][3] == 64   # If in mark mode
        @squares.length.times do |i|
          if (@index[0] * 64) + 128 == @squares[i][0] && @index[1] * 64 == @squares[i][1] && @squares[i][3] == false
            pbSEPlay("Voltorb Flip mark")
          end
        end
        (@marks.length + 1).times do |i|
          if @marks[i].nil?
            @marks[i] = [GRAPHICS_DIRECTORY + "tiles", (@index[0] * 64) + 128, @index[1] * 64, 256, 0, 64, 64]
          elsif @marks[i][1] == (@index[0] * 64) + 128 && @marks[i][2] == @index[1] * 64
            @marks.delete_at(i)
            @marks.compact!
            @sprites["mark"].bitmap.clear
            break
          end
        end
        pbDrawImagePositions(@sprites["mark"].bitmap, @marks)
        pbWait(0.05)
      else
        # Display the tile for the selected spot
        icons = []
        @squares.length.times do |i|
          if (@index[0] * 64) + 128 == @squares[i][0] && @index[1] * 64 == @squares[i][1] && @squares[i][3] == false
            pbAnimateTile((@index[0] * 64) + 128, @index[1] * 64, @squares[i][2])
            @squares[i][3] = true
            # If Voltorb (0), display all tiles on the board
            if @squares[i][2] == 0
              pbSEPlay("Voltorb Flip explosion")
              # Play explosion animation
              # Part1
              animation = []
              3.times do |j|
                animation[0] = icons[0] = [GRAPHICS_DIRECTORY + "tiles", (@index[0] * 64) + 128, @index[1] * 64,
                                           704 + (64 * j), 0, 64, 64]
                pbDrawImagePositions(@sprites["animation"].bitmap, animation)
                pbWait(0.05)
                @sprites["animation"].bitmap.clear
              end
              # Part2
              animation = []
              6.times do |j|
                animation[0] = [GRAPHICS_DIRECTORY + "explosion", (@index[0] * 64) - 32 + 128, (@index[1] * 64) - 32,
                                j * 128, 0, 128, 128]
                pbDrawImagePositions(@sprites["animation"].bitmap, animation)
                pbWait(0.1)
                @sprites["animation"].bitmap.clear
              end
              # Unskippable text block, parameter 2 = wait time (corresponds to ME length)
              pbMessage("\\me[Voltorb Flip game over]" + _INTL("不！你一枚代币都没得到！") + "\\wtnp[80]")
              pbShowAndDispose
              @sprites["mark"].bitmap.clear
              if @level > 1
                # Determine how many levels to reduce by
                newLevel = @squares.count { |tile| tile[3] && tile[2] > 0 }
                newLevel = newLevel.clamp(1, @level)
                if newLevel < @level
                  @level = newLevel
                  pbMessage("\\se[Voltorb Flip level down]" + _INTL("游戏下降到{1}级！", @level.to_s) + "\\wtnp[20]")
                end
              end
              # Update level text
              @sprites["level"].bitmap.clear
              pbDrawShadowText(@sprites["level"].bitmap, 8, 154, 118, 28, "Level " + @level.to_s,
                               Color.new(60, 60, 60), Color.new(150, 190, 170), 1)
              @points = 0
              pbUpdateCoins
              # Revert numbers to 0s
              @sprites["numbers"].bitmap.clear
              NUM_ROWS.times { |j| pbUpdateRowNumbers(0, 0, j) }
              NUM_COLUMNS.times { |j| pbUpdateColumnNumbers(0, 0, j) }
              pbDisposeSpriteHash(@sprites)
              @firstRound = false
              pbNewGame
            else
              # Play tile animation
              animation = []
              4.times do |j|
                animation[0] = [GRAPHICS_DIRECTORY + "flipAnimation", (@index[0] * 64) - 14 + 128, (@index[1] * 64) - 16,
                                j * 92, 0, 92, 96]
                pbDrawImagePositions(@sprites["animation"].bitmap, animation)
                pbWait(0.05)
                @sprites["animation"].bitmap.clear
              end
              if @points == 0
                @points += @squares[i][2]
                pbSEPlay("Voltorb Flip point")
              elsif @squares[i][2] > 1
                @points *= @squares[i][2]
                pbSEPlay("Voltorb Flip point")
              end
              break
            end
          end
        end
      end
      count = 0
      @squares.length.times do |i|
        count += 1 if @squares[i][3] == false && @squares[i][2] > 1
      end
      pbUpdateCoins
      # Game cleared
      if count == 0
        @sprites["curtain"].opacity = 100
        pbMessage("\\me[Voltorb Flip win]" + _INTL("游戏胜利！") + "\\wtnp[40]")
#        pbMessage(_INTL("你已经找到所有的x2和x3卡牌了。"))
#        pbMessage(_INTL("也就是说你已经找到游戏里的所有代币了，所以游戏结束。"))
        pbMessage("\\se[Voltorb Flip gain coins]" + _INTL("{1}得到了{2}枚代币！", $player.name, @points.to_s_formatted) + "\\wtnp[10]")
        # Update level text
        @sprites["level"].bitmap.clear
        pbDrawShadowText(@sprites["level"].bitmap, 8, 154, 118, 28, _INTL("等级{1}", @level.to_s),
                         Color.new(60, 60, 60), Color.new(150, 190, 170), 1)
        old_coins = $player.coins
        $player.coins += @points
        $stats.coins_won += $player.coins - old_coins if $player.coins > old_coins
        @points = 0
        pbUpdateCoins
        @sprites["curtain"].opacity = 0
        pbShowAndDispose
        # Revert numbers to 0s
        @sprites["numbers"].bitmap.clear
        NUM_ROWS.times { |i| pbUpdateRowNumbers(0, 0, i) }
        NUM_COLUMNS.times { |i| pbUpdateColumnNumbers(0, 0, i) }
        @sprites["curtain"].opacity = 100
        if @level < 8
          @level += 1
          pbMessage("\\se[Voltorb Flip level up]" + _INTL("游戏上升到了{1}级！", @level.to_s) + "\\wtnp[10]")
          if @firstRound
#            pbMessage(_INTL("恭喜！"))
#            pbMessage(_INTL("下次游戏你可以得到更多的代币！"))
            @firstRound = false
          end
        end
        pbDisposeSpriteHash(@sprites)
        pbNewGame
      end
    elsif Input.trigger?(Input::ACTION)
      pbPlayDecisionSE
      @sprites["cursor"].bitmap.clear
      if @cursor[0][3] == 0   # If in normal mode
        @cursor[0] = [GRAPHICS_DIRECTORY + "cursor", 128, 0, 64, 0, 64, 64]
        @sprites["memo"].visible = true
      else   # Mark mode
        @cursor[0] = [GRAPHICS_DIRECTORY + "cursor", 128, 0, 0, 0, 64, 64]
        @sprites["memo"].visible = false
      end
    elsif Input.trigger?(Input::BACK)
      @sprites["curtain"].opacity = 100
      if @points == 0
        if pbConfirmMessage(_INTL("你还没有找到任何代币！你确定要退出吗？"))
          @sprites["curtain"].opacity = 0
          pbShowAndDispose
          @quit = true
        end
      elsif pbConfirmMessage(_INTL("如果你现在退出，你可以得到{1}枚代币。你要退出吗？",
                                   @points.to_s_formatted))
        pbMessage(_INTL("{1}得到了{2}枚代币！", $player.name, @points.to_s_formatted))
        old_coins = $player.coins
        $player.coins += @points
        $stats.coins_won += $player.coins - old_coins if $player.coins > old_coins
        @points = 0
        pbUpdateCoins
        @sprites["curtain"].opacity = 0
        pbShowAndDispose
        @quit = true
      end
      @sprites["curtain"].opacity = 0
    end
    # Draw cursor
    pbDrawImagePositions(@sprites["cursor"].bitmap, @cursor)
  end

  def pbUpdateRowNumbers(num, voltorbs, i)
    numText = sprintf("%02d", num)
    numText.chars.each_with_index do |digit, j|
      @numbers[j] = [GRAPHICS_DIRECTORY + "numbersSmall", 472 + (j * 16), 8 + (i * 64), digit.to_i * 16, 0, 16, 16]
    end
    @voltorbNumbers[i] = [GRAPHICS_DIRECTORY + "numbersSmall", 488, 34 + (i * 64), voltorbs * 16, 0, 16, 16]
    # Display the numbers
    pbDrawImagePositions(@sprites["numbers"].bitmap, @numbers)
    pbDrawImagePositions(@sprites["numbers"].bitmap, @voltorbNumbers)
  end

  def pbUpdateColumnNumbers(num, voltorbs, i)
    numText = sprintf("%02d", num)
    numText.chars.each_with_index do |digit, j|
      @numbers[j] = [GRAPHICS_DIRECTORY + "numbersSmall", 152 + (i * 64) + (j * 16), 328, digit.to_i * 16, 0, 16, 16]
    end
    @voltorbNumbers[i] = [GRAPHICS_DIRECTORY + "numbersSmall", 168 + (i * 64), 354, voltorbs * 16, 0, 16, 16]
    # Display the numbers
    pbDrawImagePositions(@sprites["numbers"].bitmap, @numbers)
    pbDrawImagePositions(@sprites["numbers"].bitmap, @voltorbNumbers)
  end

  def pbCreateCoins(source, y)
    coinText = sprintf("%05d", source)
    coinText.chars.each_with_index do |digit, i|
      @coins[i] = [GRAPHICS_DIRECTORY + "numbersScore", 6 + (i * 24), y, digit.to_i * 24, 0, 24, 38]
    end
  end

  def pbUpdateCoins
    # Update coins display
    @sprites["totalCoins"].bitmap.clear
    pbCreateCoins($player.coins, 46)
    pbDrawImagePositions(@sprites["totalCoins"].bitmap, @coins)
    # Update points display
    @sprites["currentCoins"].bitmap.clear
    pbCreateCoins(@points, 112)
    pbDrawImagePositions(@sprites["currentCoins"].bitmap, @coins)
  end

  def pbAnimateTile(x, y, tile)
    icons = []
    points = 0
    3.times do |i|
      points = tile if i == 2
      icons[i] = [GRAPHICS_DIRECTORY + "tiles", x, y, 320 + (i * 64) + (points * 64), 0, 64, 64]
      pbDrawImagePositions(@sprites["icon"].bitmap, icons)
      pbWait(0.05)
    end
    icons[3] = [GRAPHICS_DIRECTORY + "tiles", x, y, tile * 64, 0, 64, 64]
    pbDrawImagePositions(@sprites["icon"].bitmap, icons)
    pbSEPlay("Voltorb Flip tile")
  end

  def pbShowAndDispose
    # Make pre-rendered sprites visible (this approach reduces lag)
    5.times do |i|
      @sprites[i].visible = true
      pbWait(0.05) if i < 3
      @sprites[i].bitmap.clear
      @sprites[i].z = 99997
    end
    pbSEPlay("Voltorb Flip tile")
    @sprites[5].visible = true
    @sprites["mark"].bitmap.clear
    pbWait(0.1)
    # Wait for user input to continue
    loop do
      Graphics.update
      Input.update
      update
      if Input.trigger?(Input::USE) || Input.trigger?(Input::BACK)
        break
      end
    end
    # "Dispose" of tiles by column
    NUM_COLUMNS.times do |i|
      icons = []
      pbSEPlay("Voltorb Flip tile")
      NUM_ROWS.times do |j|
        icons[j] = [GRAPHICS_DIRECTORY + "tiles", @squares[i + (j * NUM_COLUMNS)][0], @squares[i + (j * NUM_COLUMNS)][1],
                    448 + (@squares[i + (j * NUM_COLUMNS)][2] * 64), 0, 64, 64]
      end
      pbDrawImagePositions(@sprites[i].bitmap, icons)
      pbWait(0.05)
      NUM_ROWS.times do |j|
        icons[j] = [GRAPHICS_DIRECTORY + "tiles", @squares[i + (j * NUM_COLUMNS)][0], @squares[i + (j * NUM_COLUMNS)][1],
                    384, 0, 64, 64]
      end
      pbDrawImagePositions(@sprites[i].bitmap, icons)
      pbWait(0.05)
      NUM_ROWS.times do |j|
        icons[j] = [GRAPHICS_DIRECTORY + "tiles", @squares[i + (j * NUM_COLUMNS)][0], @squares[i + (j * NUM_COLUMNS)][1],
                    320, 0, 64, 64]
      end
      pbDrawImagePositions(@sprites[i].bitmap, icons)
      pbWait(0.05)
      NUM_ROWS.times do |j|
        icons[j] = [GRAPHICS_DIRECTORY + "tiles", @squares[i + (j * NUM_COLUMNS)][0], @squares[i + (j * NUM_COLUMNS)][1],
                    896, 0, 64, 64]
      end
      pbDrawImagePositions(@sprites[i].bitmap, icons)
      pbWait(0.05)
    end
    @sprites["icon"].bitmap.clear
    6.times do |i|
      @sprites[i].bitmap.clear
    end
    @sprites["cursor"].bitmap.clear
  end

#  def pbWaitText(msg, frames)
#    msgwindow = pbCreateMessageWindow
#    pbMessageDisplay(msgwindow, msg)
#    pbWait(frames / 20.0)
#    pbDisposeMessageWindow(msgwindow)
#  end

  def pbEndScene
    @sprites["curtainL"].angle = -180
    @sprites["curtainR"].angle = 90
    # Draw curtain effect
    @sprites["curtainL"].visible = true
    @sprites["curtainR"].visible = true
    curtain_duration = 0.25
    timer_start = System.uptime
    loop do
      @sprites["curtainL"].angle = lerp(-180, -90, curtain_duration, timer_start, System.uptime)
      @sprites["curtainR"].angle = lerp(90, 0, curtain_duration, timer_start, System.uptime)
      Graphics.update
      Input.update
      update
      break if @sprites["curtainL"].angle >= -90
    end
    pbFadeOutAndHide(@sprites) { update }
    pbDisposeSpriteHash(@sprites)
    @viewport.dispose
  end

  def pbScene
    loop do
      Graphics.update
      Input.update
      getInput
      break if @quit
    end
  end
end

#===============================================================================
#
#===============================================================================
class VoltorbFlipScreen
  def initialize(scene)
    @scene = scene
  end

  def pbStartScreen
    @scene.pbStart
    @scene.pbScene
    @scene.pbEndScene
  end
end

#===============================================================================
#
#===============================================================================
def pbVoltorbFlip
  if !$bag.has?(:COINCASE)
    pbMessage(_INTL("你没有代币盒，无法游玩！"))
  elsif $player.coins == Settings::MAX_COINS
    pbMessage(_INTL("你的代币盒满了！"))
  else
    scene = VoltorbFlip.new
    screen = VoltorbFlipScreen.new(scene)
    screen.pbStartScreen
  end
end
