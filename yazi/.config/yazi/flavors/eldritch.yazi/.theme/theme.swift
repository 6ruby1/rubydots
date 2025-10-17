// comment.line.double-slash
/* comment.block */

/// comment.documentation

let num: Int = 42                 // constant.numeric
let esc: Character = "\n"         // constant.character.escape
let flag: Bool = true             // constant.language

class MyClass: BaseClass {        // entity.name.type, entity.inherited-class
    func myFunction(param: String) -> String { // entity.name.function, variable.parameter
        let color = "#ff0000"     // constant.other, string.quoted.double
        if flag {                 // keyword.control
            return color          // keyword.control
        }
        return ""
    }
}
