require "rubohash/version"

require 'securerandom'
require 'digest'
require 'pp'
require 'mini_magick'

module Rubohash
  class Factory
    attr_accessor :my_hash_array, :my_digest, :remove_extensions, :my_format, :string

    def initialize(string = nil, my_format = nil)
      self.string            = string
      self.remove_extensions = true
      self.my_format         = my_format
      self.my_format ||= 'png'
      self.my_digest = make_digest(string)
      self.my_hash_array = create_hashes([], self.my_digest, 11)
    end

    def make_digest(string)
      string = remove_extensions(string)
      Digest::SHA512.hexdigest(string)
    end

    def remove_extensions(string)
      %w[.png .gif .jpg .bmp .jpeg .ppm .datauri].any? do |ext|
        if string.end_with?(ext)
          # format = string.rindex('.') ? string.rindex('.') + 1 : string.length
          return string[0...string.rindex('.')]
        else
          return string
        end
      end
    end

    # Breaks up our hash into slots, so we can pull them out later.
    # Essentially, it splits our SHA/MD5/etc into X parts.
    def create_hashes(my_hash_array, digest, kount)
      (0..kount.to_i).each do |iter|
        blocksize = (digest.length / kount).to_i
        currentstart = (1+ iter) * blocksize - blocksize
        currentend = (1 + iter) * blocksize
        my_hash_array.push(digest[currentstart...currentend].to_i(16))
      end
      my_hash_array
    end

    def list_directories(path)
      Dir.entries(path).select do |entry|
        next if %w[. ..].include?(entry)
        File.directory?(File.join(path, entry))
      end.sort
    end

    def list_files(path)
      Dir.glob("#{path}/**").select do |entry|
        next if %w[. ..].include?(entry)
        !File.directory?(entry)
      end.sort
    end

    # eyes, ears, etc... #TODO: ordering!
    def get_list_of_files(path)
      # Get all subdirectories
      # sets/set1/blue
      directories = Dir.glob("#{path}/**").select do |entry|
        next if %w[. ..].include?(entry)
        File.directory?(entry)
      end.sort

      directories.map.with_index do |dir, index|
        files = Dir.entries(dir).reject { |k| %w[. ..].include?(k) }
        sample = files[self.my_hash_array[index] % files.length]
        [dir, sample].join('/')
      end
    end

    def resource_dir
      File.expand_path('./assets', File.dirname(__FILE__))
    end

    def sets
      list_directories("#{resource_dir}/sets")
    end

    def bg_sets
      list_directories("#{resource_dir}/backgrounds")
    end

    def colors
      list_directories("#{resource_dir}/sets/set1")
    end

    # TODO: see if this file already exists
    def assemble
      # Find Our sets
      # IF it is set1, pick a random color
      attrs = build_robot_attrs()
      robot = Rubohash::Robot.new(attrs[:set], attrs[:color], attrs[:bg])

      roboparts = get_list_of_files(robot.my_set).sort_by { |k| k.split("#")[1] }

      # uuse the hash bits to get the actual sample
      background_files = list_files(robot.my_background)
      background = background_files[self.my_hash_array[3] % background_files.size]

      image = MiniMagick::Image.open(roboparts.first)
      image = image.resize("1024x1024")

      # puts roboparts.inspect
      # puts background.inspect

      roboparts.each do |part|
        img = MiniMagick::Image.open(part)
        img = img.resize("1024x1024")
        image = image.composite(img) do |c|
          c.compose "Over"
        end
      end

      bg = MiniMagick::Image.open(background)
      bg = bg.resize("1024x1024")
      image = image.composite(bg) do |c|
        c.compose "Dst_Over"
        c.resize "300x300"
      end

      robot.name = self.my_digest

      # path = File.expand_path("../output/#{robot.name}.png", File.dirname(__FILE__))
      path = "/Users/mark/dev/backend-tools/rubohash/output/#{robot.name}.png"
      puts "Writing Robot: '#{path}'"
      image.write path
      robot
    end

    private
    def build_robot_attrs
      # set = "set1"
      set = self.sets[self.my_hash_array[1] % self.sets.length]
      bg_sample = self.bg_sets[self.my_hash_array[2] % self.bg_sets.length]

      color = if set == 'set1'
        color_sample = self.colors[self.my_hash_array[0] % self.colors.length]
        set = "set1/#{color_sample}"
      else
        nil
      end

      {
        set: [resource_dir, "sets", set].join('/'),
        color: color,
        bg: [resource_dir, "backgrounds", bg_sample].join('/'),
      }
    end
  end

  class Robot
    attr_accessor :my_set, :my_color, :my_background, :name

    def initialize(my_set = nil, my_color = nil, my_background = nil)
      self.my_set        = my_set
      self.my_color      = my_color
      self.my_background = my_background
    end
  end
end
