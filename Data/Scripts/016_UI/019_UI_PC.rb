#===============================================================================
#
#===============================================================================
module UI::PC
  module_function

  #-----------------------------------------------------------------------------

  def menu(menu_type, message)
    # Get all commands
    command_list = []
    commands = []
    MenuHandlers.each_available(menu_type) do |option, hash, name|
      command_list.push(name)
      commands.push(hash)
    end
    # Main loop
    command = 0
    loop do
      choice = pbMessage(message, command_list, -1, nil, command)
      break if choice < 0
      break if commands[choice]["effect"].call
    end
  end

  def trainer_pc_menu
    menu(:player_pc_menu, _INTL("你想做什么？"))
  end

  def poke_center_pc_menu
    menu(:pc_menu, _INTL("你要连接哪一部电脑？"))
  end

  #-----------------------------------------------------------------------------

  def item_storage
    $PokemonGlobal.pcItemStorage ||= PCItemStorage.new
    commands = {
      :withdraw => [_INTL("取出道具"),      _INTL("从电脑中取出道具。")],
      :deposit  => [_INTL("存入道具"),      _INTL("将道具存入电脑。")],
      :toss     => [_INTL("丢弃道具"),      _INTL("丢弃电脑里存储的道具。")],
      :exit     => [_INTL("退出"),          _INTL("返回上一级菜单。")]
    }
    command = 0
    loop do
      commands.values.map { |val| val[0] }
      command = pbShowCommandsWithHelp(nil, commands.values.map { |val| val[0] },
                                       commands.values.map { |val| val[1] }, -1, command)
      break if command < 0
      case commands.keys[command]
      when :withdraw
        if $PokemonGlobal.pcItemStorage.empty?
          pbMessage(_INTL("电脑里没有道具。"))
          next
        end
        pbPlayDecisionSE
        pbFadeOutIn do
          scene = WithdrawItemScene.new
          screen = ItemStorageScreen.new(scene, $bag)
          screen.pbWithdrawItemScreen
        end
      when :deposit
        pbPlayDecisionSE
        item_storage = $PokemonGlobal.pcItemStorage
        pbFadeOutIn do
          bag_screen = UI::Bag.new($bag, mode: :choose_item)
          bag_screen.choose_item do |item|
            item_data = GameData::Item.get(item)
            if (Settings::DISABLE_STORING_IMPORTANT_ITEMS && item_data.is_important?) ||
               item_data.has_flag?("CannotDeposit")
              bag_screen.show_message(_INTL("你不能存入如此重要的道具！"))
              next false
            end
            qty = $bag.quantity(item)
            if qty > 1 && !item_data.is_important?
              qty = bag_screen.choose_number(_INTL("你要存入多少个？"), qty)
            end
            next false if qty == 0
            if !item_storage.can_add?(item, qty)
              bag_screen.show_message(_INTL("电脑里没有空间来存储道具。"))
              next false
            end
            raise "Can't delete items from Bag" if !$bag.remove(item, qty)
            raise "Can't deposit items to storage" if !item_storage.add(item, qty)
            bag_screen.refresh
            disp_qty  = (item_data.is_important?) ? 1 : qty
            item_name = (disp_qty > 1) ? item_data.portion_name_plural : item_data.portion_name
            bag_screen.show_message(_INTL("存入了{1}个{2}。", disp_qty, item_name))
            next false
          end
        end
      when :toss
        if $PokemonGlobal.pcItemStorage.empty?
          pbMessage(_INTL("电脑里没有道具。"))
          next
        end
        pbPlayDecisionSE
        pbFadeOutIn do
          scene = TossItemScene.new
          screen = ItemStorageScreen.new(scene, $bag)
          screen.pbTossItemScreen
        end
      else
        break
      end
    end
  end

  #-----------------------------------------------------------------------------

  def mailbox
    command = 0
    loop do
      # Choose a mail or cancel
      commands = []
      $PokemonGlobal.mailbox.each { |mail| commands.push(mail.sender) }
      commands.push(_INTL("取消"))
      mail_index = pbShowCommands(nil, commands, -1, command)
      break if mail_index < 0 || mail_index >= $PokemonGlobal.mailbox.length
      # Interact with mail
      interact_commands = {
        :read        => _INTL("阅读"),
        :move_to_bag => _INTL("移动到包包"),
        :give        => _INTL("给予"),
        :cancel      => _INTL("取消")
      }
      command_mail = pbMessage(
        _INTL("要对{1}的邮件做什么？", $PokemonGlobal.mailbox[mail_index].sender),
        interact_commands.values, -1
      )
      case interact_commands.keys[command_mail]
      when :read
        pbPlayDecisionSE
        pbFadeOutIn { pbDisplayMail($PokemonGlobal.mailbox[mail_index]) }
      when :move_to_bag
        if pbConfirmMessage(_INTL("邮件里的消息会丢失。这样可以吗？"))
          if $bag.add($PokemonGlobal.mailbox[mail_index].item)
            pbMessage(_INTL("消息被清除，邮件返回了包包！"))
            $PokemonGlobal.mailbox.delete_at(mail_index)
          else
            pbMessage(_INTL("包包满了。"))
          end
        end
      when :give
        pbPlayDecisionSE
        pbFadeOutIn do
          screen = UI::Party.new($player.party, mode: :choose_pokemon)
          screen.choose_pokemon do |pkmn, party_index|
            next true if party_index < 0
            if pkmn.egg?
              screen.show_message(_INTL("蛋无法携带邮件。"))
            elsif pkmn.hasItem? || pkmn.mail
              screen.show_message(_INTL("这只宝可梦携带着道具，不能携带邮件了。"))
            else
              pkmn.mail = $PokemonGlobal.mailbox[mail_index]
              $PokemonGlobal.mailbox.delete_at(mail_index)
              screen.refresh
              screen.show_message(_INTL("邮件从邮箱传送过来了。"))
              next true
            end
            next false
          end
        end
      else
        pbPlayDecisionSE
      end
    end
  end

  #-----------------------------------------------------------------------------

  def storage_creator_name
    return GameData::Metadata.get.storage_creator
  end

  def pokemon_storage
    commands = {
      :organize => [_INTL("整理盒子"),   _INTL("整理盒子中的宝可梦和你的队伍。")],
      :withdraw => [_INTL("取出宝可梦"), _INTL("将盒子中的宝可梦移到你的队伍。")],
      :deposit  => [_INTL("存入宝可梦"),  _INTL("将你的队伍中的宝可梦存入盒子。")],
      :quit     => [_INTL("再见！"),      _INTL("返回上一个菜单。")]
    }
    command = 0
    loop do
      command = pbShowCommandsWithHelp(nil, commands.values.map { |val| val[0] },
                                       commands.values.map { |val| val[1] }, -1, command)
      break if command < 0
      case commands.keys[command]
      when :organize
      when :withdraw
        if $PokemonStorage.party_full?
          pbMessage(_INTL("你的队伍满了！"))
          next
        end
      when :deposit
        if $player.able_pokemon_count <= 1
          pbMessage(_INTL("不能存放最后一只宝可梦！"))
          next
        end
      else
        break
      end
      pbPlayDecisionSE
      pbFadeOutIn { UI::PokemonStorage.new($PokemonStorage, mode: commands.keys[command]).main }
    end
  end
