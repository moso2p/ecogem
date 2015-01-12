module Ecogem
  class Config
    class GitSource
      def initialize(data)
        @data = data
      end

      def uri
        @data['uri']
      end

      def uri_alias
        @data['uri_alias']
      end
    end
  end
end