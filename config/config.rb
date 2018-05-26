require 'yaml'
require 'ostruct'

Config = OpenStruct.new YAML.load File.read "./config.yml"