require "rubohash/version"

require 'securerandom'
require 'digest'
require 'pp'
require 'mini_magick'

require 'rubohash/factory'
require 'rubohash/robot'

module Rubohash
  @default_extensions = %w[.png .gif .jpg .bmp .jpeg .ppm .datauri]
  @default_set = "set1"

  def self.default_extensions=(my_default_extensions)
    @default_extensions = my_default_extensions
  end

  def self.default_extensions
    @default_extensions
  end

  def self.default_set=(my_default_set)
    @default_set = my_default_set
  end

  def self.default_set
    @default_set
  end

  def self.assemble!(string)
    Rubohash::Factory.new(string).assemble
  end
end
