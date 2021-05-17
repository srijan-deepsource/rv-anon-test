require_relative "stack.rb"                      # => true
class CommentValidator
  attr_reader :i, :j, :char_matrix, :hash_stack  # => nil
  def initialize(i,j,char_matrix)
  	@i = i                                        # => 1
  	@j = j                                        # => 0
  	@char_matrix = char_matrix                    # => [["{", "/"], ["/", "/", " ", "I", "'", "m", " ", "i", "g", "n", "o", "r", "e", "d", "\n"], ["\"", "a", "b", "c", "\"", " ", " ", ":", " ", " ", "[", "\"", "a", "b", "c", "\"", ",", " ", "{", "\"", "d", "e", "f", "\"", ":", " ", "\"", "d", "e", "f", "\"", "}", "]", " ", " ", " ", "\n"], ["}"]]
  end                                            # => :initialize

	def valid
		comment_index = [i,j]                                          # => [1, 0]
		char_matrix                                                    # => [["{", "/"], ["/", "/", " ", "I", "'", "m", " ", "i", "g", "n", "o", "r", "e", "d", "\n"], ["\"", "a", "b", "c", "\"", " ", " ", ":", " ", " ", "[", "\"", "a", "b", "c", "\"", ",", " ", "{", "\"", "d", "e", "f", "\"", ":", " ", "\"", "d", "e", "f", "\"", "}", "]", " ", " ", " ", "\n"], ["}"]]
		comment_index[0]                                               # => 1
		comment_index[1]+1                                             # => 1
		next_item = char_matrix[comment_index[0]][comment_index[1]+1]  # => "/"
		if next_item && next_item == "/"                               # => true
			return comment_index[0]+1,0                                   # => 0
		else
			raise "Invalid comment"
		end
	end                                                             # => :valid
end                                                              # => :valid

# char_matrix = [["{", "/"], ["/", "/", " ", "I", "'", "m", " ", "i", "g", "n", "o", "r", "e", "d", "\n"], ["\"", "a", "b", "c", "\"", " ", " ", ":", " ", " ", "[", "\"", "a", "b", "c", "\"", ",", " ", "{", "\"", "d", "e", "f", "\"", ":", " ", "\"", "d", "e", "f", "\"", "}", "]", " ", " ", " ", "\n"], ["}"]]  # => [["{", "/"], ["/", "/", " ", "I", "'", "m", " ", "i", "g", "n", "o", "r", "e", "d", "\n"], ["\"", "a", "b", "c", "\"", " ", " ", ":", " ", " ", "[", "\"", "a", "b", "c", "\"", ",", " ...
# i,j = 1,0                                                                                                                                                                                                                                                                                                            # => [1, 0]
# pp CommentValidator.new(i,j,char_matrix).valid                                                                                                                                                                                                                                                                       # => [2, 0]
# >> [2, 0]

