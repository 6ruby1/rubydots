// comment.line.double-slash
/* comment.block */
/** comment.documentation */

const num: number = 42; // constant.numeric
const esc: string = "\n"; // constant.character.escape
const flag: boolean = true; // constant.language

function myFunction(param: string): void {
  // entity.name.function, variable.parameter
  let color = "#ff0000"; // constant.other, string.quoted.double
  if (flag) {
    // keyword.control
    color = flag ? "red" : "blue"; // keyword.operator
  }
  return color; // keyword.control
}

class MyClass extends BaseClass {} // entity.name.type, entity.inherited-class

type MyType = { a: number }; // storage.type

import { something } from "module"; // keyword.other, support.other
