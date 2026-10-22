import com.github.javaparser.StaticJavaParser;
import com.github.javaparser.ast.stmt.ExpressionStmt;

// 先頭5トークン(foo . bar . X)が同じ2つの文を、どちらの文として読んだかを出す
public class Lookahead {
    public static void main(String[] args) {
        String[] inputs = { "foo.bar.Baz x = y;", "foo.bar.baz = y;", "a.b.c.d.e.f.g.h.I x = y;" };
        for (String src : inputs) {
            ExpressionStmt s = StaticJavaParser.parseStatement(src).asExpressionStmt();
            System.out.printf("%-24s -> %s%n", src, s.getExpression().getClass().getSimpleName());
        }
    }
}
