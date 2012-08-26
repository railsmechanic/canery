# encoding: utf-8

require "canery/backend"
require "canery/tub"

module Canery
  
  class CaneryError < StandardError; end
  
  class Client
    
    def initialize(connection_uri = nil)
      @backend = Backend.new(connection_uri)
    end
    
    def tub(name)
      build_tub_name!(name)
      create_tub(name) unless tub?(name)
      begin
        @tub_cache ||= {}
        @tub_cache[name] ||= Tub.new(backend, name)
      rescue
        raise Canery::CaneryError, "This tub does not exist! You must create it before you can use it."
      end
    end
    
    def delete_tub(name)
      build_tub_name!(name)
      @tub_cache.delete(name) if @tub_cache[name]
      backend.call(:delete_namespace, name)
    end
    
    def has_tub?(name)
      backend.call(:namespace?, name)
    end
    alias :tub? :has_tub?
    
    def tubs
      backend.call(:namespaces)
    end
          
    private
    
    def backend
      @backend
    end
    
    def create_tub(name)
      begin
        backend.call(:create_namespace, name)
      rescue => exception
        raise Canery::CaneryError, exception
      end
    end
    
    def build_tub_name!(name)
      name.to_s.strip!
    end
    
  end
end