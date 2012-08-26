# encoding: utf-8

require "spec_helper"
require "canery"

describe Canery::Tub do
  before(:each) do
    @client = Canery::Client.new
  end
  
  context "on retrieving values" do
    describe "#get" do
      it "should retrieve value" do
        store = @client.tub("store")
        store.set("hello", "hello world")
        store.get("hello").should == "hello world"
      end
      
      it "should retrieve value using the alias method" do
        store = @client.tub("store")
        store.set("hello", "hello world")
        store["hello"].should == "hello world"
      end
      
      it "should return nil if value is not set" do
        store = @client.tub("store")
        store.get("unset_key").should be_nil
      end
    end
    
    describe "#mget" do
      it "should retrieve multiple values at once" do
        store = @client.tub("store")
        store.mset(demo_hash)
        store.mget(demo_hash.keys).each do |value|
          demo_hash.values.should include(value)
        end
      end
    end
  end

  context "on setting values" do
    describe "#set" do
      it "should set value and return key" do
        store = @client.tub("store")
        store.set("hello", "hello world").should == "hello"
      end
      
      it "should set value using the alias method" do
        store = @client.tub("store")
        (store["hello"] = "hello world") == "hello"
      end
      
      it "should overwrite an existing value" do
        store = @client.tub("store")
        store.set("hello", "hello world").should == "hello"
        store.get("hello") == "hello world"
        store.set("hello", "new hello world").should == "hello"
        store.get("hello") == "new hello world"
      end
      
      it "should automatically create an uuid key if key is nil" do
        store = @client.tub("store")
        uuid?(store.set(nil, "hello world")).should be_true
      end
    end
    
    describe "#mset" do
      it "should set multiple values at once" do
        store = @client.tub("store")
        store.mset(demo_hash).should == "OK"
        demo_hash.each do |key, value|
          store.get(key).should == value
        end
      end
      
      it "should overwrite alread set values" do
        store = @client.tub("store")
        store.mset(demo_hash).should == "OK"
        store.mset(second_demo_hash).should == "OK"
        second_demo_hash.each do |key, value|
          store.get(key).should == value
        end
      end
    end
  end
  
  describe "#delete" do
    it "should delete a value" do
      store = @client.tub("store")
      store.set("hello", "hello world")
      store.delete("hello").should == "OK"
    end
  end
  
  describe "#clear" do
    it "should delete all values of a tub" do
      store = @client.tub("store")
      store.mset(demo_hash)
      store.size.should == demo_hash.length
      store.clear
      store.size.should == 0
    end
  end
  
  describe "#has_key?" do
    it "should return true if key is present in tub" do
      store = @client.tub("store")
      store.set("hello", "hello world")
      store.has_key?("hello").should be_true
    end
  end
  
  describe "#keys" do
    it "should return all keys present in a tub" do
      store = @client.tub("store")
      store.mset(demo_hash)
      (store.keys & demo_hash.keys).should == demo_hash.keys
    end
  end
  
  describe "#values" do
    it "should return all values present in a tub" do
      store = @client.tub("store")
      store.mset(demo_hash)
      (store.values & demo_hash.values).should == demo_hash.values
    end
  end
  
  describe "#sort" do
    it "should sort keys in ascending order" do
      store = @client.tub("store")
      store.mset(demo_hash)
      (store.sort(:asc) & demo_hash.keys.sort).should == demo_hash.keys.sort
    end
    
    it "should sort keys in descending order" do
      store = @client.tub("store")
      store.mset(demo_hash)
      data_hash = demo_hash.keys.sort{|a,b| b <=> a}
      (store.sort(:desc) & data_hash).should == data_hash
    end
    
    it "should sort keys and limit" do
      store = @client.tub("store")
      store.mset(demo_hash)
      (store.sort(:asc, 3) & demo_hash.keys.sort[0...3]).should == demo_hash.keys.sort[0...3]
    end
  end
  
  describe "#rename" do
    it "should rename a key without touching the value" do
      store = @client.tub("store")
      store.set("hello", "hello world")
      store.get("hello").should == "hello world"
      store.rename("hello", "new_hello")
      store.get("new_hello").should == "hello world"
    end
  end
  
  describe "#length" do
    it "should return the number of elements in a tub" do
      store = @client.tub("store")
      store.mset(demo_hash)
      store.length.should == demo_hash.length
    end
  end
  
end
