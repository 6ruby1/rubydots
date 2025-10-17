# comment.line.number-sign

set(NUM 42)                # constant.numeric
set(ESC "\n")              # constant.character.escape
set(FLAG ON)               # constant.language

function(my_function param) # entity.name.function, variable.parameter
    set(COLOR "#ff0000")   # constant.other, string.quoted.double
    if(FLAG)               # keyword.control
        message("Flag is ON") # support.function
    endif()
endfunction()

set(MyClass "ClassName")   # entity.name.type
