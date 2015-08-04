import System.Environment

data Flag = Nono | Clean | Hard | Help deriving (Eq,Ord,Enum,Show,Bounded)

main :: IO ()
main = do
  arg <- getArgs
  case length arg of
    2 -> isValidTwo (parse 0 (arg !! 0)) (parse 1 (arg !! 1))
    1 -> isValidOne (parse 0 (arg !! 0))
  sayEverything 0 arg
  where sayEverything _ []         = return ()
        sayEverything n (arg:args) = putStrLn (show (parse n arg)) >> sayEverything (n+1) args

parse 0 s
  | s == "-n" || s == "--nono"  = Right Nono
  | s == "-c" || s == "--clean" = Right Clean
  | s == "-h" || s == "--hard"  = Right Hard
  | s == "--help"               = Right Help
parse _ s = Left s

isValidTwo (Right _) (Left _)  = return ()
isValidTwo (Right _) (Right _) = error "Takes one file and possibly one option, not two options"
isValidTwo (Left _) (Right _)  = error "Takes one file and possibly one option, in that order"
isValidTwo (Left _) (Left _)   = error "Takes one file and possibly one option, not two files"

isValidOne (Left _)     = return ()
isValidOne (Right Help) = help
isValidOne _            = error "Use `--help' to get help"

help = do
  putStrLn "          confman"
  putStrLn "          /// \\\\\\"
  putStrLn "configuration manager"
  putStrLn ""
  putStrLn "Usage:"
  putStrLn "    --help | no arguments = show this message"
  putStrLn "Three options are allowedn:"
  putStrLn "    -n | --nono  = list what it processes it would execute."
  putStrLn "    -c | --clean = cleanup (delete) the backup files it would normally generate. DOES NOT do anything else."
  putStrLn "    -h | --hard  = `ln' the files instead of `ln -s'"
  putStrLn "  They are mutually exclusive!"
  putStrLn "Then you must specify the configuration file to read."
  putStrLn ""
  putStrLn "Example: `confman -c configuration')"
