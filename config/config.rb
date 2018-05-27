require 'yaml'
require 'ostruct'
require 'recursive-open-struct'
require 'forwardable'

class Object
  def yield_self
    yield self
  end
end

class RecursiveOpenStruct
  extend Forwardable
  def merge(dict)
    res = RecursiveOpenStruct.new
    [self, dict].each do |obj|
      obj.each { |k, v| res[k] = v }
    end
    res
  end
  def merge!(dict)
    dict.each { |k, v| self[k] = v }
    self
  end
  def each(&blk)
    @table.each do |k, v|
      blk.call k, (v.is_a?(Hash) ? to_struct(v) : v)
    end
    self
  end
  def map(&blk)
    @table.map do |k, v|
      blk.call k, (v.is_a?(Hash) ? to_struct(v) : v)
    end
  end
  def reduce(memo, &blk)
    @table.reduce memo do |k, v|
      blk.call k, (v.is_a?(Hash) ? to_struct(v) : v)
    end
  end
  def keys
    @table.keys
  end
  def values
    @table.values.map do |v|
      v.is_a?(Hash) ? to_struct(v) : v
    end
  end
end

def load_yml(path)
  YAML.load File.read path
end

def to_struct(hash)
  RecursiveOpenStruct.new hash
end

Config = RecursiveOpenStruct.new

Config.merge! to_struct load_yml "./config/game_config.yml"

Config.characters = to_struct load_yml "./config/char_config.yml"

Config.levels = Dir.glob("./content/levels/*.yml")
  .map(&method(:load_yml))
  .map(&method(:to_struct))
  .reduce(&:merge)