module SystemParse where

import System.Environment

systemParse :: String -> IO String
systemParse [] = return []
systemParse ('$':exs) = do
  let (ret,var) = parseVar exs
  car <- getEnv var
  cdr <- systemParse ret
  return $ car++cdr
  where parseVar ('{':xs) = parseInCurly xs
        parseVar x        = parseNormal x
        parseInCurly []        = ([],[])
        parseInCurly ('}':xs)  = (xs,[])
        parseInCurly (x  :xs)  = let (ret,cdr) = parseInCurly xs
                                 in (ret,x:cdr)
        parseNormal []         = ([],[])
        parseNormal xs@(' ':_) = (xs,[])
        parseNormal xs@('-':_) = (xs,[])
        parseNormal xs@('/':_) = (xs,[])
        parseNormal (x  :xs)   = let (ret,cdr) = parseNormal xs
                                 in (ret,x:cdr)
systemParse (x:xs) = do
  parsed <- systemParse xs
  return $ x:parsed
