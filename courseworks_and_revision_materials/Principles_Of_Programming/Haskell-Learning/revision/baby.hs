import Text.Read (readMaybe)
import Text.ParserCombinators.ReadP (gather)

doubleUs :: Num a => a -> a -> a
doubleUs x y = doubleMe x + doubleMe y

doubleMe :: Num a => a -> a
doubleMe x = x + x

doubleSmallNumber :: (Ord a, Num a) => a -> a
doubleSmallNumber x = if x <= 100
                        then x*2
                        else x

doubleLargeNumber :: (Ord a, Num a) => a -> a
doubleLargeNumber x = if x >= 100
                        then x*2
                        else x

doubleLargeNumber' :: (Ord a, Num a) => a -> a
doubleLargeNumber' x = (if x >= 100 then x else 0) + x

listA :: [Integer]
listA = [1,2,3]

listB :: [[Integer]]
listB = [[1..5],[1,2],[2..10]]

reverse' :: [a] -> [a]
reverse' (x:xs) = reverse' xs ++ [x]
reverse' [] = []

reverse'' :: [a] -> [a] -> [a]
reverse'' (x:xs) acc = reverse'' xs (x : acc)
reverse'' [] acc = acc

tail' :: [a] -> [a]
tail' (x:xs) = xs
tail' [] = []

elem' :: Eq a => a -> [a] -> Bool
elem' x (y:ys) = (x == y) || elem' x ys
elem' _ [] = False

cross :: [a] -> [b] -> [(a,b)]
cross as bs = [(a,b) | a <- as, b <- bs]

length' :: [a] -> Int
length' xs = length'' xs 0

length'' :: [a] -> Int -> Int
length'' [] count = count
length'' (x:xs) count = length'' xs (succ count)

length''' :: [a] -> Int
length''' xs = sum [1 | _ <- xs]

removeNonUpperCase :: String -> String
removeNonUpperCase str = [c | c <- str, c `elem` ['A'..'Z']]

factorial :: Integer -> Integer
factorial x = product [1..x]

circumFloat :: Float -> Float
circumFloat r = 2 * pi * r

circumDouble :: Double -> Double
circumDouble r = 2 * pi * r

frst :: (a,b,c) -> a
frst (a,b,c) = a

scnd :: (a,b,c) -> b
scnd (a,b,c) = b

thrd :: (a,b,c) -> c
thrd (a,b,c) = c

linSearch :: (Eq a) => a -> [a] -> Bool
linSearch _ [] = False
linSearch x (y:ys) = x == y || linSearch x ys

quickSort :: (Ord a) => [a] -> [a]
quickSort [] = []
quickSort (x:xs) = quickSort greater ++ x:equal ++ quickSort lower
                        where greater = [y | y <- xs, y > x]
                              equal = [y | y <- xs, y == x]
                              lower = [y | y <- xs, y < x]

array2strarr :: (Show a) => [a] -> [String]
array2strarr = map show

productOfStrArr :: (Read a, Num a) => [String] -> a
productOfStrArr xs = product $ map read xs

lucky :: Integral a => a -> String
lucky 7 = "Lucky number seven!!"
lucky _ = "naw unlucky try again next time"

factorial' :: (Integral a) => a -> a
factorial' 0 = 1
factorial' n = n * factorial' (n - 1)

charName :: Char -> String
charName 'c' = "Charlie"
charName 'k' = "Kirk"

addVectors :: (Num a) => (a, a) -> (a, a) -> (a, a)
addVectors (a,b) (c,d) = (a+c, b+d)

addVectors' :: (Num a) => (a, a) -> (a, a) -> (a, a)
addVectors' a b = (fst a + fst b, snd a + snd b)

sumTriples :: (Num a) => [a] -> [a]
sumTriples (x:y:z:zs) = x+y+z : sumTriples zs 
sumTriples (x:y:zs) = []

head' :: [a] -> a 
head' [] = error "cannot call head to an empty list"
head' (x:_) = x

