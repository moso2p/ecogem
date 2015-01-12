require 'fileutils'

module Ecogem
  class Git
    def initialize(uri, ref)
      @uri = uri
      @ref = ref || 'master'
    end

    def key
      @key ||= "#{@uri} #{@ref}"
    end

    def dir
      @dir ||= ::Ecogem.workspace.gitsfile.dir_of(key)
    end

    def uri_alias
      @uri_alias ||= ::Ecogem.workspace.env.git_source_uri_to_alias(@uri)
    end

    def exec(cmd)
      puts "git: #{cmd}"
      cmd = "git #{cmd}"
      system("cd \"#{dir}\"; #{cmd}")
    end

    private def load
      unless @loaded
        ::FileUtils.rm_rf dir
        ::FileUtils.mkdir_p dir
        self.exec "init -q"
        self.exec "remote add origin \"#{uri_alias}\""
        self.exec "fetch -q origin #{@ref}"
        raise CommandError unless $?.success?
        self.exec "checkout -q FETCH_HEAD"
        raise CommandError unless $?.success?
        @loaded = true
      end
    end

    private def gemfile_path
      @gemfile_path ||= ::File.expand_path("#{dir}/Ecogemfile")
    end

    def gemfile
      @gemfile ||= begin
        load
        ::Ecogem::Gemfile.new(gemfile_path) if ::File.file?(gemfile_path)
      end
    end

    class CommandError < ::StandardError
    end
  end
end