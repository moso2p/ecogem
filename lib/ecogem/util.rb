module Ecogem
  module Util
    %w[config].each do |name|
      pascal = name.split(/_/).map{|i| i[0].upcase + i[1..-1]}.join('')
      autoload pascal, ::File.expand_path("../util/#{name}", __FILE__)
    end
  end
end
