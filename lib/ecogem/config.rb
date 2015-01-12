module Ecogem
  class Config < ::Ecogem::Util::Config
    %w[entries git_source].each do |name|
      pascal = name.split(/_/).map{|i| i[0].upcase + i[1..-1]}.join('')
      autoload pascal, ::File.expand_path("../config/#{name}", __FILE__)
    end

    entry_namespace Entries
    entry :git_sources
  end
end