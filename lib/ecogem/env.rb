require 'yaml'

module Ecogem
  class Env
    %w[git_source].each do |name|
      pascal = name.split(/_/).map{|i| i[0].upcase + i[1..-1]}.join('')
      autoload pascal, ::File.expand_path("../env/#{name}", __FILE__)
    end

    attr_reader :dir

    def initialize(base, dir)
      @base = base
      @dir = ::File.expand_path(dir)
    end

    private def config_path
      @config_path ||= "#{dir}/config"
    end

    def config
      @config ||= ::Ecogem::Config.new(@base && @base.config, config_path)
    end

    def git_sources
      @git_sources ||= ::Hash[config.values.git_sources.map{|i| [i.uri, i]}]
    end

    def git_source_uri_to_alias(uri)
      source = git_sources[uri]
      (source && source.uri_alias) || uri
    end
  end
end