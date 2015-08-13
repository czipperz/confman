module Main where

import System.Environment

import ParseWord
import Help
import Flag
import Procedure
import SystemParse

main :: IO ()
main = do
  arg <- getArgs
  let first  = parseS (arg !! 0) (length arg)
      second = parseS (arg !! 1) (length arg)
  case length arg of
    0 -> help
    1 -> isValidOne first
    2 -> isValidTwo first second
  contents <- readFile (first `getFile` second)
  let filtered = removeEmptyLists $ lines contents
      parsed   = parseW filtered
  prefix <- systemParse $ head parsed
  case length arg of
    1 -> procedure     prefix                        (tail parsed)
    2 -> procedureFlag prefix (first `getFlag` second) (tail parsed)

getFile :: Either t a -> Either t b -> t -- get file
(Left x) `getFile` _ = x
_ `getFile` (Left x) = x

getFlag :: Either a t -> Either b t -> t -- get flag
(Right x) `getFlag` _ = x
_ `getFlag` (Right x) = x

removeEmptyLists :: [[x]] -> [[x]]
removeEmptyLists []      = []
removeEmptyLists ([]:xs) =   removeEmptyLists xs
removeEmptyLists (x :xs) = x:removeEmptyLists xs

parseS :: String -> Int -> Either String Flag
parseS s 2
  | s == "-n" || s == "--nono"  = Right Nono
  | s == "-c" || s == "--clean" = Right Clean
  | s == "-h" || s == "--hard"  = Right Hard
  | otherwise                   = Left s
parseS s 1
  | s == "-h" || s == "--help"  = Right Help
  | otherwise                   = Left s

parseW :: [String] -> [String]
parseW str = parseW' False str
  where parseW' False ([]:_) = error $ "The first line needs to be nonempty: " ++
                               "it is the prefix. Use `.' to imply nothing"
        parseW' True [] = []
        parseW' False (x:xs) = x:parseW' True xs
        parseW' True  (x:xs) =
          let (a,pos) = parseWord 0 x
              (b,_)   = parseWord pos x in
          a:b:parseW' True xs

isValidTwo :: Monad m => Either a b -> Either c d -> m ()
isValidTwo (Right _) (Left  _) = return ()
isValidTwo (Right _) (Right _) = error "Takes one file and possibly one option, not two options"
isValidTwo (Left  _) (Right _) = error "Takes one file and possibly one option, in that order"
isValidTwo (Left  _) (Left  _) = error "Takes one file and possibly one option, not two files"

isValidOne :: Either t Flag -> IO ()
isValidOne (Left _)     = return ()
isValidOne (Right Help) = help
isValidOne _            = error "Use ``--help'' to get help"
