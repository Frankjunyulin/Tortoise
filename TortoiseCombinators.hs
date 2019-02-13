module TortoiseCombinators
       ( andThen 
       , loop 
       , invisibly 
       , retrace 
       , overlay 
       ) where

import Tortoise

-- See Tests.hs or the assignment spec for specifications for each
-- of these combinators.

andThen :: Instructions -> Instructions -> Instructions
andThen i1 Stop = i1
andThen Stop i2 = i2
andThen (Move dist i1) i2 = Move dist $ andThen i1 i2
andThen (Turn ang i1) i2 = Turn ang $ andThen i1 i2
andThen (SetStyle lineSty i1) i2 = SetStyle lineSty $ andThen i1 i2
andThen (SetColour col i1) i2 = SetColour col $ andThen i1 i2
andThen (PenUp i1) i2 = PenUp $ andThen i1 i2
andThen (PenDown i1) i2 = PenDown $ andThen i1 i2


--double Stop = Stop
--double (Move dst i) = Move dst $ Move dst $ double i
--double (Turn deg i) = Turn deg $ Turn deg $ double i

--andThen (i1 Stop) (i2 Stop) = (i1) $ (i2) Stop
--andThen (i1) (i2) = (w1) $ (w2) Stop
--  where 
--    w1 Stop = i1
--    w2 Stop = i2

--andThen i1 i2 = error "'andThen' unimplemented"

loop :: Int -> Instructions -> Instructions
loop n i | n <= 0 =  Stop
         | n == 1 = i
         | otherwise =  i `andThen` loop (n-1) i

{-
loop _ Stop = Stop
loop n (Move dst i) = Move dst $ loop (n-1) (Move dst i)
loop n (Turn ang i) = Turn ang $ loop (n-1) (Turn ang i)
loop n (SetStyle lineSty i) = SetStyle lineSty $ loop (n-1) (SetStyle lineSty i)
loop n (SetColour col i) = SetColour col $ loop (n-1) (SetColour col i)
loop n (PenUp i) = PenUp$ loop (n-1) (PenUp i)
loop n (PenDown i) = PenDown$ loop (n-1) (PenDown i)
-}
--loop n i = error "'loop' unimplemented"



invisibly :: Instructions -> Instructions
invisibly Stop = Stop 
invisibly i = invisiblyHelper i "down"

{-
invisibly Stop = PenDown Stop 
invisibly (Move dist i1) = PenUp $ Move dist $ invisibly i1
invisibly (Turn ang i1) = PenUp $ Turn ang  $ invisibly i1
invisibly (SetStyle lineSty i1) = PenUp $ SetStyle lineSty $ invisibly i1
invisibly (SetColour col i1) = PenUp $ SetColour col $ invisibly i1
invisibly (PenUp i1) = PenUp $ invisibly i1
invisibly (PenDown i1) = PenDown $ invisibly i1
-}

invisiblyHelper :: Instructions -> String -> Instructions
invisiblyHelper Stop "up" = PenUp $ Stop
invisiblyHelper Stop "down" = PenDown $ Stop 
invisiblyHelper (Move dist i1) s = PenUp $ Move dist $ invisiblyHelper i1 s
invisiblyHelper (Turn ang i1) s = PenUp $ Turn ang  $ invisiblyHelper i1 s
invisiblyHelper (SetStyle lineSty i1) s = PenUp $ SetStyle lineSty $ invisiblyHelper i1 s
invisiblyHelper (SetColour col i1) s = PenUp $ SetColour col $ invisiblyHelper i1 s
invisiblyHelper (PenUp i1) s = PenUp $ invisiblyHelper i1 "up"
invisiblyHelper (PenDown i1) s = PenDown $ invisiblyHelper i1 "down"



--invisibly i = PenUp i

--invisibly i = error "'invisibly' unimplemented"

retrace :: Instructions -> Instructions
retrace Stop = Stop
--retrace (i1 `andThen` i2) = i2 
--reverseList (x:xs) = reverseList xs ++ [x]

--retrace (Move dist i1) = Move (-dist) $ retrace i1
--retrace (Move dist i1) = retrace i1 $ Move (-dist)
retrace i1 = go i1 Stop (Solid 1) white True
  where 
    go Stop acc preSty preCol down= acc
    go (Move dist i) acc preSty preCol down= go i (Move (-dist) acc) preSty preCol down
    go (Turn ang i) acc preSty preCol down = go i (Turn (-ang) acc) preSty preCol down
    go (SetStyle lineSty i) acc preSty preCol down = go i (SetStyle preSty acc) lineSty preCol down
    go (SetColour col i) acc preSty preCol down = go i (SetColour preCol acc) preSty col down
    
    go (PenUp i) acc preSty preCol True = go i (PenDown acc) preSty preCol False
    go (PenUp i) acc preSty preCol False = go i acc preSty preCol False
    
    go (PenDown i) acc preSty preCol False = go i (PenUp acc) preSty preCol True
    go (PenDown i) acc preSty preCol True = go i acc preSty preCol True

    


       

--retrace (Turn ang i1) = Turn (-ang) $ retrace i1
--retrace (SetStyle lineSty i1) = SetStyle lineSty $ retrace i1
--retrace (SetColour col i1) = SetColour col $ retrace i1
--retrace (PenUp i1) = PenDown $ retrace i1
--retrace (PenDown i1) = PenUp $ retrace i1

--retrace i = error "'retrace' unimplemented"

--reverse l = go l []
--  where go [] a = a
--        go (x:xs) a = go xs (x:a)




overlay :: [Instructions] -> Instructions
overlay [] = Stop
overlay [x] = x `andThen` invisibly(retrace x)
overlay (x:xs) = x `andThen` invisibly(retrace x) `andThen` overlay xs
--overlay (x:xs) = (x `andThen` invisibly(retrace x)) `andThen` overlay xs
--overlay is = error "'overlay' unimplemented"

