# Canery
Canery is a simple and easy to use key/value store with several commands to store and retrieve data. As the backend uses [Sequel](https://github.com/jeremyevans/sequel/) for persistence, Canery can be used in virtually any environment where a SQL database is available. (For more information please check out the section in the Sequel documentation with the available database adapters.)

## Installation
	gem install canery

## Usage
Canery provides a simple and understandable API which is a bit inspired by Redis. So everyone with a little knowledge of Redis should be able to use Canery, too. 

	require 'canery'

	# Create a Client interface with an in-memory SQLite database 
	client = Canery::Client.new
	
	# Create a Client interface connecting to a PostgreSQL database
	client = Canery::Client.new("postgres://username:password@host:port/database_name")

	# Create a new namespace
	store = client.tub("store")

	# Set a simple value in this defined namespace
	store.set("github", "github is awesome") # => "github"

	# Get this previously set value
	store.get("github") # => "github is awesome"

	# Canery can also handle complex data types
	store.set("demo_hash", {:first_name => "John", :last_name => "Doe"}) # => "demo_hash"

	# Get this complex value
	store.get("demo_hash") # => {:first_name => "John", :last_name => "Doe"}

For more information consider the wiki. (Comming soon... I promise!)


## Information about data types
### Keys & Tub names
Theoretically every string can be used as a key/tub name, from a string like "foo" to the content of a JPEG file. Even an empty string is a valid key. But for better performance, short keys should be your first choice.

Please keep in mind that Canery uses strings for all keys/tub names, so any other data type will be converted to a string!

### Values
Canery makes use of Ruby's marshaling library for serializing the given values. So every data type which supports marshalling is compatible with Canery. If you want to add serialization support to your class (for example, if you want to serialize in some specific format), or if it contains objects that would otherwise not be serializable, you can implement your own serialization strategy. See [Ruby's Mashal Documentation](http://www.ruby-doc.org/core-1.9.3/Marshal.html) for more information.

## License
Copyright (c) 2012 Matthias Kalb, Railsmechanic

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
