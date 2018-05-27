require 'yaml'
require 'ostruct'

def struct_from_yml(path)
  OpenStruct.new YAML.load File.read path
end

Config = struct_from_yml "./config/game_config.yml"

Config.characters = struct_from_yml "./config/char_config.yml"