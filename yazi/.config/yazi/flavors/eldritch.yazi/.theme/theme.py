# comment.line.number-sign
"""comment.block"""

PI = 3.14  # constant.numeric
ESC = "\n"  # constant.character.escape
FLAG = True  # constant.language


class MyClass(BaseClass):  # entity.name.type, entity.inherited-class
    def func(self, param):  # entity.name.function, variable.parameter
        color = "#ff0000"  # constant.other, string.quoted.double
        if FLAG:  # keyword.control
            return color  # keyword.control


__underline__  # markup.underline
print("bold text")  # markup.bold
