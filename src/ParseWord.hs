module ParseWord where

parseWord :: (Eq η,Num η,Num α) => η -> String -> (String,α)
parseWord start line = goForward $ byepassWhitespace $ cropTo start line
  where cropTo 0 li     = li
        cropTo _ []     = error "Can't parse word"
        cropTo n (_:xs) = cropTo (n-1) xs

        byepassWhitespace [] = error "Can't remove whitespace between words"
        byepassWhitespace (' ':xs) = byepassWhitespace xs
        byepassWhitespace ('\t':xs) = byepassWhitespace xs
        byepassWhitespace (x:xs) = x:xs

        goForward ('\'':xs) = walkTo '\'' (xs,2)
        goForward ('"' :xs) = walkTo '"'  (xs,2)
        goForward xs        = walkTo ' '  (xs,0)
        walkTo _ ([]    ,n)             = ([],n)
        walkTo c ((x:xs),n) | c == x    = ([],n)
                            | otherwise = let y = walkTo c (xs,n) in (x:fst y,1+snd y)
