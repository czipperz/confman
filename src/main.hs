module Main where

import System.Environment
import System.Exit

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
  contents <- readFile (first <-> second)
  putStrLn contents
  putStrLn ""
  sayFirstWordsLines (lines contents) False
  return ()
  where sayFirstWordsLines [] _ = return ()
        sayFirstWordsLines (x:xs) True =
          let (word1,start) = parseWord 0 x
              (word2,_) = parseWord start x in
          do putStrLn word1
             putStrLn $ "  " ++ word2
             sayFirstWordsLines xs True
        sayFirstWordsLines (x:xs) False =
          let (word1,start) = parseWord 0 x in
          do putStrLn word1
             sayFirstWordsLines xs True

(Left x) <-> _ = x
_ <-> (Left x) = x

parseS s
  | s == "-n" || s == "--nono"  = Right Nono
  | s == "-c" || s == "--clean" = Right Clean
  | s == "-h" || s == "--hard"  = Right Hard
  | s == "--help"               = Right Help
  | otherwise                   = Left s

isValidTwo (Right _) (Left _)  = return ()
isValidTwo (Right _) (Right _) = error "Takes one file and possibly one option, not two options"
isValidTwo (Left _) (Right _)  = error "Takes one file and possibly one option, in that order"
isValidTwo (Left _) (Left _)   = error "Takes one file and possibly one option, not two files"

isValidOne (Left _)     = return ()
isValidOne (Right Help) = help >> exitWith (ExitFailure 1)
isValidOne _            = error "Use `--help' to get help"
