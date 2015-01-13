module Ecogem
  class Path
    attr_reader :dir

    def initialize(dir)
      @dir = dir
    end

    private def gemfile_path
      @gemfile_path ||= ::File.expand_path("#{dir}/Ecogemfile")
    end

    def gemfile
      @gemfile ||= begin
        ::Ecogem::Gemfile.new(gemfile_path) if ::File.file?(gemfile_path)
      end
    end
  end
end