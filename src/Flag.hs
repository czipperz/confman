module Flag where

data Flag = Nono | Clean | Hard | Help deriving (Eq,Ord,Enum,Show,Bounded)
