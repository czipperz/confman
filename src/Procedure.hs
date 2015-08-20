module Procedure (procedureFlag,procedure) where

import System.Directory
import System.Process
-- Methods to use
--  * callCommand
--  * removeFile
--  * doesFileExists
--  * copyfile
import Flag
import SystemParse

procedureFlag :: String -> Flag -> [FilePath] -> IO ()
procedureFlag _ _ []  = return ()
procedureFlag _ _ [_] = error "Need more than just prefix declaration"
procedureFlag pre Nono (src:out:xs) = do
  fileNameUn <- systemParse out
  exists <- doesFileExist fileNameUn
  if exists
    then putStrLn $ "mv \"" ++ fileNameUn ++ "\" \"" ++ fileNameUn ++ ".backup\""
    else return ()
  putStrLn $ "ln -s \"" ++ pre ++ "/" ++ src ++ "\" \"" ++ fileNameUn ++ "\""
  procedureFlag pre Nono xs
procedureFlag pre Clean (_:out:xs) = do
  fileNameUn <- systemParse $ out ++ ".backup"
  exists <- doesFileExist fileNameUn
  if exists
    then callCommand $ "rm \"" ++ fileNameUn ++ "\""
    else return ()
  procedureFlag pre Clean xs
procedureFlag pre Hard (src:out:xs) = do
  fileNameUn <- systemParse out
  exists <- doesFileExist fileNameUn
  if exists
    then callCommand $ "mv \"" ++ fileNameUn ++ "\" \"" ++ fileNameUn ++ ".backup\""
    else return ()
  callCommand $ "ln \"" ++ pre ++ "/" ++ src ++ "\" \"" ++ fileNameUn ++ "\""
  procedureFlag pre Hard xs


procedure :: String -> [FilePath] -> IO ()
procedure _ []  = return ()
procedure _ [_] = error "Need more than just prefix declaration"
procedure pre (src:out:xs) = do
  fileNameUn <- systemParse out
  exists <- doesFileExist $ fileNameUn
  if exists
    then callCommand $ "mv \"" ++ fileNameUn ++ "\" \"" ++ fileNameUn ++ ".backup\""
    else return ()
  callCommand $ "ln -s \"" ++ pre ++ "/" ++ src ++ "\" \"" ++ fileNameUn ++ "\""
  procedure pre xs
