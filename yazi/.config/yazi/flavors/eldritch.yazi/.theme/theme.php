<?php
// comment.line.double-slash
# comment.line.number-sign
/* comment.block */

/**
 * comment.documentation
 */

define('NUM', 42);                    // constant.numeric
define('ESC', "\n");                  // constant.character.escape
define('FLAG', true);                 // constant.language

class MyClass extends BaseClass {      // entity.name.type, entity.inherited-class
    public function myFunction($param) { // entity.name.function, variable.parameter
        $color = "#ff0000";           // constant.other, string.quoted.double
        if (FLAG) {                   // keyword.control
            return $color;            // keyword.control
        }
        return "";
    }
}
?>
