import com.github.javaparser.JavaParser;
import com.github.javaparser.ParseResult;
import com.github.javaparser.ast.CompilationUnit;
import com.github.javaparser.ast.expr.VariableDeclarationExpr;

// 構文の誤りと型の誤りを、JavaParserがそれぞれどう扱うかを出す
public class NoTypes {
    public static void main(String[] args) {
        String[] inputs = {
            "class A { void f() { String s = 1; undefinedVar.foo(); } }", // 型の誤り
            "class A { void f() { String s = ; } }",                     // 構文の誤り
        };
        for (String src : inputs) {
            ParseResult<CompilationUnit> r = new JavaParser().parse(src);
            System.out.println("successful: " + r.isSuccessful());
            r.getProblems().forEach(p -> System.out.println("  problem: " + p.getVerboseMessage().lines().findFirst().get()));
        }

        CompilationUnit cu = new JavaParser().parse(inputs[0]).getResult().get();
        VariableDeclarationExpr decl = cu.findFirst(VariableDeclarationExpr.class).get();
        try {
            decl.getVariable(0).getInitializer().get().calculateResolvedType();
        } catch (IllegalStateException e) {
            System.out.println("calculateResolvedType: " + e.getMessage());
        }
    }
}
