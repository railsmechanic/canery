# Canery
Canery is a simple and easy to use key/value store with several commands to store and retrieve data. Canery uses [Sequel](https://github.com/jeremyevans/sequel/) for persistence, so it can be used in virtually any environment where a SQL database is available. (For more information about the available database adapters please check out the appropriate section in the Sequel documentation.)

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
	
	# If you set nil as key, Canery builds a uuid-key for you
	store.set(nil, "oh my god, no key given!") # => "2cf7541a-00c1-4bda-8c75-fc32a5f5fac7"

For more information consider the wiki. (Comming soon... I promise!)

## Performance
Due to the nature of SQL databases it's (almost) impossible for Canery to be as fast as well-known NoSQL key/value stores like Kyoto Cabinet, LevelDB or Redis. But for environments where NoSQL databases are not available or just for small Web Applications you should give Canery a try.

## Information about data types
### Keys & Tub names
Theoretically every string can be used as a key/tub name, from a string like "foo" to the serialized content of a PNG file. Even an empty string is a valid key/tub name. But for better performance the max key size defaults to 255 characters.

Please keep in mind that Canery uses strings for all keys/tub names, so any other data type will be converted to a string!

### Values
Canery makes use of Ruby's marshaling library for serializing the given values. So every data type which supports marshalling is compatible with Canery. If you want to add serialization support to your class (for example, if you want to serialize in some specific format), or if it contains objects that would otherwise not be serializable, you can implement your own serialization strategy. See [Ruby's Mashal Documentation](http://www.ruby-doc.org/core-1.9.3/Marshal.html) for more information.

## License
Copyright (c) 2012 Matthias Kalb, Railsmechanic

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
