module Ecogem
  class Gemfile
    %w[dependency marshal source].each do |name|
      pascal = name.split(/_/).map{|i| i[0].upcase + i[1..-1]}.join('')
      autoload pascal, ::File.expand_path("../gemfile/#{name}", __FILE__)
    end

    def initialize(path)
      @path = path
    end

    def dir
      @dir ||= ::File.dirname(@path)
    end

    private def dependencies
      @dependencies ||= data.dependencies.map{|i| ::Ecogem::Gemfile::Dependency.new(self, i)}
    end

    private def extracted_dependencies
      @extracted_dependencies ||= extract_dependencies([], [], [], false)
    end

    protected def extract_dependencies(into, gits, paths, subfile)
      dependencies.each do |d|
        if d.source.git?
          unless gits.include?(d.source.git_source.key)
            gits << d.source.git_source.key
            d.source.git_source.gemfile.extract_dependencies into, gits, paths, true if d.source.git_source.gemfile
            into << d
          end
        elsif d.source.path?
          unless paths.include?(d.source.path_source.key)
            paths << d.source.path_source.key
            d.source.path_source.gemfile.extract_dependencies into, gits, paths, true if d.source.path_source.gemfile
            into << d
          end
        else
          into << d unless subfile
        end
      end
      into
    end

    private def sources
      @sources ||= data.sources.instance_variable_get(:@rubygems_aggregate).remotes.map{|i| i.to_s}
    end

    def code
      @code ||= begin
        a = []
        a << 'require "ecogem"'
        a << sources.reverse.map{|i| "source #{i.inspect}"}.join("\n")
        a << extracted_dependencies.map{|i| i.code}.uniq.join("\n")
        a.join("\n\n")
      end
    end

    def write(dir = nil, name = nil)
      dir ||= self.dir
      name ||= 'Gemfile'
      path = "#{dir}/#{name}"
      ::File.write "#{dir}/#{name}", code
      path
    end

    private def data
      @data ||= load
    end

    private def load
      in_r, in_w, out_r, out_w = []

      begin
        in_r, in_w = ::IO.pipe
        out_r, out_w = ::IO.pipe

        params = {
          path: @path
        }
        ::Marshal.dump({path: @path}, in_w)

        pid = ::Process.fork do
          params = ::Marshal.load(in_r)

          ::Dir.chdir(::File.dirname(params[:path])) do
            dsl = ::Bundler::Dsl.new
            dsl.eval_gemfile(params[:path])
            result = ::Ecogem::Gemfile::Marshal.new(dsl).to_data
            ::Marshal.dump(result, out_w)
          end

          ::Process.exit!
        end
        ::Process.waitpid(pid)

        ::Marshal.load(out_r)
      ensure
        [in_r, in_w, out_r, out_w].each{|i| i.close if i}
      end
    end
  end
end