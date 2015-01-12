module Ecogem
  class Cli
    class Args
      attr_reader :command

      def initialize(argv)
        @argv = argv.dup
        parse
      end

      def options
        @options ||= {}
      end

      def bundler_args
        @argv
      end

      private def parse
        @command = @argv.shift
        extract_options
        @argv.freeze
      end

      private def extract_options
        %i[file port].each do |key|
          if found = @argv.find_index("--ecogem-#{key}")
            name, value = @argv.slice(found, 2)
            options[key] = value
          end
        end
      end
    end
  end
end
