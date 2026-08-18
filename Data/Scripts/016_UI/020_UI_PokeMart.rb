#===============================================================================
#
#===============================================================================
class UI::MartStockWrapper
  def initialize(stock)
    @stock = stock
    refresh
  end

  def length
    return @stock.length
  end

  def [](index)
    return @stock[index]
  end

  def money
    return $player.money
  end

  def buy_price(item)
    return 0 if item.nil?
    if $game_temp.mart_prices && $game_temp.mart_prices[item]
      return $game_temp.mart_prices[item][0] if $game_temp.mart_prices[item][0] > 0
    end
    return GameData::Item.get(item).price
  end

  def buy_price_string(item)
    price = buy_price(item)
    return _INTL("${1}", price.to_s_formatted)
  end

  def sell_price(item)
    return 0 if item.nil?
    if $game_temp.mart_prices && $game_temp.mart_prices[item]
      return $game_temp.mart_prices[item][1] if $game_temp.mart_prices[item][1] >= 0
    end
    return GameData::Item.get(item).sell_price
  end

  def stock_quantity(item)
    return -1
  end

  def maximum_affordable_quantity(item)
    item_price = buy_price(item)
    return 0 if money < item_price
    return 1 if GameData::Item.get(item).is_important?
    max_quantity = (item_price <= 0) ? PokemonBag::MAX_PER_SLOT : money / item_price
    max_quantity = [max_quantity, PokemonBag::MAX_PER_SLOT].min
    max_stock = stock_quantity(item)
    max_quantity = [max_quantity, max_stock].min if max_stock > 0
    return max_quantity
  end

  def remove_from_stock(item, quantity)
  end

  def refresh
    @stock.delete_if { |itm| GameData::Item.get(itm).is_important? && $bag.has?(itm) }
  end
end

#===============================================================================
# Pokémon Mart.
#===============================================================================
class UI::MartVisualsList < Window_DrawableCommand
  attr_accessor :expensive_base_color, :expensive_shadow_color

  def initialize(stock, x, y, width, height, screen, viewport = nil)
    @stock = stock
    super(x, y, width, height, viewport)
    @selarrow    = AnimatedBitmap.new(bag_folder + "cursor")
    @baseColor   = screen.get_text_color_theme(:gray)[0]
    @shadowColor = screen.get_text_color_theme(:gray)[1]
    self.windowskin = nil
  end

  #-----------------------------------------------------------------------------

  def itemCount
    return @stock.length + 1   # The extra 1 is the Cancel option
  end

  def bag_folder
    return UI::MartVisuals::UI_FOLDER + UI::MartVisuals::GRAPHICS_FOLDER
  end

  def item_id
    return (self.index >= @stock.length) ? nil : @stock[self.index]
  end

  def expensive?(this_item)
    return @stock.buy_price(this_item) > @stock.money
  end

  #-----------------------------------------------------------------------------

  # This draws all the visible options first, and then draws the cursor.
  def refresh
    @item_max = itemCount
    update_cursor_rect
    dwidth  = self.width - self.borderX
    dheight = self.height - self.borderY
    self.contents = pbDoEnsureBitmap(self.contents, dwidth, dheight)
    self.contents.clear
    @item_max.times do |i|
      next if i < self.top_item || i > self.top_item + self.page_item_max
      drawItem(i, @item_max, itemRect(i))
    end
    drawCursor(self.index, itemRect(self.index))
  end

  def drawItem(index, count, rect)
    rect = drawCursor(index, rect)
    this_item = @stock[index]
    if !this_item
      pbDrawShadowText(self.contents, rect.x, rect.y + 2, rect.width, rect.height,
                       _INTL("取消"), self.baseColor, self.shadowColor)
      return
    end
    # Draw item name
    item_name = GameData::Item.get(this_item).display_name
    pbDrawShadowText(self.contents, rect.x, rect.y + 2, rect.width, rect.height,
                     item_name, self.baseColor, self.shadowColor)
    # Draw item price
    price = @stock.buy_price_string(this_item)
    price_width = self.contents.text_size(price).width
    price_x = rect.x + rect.width - price_width - 2 - 16
    expensive = expensive?(this_item)
    price_base_color = (expensive) ? @expensive_base_color || self.baseColor : self.baseColor
    price_shadow_color = (expensive) ? @expensive_shadow_color || self.shadowColor : self.shadowColor
    pbDrawShadowText(self.contents, price_x, rect.y + 2, rect.width, rect.height,
                     price, price_base_color, price_shadow_color)
  end
end

