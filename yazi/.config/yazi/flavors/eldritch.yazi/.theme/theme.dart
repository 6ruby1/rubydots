// comment.line.double-slash
/* comment.block */
/// comment.documentation

const num = 42;                 // constant.numeric
final esc = '\n';               // constant.character.escape
bool flag = true;               // constant.language

class MyClass extends BaseClass { // entity.name.type, entity.inherited-class
    String myFunction(String param) { // entity.name.function, variable.parameter
        var color = "#ff0000";        // constant.other, string.quoted.double
        if (flag) {                   // keyword.control
            return color;             // keyword.control
        }
        return "";
    }
}
