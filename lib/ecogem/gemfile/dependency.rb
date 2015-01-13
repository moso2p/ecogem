module Ecogem
  class Gemfile
    class Dependency
      attr_reader :gemfile
      
      def initialize(gemfile, data)
        @gemfile = gemfile
        @data = data
      end

      def name
        @data.name
      end

      def source
        @source ||= ::Ecogem::Gemfile::Source.new(self, @data.instance_variable_get(:@source))
      end

      def versions
        @versions ||= @data.requirement.requirements.map{|i| "#{i[0]} #{i[1]}"}
      end

      def platforms
        @platforms ||= @data.instance_variable_get(:@platforms).dup
      end

      def groups
        @groups ||= @data.instance_variable_get(:@groups).dup
      end

      def code
        @code ||= begin
          a = ["gem \"#{name}\""]

          if !(versions.size == 1 && versions[0] == '>= 0')
            a << versions.map{|i| "\"#{i}\""}.join(', ')
          end

          if platforms.size > 0
            s = if platforms.size == 1
              ":#{platforms[0]}"
            else
              '[' + platforms.map{|i| ":#{i}"}.join(', ') + ']'
            end
            a << "platform: #{s}"
          end

          if groups.size > 0 && !(groups.size == 1 && groups[0] == :default)
            s = if groups.size == 1
              ":#{groups[0]}"
            else
              '[' + groups.map{|i| ":#{i}"}.join(', ') + ']'
            end
            a << "group: #{s}"
          end

          if s = source.code
            a << s
          end

          a.join(', ')
        end
      end
    end
  end
end