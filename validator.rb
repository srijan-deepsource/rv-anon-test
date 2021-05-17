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
 end                                                                                  # => :valid

 require_relative "stack.rb"          # => false
class StringValidator
  SKIP = [" ", "\n", "\t", "\s"]      # => [" ", "\n", "\t", " "]
  attr_accessor :i, :j, :char_matrix  # => nil
  def initialize(i,j,char_matrix)
    @i = i                             # => 2
    @j = j                             # => 7
    @char_matrix = char_matrix         # => [["{", "\n"], ["/", "/", " ", "I", "'", "m", " ", "i", "g", "n", "o", "r", "e", "d", "\n"], ["\"", "K", "E", "Y", "\"", ":", " ", "\"", "V", "A", "L", "U", "E", "\"", "\n"], ["}", "\n"]]
  end                                 # => :initialize
    def valid
        key_valid                         # => 2..3
    end                                  # => :valid

    def key_valid
        key_stack = []                                     # => []
        for row in i..(char_matrix.size-1)                 # => 2..3
            for column in j..(char_matrix[i].size-1)       # => 7..14, 7..14
                char = char_matrix[row][column]               # => "\"",  "V",   "A",   "L",   "U",   "E",   "\"",  "\n",  nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil
                if char == ":"                                # => false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false
                    return row, column if valid_key?(key_stack)
                else
                    key_stack << char_matrix[row][column]        # => ["\""], ["\"", "V"], ["\"", "V", "A"], ["\"", "V", "A", "L"], ["\"", "V", "A", "L", "U"], ["\"", "V", "A", "L", "U", "E"], ["\"", "V", "A", "L", "U", "E", "\""], ["\"", "V", "A", "L", "U", "E", "\"", "\n"], ["\"", "V", "A", "L", "U", "E", "\"", "\n", nil], ["\"", "V", "A", "L", "U", "E", "\"", "\n", nil, nil], ["\"", "V", "A", "L", "U", "E", "\"", "\n", nil, nil, nil], ["\"", "V", "A", "L", "U", "E", "\"", "\n", nil, nil, nil, nil], ["...
                end
            end                                               # => 7..14, 7..14
        end                                             # => 2..3
    end                                                 # => :key_valid

  SKIP = [" ", "\n", "\t", "\s"]          # => [" ", "\n", "\t", " "]
    def valid_key?(key_stack)
        key_stack.reverse!.delete_if do |item|
            break if item == "\""
            SKIP.include? item
        end

        # raise "Invalid key" if key_stack[0] != "\"" || key_stack[-1] != "\""  # => nil
        # key_stack.delete_at(0)                                                # => "\""
        # key_stack.delete_at(-1)                                               # => "\""
        # key_stack.reduce(:+).match?(/^[a-zA-Z0-9_]*$/)                        # => true
    end  # => :valid_key?
 end  # => :valid_key?



require_relative "stack.rb"                # => false
require_relative "comment_validator.rb"    # => true
require_relative "key_value_validator.rb"  # => true
class HashValidator
  HASH_NEXT_RULE = {
    "\"" => [",", "{"],                     # => [",", "{"]
    "," => ["\""],                          # => ["\""]
    "/" => ["\"", ",", "{"],                # => ["\"", ",", "{"]
    "}" => ["\"", ",", "{"]                 # => ["\"", ",", "{"]
  }                                        # => {"\""=>[",", "{"], ","=>["\""], "/"=>["\"", ",", "{"], "}"=>["\"", ",", "{"]}

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
    @hash_stack = Stack.new                         # => #<Stack:0x00007fd0f6154900 @ary=[], @max_size=1000>
  end                                              # => :initialize

  def valid
    skip = false   # => false
    next_row = 0     # => 0
    next_column = 0  # => 0

    for row in i..(char_matrix.size-1)                                        # => 0..3
        if row != i                                                              # => false, true, true
            @j = 0                                                                  # => 0, 0
        end                                                                      # => nil,  0,    0
        for column in j..(char_matrix[i].size-1)                                # => 0..1, 0..1, 0..1
            char = char_matrix[row][column]                                        # => "{",   "\n", "/",   "/",   "\"",  "K"
            next if SKIP.include?(char)                                            # => false, true, false, false, false, false
            if skip == true                                                        # => false, false, true, true, true
             next if row < next_row                                                # ~> ArgumentError: comparison of Integer with nil failed
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
                 next_row, next_column = Object.const_get(VALIDATOR_CLASS_RULE[char]).new(row, column, char_matrix).valid  # => [2, 0],             nil
                 skip = true                                                                                               # => true,               true
                end                                                                                                        # => true,               true
            end                                                                                                         # => ["{"], true, true
        end                                                                                                       # => 0..1, 0..1
     end
    end                                                                                                           # => :valid
 end                                                                                                           # => :valid



require_relative "stack.rb"                      # => false
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
        value_valid(row,column)                      # => nil
    end                                           # => :valid

    def colon_present
    end                # => :colon_present

    def value_valid(row,column)
        row                                                # => 2
        column                                             # => 6
        ValueValidator.new(row,column,  char_matrix).valid  # => nil
    end                                                 # => :value_valid

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

  SKIP = [" ", "\n", "\t", "\s"]                                        # => [" ", "\n", "\t", " "]
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


 # require_relative "hash_validator.rb"                                # => true
