
require_relative "stack.rb"              # => true
require_relative "comment_validator.rb"  # => true
require_relative "key_value_validator.rb"
class HashValidator
  HASH_NEXT_RULE = {
  	"\"" => [",", "{"],                   # => [",", "{"]
  	"," => ["\""],                        # => ["\""]
  	"/" => ["\"", ",", "{"],              # => ["\"", ",", "{"]
  	"}" => ["\"", ",", "{"]               # => ["\"", ",", "{"]
  }                                      # => {"\""=>[",", "{"], ","=>["\""], "/"=>["\"", ",", "{"], "}"=>["\"", ",", "{"]}

  HASH_PUSH_RULE = ["\"", ","]  # => ["\"", ","]

  VALIDATOR_CLASS_RULE = {
  	"/" => "CommentValidator",   # => "CommentValidator"
  	"\"" => "KeyValueValidator"  # => "KeyValueValidator"
  }                             # => {"/"=>"CommentValidator", "\""=>"KeyValueValidator"}

  SKIP = [" ", "\n", "\t", "\s"]                   # => [" ", "\n", "\t", " "]
  attr_accessor :i, :j, :char_matrix, :hash_stack  # => nil
  def initialize(i,j,char_matrix)
  	@i = i                                          # => 0
  	@j = j                                          # => 0
  	@char_matrix = char_matrix                      # => [["{", "\n"], ["/", "/", " ", "I", "'", "m", " ", "i", "g", "n", "o", "r", "e", "d", "\n"], ["\"", "K", "E", "Y", "\"", ":", " ", "\"", "V", "A", "L", "U", "E", "\"", "\n"], ["}", "\n"]]
  	@hash_stack = Stack.new                         # => #<Stack:0x00007fea68135a60 @ary=[], @max_size=1000>
  end                                              # => :initialize

  def valid
  	skip = false   # => false
	next_row = 0     # => 0
	next_column = 0  # => 0

  	for row in i..(char_matrix.size-1)                                        # => 0..3
  		if row != i                                                              # => false, true, true, true
  			@j = 0                                                                  # => 0, 0, 0
  		end                                                                      # => nil,  0,    0,    0
	    for column in j..(char_matrix[i].size-1)                                # => 0..1, 0..1, 0..1, 0..1
	    	char = char_matrix[row][column]                                        # => "{",   "\n", "/",   "/",   "\"",  "K",   "}",   "\n"
	    	next if SKIP.include?(char)                                            # => false, true, false, false, false, false, false, true
	    	if skip == true                                                        # => false, false, true, true, true, true
	    	 next if row < next_row                                                # => true, false, true, true
	    	 next if column < next_column                                          # => false
				next_row = 0                                                             # => 0
				next_column = 0                                                          # => 0
	    	 skip = false                                                          # => false
	    	end                                                                    # => nil,  nil,   false
	    	char                                                                   # => "{",  "/",   "\""
	    	if char == "{"                                                         # => true, false, false
	    		raise "Cannot have two opening {" unless hash_stack.empty?            # => nil
	    		hash_stack.push(char)                                                 # => ["{"]
	    	else
	    		last_entry = hash_stack.peek                                          # => "{",   "{"
	    		char                                                                  # => "/",   "\""
	    		HASH_NEXT_RULE[char].include?(last_entry)                             # => true,  true
				raise "Not valid hash" unless HASH_NEXT_RULE[char].include?(last_entry)  # => nil,   nil
				if char == "}"                                                           # => false, false
					if char_matrix[row][column+1]
						return row, column+1
					elsif char_matrix[row+1][0]
						return row+1, 0
					else
						return row, column
					end
				end

				char                                                                                                       # => "/",                "\""
				hash_stack.push(char) if HASH_PUSH_RULE.include?(char)                                                     # => nil,                ["{", "\""]
				if VALIDATOR_CLASS_RULE[char]                                                                              # => "CommentValidator", "KeyValueValidator"
				 next_row, next_column = Object.const_get(VALIDATOR_CLASS_RULE[char]).new(row, column, char_matrix).valid  # => [2, 0],             6
				 skip = true                                                                                               # => true,               true
				end                                                                                                        # => true,               true
			end                                                                                                         # => ["{"], true, true
	    end                                                                                                       # => 0..1, 0..1, 0..1, 0..1
	 end                                                                                                          # => 0..3
	end                                                                                                           # => :valid
 end                                                                                                           # => :valid
