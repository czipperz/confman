module Main where

import System.Environment

import ParseWord
import Help

data Flag = Nono | Clean | Hard | Help deriving (Eq,Ord,Enum,Show,Bounded)

main :: IO ()
main = do
  arg <- getArgs
  let first  = parseS (arg !! 0)
      second = parseS (arg !! 1)
  case length arg of
    2 -> isValidTwo first second
    1 -> isValidOne first
    0 -> help
  contents <- readFile (first <-> second)
  let filtered = removeEmptyLists (lines contents)
  sayWords filtered False

  where sayWords [] _         = return ()
        sayWords (x :xs) True =
          let (word1,start) = parseWord 0 x
              (word2,_)     = parseWord start x in
          do putStrLn word1
             putStrLn $ "  " ++ word2
             sayWords xs True
        sayWords (x:xs) False =
          let (word1,_) = parseWord 0 x in
          do putStrLn word1
             sayWords xs True

(<->) :: Either t a -> Either t b -> t
(Left x) <-> _ = x
_ <-> (Left x) = x

removeEmptyLists :: [[x]] -> [[x]]
removeEmptyLists []      = []
removeEmptyLists ([]:xs) =   removeEmptyLists xs
removeEmptyLists (x :xs) = x:removeEmptyLists xs

parseS :: String -> Either String Flag
parseS s
  | s == "-n" || s == "--nono"  = Right Nono
  | s == "-c" || s == "--clean" = Right Clean
  | s == "-h" || s == "--hard"  = Right Hard
  | s == "--help"               = Right Help
  | otherwise                   = Left s

isValidTwo :: Monad m => Either a b -> Either c d -> m ()
isValidTwo (Right _) (Left _)  = return ()
isValidTwo (Right _) (Right _) = error "Takes one file and possibly one option, not two options"
isValidTwo (Left _)  (Right _) = error "Takes one file and possibly one option, in that order"
isValidTwo (Left _)  (Left _)  = error "Takes one file and possibly one option, not two files"

isValidOne :: Either t Flag -> IO ()
isValidOne (Left _)     = return ()
isValidOne (Right Help) = help
isValidOne _            = error "Use `--help' to get help"
