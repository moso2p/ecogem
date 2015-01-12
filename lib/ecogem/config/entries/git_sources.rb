module Ecogem
  class Config
    module Entries
      class GitSources < ::Ecogem::Util::Config::Entry
        def parse(data)
          (data || []).map{|i| ::Ecogem::Config::GitSource.new(i)}
        end
      end
    end
  end
end