#===============================================================================
#
#===============================================================================
class UI::MartVisuals < UI::BaseVisuals
  attr_reader :pocket

  GRAPHICS_FOLDER   = "Mart/"   # Subfolder in Graphics/UI
  TEXT_COLOR_THEMES = {   # Themes not in DEFAULT_TEXT_COLOR_THEMES
    :expensive => [Color.new(224, 0, 0), Color.new(248, 144, 144)]
  }
  ITEMS_VISIBLE = 7

  def initialize(stock, bag)
    @stock = stock
    @bag = bag
    super()
  end

  def initialize_sprites
    initialize_item_list
    initialize_item_sprites
    initialize_money_window
    initialize_bag_quantity_window
  end

  def initialize_item_list
    @sprites[:item_list] = UI::MartVisualsList.new(@stock, 152, 10, 374, 38 + (ITEMS_VISIBLE * 32), self, @viewport)
    @sprites[:item_list].expensive_base_color   = get_text_color_theme(:expensive)[0]
    @sprites[:item_list].expensive_shadow_color = get_text_color_theme(:expensive)[1]
    @sprites[:item_list].active                 = false
  end

  def initialize_item_sprites
    # Selected item's icon
    @sprites[:item_icon] = ItemIconSprite.new(48, Graphics.height - 48, nil, @viewport)
    # Selected item's description text box
    @sprites[:item_description] = Window_UnformattedTextPokemon.newWithSize(
      "", 80, 272, Graphics.width - 98, 128, @viewport
    )
    @sprites[:item_description].baseColor   = get_text_color_theme(:white)[0]
    @sprites[:item_description].shadowColor = get_text_color_theme(:white)[1]
    @sprites[:item_description].visible     = true
    @sprites[:item_description].windowskin  = nil
  end

  def initialize_money_window
    @sprites[:money_window] = Window_AdvancedTextPokemon.newWithSize("", 0, 0, 162, 96, @viewport)
    @sprites[:money_window].setSkin("Graphics/Windowskins/goldskin")
    @sprites[:money_window].baseColor      = get_text_color_theme(:gray)[0]
    @sprites[:money_window].shadowColor    = get_text_color_theme(:gray)[1]
    @sprites[:money_window].letterbyletter = false
    @sprites[:money_window].visible        = true
  end

  def initialize_bag_quantity_window
    @sprites[:bag_quantity_window] = Window_AdvancedTextPokemon.newWithSize(
      _INTL("包包里有：<r>{1}", @bag.quantity(item)), 0, 0, 162, 64, @viewport
    )
    @sprites[:bag_quantity_window].setSkin("Graphics/Windowskins/goldskin")
    @sprites[:bag_quantity_window].baseColor      = get_text_color_theme(:gray)[0]
    @sprites[:bag_quantity_window].shadowColor    = get_text_color_theme(:gray)[1]
    @sprites[:bag_quantity_window].letterbyletter = false
    @sprites[:bag_quantity_window].visible        = true
    @sprites[:bag_quantity_window].y              = Graphics.height - 102 - @sprites[:bag_quantity_window].height
  end

  #-----------------------------------------------------------------------------

  def index
    return @sprites[:item_list].index
  end

  def set_index(value)
    @sprites[:item_list].index = value
    refresh_on_index_changed(nil)
  end

  def item
    return @sprites[:item_list].item_id
  end

  def show_money_window
    @sprites[:money_window].visible = true
  end

  def hide_money_window
    @sprites[:money_window].visible = false
  end

  def show_bag_quantity_window
    @sprites[:bag_quantity_window].visible = true
  end

  def hide_bag_quantity_window
    @sprites[:bag_quantity_window].visible = false
  end

  #-----------------------------------------------------------------------------

  def refresh
    refresh_item_list
    refresh_selected_item
    refresh_money_window
  end

  def refresh_item_list
    @sprites[:item_list].refresh
  end

  def refresh_selected_item
    selected_item = item
    # Set the selected item's icon
    @sprites[:item_icon].item = selected_item
    # Set the selected item's description
    if selected_item
      @sprites[:item_description].text = GameData::Item.get(selected_item).description
    else
      @sprites[:item_description].text = _INTL("退出购物。")
    end
    refresh_bag_quantity_window
  end

  def refresh_bag_quantity_window
    @sprites[:bag_quantity_window].text = _INTL("包包里有：<r>{1}", @bag.quantity(item))
    (item) ? show_bag_quantity_window : hide_bag_quantity_window
  end

  def refresh_money_window
    @sprites[:money_window].text = _INTL("零花钱：\n<r>${1}", $player.money.to_s_formatted)
  end

  def refresh_on_index_changed(old_index)
    refresh_selected_item
  end

  #-----------------------------------------------------------------------------

  def update_input
    # Check for interaction
    if Input.trigger?(Input::USE)
      return update_interaction(Input::USE)
    elsif Input.trigger?(Input::BACK)
      return update_interaction(Input::BACK)
    end
    return nil
  end

  def update_interaction(input)
    case input
    when Input::USE
      if item
        pbPlayDecisionSE
        return :interact
      end
      pbPlayCloseMenuSE
      return :quit
    when Input::BACK
      pbPlayCloseMenuSE
      return :quit
    end
    return nil
  end

  def navigate
    @sprites[:item_list].active = true
    ret = super
    @sprites[:item_list].active = false
    return ret
  end
