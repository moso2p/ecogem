require 'yaml'

module Ecogem
  module Util
    class Config
      %w[entry value value_container].each do |name|
        pascal = name.split(/_/).map{|i| i[0].upcase + i[1..-1]}.join('')
        autoload pascal, ::File.expand_path("../config/#{name}", __FILE__)
      end

      def self.entry_namespaces
        @entry_namespaces ||= []
      end

      def self.entry_namespace(ns)
        entry_namespaces << ns
      end

      def self.entry(key)
        e = ::Ecogem::Util::Config::Entry.create(self, key)
        entries[key] = e
      end

      def self.find_entry_class(key)
        pascal = key.to_s.split(/_/).map{|i| i[0].upcase + i[1..-1]}.join('')
        entry_namespaces.reverse.each do |ns|
          return ns.const_get(pascal, false) if ns.const_defined?(pascal, false)
        end
        nil
      end

      def self.entries
        @entries ||= {}
      end

      def initialize(base, path)
        @base = base
        @path = ::File.expand_path(path)
      end

      def dir
        @dir ||= ::File.dirname(@path)
      end

      protected def value_container
        @value_conatiner ||= ::Ecogem::Util::Config::ValueContainer.new(@base && @base.value_container, self, load || {})
      end

      def values
        @values ||= value_container.proxy
      end

      private def load
        ::YAML.load(::File.read(@path)) if ::File.file?(@path)
      end

      def save
        ::File.write @path, value_container.values_to_h.to_yaml
      end
    end
  end
end