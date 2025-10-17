// comment.line.double-slash
/* comment.block */
/// comment.documentation

const PI: f64 = 3.14;          // constant.numeric
let esc = '\n';                // constant.character.escape
let flag = true;               // constant.language

struct MyStruct;               // entity.name.type
fn my_function(param: i32) {   // entity.name.function, variable.parameter
    let color = "#ff0000";     // constant.other, string.quoted.double
    if flag {                  // keyword.control
        println!("{}", color); // support.function
    }
}
