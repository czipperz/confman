module ParseWord where

parseWord :: (Eq n, Num n, Num a) => n -> String -> (String,a)
parseWord start line = goForward . byepassWhitespace $ cropTo start line
  where cropTo 0 li     = li
        cropTo _ []     = error "Can't parse word"
        cropTo n (_:xs) = cropTo (n-1) xs

        byepassWhitespace []        = error "Can't remove whitespace between words"
        byepassWhitespace (' ' :xs) = byepassWhitespace xs
        byepassWhitespace ('\t':xs) = byepassWhitespace xs
        byepassWhitespace (x   :xs) = x:xs

        goForward ('\'':xs) = walkTo '\'' (xs,2)
        goForward ('"' :xs) = error "Use of double quotes as the start of a group of words is NOT allowed"
        goForward xs        = walkTo ' '  (xs,0)

        walkTo _ ([]    ,n)             = ([],n)
        walkTo _ (('"':xs),_)           = error "Use of doulbe quotes in the string body is NOT allowed"
        walkTo c ((x:xs),n) | c == x    = ([],n)
                            | otherwise = let y = walkTo c (xs,n) in
                                            (x:fst y, 1+snd y)