tell :: (Show a) => [a] -> String
tell [] = "this list is empty"
tell [x] = "theres only one element in this array: " ++ show x
tell [x,y] = "there are two elements in this array: " ++ show x ++ " " ++ show y
tell [x,y,z] = "there are three elements in this array: " ++ show x ++ " " ++ show y ++ " " ++ show z
tell (_:_) = "there are more than three elements in this array"

length'''' :: [a] -> Int
length'''' [] = 0
length'''' (_:xs) = 1 + length'''' xs

firstLetter :: String -> String
firstLetter st@(x:_) = "The first letter of " ++ st ++ ", is " ++ [x]

densityTell :: (Fractional a, Ord a, Show a) => a -> String
densityTell density
      | density < 1.2 = "oh wow, you're lighter than air!"
      | density <= 1000.0 = "The water is really nice this time of year"
      | otherwise = "good luck surviving this world of just air and water when you're "++show density++"g/L dense"

calcDensity :: (Fractional a) => a -> a -> a
calcDensity mass volume = mass / volume

max' :: (Ord a) => a -> a -> a
max' a b
      | a >= b = a
      | otherwise = b

compare' :: (Ord a) => a -> a -> Ordering
a `compare'` b
      | a > b = GT
      | a == b = EQ
      | otherwise = LT

densityTell' :: String -> String
densityTell' input
      | Just density <- readMaybe input, density < 1.2 = "whut the"
      | Just density <- readMaybe input, density <= 1000.0 = "swim forrest swim!"
      | Nothing :: (Fractional a => Maybe a) <- readMaybe input = "come onnnn"
      | otherwise = "u gonna die holmes"


densityTell'' :: (Fractional a, Ord a) => a -> a -> String
densityTell'' mass volume
      | density < air = "yippeee"
      | density <= water = "hallo i am unda da wata"
      | otherwise = "booring"
      where density = mass / volume
            (air, water) = (1.2, 1000.0)

initials :: String -> String -> String
initials firstname lastname = f:'.':[l]
      where (f:_, l:_) = (firstname, lastname)

calcDensities :: (Fractional a) => [(a, a)] -> [a]
calcDensities xs = [mass / volume | (mass, volume) <- xs]

cylinder :: (Floating a) => a -> a -> a
cylinder r h =
      let sideArea = 2 * pi * r * h
          topArea = pi * r^2
      in  sideArea + 2 * topArea

calcDensities' :: (Fractional a) => [(a,a)] -> [a]
calcDensities' xs = [density | (m, v) <- xs, let density = m / v]

head'' :: [a] -> a
head'' xs = case xs of [] -> error "Nope nope nope"
                       (x:_) -> x

fibonacci :: Integral a => a -> a
fibonacci 0 = 0
fibonacci 1 = 1
fibonacci n = fibonacci (n - 1) + fibonacci (n - 2)

tribonacci :: Integral a => a -> a
tribonacci 0 = 0
tribonacci 1 = 0
tribonacci 2 = 1
tribonacci n = tribonacci (n-1) + tribonacci (n-2) + tribonacci (n-3)

elem'' :: (Eq a) => a -> [a] -> Bool
elem'' _ [] = False
elem'' x (y:ys)
      | x == y = True
      | otherwise = x `elem''` ys

max'' :: (Ord a) => a -> a -> a
max'' a = \b -> if a <= b then b else a

compareWithHundred :: (Ord a, Num a) => a -> Ordering
compareWithHundred = compare 100

isUpperAlphanum :: Char -> Bool
isUpperAlphanum = (`elem` ['A'..'Z'])

applyTwice :: (a -> a) -> a -> a
applyTwice f x = f (f x)

zipWith' :: (a -> a -> a) -> [a] -> [a] -> [a]
zipWith' _ _ [] = []
zipWith' _ [] _ = []
zipWith' f (x:xs) (y:ys) = f x y : zipWith' f xs ys

flip' :: (a -> b -> c) -> (b -> a -> c)
flip' f = g
      where g x y = f y x

