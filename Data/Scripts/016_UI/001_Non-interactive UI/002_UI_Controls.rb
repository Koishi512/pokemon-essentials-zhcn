#==============================================================================
# * Scene_Controls
#------------------------------------------------------------------------------
# Shows a help screen listing the keyboard controls.
# Display with:
#      pbEventScreen(ButtonEventScene)
#==============================================================================
class ButtonEventScene < EventScene
  FADE_DURATION = 8   # In 1/20 of a second

  def initialize(viewport = nil)
    super(viewport)
    Graphics.freeze
    @current_screen = 1
    addImage(0, 0, "Graphics/UI/Controls help/bg")
    @labels = []
    @label_screens = []
    @keys = []
    @key_screens = []

    addImageForScreen(1, 16, 96, "Graphics/UI/Controls help/help_arrows")
    addImageForScreen(1, 48, 258, "Graphics/UI/Controls help/help_use")
    addLabelForScreen(1, 128, 68, 352, _INTL("按方向键移动主角。你也可以用它们来选择条目和导航菜单。"))
    addLabelForScreen(1, 128, 228, 352, _INTL("用于确认选择、与人物和道具互动以及在文本中移动。（默认: 空格键）"))

    addImageForScreen(2, 48, 114, "Graphics/UI/Controls help/help_back")
    addImageForScreen(2, 48, 258, "Graphics/UI/Controls help/help_action")
    addLabelForScreen(2, 128, 68, 352, _INTL("用于退出、取消选择和取消模式。在移动时，按住不放可以以不同速度移动。（默认: Esc）"))
    addLabelForScreen(2, 128, 228, 352, _INTL("用于打开暂停菜单。根据上下文，它还有各种其他功能。（默认: Backspace）"))

    addImageForScreen(3, 48, 96, "Graphics/UI/Controls help/help_quick")
    addImageForScreen(3, 42, 252, "Graphics/UI/Controls help/help_f8")
    addLabelForScreen(3, 128, 68, 352, _INTL("用于打开就绪菜单。在某些菜单中，它还用于快速上下移动，或在某些情况下在标签页之间切换。（默认: PgUp/PgDn）"))
    addLabelForScreen(3, 128, 228, 352, _INTL("用于拍摄截图。它会保存到游戏文件夹中的\"Screenshots\"文件夹里。（默认: F8）"))

    set_up_screen(@current_screen, true)
    # NOTE: I don't know why the fade duration needs to be halved for this.
    Graphics.transition(FADE_DURATION / 2, "")
    # Go to next screen when user presses USE
    onCTrigger.set(method(:pbOnScreenEnd))
  end

  def addLabelForScreen(number, x, y, width, text)
    @labels.push(addLabel(x, y, width, text))
    @label_screens.push(number)
    @picturesprites[@picturesprites.length - 1].opacity = 0
  end

  def addImageForScreen(number, x, y, filename)
    @keys.push(addImage(x, y, filename))
    @key_screens.push(number)
    @picturesprites[@picturesprites.length - 1].opacity = 0
  end

  def set_up_screen(number, initial = false)
    dur = (initial) ? 0 : FADE_DURATION
    @label_screens.each_with_index do |screen, i|
      @labels[i].moveOpacity((screen == number) ? dur : 0, dur, (screen == number) ? 255 : 0)
    end
    @key_screens.each_with_index do |screen, i|
      @keys[i].moveOpacity((screen == number) ? dur : 0, dur, (screen == number) ? 255 : 0)
    end
    pictureWait   # Update event scene with the changes
  end

  def pbOnScreenEnd(scene, *args)
    last_screen = [@label_screens.max, @key_screens.max].max
    if @current_screen >= last_screen
      # End scene
      $game_temp.background_bitmap = Graphics.snap_to_bitmap
      Graphics.freeze
      @viewport.color = Color.black   # Ensure screen is black
      Graphics.transition(FADE_DURATION, "fadetoblack")
      $game_temp.background_bitmap.dispose
      scene.dispose
    else
      # Next screen
      @current_screen += 1
      onCTrigger.clear
      set_up_screen(@current_screen)
      onCTrigger.set(method(:pbOnScreenEnd))
    end
  end
end
