import System.Environment
import System.Exit
import Control.Monad

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

help = do
  putStrLn "          confman"
  putStrLn "          /// \\\\\\"
  putStrLn "configuration manager"
  putStrLn ""
  putStrLn "Usage:"
  putStrLn "    --help | no arguments = show this message"
  putStrLn "Three options are allowed:"
  putStrLn "    -n | --nono  = list what it processes it would execute."
  putStr   "    -c | --clean = cleanup (delete) the backup files it"
  putStrLn "would normally generate. DOES NOT do anything else."
  putStrLn "    -h | --hard  = `ln' the files instead of `ln -s'"
  putStrLn "  They are mutually exclusive!"
  putStrLn "Then you must specify the configuration file to read."
  putStrLn ""
  putStrLn "Example: `confman -c configuration')"
