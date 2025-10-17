// comment.line.double-slash
/* comment.block */
/// comment.documentation

const int NUM = 42;     // constant.numeric
const char ESC = '\n';  // constant.character.escape
const bool FLAG = true; // constant.language

class MyClass : public BaseClass { // entity.name.type, entity.inherited-class
public:
  static void func(
      int param) { // entity.name.function, variable.parameter, storage.modifier
    int result = NUM + 1; // variable.other
    return;               // keyword.control
  }
};

#define COLOR "#ff0000" // constant.other
if (FLAG) {             // keyword.control
  result = a || b;      // keyword.operator
}
