module Ecogem
  class Gitsfile < ::Ecogem::Util::Config
    %w[entries].each do |name|
      pascal = name.split(/_/).map{|i| i[0].upcase + i[1..-1]}.join('')
      autoload pascal, ::File.expand_path("../gitsfile/#{name}", __FILE__)
    end

    entry_namespace Entries
    entry :keys

    def dir_of(key)
      i = values.keys.find_index(key) || begin
        values.keys << key
        values.keys.size - 1
      end
      "#{dir}/#{i+1}"
    end
  end
end