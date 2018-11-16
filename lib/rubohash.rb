require "rubohash/version"

require 'securerandom'
require 'digest'
require 'pp'
require 'mini_magick'

require 'rubohash/factory'
require 'rubohash/robot'

module Rubohash
  @default_extensions = %w[.png .gif .jpg .bmp .jpeg .ppm .datauri]
  @default_set        = "set1"
  @use_default_set    = false
  @robot_output_path  = '/Users/mark/dev/backend-tools/rubohash/output/'
  @default_format     = 'png'
  @default_bg_set     = 'bg1'
  @use_default_bg_set = false

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

  def self.use_default_set=(my_use_default_set)
    @use_default_set = my_use_default_set
  end

  def self.use_default_set
    @use_default_set
  end

  def self.robot_output_path=(my_robot_output_path)
    @robot_output_path = my_robot_output_path
  end

  def self.robot_output_path
    @robot_output_path
  end

  def self.default_format=(my_default_format)
    @default_format = my_default_format
  end

  def self.default_format
    @default_format
  end

  def self.default_bg_set=(my_default_bg_set)
    @default_bg_set = my_default_bg_set
  end

  def self.default_bg_set
    @default_bg_set
  end

  def self.use_default_bg_set=(my_use_default_bg_set)
    @use_default_bg_set = my_use_default_bg_set
  end

  def self.use_default_bg_set
    @use_default_bg_set
  end

  def self.assemble!(string)
    Rubohash::Factory.new(string).assemble
  end

  def self.configure
    yield self
  end
end