end

#===============================================================================
#
#===============================================================================
class UI::Mart < UI::BaseScreen
  attr_reader :stock, :bag

  ACTIONS = HandlerHash.new

  def initialize(stock, bag)
    pbScrollMap(6, 5, 5)   # Direction 6 (right), 5 tiles, speed 5 (cycling speed, 10 tiles/second)
    @bag = bag
    initialize_stock(stock)
    super()
  end

  def initialize_stock(stock)
    @stock = UI::MartStockWrapper.new(stock)
  end

  def initialize_visuals
    @visuals = UI::MartVisuals.new(@stock, @bag)
  end

  def start_screen
    pbSEPlay("GUI menu open")
  end

  def end_screen
    return if @disposed
    pbPlayCloseMenuSE
    silent_end_screen
    pbScrollMap(4, 5, 5)   # Direction 4 (left), 5 tiles, speed 5 (cycling speed, 10 tiles/second)
  end

  #-----------------------------------------------------------------------------

  def item_data
    return nil if @visuals.item.nil?
    return GameData::Item.get(@visuals.item)
  end

  #-----------------------------------------------------------------------------

  ACTIONS.add(:interact, {
    :effect => proc { |screen|
      item_data = screen.item_data
      item_price = screen.stock.buy_price(item_data.id)
      max_quantity = screen.stock.maximum_affordable_quantity(item_data.id)
      # Check affordability
      if max_quantity == 0
        screen.show_message(_INTL("您的钱不够呢！"))
        next
      end
      # Choose how many of the item to buy
      quantity = 1
      if item_data.is_important?
        next if !screen.show_confirm_message(
          _INTL("是{1}啊。\n一共${2}可以吗？",
                item_data.portion_name, item_price.to_s_formatted)
        )
      else
        quantity = screen.choose_number_as_money_multiplier(
          _INTL("您要买几个{1}？", item_data.portion_name_plural), item_price, max_quantity
        )
        next if quantity == 0
        item_price *= quantity
        if quantity > 1
          next if !screen.show_confirm_message(
            _INTL("是{2}啊。\n{1}个一共${3}可以吗？",
                  quantity, item_data.portion_name_plural, item_price.to_s_formatted)
          )
        elsif quantity > 0
          next if !screen.show_confirm_message(
            _INTL("是{2}啊。\n{1}个一共${3}可以吗？",
                  quantity, item_data.portion_name, item_price.to_s_formatted)
          )
        end
      end
      # Check the item can be put in the Bag
      if !screen.bag.can_add?(item_data.id, quantity)
        screen.show_message(_INTL("不好意思，您好像已经拿不下了呢……"))
        next
      end
      # Add the bought item(s)
      screen.bag.add(item_data.id, quantity)
      $stats.money_spent_at_marts += item_price
      $stats.mart_items_bought += quantity
      $player.money -= item_price
      screen.stock.remove_from_stock(item_data.id, quantity)
      screen.stock.refresh   # Removes bought important items
      screen.refresh
      screen.show_message(_INTL("请拿好。谢谢惠顾。")) { pbSEPlay("Mart buy item") }
      # Give bonus Premier Ball(s)
      if quantity >= 10 && item_data.is_poke_ball? && GameData::Item.exists?(:PREMIERBALL)
        if Settings::MORE_BONUS_PREMIER_BALLS || item_data.id == :POKEBALL
          premier_balls_earned = (Settings::MORE_BONUS_PREMIER_BALLS) ? (quantity / 10) : 1
          premier_balls_added = 0
          premier_balls_earned.times do
            break if !screen.bag.add(:PREMIERBALL)
            premier_balls_added += 1
          end
          if premier_balls_added > 0
            $stats.premier_balls_earned += premier_balls_added
            if premier_balls_added > 1
              ball_name = GameData::Item.get(:PREMIERBALL).portion_name_plural
            else
              ball_name = GameData::Item.get(:PREMIERBALL).portion_name
            end
            screen.show_message(_INTL("还要多送{1}个{2}给您哦！", premier_balls_added, ball_name))
          end
        end
      end
    }
  })
