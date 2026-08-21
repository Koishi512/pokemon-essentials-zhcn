#===============================================================================
#
#===============================================================================
module Compiler
  @@categories[:animations] = {
    :should_compile => proc { |compiling| next should_compile_animations? },
    :header_text    => proc { next _INTL("正在编译动画") },
    :skipped_text   => proc { next _INTL("未编译") },
    :compile        => proc {
      # Delete old data files in preparation for recompiling
      begin
        File.delete("Data/animations.dat") if FileTest.exist?("Data/animations.dat")
      rescue SystemCallError
      end
      text_files = get_animation_pbs_files_to_compile
      compile_battle_animations(*text_files)
    }
  }
  @@emitter_only_properties = []

  module_function

  def get_animation_pbs_files_to_compile
    ret = []
    if FileTest.directory?("PBS/Animations")
      Dir.all("PBS/Animations", "**/**.txt").each { |file| ret.push(file) }
    end
    return ret
  end

  def should_compile_animations?
    # Get all data files and PBS files to be checked for their last modified times
    data_file = "animations.dat"
    text_files = get_animation_pbs_files_to_compile
    # Check data files for their latest modify time
    latest_data_write_time = 0
    if FileTest.exist?("Data/" + data_file)
      begin
        File.open("Data/#{data_file}") do |file|
          latest_data_write_time = [latest_data_write_time, file.mtime.to_i].max
        end
      rescue SystemCallError
        return true
      end
    else
      return true
    end
    # Check PBS files for their latest modify time
    latest_text_edit_time = 0
    text_files.each do |filepath|
      begin
        File.open(filepath) { |file| latest_text_edit_time = [latest_text_edit_time, file.mtime.to_i].max }
      rescue SystemCallError
      end
    end
    # Decide to compile if a PBS file was edited more recently than any .dat files
    return (latest_text_edit_time >= latest_data_write_time)
  end

  #-----------------------------------------------------------------------------
  # Compile battle animations.
  #-----------------------------------------------------------------------------
  def compile_battle_animations(*paths)
    GameData::Animation::DATA.clear
    schema = GameData::Animation.schema
    sub_schema = GameData::Animation.sub_schema
    idx = 0
    # Read from PBS file(s)
    Console.echo_li(_INTL("正在编译动画 PBS 文件……"))
    paths.each do |path|
      file_name = path.gsub(/^PBS\/Animations\//, "").gsub(/.txt$/, "")
      data_hash = nil
      current_particle = nil
      section_name = nil
      section_line = nil
      # Read each line of the animation PBS file at a time and compile it as an
      # animation property
      pbCompilerEachPreppedLine(path) do |line, line_no|
        echo "." if idx % 100 == 0
        idx += 1
        Graphics.update if idx % 500 == 0
        FileLineData.setSection(section_name, nil, section_line)
        if line[/^\s*\[\s*(.+)\s*\]\s*$/]
          # New section [anim_type, name]
          section_name = $~[1]
          section_line = line
          if data_hash
            validate_compiled_animation(data_hash)
            GameData::Animation.register(data_hash)
          end
          FileLineData.setSection(section_name, nil, section_line)
          # Construct data hash
          data_hash = {
            :pbs_path => file_name
          }
          data_hash[schema["SectionName"][0]] = get_csv_record(section_name.clone, schema["SectionName"])
          data_hash[schema["Particle"][0]] = []
          current_particle = nil
        elsif line[/^\s*<\s*(.+)\s*>\s*$/]
          # New subsection [particle_name]
          value = get_csv_record($~[1], schema["Particle"])
          current_particle = {
            :name => value
          }
          data_hash[schema["Particle"][0]].push(current_particle)
        elsif line[/^\s*(\w+)\s*=\s*(.*)$/]
          # XXX=YYY lines
          if !data_hash
            raise _INTL("文件开头应为一个段落。") + "\n" + FileLineData.linereport
          end
          key = $~[1]
          if schema[key]   # Property of the animation
            value = get_csv_record($~[2], schema[key])
            if schema[key][1][0] == "^"
              value = nil if value.is_a?(Array) && value.empty?
              data_hash[schema[key][0]] ||= []
              data_hash[schema[key][0]].push(value) if value
            else
              value = nil if value.is_a?(Array) && value.empty?
              data_hash[schema[key][0]] = value
            end
          elsif sub_schema[key]   # Property of a particle
            if !current_particle
              raise _INTL("尚未定义粒子！") + "\n" + FileLineData.linereport
            end
            value = get_csv_record($~[2], sub_schema[key])
            if sub_schema[key][1][0] == "^"
              value = nil if value.is_a?(Array) && value.empty?
              current_particle[sub_schema[key][0]] ||= []
              current_particle[sub_schema[key][0]].push(value) if value
            else
              value = nil if value.is_a?(Array) && value.empty?
              current_particle[sub_schema[key][0]] = value
            end
          end
        end
      end
      # Add last animation's data to records
      if data_hash
        FileLineData.setSection(section_name, nil, section_line)
        validate_compiled_animation(data_hash)
        GameData::Animation.register(data_hash)
      end
    end
    validate_all_compiled_animations
    process_pbs_file_message_end
    # Save all data
    GameData::Animation.save
  end

  def validate_compiled_animation(hash)
    # Split anim_type, move/common_name, version into their own values
    hash[:type] = hash[:id][0]
    hash[:move] = hash[:id][1]
    hash[:version] = hash[:id][2] || 0
    # Ensure there is at most one each of "User", "Target" and "SE" particles
    ["User", "Target", "SE"].each do |type|
      next if hash[:particles].count { |particle| particle[:name] == type } <= 1
      raise _INTL("动画包含多个“{1}”粒子，这是不允许的。", type) + "\n" + FileLineData.linereport
    end
    # Ensure there is no "User" particle if "NoUser" is set
    if hash[:particles].any? { |particle| particle[:name] == "User" } && hash[:no_user]
      raise _INTL("不能同时定义“User”粒子，并将属性“NoUser”设为 true。") + "\n" + FileLineData.linereport
    end
    # Ensure there is no "Target" particle if "NoTarget" is set
    if hash[:particles].any? { |particle| particle[:name] == "Target" } && hash[:no_target]
      raise _INTL("不能同时定义“Target”粒子，并将属性“NoTarget”设为 true。") + "\n" + FileLineData.linereport
    end
    # Create "User", "Target" and "SE" particles if they don't exist but should
    if hash[:particles].none? { |particle| particle[:name] == "User" } && !hash[:no_user]
      hash[:particles].push({:name => "User"})
    end
    if hash[:particles].none? { |particle| particle[:name] == "Target" } && !hash[:no_target]
      hash[:particles].push({:name => "Target"})
    end
    if hash[:particles].none? { |particle| particle[:name] == "SE" }
      hash[:particles].push({:name => "SE"})
    end
    if @@emitter_only_properties.empty?
      AnimationEditor::ListedParticle::EMITTER_PROPERTY_GROUPS.each_pair do |group, vals|
        vals.each do |property|
          @@emitter_only_properties.push(property) if !AnimationEditor::ListedParticle::PROPERTY_GROUPS[group]&.include?(property)
        end
      end
    end
    # Go through each particle in turn
    hash[:particles].each do |particle|
      # Ensure the second layer-exclusive commands are only on particles with one
      if !particle[:second_layer]
        particle.keys.each do |property|
          next if !GameData::Animation::SECOND_LAYER_PROPERTIES.include?(property)
          raise _INTL("粒子“{1}”没有第二层，却包含第二层命令。",
                      particle[:name]) + "\n" + FileLineData.linereport
        end
      end
      # Ensure the emitter-exclusive commands are only on emitter particles
      if !particle[:emitter_type] || particle[:emitter_type] == :none
        particle.keys.each do |property|
          next if !@@emitter_only_properties.include?(property)
          raise _INTL("粒子“{1}”不是发射器，却包含仅限发射器的命令。",
                      particle[:name]) + "\n" + FileLineData.linereport
        end
      end
      # Ensure the particle's coordinate system is correct
      if particle[:polar_coordinates]
        if particle[:x] || particle[:y]
          raise _INTL("粒子“{1}”使用极坐标，却包含 X/Y 命令。",
                      particle[:name]) + "\n" + FileLineData.linereport
        end
      else
        if particle[:r] || particle[:theta]
          raise _INTL("粒子“{1}”不使用极坐标，却包含 R/Theta 命令。",
                      particle[:name]) + "\n" + FileLineData.linereport
        end
      end
      if particle[:emitter_position_polar_coordinates]
        if particle[:emitter_x] || particle[:emitter_y]
          raise _INTL("发射器“{1}”的位置使用极坐标，却包含 EmitterX/EmitterY 命令。",
                      particle[:name]) + "\n" + FileLineData.linereport
        end
      else
        if particle[:emitter_r] || particle[:emitter_theta]
          raise _INTL("发射器“{1}”的位置不使用极坐标，却包含 EmitterR/EmitterTheta 命令。",
                      particle[:name]) + "\n" + FileLineData.linereport
        end
      end
      if particle[:emitter_spawn_polar_coordinates]
        if particle[:spawn_x] || particle[:spawn_x_range] ||
           particle[:spawn_y] || particle[:spawn_y_range] ||
           particle[:spawn_x_offset] || particle[:spawn_x_multiplier] ||
           particle[:spawn_y_offset] || particle[:spawn_y_multiplier]
          raise _INTL("发射器“{1}”的生成位置使用极坐标，却包含 Spawn X/Y 命令。",
                      particle[:name]) + "\n" + FileLineData.linereport
        end
      else
        if particle[:spawn_r] || particle[:spawn_r_range] ||
           particle[:spawn_theta] || particle[:spawn_theta_range] ||
           particle[:spawn_r_offset] || particle[:spawn_r_multiplier] ||
           particle[:spawn_theta_offset]
          raise _INTL("发射器“{1}”的生成位置不使用极坐标，却包含 Spawn R/Theta 命令。",
                      particle[:name]) + "\n" + FileLineData.linereport
        end
      end
      # Ensure the "Play"-type commands are exclusive to the "SE" particle, and
      # that the "SE" particle has no other commands
      if particle[:name] == "SE"
        particle.keys.each do |property|
          next if [:name, :se, :user_cry, :target_cry].include?(property)
          raise _INTL("粒子“{1}”包含非“Play”类型命令。",
                      particle[:name]) + "\n" + FileLineData.linereport
        end
      else
        if particle[:se]
          raise _INTL("粒子“{1}”不应包含“Play”命令。",
                      particle[:name]) + "\n" + FileLineData.linereport
        elsif particle[:user_cry]
          raise _INTL("粒子“{1}”不应包含“PlayUserCry”命令。",
                      particle[:name]) + "\n" + FileLineData.linereport
        elsif particle[:target_cry]
          raise _INTL("粒子“{1}”不应包含“PlayTargetCry”命令。",
                      particle[:name]) + "\n" + FileLineData.linereport
        end
      end
      # Ensure all particles have a default focus if not given
      if !particle[:focus] && particle[:name] != "SE"
        case particle[:name]
        when "User"   then particle[:focus] = :user
        when "Target" then particle[:focus] = :target
        else               particle[:focus] = GameData::Animation::PARTICLE_DEFAULT_VALUES[:focus]
        end
      end
      # Ensure user/target particles have a default graphic if not given
      if !particle[:graphic] && particle[:name] != "SE"
        case particle[:name]
        when "User"   then particle[:graphic] = "USER"
        when "Target" then particle[:graphic] = "TARGET"
        end
      end
      # If the animation doesn't involve a user, ensure that particles don't
      # have a focus/graphic that involves a user, and that the animation
      # doesn't play a user's cry
      if hash[:no_user]
        if GameData::Animation::FOCUS_TYPES_WITH_USER.include?(particle[:focus])
          raise _INTL("属性“NoUser”设为 true 时，粒子“{1}”不能使用涉及使用者的“Focus”。",
                      particle[:name]) + "\n" + FileLineData.linereport
        end
        if ["USER", "USER_OPP", "USER_FRONT", "USER_BACK"].include?(particle[:graphic])
          raise _INTL("属性“NoUser”设为 true 时，粒子“{1}”不能使用涉及使用者的“Graphic”。",
                      particle[:name]) + "\n" + FileLineData.linereport
        end
        if particle[:name] == "SE" && particle[:user_cry] && !particle[:user_cry].empty?
          raise _INTL("属性“NoUser”设为 true 时，动画不能播放使用者的叫声。") + "\n" + FileLineData.linereport
        end
      end
      # If the animation doesn't involve a target, ensure that particles don't
      # have a focus/graphic that involves a target, and that the animation
      # doesn't play a target's cry
      if hash[:no_target]
        if GameData::Animation::FOCUS_TYPES_WITH_TARGET.include?(particle[:focus])
          raise _INTL("属性“NoTarget”设为 true 时，粒子“{1}”不能使用涉及目标的“Focus”。",
                      particle[:name]) + "\n" + FileLineData.linereport
        end
        if ["TARGET", "TARGET_OPP", "TARGET_FRONT", "TARGET_BACK"].include?(particle[:graphic])
          raise _INTL("属性“NoTarget”设为 true 时，粒子“{1}”不能使用涉及目标的“Graphic”。",
                      particle[:name]) + "\n" + FileLineData.linereport
        end
        if particle[:name] == "SE" && particle[:target_cry] && !particle[:target_cry].empty?
          raise _INTL("属性“NoTarget”设为 true 时，动画不能播放目标的叫声。") + "\n" + FileLineData.linereport
        end
      end
      # Ensure that none of the particle's "alter something if focus is a
      # battler on the foe's side" properties are set if the particle doesn't
      # have such a focus
      if GameData::Animation::FOCUS_TYPES_WITH_USER.include?(particle[:focus]) == GameData::Animation::FOCUS_TYPES_WITH_TARGET.include?(particle[:focus])
        if particle[:foe_invert_x]
          raise _INTL("粒子“{1}”的焦点并非恰好一个对象时，不能设置“FoeInvertX”。",
                      particle[:name]) + "\n" + FileLineData.linereport
        end
        if particle[:foe_invert_y]
          raise _INTL("粒子“{1}”的焦点并非恰好一个对象时，不能设置“FoeInvertY”。",
                      particle[:name]) + "\n" + FileLineData.linereport
        end
        if particle[:foe_flip]
          raise _INTL("粒子“{1}”的焦点并非恰好一个对象时，不能设置“FoeFlip”。",
                      particle[:name]) + "\n" + FileLineData.linereport
        end
      end
      # Ensure that the particle isn't a tiled graphic if it is an emitter or
      # has a non-screen focus
      if particle[:tiled_graphic] && ((particle[:emitter_type] || :none) != :none ||
         GameData::Animation::FOCUS_TYPES_WITH_USER.include?(particle[:focus]) ||
         GameData::Animation::FOCUS_TYPES_WITH_TARGET.include?(particle[:focus]))
        raise _INTL("粒子“{1}”是发射器或焦点不在屏幕上时，不能设置“TiledGraphic”。",
                    particle[:name]) + "\n" + FileLineData.linereport
      end
      # Ensure that a particle with a user's/target's graphic doesn't have any
      # :frame commands
      if !["User", "Target", "SE"].include?(particle[:name]) &&
         ["USER", "USER_OPP", "USER_FRONT", "USER_BACK",
          "TARGET", "TARGET_OPP", "TARGET_FRONT", "TARGET_BACK"].include?(particle[:graphic]) &&
         particle[:frame] && !particle[:frame].empty?
        raise _INTL("粒子“{1}”的图像为宝可梦精灵图时，不能包含“Frame”命令。",
                    particle[:name]) + "\n" + FileLineData.linereport
      end
      # Ensure that the same SE isn't played twice in the same frame
      if particle[:name] == "SE"
        [:se, :user_cry, :target_cry].each do |property|
          next if !particle[property]
          files_played = []
          particle[property].each do |play|
            files_played[play[0]] ||= []
            if files_played[play[0]].include?(play[1])
              case property
              when :se
                raise _INTL("音效“{1}”不应在同一帧（{2}）播放两次。", play[1], play[0]) + "\n" + FileLineData.linereport
              when :user_cry
                raise _INTL("使用者的叫声不应在同一帧（{1}）播放两次。", play[0]) + "\n" + FileLineData.linereport
              when :target_cry
                raise _INTL("目标的叫声不应在同一帧（{1}）播放两次。", play[0]) + "\n" + FileLineData.linereport
              end
            end
            files_played[play[0]].push(play[1])
          end
        end
      end
      # Convert all "SetXYZ" particle commands to "MoveXYZ" by giving them a
      # duration of 0 (even ones that can't have a "MoveXYZ" command)
      GameData::Animation::PARTICLE_KEYFRAME_DEFAULT_VALUES.keys.each do |prop|
        next if !particle[prop]
        particle[prop].each do |cmd|
          cmd.insert(1, 0) if cmd.length == 2 || particle[:name] == "SE"
          # Give default interpolation value of :linear to any "MoveXYZ" command
          # that doesn't have one already
          cmd.push(:linear) if cmd[1] > 0 && cmd.length < 4
        end
      end
      # Sort each particle's commands by their keyframe and duration
      particle.keys.each do |key|
        next if !particle[key].is_a?(Array)
        particle[key].sort! { |a, b| a[0] == b[0] ? a[1] == b[1] ? 0 : a[1] <=> b[1] : a[0] <=> b[0] }
        next if particle[:name] == "SE"
        # Check for any overlapping particle commands
        last_frame = -1
        last_set_frame = -1
        particle[key].each do |cmd|
          if last_frame > cmd[0]
            raise _INTL("动画的 {1} 属性存在重叠命令。",
                        key.to_s.capitalize) + "\n" + FileLineData.linereport
          end
          if cmd[1] == 0 && last_set_frame >= cmd[0]
            raise _INTL("动画在同一关键帧中为 {1} 属性包含多个“Set”命令。",
                        key.to_s.capitalize) + "\n" + FileLineData.linereport
          end
          last_frame = cmd[0] + cmd[1]
          last_set_frame = cmd[0] if cmd[1] == 0
        end
      end
      # Ensure valid values for "SetBlending" commands
      if particle[:blending]
        particle[:blending].each do |blend|
          next if blend[2] <= 2
          raise _INTL("无效的混合值：{1}（必须为 0、1 或 2）。\n{2}",
                      blend[2], FileLineData.linereport)
        end
      end
    end
  end

  def validate_all_compiled_animations; end
end
