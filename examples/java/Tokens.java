import com.github.javaparser.JavaToken;
import com.github.javaparser.StaticJavaParser;
import com.github.javaparser.ast.stmt.Statement;

// 字句解析の結果(トークン列)を、空白とコメントを除いて1行ずつ出す
public class Tokens {
    public static void main(String[] args) {
        Statement stmt = StaticJavaParser.parseStatement("List<List<String>> a = b >> 1;");
        for (JavaToken t : stmt.getTokenRange().get()) {
            if (t.getCategory().isWhitespaceOrComment()) continue;
            System.out.printf("%-6s %s%n", t.getText(), JavaToken.Kind.valueOf(t.getKind()));
        }
    }
}
