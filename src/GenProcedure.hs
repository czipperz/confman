module GenProcedure (genProcedure,performProcedure) where

import System.Directory
import System.Process
import SystemParse

import Flag

genProcedure :: String -> [FilePath] -> IO [(Bool,String,String)]
genProcedure _ [] = return []
genProcedure pre (src:out:xs) = do
  fileNameUn <- systemParse out
  parseSrc   <- systemParse src
  exists     <- doesFileExist fileNameUn
  pro        <- genProcedure pre xs
  return $ (exists,pre ++ "/" ++ parseSrc,fileNameUn) : pro

performProcedure :: Maybe Flag -> [(Bool,String,String)] -> IO ()
performProcedure _ [] = return ()
performProcedure Nothing     ((exists,linkbase,fileNameUn):xs) = do
  moveIt exists fileNameUn
  callCommand $ "ln -s \"" ++ linkbase ++ "\" \"" ++ fileNameUn ++ "\""
  performProcedure  Nothing     xs
performProcedure (Just Nono) ((exists,linkbase,fileNameUn):xs) = do
  moveIt exists fileNameUn
  putStrLn    $ "ln -s \"" ++ linkbase ++ "\" \"" ++ fileNameUn ++ "\""
  performProcedure (Just Nono)  xs
performProcedure (Just Hard) ((exists,linkbase,fileNameUn):xs) = do
  moveIt exists fileNameUn
  callCommand $ "ln \""    ++ linkbase ++ "\" \"" ++ fileNameUn ++ "\""
  performProcedure (Just Hard)  xs
performProcedure (Just Clean) ((exists,_      ,fileNameUn):xs) = do
  if exists then callCommand $ "rm \"" ++ fileNameUn ++ ".backup\"" else return ()
  performProcedure (Just Clean) xs

moveIt :: Bool -> String -> IO ()
moveIt ex fn = if ex then callCommand $ "mv \"" ++ fn ++ "\" \"" ++ fn ++ ".backup\""
               else return ()
