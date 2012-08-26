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
      backend.call(:get, name, key)
    end
    alias :[] :get
    
    def mget(keys)
      backend.call(:mget, name, keys)
    end
    
    def set(key, value)
      backend.call(:set, name, key || uuid, value)
    end
    alias :[]= :set
    
    def mset(data)
      backend.call(:mset, name, data)
    end
    
    def delete(key)
      backend.call(:delete, name, key)
    end
    
    def clear
      backend.call(:clear, name)
    end
    
    def has_key?(key)
      backend.call(:has_key?, name, key)
    end
    alias :key? :has_key?
    
    def keys
      backend.call(:keys, name)
    end
    
    def values
      backend.call(:values, name)
    end
    
    def sort(order, limit = nil)
      begin
        backend.call(:sort, name, order, limit)
      rescue ArgumentError => e
        raise Canery::CaneryError, e
      end
    end
    
    def rename(old_key, new_key)
      backend.call(:rename, name, old_key, new_key)
    end
    
    def length
      backend.call(:count, name)
    end
    alias :size :length
    alias :count :length    
    
    private
    
    def backend
      @backend
    end
    
    def uuid
      SecureRandom.uuid
    end
        
  end
end