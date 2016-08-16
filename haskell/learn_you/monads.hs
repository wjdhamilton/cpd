import Control.Monad
import Data.List
import Debug.Trace

applyMaybe :: Maybe a -> (a -> Maybe b) -> Maybe b
applyMaybe Nothing f = Nothing
applyMaybe (Just x) f = f x


type Birds = Int
type Pole = (Birds, Birds)


landLeft :: Birds -> Pole -> Maybe Pole
landLeft n (left, right)
  | abs ((left + n) - right) < 4 = Just (left + n, right)
  | otherwise = Nothing


landRight :: Birds -> Pole -> Maybe Pole
landRight n (left, right) 
  | abs (left - (right + n)) < 4 = Just (left, right + n)
  | otherwise = Nothing


banana :: Pole -> Maybe Pole
banana _ = Nothing


foo :: Maybe String
foo = do
  x <- Just 3
  y <- Just "!"
  Just (show x ++ y)


routine :: Maybe Pole
routine = do
  start <- return (0,0)
  first <- landLeft 2 start
  Nothing
  second <- landRight 2 first
  landLeft 1 second


type KnightPos = (Int, Int)

moveKnight :: KnightPos -> [KnightPos]
moveKnight (c,r) = do
  (c',r') <- [(c+2,r-1),(c+2,r+1),(c-2,r-1),(c-2,r+1),(c+1,r-2),(c+1,r+2),(c-1,r-2),(c-1,r+2)]
  guard (c' `elem` [1..8] && r' `elem` [1..8])
  return (c', r')


in3 :: KnightPos -> [KnightPos]
in3 start = do
  first <- moveKnight start
  second <- moveKnight first
  moveKnight second


-- Starting at start, advance a move (first), advance another move (second), advance final move (end)
-- The problem here is to go down each route individually until all have been exhausted or the target
-- found. 
canReachIn3 :: KnightPos -> [KnightPos]
canReachIn3 start = do
  first <- moveKnight start
  second <- moveKnight first
  moveKnight second


-- Do a Knight's tour. This is inspired by the above problems, and is an interesting 
-- problem since it involves recursive backtracking which I have not yet worked out
-- how to do in Haskell.
-- For this we want to keep a track of all the positions on the board that the knight
-- has visited, and once all positions have been filled then the tour is complete. 
-- If the knight cannot complete the tour then the function should indicate as such. 
-- If the knight has completed the tour, the function should return the list of moves.

data Tour = Failed | Complete [KnightPos] deriving (Show, Eq)

-- Base cases: Complete [moves] = There are no more available squares other than the current one 
--             Failed = There are no more moves, but there are still available squares on the board
-- We need a board function to create a board. Every time a move is made a square will be removed

findTour :: [KnightPos] -> [KnightPos] -> [KnightPos] -> Tour
findTour moves board history
  | length board == 0 = Complete history
  | length moves == 0 = Failed
findTour (s:squares) board history = case tour of
                                        Complete mvs -> tour
                                        Failed -> findTour squares board history
  where 
        nb = delete s board
        m = (moveKnight s) `intersect` nb
        tour = findTour m nb (concat [history,[s]])

board :: [KnightPos]
board = do
  cols <- [1..7]
  rows <- [1..7]
  return (cols,rows)