end

#===============================================================================
#
#===============================================================================
class UI::BagSellVisuals < UI::BagVisuals
  def initialize(bag, stock, mode = :choose_item)
    @stock = stock
    super(bag, mode: mode)
  end

  def initialize_sprites
    super
    @sprites[:money_window] = Window_AdvancedTextPokemon.newWithSize("", 0, 36, 184, 96, @viewport)
    @sprites[:money_window].setSkin("Graphics/Windowskins/goldskin")
    @sprites[:money_window].z              = 2000
    @sprites[:money_window].baseColor      = get_text_color_theme(:gray)[0]
    @sprites[:money_window].shadowColor    = get_text_color_theme(:gray)[1]
    @sprites[:money_window].letterbyletter = false
    @sprites[:money_window].visible        = true
    @sprites[:unit_price_window] = Window_AdvancedTextPokemon.newWithSize("", 0, 184, 184, 96, @viewport)
    @sprites[:unit_price_window].setSkin("Graphics/Windowskins/goldskin")
    @sprites[:unit_price_window].z              = 2000
    @sprites[:unit_price_window].baseColor      = get_text_color_theme(:gray)[0]
    @sprites[:unit_price_window].shadowColor    = get_text_color_theme(:gray)[1]
    @sprites[:unit_price_window].letterbyletter = false
    @sprites[:unit_price_window].visible        = true
  end

  def refresh
    super
    @sprites[:money_window].text = _INTL("零花钱：\n<r>${1}", $player.money.to_s_formatted)
    refresh_unit_price_window
  end

  def refresh_input_indicators; end

  def refresh_unit_price_window
    @sprites[:unit_price_window].visible = (!item.nil?)
    return if item.nil?
    price = @stock.sell_price(item)
    if GameData::Item.get(item).is_important? || price == 0
      @sprites[:unit_price_window].text = _INTL("无法出售该道具。")
    else
      @sprites[:unit_price_window].text = _INTL("单价：\n<r>${1}", price.to_s_formatted)
    end
  end

  def refresh_on_index_changed(old_index)
    super
    refresh_unit_price_window
  end
end

#===============================================================================
#
#===============================================================================
class UI::BagSell < UI::Bag
  def initialize(bag, mode: :choose_item)
    @stock = UI::MartStockWrapper.new([])
    super(bag, mode: mode)
  end

  def initialize_visuals
    @visuals = UI::BagSellVisuals.new(@bag, @stock, mode: @mode)
  end

  def sell_items
    choose_item do |item|
      item_data = GameData::Item.get(item)
      item_name        = item_data.portion_name
      item_name_plural = item_data.portion_name_plural
      price = @stock.sell_price(item)
      # Ensure item can be sold
      if item_data.is_important? || price == 0
        show_message(_INTL("不，我买不了{1}。", item_name_plural))
        next
      end
      # Choose a quantity of the item to sell
      quantity = @bag.quantity(item)
      if quantity > 1
        quantity = choose_number_as_money_multiplier(
          _INTL("您要卖几个{1}？", item_name_plural), price, quantity
        )
      end
      next if quantity == 0
      # Sell the item(s)
      price *= quantity
      if show_confirm_message(_INTL("我可以出${1}。\n可以吗？", price.to_s_formatted))
        @bag.remove(item, quantity)
        old_money = $player.money
        $player.money += price
        $stats.money_earned_at_marts += $player.money - old_money
        refresh
        sold_item_name = (quantity > 1) ? item_name_plural : item_name
          show_message(_INTL("你卖出了{1}，赚了${2}。",
                           sold_item_name, price.to_s_formatted)) { pbSEPlay("Mart buy item") }
      end
      next false
    end
  end
end

#===============================================================================
#
#===============================================================================
def pbPokemonMart(stock, speech = nil, cannot_sell = false)
  commands = {}
  commands[:buy]    = _INTL("购买")
  commands[:sell]   = _INTL("出售") if !cannot_sell
  commands[:cancel] = _INTL("什么也不需要")
  cmd = pbMessage(speech || _INTL("欢迎光临！请问您有什么需要？"), commands.values, commands.length)
  loop do
    case commands.keys[cmd]
    when :buy
      UI::Mart.new(stock, $bag).main
    when :sell
      pbFadeOutIn { UI::BagSell.new($bag).sell_items }
    else
      pbMessage(_INTL("欢迎再次光临！"))
      break
    end
    cmd = pbMessage(_INTL("还有什么其他需要吗？"), commands.values, commands.length, nil, cmd)
  end
  $game_temp.clear_mart_prices
end
