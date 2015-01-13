require_relative 'ecogem/version'

Object.autoload :Bundler, 'bundler' unless Object.const_defined?(:Bundler, false)

module Ecogem
  %w[cli config env gemfile git gitsfile path util workspace].each do |name|
    pascal = name.split(/_/).map{|i| i[0].upcase + i[1..-1]}.join('')
    autoload pascal, ::File.expand_path("../ecogem/#{name}", __FILE__)
  end

  def self.workspaces
    ::Thread.current[:ecogem_workspaces] ||= []
  end

  def self.workspace
    workspaces.last
  end

  def self.new_workspace(args, options = {}, &block)
    Workspace.new(args, options) do |ws|
      begin
        ::Thread.current[:ecogem_workspaces] ||= []
        workspaces << ws
        break block.call(ws)
      ensure
        workspaces.pop
      end
    end
  end

  def self.git_path(key)
    new_workspace(nil, readonly: true) do |ws|
      break ws.gitsfile.dir_of(key)
    end
  end
end
