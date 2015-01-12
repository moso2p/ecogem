require_relative 'cli/args'

module Ecogem
  class Cli
    def self.start(argv)
      self.new(argv).execute
    end

    def initialize(argv)
      @args = ::Ecogem::Cli::Args.new(argv)
    end

    def execute
      raise "Unknown command: #{@args.command}" unless %w[install update].include?(@args.command)
      require_relative "cli/commands/#{@args.command}"
      klass_name = @args.command.split(/_/).map{|i| i[0].upcase + i[1..-1]}.join('')
      klass = ::Ecogem::Cli::Commands.const_get(klass_name, false)
      klass.new(@args).execute
    end
  end
end