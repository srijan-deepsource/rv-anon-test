require_relative "stack.rb"                                                           # => true
class ValueValidator
  VALIDATOR_CLASS_RULE = {
  	"\"" => "StringValidator",                                                         # => "StringValidator"
  	"[" => "ArrayValidator",                                                           # => "ArrayValidator"
  	"{" => "HashValidator"                                                             # => "HashValidator"
  }                                                                                   # => {"\""=>"StringValidator", "["=>"ArrayValidator", "{"=>"HashValidator"}
  SKIP = [" ", "\n", "\t", "\s"]                                                      # => [" ", "\n", "\t", " "]
  attr_accessor :i, :j, :char_matrix                                                  # => nil
  def initialize(i,j,char_matrix)
  	@i = i                                                                             # => 2
  	@j = j                                                                             # => 6
  	@char_matrix = char_matrix                                                         # => [["{", "\n"], ["/", "/", " ", "I", "'", "m", " ", "i", "g", "n", "o", "r", "e", "d", "\n"], ["\"", "K", "E", "Y", "\"", ":", " ", "\"", "V", "A", "L", "U", "E", "\"", "\n"], ["}", "\n"]]
  end                                                                                 # => :initialize
  	def valid
	  	 for row in i..(char_matrix.size-1)                                               # => 2..3
	  		if row != i                                                                      # => false
	  			@j = 0
	  		end                                                                              # => nil
		    for column in j..(char_matrix[i].size-1)                                        # => 6..14
		    	char = char_matrix[row][column]                                                # => " ",  "\""
		    	next if SKIP.include?(char)                                                    # => true, false
		    	raise "Not a valid value" unless VALIDATOR_CLASS_RULE[char]                    # => nil
				Object.const_get(VALIDATOR_CLASS_RULE[char]).new(row, column, char_matrix).valid  # => 2..3
				return
		    end
		 end
	end                                                                                  # => :valid
 end 