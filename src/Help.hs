module Help where

import System.Exit

help :: IO ()
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
  exitWith (ExitFailure 1)
