{-# OPTIONS_GHC -Wunused-imports #-}
-- JLSの書き方そのまま(左再帰)の規則を、再帰下降で書くとどうなるか
--   expr ::= expr "+" num | num
module Main (main) where

data Token = TNum Int | TPlus

data Expr = Num Int | Add Expr Expr

type Parser a = [Token] -> Maybe (a, [Token])

-- 最初の選択肢 expr "+" num を試す: トークンを1つも読まずに、同じ入力で自分を呼ぶ
expr :: Parser Expr
expr ts = case expr ts of
  Just (lhs, TPlus : TNum n : rest) -> Just (Add lhs (Num n), rest)
  _ -> num ts

num :: Parser Expr
num (TNum n : rest) = Just (Num n, rest)
num _ = Nothing

main :: IO ()
main = case expr [TNum 1, TPlus, TNum 2] of
  Just _ -> putStrLn "parsed"
  Nothing -> putStrLn "parse error"
