module ParseWord where

parseWord :: (Eq n, Num n, Num a) => n -> String -> (String,a)
parseWord start = goForward . byepassWhitespace . cropTo start
  where cropTo 0 li     = li
        cropTo _ []     = error "Can't parse word"
        cropTo n (_:xs) = cropTo (n-1) xs

        byepassWhitespace []        = error "Can't remove whitespace between words"
        byepassWhitespace (' ' :xs) = byepassWhitespace xs
        byepassWhitespace ('\t':xs) = byepassWhitespace xs
        byepassWhitespace (x   :xs) = x:xs

        goForward (x:xs) | x == '\'' || x == '"'
                             = walkTo x   (xs,2)
        goForward xs         = walkTo ' ' (xs,0)

        walkTo :: Num n => Char -> (String,n) -> (String,n)
        walkTo _      ([]       ,n)          = ([],n)
        walkTo c      (x:_      ,n) | c == x = ([],n)
        walkTo c@'"'  ('\\':x:xs,n) | x == '"' || x == '\\'
                                     = commonWalk c x xs n
        walkTo c      (x:xs     ,n)  = commonWalk c x xs n
        commonWalk c x xs n          = let (y,z) = walkTo c (xs,n) in
                                         (x:y, 1+z)
