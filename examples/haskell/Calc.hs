{-# OPTIONS_GHC -Wunused-imports #-}
-- 四則演算の最小の再帰下降パーサ。文法(BNF):
--   expr   ::= term   (("+" | "-") term)*
--   term   ::= factor (("*" | "/") factor)*
--   factor ::= 数 | "(" expr ")"
module Main (main) where

import Data.Char (isDigit, isSpace)

data Token = TNum Int | TOp Char | TLParen | TRParen
  deriving (Show)

data Expr = Num Int | Bin Char Expr Expr

-- 字句解析: 文字列 -> トークン列
tokenize :: String -> [Token]
tokenize [] = []
tokenize (c : cs)
  | isSpace c = tokenize cs
  | isDigit c = let (ds, rest) = span isDigit (c : cs) in TNum (read ds) : tokenize rest
  | c == '(' = TLParen : tokenize cs
  | c == ')' = TRParen : tokenize cs
  | otherwise = TOp c : tokenize cs

-- 構文解析: 規則1つ = 関数1つ。読めたら(木, 残りのトークン列)を返す
type Parser a = [Token] -> Maybe (a, [Token])

-- x (op x)* : 次のトークンを1つ見て、opなら続けて読み、木を左に積む
chainl :: [Char] -> Parser Expr -> Parser Expr
chainl ops sub ts = case sub ts of
  Nothing -> Nothing
  Just (lhs, rest) -> go lhs rest
  where
    go :: Expr -> [Token] -> Maybe (Expr, [Token])
    go acc (TOp o : rest)
      | o `elem` ops = case sub rest of
          Nothing -> Nothing
          Just (rhs, rest') -> go (Bin o acc rhs) rest'
    go acc rest = Just (acc, rest)

expr :: Parser Expr
expr ts = chainl "+-" term ts

term :: Parser Expr
term ts = chainl "*/" factor ts

factor :: Parser Expr
factor (TNum n : rest) = Just (Num n, rest)
factor (TLParen : rest) = case expr rest of
  Just (e, TRParen : rest') -> Just (e, rest')
  _ -> Nothing
factor _ = Nothing

-- 木をS式で表示する
sexp :: Expr -> String
sexp (Num n) = show n
sexp (Bin o l r) = "(" ++ [o] ++ " " ++ sexp l ++ " " ++ sexp r ++ ")"

parseAll :: String -> String
parseAll src = case expr $ tokenize src of
  Just (e, []) -> sexp e
  Just (_, rest) -> "parse error: 残り " ++ show rest
  Nothing -> "parse error"

main :: IO ()
main = do
  print $ tokenize "1 + 2 * 3 - 4"
  mapM_ (\src -> putStrLn $ src ++ "  =>  " ++ parseAll src) ["1 + 2 * 3 - 4", "1 - 2 - 3", "(1 + 2) * 3", "1 + * 2"]
