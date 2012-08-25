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
      create_tub(tub_name(name)) unless tub?(tub_name(name))
      begin
        @tub_cache ||= {}
        @tub_cache[tub_name(name)] ||= Tub.new(backend, tub_name(name))
      rescue
        raise Canery::CaneryError, "This tub does not exist! You must create it before you can use it."
      end
    end
    
    def delete_tub(name)
      @tub_cache.delete(tub_name(name)) if @tub_cache[tub_name(name)]
      backend.delete_namespace(tub_name(name))
    end
    
    def has_tub?(name)
      backend.namespace?(tub_name(name))
    end
    alias :tub? :has_tub?
    
    def tubs
      backend.namespaces
    end
          
    private
    
    def backend
      @backend
    end
    
    def create_tub(name)
      begin
        backend.create_namespace(tub_name(name))
      rescue => exception
        raise Canery::CaneryError, exception
      end
    end
    
    def tub_name(name)
      name.to_s.strip
    end
    
  end
end