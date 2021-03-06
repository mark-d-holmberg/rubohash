# Rubohash namespace
module Rubohash
  # A Robot
  class Robot
    attr_accessor :my_set, :my_color, :my_background_set, :name, :parts, :my_digest

    # Default the robot params
    def initialize(params = {})
      puts 'Building Robot with Params:'
      pp params
      self.my_set        = params.fetch(:my_set, nil)
      self.my_color      = params.fetch(:my_color, nil)
      self.my_background_set = params.fetch(:my_background_set, nil)
    end
  end
end
