# encoding: utf-8

require "sequel"
require "base64"

module Canery
  
  class Backend
    
    TABLE_PREFIX = "canery_"
    
    def initialize(connection_uri)
      raise ArgumentError, "connection_uri must be a String or nil" unless NilClass === connection_uri || String === connection_uri
      @connection = connection_uri.nil? ? Sequel.sqlite : Sequel.connect(connection_uri)
      @namespace_cache = {}
    end
    
    # Basic namespace methods #
    ###########################
    
    def create_namespace(name)
      connection.create_table basic_tub_name(name) do
        String :key, :primary_key => true
        String :value, :text => true
      end
    end
    
    def delete_namespace(name)
      @namespace_cache.delete(basic_tub_name(name)) if @namespace_cache[basic_tub_name(name)]
      connection.drop_table?(basic_tub_name(name)) && "OK"
    end
    
    def namespace(name)
      @namespace_cache[basic_tub_name(name)] ||= connection.dataset.select(:key, :value).from(basic_tub_name(name))
    end
    
    def namespaces
      connection.tables.select{ |name| name =~ /^#{TABLE_PREFIX}/ }.map{ |tub_name| tub_name.to_s[TABLE_PREFIX.length..-1] }
    end
    
    def namespace?(name)
      connection.table_exists?(basic_tub_name(name))
    end
    
    
    # Methods for get, set, etc. #
    ##############################
    
    def get(name, key)
      data = namespace(name).first(:key => build_key(key))
      data.nil? ? nil : load(data[:value])
    end
    
    def mget(name, keys)
      raise ArgumentError, "keys argument must be an Array of keys" unless Array === keys
      keys.map!{ |key| build_key(key) }

      # Sort data in the order they appear in the 'keys' Array
      namespace(name).where(:key => keys).sort_by { |element| keys.index(element[:key]) }.map {|dataset| load(dataset[:value]) }
    end
    
    def set(name, key, value)
      begin
        namespace(name).insert(:key => build_key(key), :value => dump(value)) && build_key(key)
      rescue Sequel::DatabaseError # raised if the key already exists, than update
        update(name, key, value)
      rescue
        "ERROR"
      end
    end
    
    def mset(name, data)
      raise ArgumentError, "data must be a Hash with keys and values" unless Hash === data
      begin
        namespace(name).multi_insert(data.map{ |key, value| {:key => build_key(key), :value => dump(value)} }) && "OK"
      rescue
        # Fallback to the slower update method
        data.each do |key, value|
          update(name, key, value)
        end && "OK"
      end
    end
    
    def delete(name, key)
      namespace(name).where(:key => build_key(key)).limit(1).delete && "OK"
    end
    
    def clear(name)
      namespace(name).delete && "OK"
    end
    
    def update(name, key, value)
      namespace(name).where(:key => build_key(key)).limit(1).update(:value => dump(value)) && build_key(key)
    end
    
    def has_key?(name, key)
      !!get(name, key)
    end
    
    def keys(name)
      namespace(name).map{ |dataset| dataset[:key] }
    end
    
    def values(name)
      namespace(name).map{ |dataset| load(dataset[:value]) }
    end
    
    def sort(name, order, limit)
      data = case order.downcase
        when :asc, 'asc'
          namespace(name).order(Sequel.asc(:key))
        when :desc, 'desc'
          namespace(name).order(Sequel.desc(:key))
        else
          namespace(name).order(Sequel.asc(:key))
      end
      
      unless limit.nil?
        raise ArgumentError, "limit must be a positive Integer" unless Integer === limit
        data = data.limit(limit)
      end
      data.map{ |dataset| dataset[:key] }
    end
    
    def rename(name, old_key, new_key)
      namespace(name).where(:key => build_key(old_key)).limit(1).update(:key => build_key(new_key)) && "OK"
    end
    
    def length(name)
      namespace(name).count
    end
    
    private
    
    # Sequel seems to have problems with escaping, so we use Base64 encoding/decoding as a simple work around
    def load(data)
      Marshal.load(Base64.urlsafe_decode64(data))
    end
    
    def dump(data)
      Base64.urlsafe_encode64(Marshal.dump(data))
    end
    
    def connection
      @connection
    end
    
    def build_key(key)
      key.to_s.strip
    end
    
    def basic_tub_name(name)
      "#{TABLE_PREFIX}#{name.strip}"
    end
    
  end
end