# Rubohash namespace
module Rubohash
  # The factory which builds robots
  class Factory
    attr_accessor :my_hash_array, :my_digest, :remove_extensions, :my_format, :string

    # Setup defaults for the factory
    def initialize(string = nil, my_format = nil)
      self.string            = string
      self.remove_extensions = true
      self.my_format         = my_format
      self.my_format ||= Rubohash.default_format
      self.my_digest = make_digest(string)
      self.my_hash_array = create_hashes([], my_digest, 11)
    end

    # Build the SHA512 checksum based on string
    def make_digest(string)
      string = remove_extensions(string)
      Digest::SHA512.hexdigest(string)
    end

    # Strip out the specified extensions from string
    def remove_extensions(string)
      Rubohash.default_extensions.any? do |ext|
        if string.end_with?(ext)
          return string[0...string.rindex('.')]
        else
          return string
        end
      end
    end

    # Breaks up our hash into slots, so we can pull them out later.
    # Essentially, it splits our SHA/MD5/etc into X parts.
    def create_hashes(my_hash_array, digest, kount)
      blocksize = (digest.length / kount).to_i
      (0...kount.to_i).each do |iter|
        currentstart = (1 + iter) * blocksize - blocksize
        currentend = (1 + iter) * blocksize
        digest_subset = digest[currentstart...currentend]
        range = digest_subset.to_i(16)
        my_hash_array.push(range)
      end
      my_hash_array
    end

    # List directories for the given path
    def list_directories(path)
      Dir.entries(path).select do |entry|
        next if %w[. ..].include?(entry)
        File.directory?(File.join(path, entry))
      end.sort
    end

    # List files from the given path
    def list_files(path)
      Dir.glob("#{path}/**").reject do |entry|
        next if %w[. ..].include?(entry)
        File.directory?(entry)
      end.sort
    end

    # Get the random parts for the robot
    # eyes, ears, etc...
    def get_list_of_files(path)
      # Get all subdirectories
      # sets/set1/blue
      directories = Dir.glob("#{path}/**").select do |entry|
        next if %w[. ..].include?(entry)
        File.directory?(entry)
      end.sort

      # This is to index into the proper place in the hash array
      iter = 4
      directories.map do |dir|
        files = Dir.entries(dir).reject { |k| %w[. ..].include?(k) }.sort
        sample = files[my_hash_array[iter] % files.length]
        iter += 1
        [dir, sample].join('/')
      end
    end

    # Default asset path
    def resource_dir
      File.expand_path('../assets', File.dirname(__FILE__))
    end

    # Where are the sets located
    def sets
      list_directories("#{resource_dir}/sets")
    end

    # Where are the background sets located
    def bg_sets
      list_directories("#{resource_dir}/backgrounds")
    end

    # Where are the color sets located for set1
    def colors
      list_directories("#{resource_dir}/sets/set1")
    end

    # Assemble our robot from elements from the hash_array
    # TODO: see if this file already exists
    def assemble
      # Find Our sets
      # IF it is set1, pick a random color
      robot = Rubohash::Robot.new(build_robot_attrs)

      roboparts = get_list_of_files(robot.my_set).sort_by { |k| k.split('#')[1] }
      robot.parts = roboparts

      # uuse the hash bits to get the actual sample
      background_files = list_files(robot.my_background_set)

      # Set background itself from hash bits
      background_hash_key = my_hash_array[3] % background_files.size
      background = background_files[background_hash_key]

      image = MiniMagick::Image.open(roboparts.first)
      image = image.resize('1024x1024')

      roboparts.each do |part|
        img = MiniMagick::Image.open(part)
        img = img.resize('1024x1024')
        image = image.composite(img) do |c|
          c.compose 'Over'
        end
      end

      bg = MiniMagick::Image.open(background)
      bg = bg.resize('1024x1024')
      image = image.composite(bg) do |c|
        c.compose 'Dst_Over'
        c.resize '300x300'
      end

      robot.name = string
      robot.my_digest = my_digest

      if Rubohash.mounted
        # Just return the image
        image
      else
        path = "#{Rubohash.robot_output_path}#{robot.name}.#{self.my_format}"
        puts "Writing Robot: '#{path}'"
        image.write path
        robot
      end
    end

    private

    # Build out robot attributes
    def build_robot_attrs
      if Rubohash.use_default_set
        set = Rubohash.default_set
        set_hash_key = nil
      else
        # Pull the set from the hash bits
        set_hash_key = my_hash_array[1] % sets.length
        set = sets[set_hash_key]
      end

      if Rubohash.use_default_bg_set
        bg_sample       = Rubohash.default_bg_set
        bg_set_hash_key = nil
      else
        # Pull the background Set from the hash bits
        bg_set_hash_key = my_hash_array[2] % bg_sets.length
        bg_sample       = bg_sets[bg_set_hash_key]
      end

      color = if set == 'set1'
                # Pull the color for the hash bits
                color_hash_key = my_hash_array[0] % colors.length
                color_sample = colors[color_hash_key]

                set = "set1/#{color_sample}"
                color_sample
              end

      # Used to build the robot
      {
        my_set: [resource_dir, 'sets', set].join('/'),
        my_color: color,
        my_background_set: [resource_dir, 'backgrounds', bg_sample].join('/'),
        set_hash_key: set_hash_key,
        bg_set_hash_key: bg_set_hash_key,
        color_hash_key: color_hash_key,
        random: {
          set: set,
          color: color,
          bg_sample: bg_sample
        }
      }
    end
  end
end
