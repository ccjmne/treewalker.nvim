-- Import the necessary modules
import Data.List (sort)
import Control.Monad (replicateM)

-- Define a function to print out all even numbers in a list
printEvens :: [Int] -> IO ()
printEvens [] = return ()
printEvens (x : xs)
  | x `mod` 2 == 0 = putStrLn (show x) >> printEvens xs
  | otherwise     = printEvens xs

-- Define a function to calculate the sum of all numbers in a list
sumNumbers :: [Int] -> Int
sumNumbers [] = 0
sumNumbers (x : xs) = x + sumNumbers xs

-- Define a function to generate a random list of numbers
randomList :: IO [Int]
randomList = do
  n <- getLine
  let n' = read n :: Int
  replicateM n (getRandomR (-100, 100)) >>= return . sort

-- Define a function to calculate the median of a list of numbers
median :: [Double] -> Double
median xs = median' (sort xs)
    where
        median' []     = error "Empty list"
        median' [_]    = error "List contains single element"
        median' xs
            | odd  len  = fromIntegral $ xs !! (len `div` 2)
            | otherwise = mean
                where
                    len = length xs
                    mean = (sum xs) / fromIntegral len

-- Main function to run the program
main :: IO ()
main = do
    printEvens [1, 3, 5, 7, 9]
    print $ sumNumbers [-2, -4, 0, 10]
    randomList >>= mapM_ putStrLn . map show
    let xs = [-3.0, -1.0, 0.0, 1.0, 3.0]
        ys = [5.5, 6.6]
    print $ median xs
    print $ sumNumbers ys