SKIP = [" ", "\n", "\t", "\s"]                                      # => [" ", "\n", "\t", " "]
char_matrix = []                                                    # => []
f = File.open(File.join(File.dirname(__FILE__), 'anon.txt'), 'r+')  # => #<File:/Users/rajeevvishnu/Desktop/project/Deepsource/anon.txt>
f.each_line do |line|                                               # => #<File:/Users/rajeevvishnu/Desktop/project/Deepsource/anon.txt>
row_matrix = []                                                     # => [],    [],                 [],                     []
line.each_char do |char|                                            # => "{\n", "// I'm ignored\n", "\"KEY\": \"VALUE\"\n", "}\n"
    row_matrix << char                                                 # => ["{"], ["{", "\n"], ["/"], ["/", "/"], ["/", "/", " "], ["/", "/", " ", "I"], ["/", "/", " ", "I", "'"], ["/", "/", " ", "I", "'", "m"], ["/", "/", " ", "I", "'", "m", " "], ["/", "/", " ", "I", "'", "m", " ", "i"], ["/", "/", " ", "I", "'", "m", " ", "i", "g"], ["/", "/", " ", "I", "'", "m", " ", "i", "g", "n"], ["/", "/", " ", "I", "'", "m", " ", "i", "g", "n", "o"], ["/", "/", " ", "I", "'", "m", " ", "i", "g", "n", "...
end                                                                 # => "{\n",         "// I'm ignored\n",                                                                          "\"KEY\": \"VALUE\"\n",                                                                                                                                                        "}\n"
  char_matrix <<  row_matrix                                        # => [["{", "\n"]], [["{", "\n"], ["/", "/", " ", "I", "'", "m", " ", "i", "g", "n", "o", "r", "e", "d", "\n"]], [["{", "\n"], ["/", "/", " ", "I", "'", "m", " ", "i", "g", "n", "o", "r", "e", "d", "\n"], ["\"", "K", "E", "Y", "\"", ":", " ", "\"", "V", "A", "L", "U", "E", "\"", "\n"]], [["{", "\n"], ["/", "/", " ", "I", "'", "m", " ", "i", "g", "n", "o", "r", "e", "d", "\n"], ["\"", "K", "E", "Y", "\"", ":", " ", "\"", "V", ...
end                                                                 # => #<File:/Users/rajeevvishnu/Desktop/project/Deepsource/anon.txt>

p char_matrix  # => [["{", "\n"], ["/", "/", " ", "I", "'", "m", " ", "i", "g", "n", "o", "r", "e", "d", "\n"], ["\"", "K", "E", "Y", "\"", ":", " ", "\"", "V", "A", "L", "U", "E", "\"", "\n"], ["}", "\n"]]

for i in 0..(char_matrix.size-1)                                 # => 0..3
    for j in 0..(char_matrix[i].size-1)                          # => 0..1
        char = char_matrix[i][j]                                    # => "{"
        next if SKIP.include?(char)                                 # => false
        char                                                        # => "{"
        if char == "{"                                              # => true
            char_matrix                                                # => [["{", "\n"], ["/", "/", " ", "I", "'", "m", " ", "i", "g", "n", "o", "r", "e", "d", "\n"], ["\"", "K", "E", "Y", "\"", ":", " ", "\"", "V", "A", "L", "U", "E", "\"", "\n"], ["}", "\n"]]
            next_i, next_j = HashValidator.new(i,j,char_matrix).valid
        # else
        #   raise "ANON should start with {"                          # ~> RuntimeError: ANON should start with {
        end
    end
end

# >> [["{", "\n"], ["/", "/", " ", "I", "'", "m", " ", "i", "g", "n", "o", "r", "e", "d", "\n"], ["\"", "K", "E", "Y", "\"", ":", " ", "\"", "V", "A", "L", "U", "E", "\"", "\n"], ["}", "\n"]]

# ~> ArgumentError
# ~> comparison of Integer with nil failed
# ~>
# ~> /Users/rajeevvishnu/Desktop/project/Deepsource/validator.rb:114:in `<'
# ~> /Users/rajeevvishnu/Desktop/project/Deepsource/validator.rb:114:in `block (2 levels) in valid'
# ~> /Users/rajeevvishnu/Desktop/project/Deepsource/validator.rb:110:in `each'
# ~> /Users/rajeevvishnu/Desktop/project/Deepsource/validator.rb:110:in `block in valid'
# ~> /Users/rajeevvishnu/Desktop/project/Deepsource/validator.rb:106:in `each'
# ~> /Users/rajeevvishnu/Desktop/project/Deepsource/validator.rb:106:in `valid'
# ~> /Users/rajeevvishnu/Desktop/project/Deepsource/validator.rb:233:in `block (2 levels) in <main>'
# ~> /Users/rajeevvishnu/Desktop/project/Deepsource/validator.rb:227:in `each'
# ~> /Users/rajeevvishnu/Desktop/project/Deepsource/validator.rb:227:in `block in <main>'
# ~> /Users/rajeevvishnu/Desktop/project/Deepsource/validator.rb:226:in `each'
# ~> /Users/rajeevvishnu/Desktop/project/Deepsource/validator.rb:226:in `<main>'



