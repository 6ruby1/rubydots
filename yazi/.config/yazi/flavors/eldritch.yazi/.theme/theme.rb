# comment.line.number-sign
=begin
comment.block
=end

NUM = 42                         # constant.numeric
ESC = "\n"                       # constant.character.escape
FLAG = true                      # constant.language

class MyClass < BaseClass        # entity.name.type, entity.inherited-class
    def my_function(param)       # entity.name.function, variable.parameter
        color = "#ff0000"        # constant.other, string.quoted.double
        if FLAG                  # keyword.control
            return color         # keyword.control
        end
    end
end
