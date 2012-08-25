# encoding: utf-8

require "canery"

describe Canery::Client do
  context "initialization" do
    it "should not require a connection string" do
      expect { Canery::Client.new }.not_to raise_error
    end
    
    it "should hide the backend" do
      @client = Canery::Client.new
      expect { @client.backend }.to raise_error
    end

    it "should have no tubs initialized" do
      @client = Canery::Client.new
      @client.tubs.should be_empty
    end
    
  end
  
  context "tub method" do
    before(:each) do
      @client = Canery::Client.new
    end
    
    describe "#tub" do
      it "should create a new tub" do
        @client.tub("store")
        @client.tubs.include?("store").should be_true
      end

      it "tub should be a Tub object" do
          @client.tub("store").should be_kind_of(Canery::Tub)
      end 

      it "should use the an existing tub instead of creating a new one" do
        @client.tub("store").should == @client.tub("store")
      end
    end
    
    describe "#delete_tub" do
      it "should delete a specified tub" do
        @client.tub("store")
        @client.tubs.length.should == 1
        @client.delete_tub("store")
        @client.tubs.length.should == 0
      end
    end
    
    describe "#has_tub?" do
      it "should check return true if a tub already exists" do
        @client.tub("store")
        @client.has_tub?("store").should be_true
      end
    end

    describe "#tubs" do
      it "should return a list of all tubs" do
        @client.tub("first_store")
        @client.tub("another_tub")
        @client.tubs.should be_kind_of(Array)
        @client.tubs.length.should == 2
        @client.tubs.include?("first_store").should be_true
        @client.tubs.include?("another_tub").should be_true
      end
    end
      
  end
end
