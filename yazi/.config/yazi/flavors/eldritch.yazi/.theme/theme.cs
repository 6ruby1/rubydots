// comment.line.double-slash
/* comment.block */
/// comment.documentation

public class MyClass : BaseClass        // entity.name.type, entity.inherited-class, storage.type
{
    public const int NUM = 42;          // constant.numeric
    public char esc = '\n';             // constant.character.escape
    public bool flag = true;            // constant.language

    public void MyFunction(int param)   // entity.name.function, variable.parameter
    {
        string color = "#ff0000";       // constant.other, string.quoted.double
        if (flag)                       // keyword.control
            color = flag ? "red" : "blue"; // keyword.operator
    }
}
