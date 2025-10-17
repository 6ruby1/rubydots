# comment.line.number-sign

num <- 42                      # constant.numeric
esc <- "\n"                    # constant.character.escape
flag <- TRUE                   # constant.language

myFunction <- function(param) { # entity.name.function, variable.parameter
    color <- "#ff0000"         # constant.other, string.quoted.double
    if (flag) {                # keyword.control
        return(color)          # keyword.control
    }
}
