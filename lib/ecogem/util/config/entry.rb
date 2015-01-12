module Ecogem
  module Util
    class Config
      class Entry
        attr_reader :key

        def initialize(config, key)
          @config = config
          @key = key
        end

        def self.create(config, key, options = {})
          klass = options[:class] || config.find_entry_class(key)
          klass.new(config, key)
        end
      end
    end
  end
end
