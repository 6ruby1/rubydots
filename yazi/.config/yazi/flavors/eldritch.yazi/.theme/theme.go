// comment.line.double-slash
/* comment.block */

/*
comment.documentation
*/

const PI = 3.14 // constant.numeric
var esc = '\n'  // constant.character.escape
var flag = true // constant.language

type MyType struct {        // entity.name.type
    Field int
}

func myFunction(param int) string { // entity.name.function, variable.parameter
    color := "#ff0000"              // constant.other, string.quoted.double
    if flag {                       // keyword.control
        return color                // keyword.control
    }
    return ""
}
