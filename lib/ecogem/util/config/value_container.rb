module Ecogem
  module Util
    class Config
      class ValueContainer
        def initialize(base, config, default_data)
          @base = base
          @config = config
          @default_data = default_data
        end

        def proxy
          @proxy ||= Proxy.new(self)
        end

        def values
          @values ||= h_to_values(@default_data || {})
        end

        def h_to_values(h)
          values = {}
          h.each do |k, v|
            k = k.to_sym
            entry = @config.class.entries[k]
            values[k] = entry.parse(v) if entry
          end
          values
        end

        def values_to_h
          h = {}
          values.each do |k, v|
            entry = @config.class.entries[k]
            h[k.to_s] = entry.unparse(v)
          end
          h
        end

        def resolve_method(name, *args, &block)
          key = name.to_s.sub(/(=)$/, '').to_sym
          assign = $1
          entry = @config.class.entries[key]
          if entry
            if assign
              return values[key] = args.first
            else
              begin
                return find_value(key)
              rescue NotFoundError
                value = entry.parse(nil)
                values[key] = value
                return value
              end
            end
          end
          raise UnresolvedError
        end

        def find_value(key)
          return values[key] if values.key?(key)
          return @base.find_value(key) if @base
          raise NotFoundError
        end

        class NotFoundError < ::StandardError
        end

        class UnresolvedError < ::StandardError
        end

        class Proxy
          def initialize(container)
            @container = container
          end

          def method_missing(name, *args, &block)
            begin
              return @container.resolve_method(name, *args, &block)
            rescue ::Ecogem::Util::Config::ValueContainer::UnresolvedError
            end
            super
          end
        end
      end
    end
  end
end