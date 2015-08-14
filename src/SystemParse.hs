module SystemParse (systemParse) where

import System.Environment

systemParse :: String -> IO String
systemParse [] = return []
systemParse ('$':exs) = do
  let (ret,var) = parseVar exs
  car <- getEnv var
  cdr <- systemParse ret
  return $ car++cdr
systemParse (x:xs) = do
  parsed <- systemParse xs
  return $ x:parsed

parseVar :: String -> (String,String)
parseVar ('{':xs) = parseInCurly xs
parseVar x        = parseNormal False x

parseInCurly :: String -> (String,String)
parseInCurly []        = ([],[])
parseInCurly ('}':xs)  = (xs,[])
parseInCurly (x  :xs)  = let (ret,cdr) = parseInCurly xs in (ret,x:cdr)

parseNormal ::  Bool -> String -> (String,String)
parseNormal _ [] = ([],[])
parseNormal True (x:xs) | x >= '0' && x <= '9' =
  let (ret,cdr) = parseNormal True xs in
  (ret,x:cdr)
parseNormal _    (x:xs) | x >= 'a' && x <= 'z' ||
                          x >= 'A' && x <= 'Z' =
  let (ret,cdr) = parseNormal True xs in
  (ret,x:cdr)
parseNormal _ xs = (xs,[])
