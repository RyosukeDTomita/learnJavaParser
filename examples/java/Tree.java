import com.github.javaparser.StaticJavaParser;
import com.github.javaparser.ast.body.VariableDeclarator;
import com.github.javaparser.ast.expr.BinaryExpr;
import com.github.javaparser.ast.expr.Expression;
import com.github.javaparser.ast.expr.VariableDeclarationExpr;
import com.github.javaparser.ast.stmt.ExpressionStmt;

// パース結果の木を、S式(演算子 左 右)の形で出す
public class Tree {
    static String sexp(Expression e) {
        if (e instanceof BinaryExpr b) {
            return "(" + b.getOperator().asString() + " " + sexp(b.getLeft()) + " " + sexp(b.getRight()) + ")";
        }
        return e.toString();
    }

    public static void main(String[] args) {
        Expression e = StaticJavaParser.parseExpression("1 + 2 * 3 - 4");
        System.out.println(sexp(e));

        ExpressionStmt s = StaticJavaParser.parseStatement("List<List<String>> a = b >> 1;").asExpressionStmt();
        VariableDeclarator v = ((VariableDeclarationExpr) s.getExpression()).getVariable(0);
        System.out.println("type: " + v.getType() + " (" + v.getType().getClass().getSimpleName() + ")");
        System.out.println("init: " + sexp(v.getInitializer().get()));
    }
}
