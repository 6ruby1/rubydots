import java.util.List;

// comment.line.double-slash
/* comment.block */
/** comment.documentation */
/**
 * @param Hello world
 * @see au.edu.rmit.sept.eventhub.controllers.LoginController#signUpSubmit(String,
 *      String, String, String, org.springframework.ui.Model,
 *      jakarta.servlet.http.HttpServletRequest)
 * @author 6ruby1
 * @madeUpSymbol hi
 */
@Override
@Test(webmvc.class)
public class MyClass extends BaseClass { // entity.name.type, entity.inherited-class, storage.type
    private static final int NUM = 42; // constant.numeric, storage.modifier
    private char esc = '\n'; // constant.character.escape
    private boolean flag = true; // constant.language
    private boolean yes = true;
    private boolean no = false;
    private String none = null;

    public void myFunction(int param, <T> hi) { // entity.name.function, variable.parameter
        String color = "#ff0000"; // constant.other, string.quoted.double
        if (flag) { // keyword.control
            color = flag ? "red" : "blue"; // keyword.operator
        }
    }
}
