module Ecogem
  class Gitsfile
    module Entries
      class Keys < ::Ecogem::Util::Config::Entry
        def parse(data)
          (data || []).dup
        end

        def unparse(value)
          value.dup
        end
      end
    end
  end
end