end

#===============================================================================
# Menu options for the player's PC found in their home.
#===============================================================================
MenuHandlers.add(:player_pc_menu, :item_storage, {
  "name"   => proc { next _INTL("道具存储") },
  "order"  => 10,
  "effect" => proc { |menu|
    pbPlayDecisionSE
    UI::PC.item_storage
    next false
  }
})

MenuHandlers.add(:player_pc_menu, :mailbox, {
  "name"   => proc { next _INTL("邮箱") },
  "order"  => 20,
  "effect" => proc { |menu|
    if !$PokemonGlobal.mailbox || $PokemonGlobal.mailbox.length == 0
      pbMessage(_INTL("这里没有邮件。"))
      next false
    end
    pbPlayDecisionSE
    UI::PC.mailbox
    next false
  }
})

MenuHandlers.add(:player_pc_menu, :close, {
  "name"   => _INTL("关机"),
  "order"  => 999,
  "effect" => proc { |menu|
    next true
  }
})

#===============================================================================
# Menu options for the main PC found in Poké Centers. There are more options
# elsewhere in the scripts, e.g. for the Hall of Fame and Purify Chamber.
#===============================================================================
MenuHandlers.add(:pc_menu, :pokemon_storage, {
  "name"   => proc {
    next ($player.seen_storage_creator) ? _INTL("{1}的电脑", UI::PC.storage_creator_name) : _INTL("某人的电脑")
  },
  "order"  => 10,
  "effect" => proc { |menu|
    pbMessage("\\se[PC access]" + _INTL("打开了宝可梦寄放系统。"))
    UI::PC.pokemon_storage
    next false
  }
})

MenuHandlers.add(:pc_menu, :player_pc, {
  "name"   => proc { next _INTL("{1}的电脑", $player.name) },
  "order"  => 20,
  "effect" => proc { |menu|
    pbMessage("\\se[PC access]" + _INTL("连接上了{1}的电脑。", $player.name))
    UI::PC.trainer_pc_menu
    next false
  }
})

MenuHandlers.add(:pc_menu, :close, {
  "name"   => _INTL("关机"),
  "order"  => 999,
  "effect" => proc { |menu|
    next true
  }
})

#===============================================================================
# Methods for interacting with PCs in the overworld.
#===============================================================================
def pbTrainerPC
  pbMessage("\\se[PC open]" + _INTL("{1}启动了电脑。", $player.name))
  UI::PC.trainer_pc_menu
  pbSEPlay("PC close")
end

def pbPokeCenterPC
  pbMessage("\\se[PC open]" + _INTL("{1}启动了电脑。", $player.name))
  UI::PC.poke_center_pc_menu
  pbSEPlay("PC close")
end

def pbGetStorageCreator
  return UI::PC.storage_creator_name
end
