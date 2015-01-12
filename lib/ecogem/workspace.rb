require 'fileutils'
require 'tmpdir'
require 'yaml'

module Ecogem
  class Workspace
    def initialize(args, options = {}, &block)
      @args = args || ::Ecogem::Cli::Args.new([])
      options = {}.merge(options)
      new_tmpdir do |dir|
        begin
          @workdir = dir
          block.call self
          unless options[:readonly]
            gitsfile.save
          end
        end
      end
    end

    def global_env
      @global_env ||= ::Ecogem::Env.new(nil, ::File.expand_path(::Dir.home + '/.ecogem'))
    end

    def env
      @env ||= ::Ecogem::Env.new(global_env, env_path)
    end

    def gitsfile
      @gitsfile ||= ::Ecogem::Gitsfile.new(nil, global_env.dir + '/gits/keys')
    end

    private def env_path
      @env_path ||= begin
        path = ::File.expand_path(@args.options[:env] || ::File.dirname(gemfile_path) + '/.ecogem')
        raise "file exists: #{path}" if ::File.file?(path)
        ::FileUtils.mkdir_p path unless ::File.exist?(path)
        path
      end
    end

    private def gemfile_path
      @gemfile_path ||= ::File.expand_path(@args.options[:gemfile] || ::Dir.pwd + '/Ecogemfile')
    end

    def gemfile
      @gemfile ||= ::Ecogem::Gemfile.new(gemfile_path)
    end

    private def tmp_path
      @tmp_path ||= begin
        path = File.expand_path(@args.options[:tmpdir] || "#{env_path}/tmp")
        raise "file exists: #{path}" if ::File.file?(path)
        path
      end
    end

    def new_tmpdir(&block)
      ::FileUtils.mkdir_p tmp_path unless ::File.exist?(tmp_path)
      ::Dir.mktmpdir(nil, tmp_path) do |dir|
        return block.call(dir)
      end
    end
  end
end