rev [] = []
rev (x:xs) = rev xs ++ [x]

quicksort [] = []
quicksort (x:xs) = (quicksort (lesser xs x)) ++ [x] ++ (quicksort (greater xs x))
  where
    lesser xs x = filter (<= x) xs
    greater xs x = filter (> x) xs