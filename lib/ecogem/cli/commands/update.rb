require 'bundler'

module Ecogem
  class Cli
    module Commands
      class Update
        def initialize(args)
          @args = args
        end

        def execute
          ::Ecogem.new_workspace(@args) do |ws|
            gemfile = "--gemfile=#{ws.gemfile.write.inspect}"
            args = [*@args.bundler_args, gemfile].join(' ')
            command = "bundle update #{args}"
            system command
          end
        end
      end
    end
  end
end
