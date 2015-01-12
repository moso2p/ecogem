module Ecogem
  class Gemfile
    class Marshal
      def initialize(dsl)
        @dsl = dsl
      end

      def to_data
        h = {
          dependencies: @dsl.dependencies,
          sources: @dsl.instance_variable_get(:@sources)
        }
        Data.new(h)
      end

      class Data
        def initialize(hash)
          @hash = hash
        end

        def dependencies
          @hash[:dependencies]
        end

        def groups
          @hash[:groups]
        end

        def sources
          @hash[:sources]
        end
      end
    end
  end
end