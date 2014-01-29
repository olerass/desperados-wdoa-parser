require "bindata"

class LittleEndianRecord < BinData::Record
  endian :little
end

class UTF16LEString < BinData::String
  def snapshot
    super.force_encoding('UTF-16LE')
  end
end

class GraphicsConfig < LittleEndianRecord
  # Seems like 1 = off and 0 = on for the four settings
  uint8 :animated_background
  uint8 :realistic_shadows
  uint8 :animated_effects
  uint8 :transparent_viewing_range
  float :res_width
  float :res_height
end

class SoundConfig < LittleEndianRecord
  uint8 :sound_3d # 0 = stereo, 1 = 3d
  uint8 :low_res  # 0 = yes, 1 = no (high res)
  # Volume encoding: 0-9 (min-max)
  uint16 :dialogue_vol
  uint16 :character_comments_vol
  uint16 :fx_vol
  uint16 :music_vol
  uint16 :comments_freq
end

# No idea what this is atm
class PlayerProfileSub1 < LittleEndianRecord
  uint16 :unk1_count # TODO: cap this to [unk1_count, 31].min
  array :unk1, :type => :uint16, :initial_length => :unk1_count
  uint16 :unk2
  uint16 :unk3
end

class SaveGame < LittleEndianRecord
  uint32 :nr
  uint32 :name_len
  string :name, :read_length => lambda { name_len }
end

class PlayerProfile < LittleEndianRecord
  uint32 :profile_nr
  uint32 :cur_lvl # 1 lower than what's shown in-game for some reason
  uint32 :missions_accomplished
  uint32 :elapsed_time_raw
  PlayerProfileSub1 :sub1
  PlayerProfileSub1 :sub2
  SoundConfig :snd_cfg
  GraphicsConfig :gfx_cfg
  uint32 :name_len
  UTF16LEString :name, :read_length => lambda { name_len*2 }

  # Savegame stuff
  uint32 :s_unk1
  uint32 :nr_saves
  array :saves, :type => SaveGame, :initial_length => :nr_saves

  def elapsed_time_mins
    elapsed_time_raw / 60000.0
  end
end

class ProfileArchive < LittleEndianRecord
  uint32 :magic_number, :assert => 0x50524F46 # Magic number in Desperados v1.01
  uint32 :version,      :assert => 0x305      # Archive version in Desperados v1.01
  uint32 :unk1
  uint32 :nr_profiles
  array :profiles, :type => PlayerProfile, :initial_length => :nr_profiles
  uint32 :active_profile_nr
end

io = File.open "C:\\Games\\Desperados Wanted Dead or Alive\\Game\\Data\\Savegame\\Profiles"
d1 = ProfileArchive.read io
io.close

puts d1