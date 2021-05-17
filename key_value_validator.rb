
require_relative "stack.rb"
class KeyValueValidator
  attr_reader :i, :j, :char_matrix, :hash_stack  # => nil
  def initialize(i,j,char_matrix)
  	@i = i                                        # => 2
  	@j = j                                        # => 0
  	@char_matrix = char_matrix                    # => [["{", "\n"], ["/", "/", " ", "I", "'", "m", " ", "i", "g", "n", "o", "r", "e", "d", "\n"], ["\"", "K", "E", "Y", "\"", ":", " ", "\"", "V", "A", "L", "U", "E", "\"", "\n"], ["}", "\n"]]
  end                                            # => :initialize

	def valid
		row, column = key_valid                      # => [2, 5]
		char_matrix[row][column+1]                   # => " "
		row, column = if char_matrix[row][column+1]  # => " "
			[row, column+1]                             # => [2, 6]
		elsif char_matrix[row+1][0]
			[row+1, 0]
		else
			raise "Invalid value for anon"
		end                                          # => [2, 6]
		value_valid(row,column)                      # => 6
	end                                           # => :valid

	def colon_present
	end  # => :colon_present

	def value_valid(row,column)
		row                         # => 2
		column                      # => 6
	end                          # => :value_valid

	def key_valid
		key_stack = []                                     # => []
		for row in i..(char_matrix.size-1)                 # => 2..3
		    for column in j..(char_matrix[i].size-1)       # => 0..14
		    	char = char_matrix[row][column]               # => "\"",  "K",   "E",   "Y",   "\"",  ":"
		    	if char == ":"                                # => false, false, false, false, false, true
		    		return row, column if valid_key?(key_stack)  # => true
		    	else
		    		key_stack << char_matrix[row][column]        # => ["\""], ["\"", "K"], ["\"", "K", "E"], ["\"", "K", "E", "Y"], ["\"", "K", "E", "Y", "\""]
				end
			end
	    end
	end                                                 # => :key_valid

  SKIP = [" ", "\n", "\t", "\s"]                                      # => [" ", "\n", "\t", " "]
	def valid_key?(key_stack)
		key_stack.reverse!.delete_if do |item|                                # => ["\"", "Y", "E", "K", "\""]
			break if item == "\""                                                # => true
			SKIP.include? item
		end                                                                   # => nil
		raise "Invalid key" if key_stack[0] != "\"" || key_stack[-1] != "\""  # => nil
		key_stack.delete_at(0)                                                # => "\""
		key_stack.delete_at(-1)                                               # => "\""
		key_stack.reduce(:+).match?(/^[a-zA-Z0-9_]*$/)                        # => true
	end                                                                    # => :valid_key?
end                                                                     # => :valid_key?
