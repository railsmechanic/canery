# encoding: utf-8

require "securerandom"

module Canery
  class Tub
    
    attr_reader :name
    
    def initialize(backend, name)
      raise ArgumentError, "unknown backend type" unless Canery::Backend === backend
      raise ArgumentError, "name of tub must be a String" unless String === name
      @backend, @name = backend, name
    end
    
    def get(key)
      backend.get(name, key)
    end
    alias :[] :get
    
    def mget(keys)
      backend.mget(name, keys)
    end
    
    def set(key, value)
      backend.set(name, key || uuid, value)
    end
    alias :[]= :set
    
    def mset(data)
      backend.mset(name, data)
    end
    
    def delete(key)
      backend.delete(name, key)
    end
    
    def clear
      backend.clear(name)
    end
    
    def has_key?(key)
      backend.has_key?(name, key)
    end
    alias :key? :has_key?
    
    def keys
      backend.keys(name)
    end
    
    def values
      backend.values(name)
    end
    
    def sort(order, limit = nil)
      begin
        backend.sort(name, order, limit)
      rescue ArgumentError
        raise Canery::CaneryError, "limit parameter must be an Integer"
      end
    end
    
    def rename(old_key, new_key)
      backend.rename(name, old_key, new_key)
    end
    
    def length
      backend.length(name)
    end
    alias :size :length
    
    private
    
    def backend
      @backend
    end
    
    def uuid
      SecureRandom.uuid
    end
        
  end
end