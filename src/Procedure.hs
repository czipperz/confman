module Procedure (procedureFlag,procedure) where

import System.Directory
import Control.Exception
import System.IO.Error
import System.Process
import System.Environment
{- Methods to use
    * callCommand
    * removeFile
    * doesFileExists
    * copyfile
-}
import Flag

procedureFlag :: String -> Flag -> [String] -> IO ()
procedureFlag _ _ []  = return ()
procedureFlag _ _ [x] = error "Need more than just prefix declaration"
procedureFlag pre Nono (src:out:xs) = do
  let fileNameUn = out ++ ".backup"
  exists <- doesFileExist fileNameUn
  if exists
    then putStr $ "rm " ++ fileNameUn
    else return ()
  putStrLn $ "ln -s \"" ++ pre ++ "/" ++ src ++ "\" \"" ++ fileNameUn ++ "\""
  procedureFlag pre Nono xs
procedureFlag pre Clean (_:out:xs) = do
  exists <- doesFileExist $ out ++ ".backup"
  if exists
    then callCommand $ "rm " ++ out
    else return ()
  procedureFlag pre Clean xs
procedureFlag pre Hard (src:out:xs) = do
  exists <- doesFileExist out
  if exists
    then callCommand $ "mv \"" ++ out ++ "\" \"" ++ out ++ ".backup\""
    else return ()
  callCommand $ "ln \"" ++ pre ++ "/" ++ src ++ "\" \"" ++ out ++ ".backup" ++ "\""
  procedureFlag pre Hard xs


procedure pre (src:out:xs) = do
  exists <- doesFileExist out
  if exists
    then callCommand $ "mv \"" ++ out ++ "\" \"" ++ out ++ ".backup\""
    else return ()
  callCommand $ "ln -s \"" ++ pre ++ "/" ++ src ++ "\" \"" ++ out ++ ".backup" ++ "\""
  procedure pre xs


removeIfExists :: FilePath -> IO ()
removeIfExists name = removeFile name `catch` handler
  where handler e | isDoesNotExistError e = return ()
                  | otherwise = throwIO e
