module Main where

import System.IO
import System.Console.ANSI
import qualified System.IO.Strict as S
import Control.Monad
import Data.List (inits)

type Entry = (Float, Float, Float, Char, String)

main = do
      --extract
    fit_sequence <- S.readFile "sequence.txt"
    string <- S.readFile "data.txt"
    let entries = (map (read :: String -> Entry) . lines) string
        grades = [ x | (_, _, _, x, _) <- entries ]
        diary = [ x | (_, _, _, _, x) <- entries ]
        prog_total = foldl ( \acc (n,_,_,_,_) -> acc+n ) 0 entries 

      --frame the day 
    clearScreen >> report fit_sequence entries

      --inspirational quote goes here
    putStrLn "\t\t\t\t\tIn the Void is Good but no Evil.\ 
              \\n\t\t\t\t\tWisdom is Existence.\
              \\n\t\t\t\t\tPrinciple is Existence.\
              \\n\t\t\t\t\tThe Way is Existence.\
              \\n\t\t\t\t\tMind is Emptiness.\n\n\n\n\n\n" 

      --wait for executive input
    cmd <- getLine
    case cmd of
      "g" -> do clearScreen
                putStrLn grades -- binary approval rating chain 
                pause
      "d" -> do clearScreen
                mapM_ putStrLn diary
                pause
      "t" -> do clearScreen
                print prog_total -- ~10000hrs to reach wizard
                pause
      "w" -> write_entry fit_sequence  --crystalize
      _ -> main

pause = putStrLn "press any key to return" >> getLine >> main --start anew after view

  --judges data and prints to screen accordingly
report :: String -> [Entry] -> IO ()
report fit entries = let activity = fitness $ head fit
                         fast = fasting $ length entries
                         (most, little, least) = judge entries
                     in mapM_ putStrLn
                        ["\t\t\t\t\t", 
                        fast, 
                        "\t\t\t\t\tMost: " ++ most, 
                        "\t\t\t\t\tLittle: " ++ little, 
                        "\t\t\t\t\tLeast: " ++ least, 
                        "\t\t\t\t\tMove: " ++ activity,
                        "\n\n\n\n\n\n"]

fitness :: Char -> String
fitness x
    | x == '0' = " - Yoga"
    | x == '1' = " - Run and Lift"
    | x == '2' = " - Run"
    | x == '3' = " - Climb"

fasting :: Int -> String
fasting x
    | x `mod` 76 == 0 = "Full Day Fast"
    | x `mod` 21 == 0 = "Partial Fast"
    | otherwise = ""

  --reads into the past 
judge :: [Entry] -> (String, String, String)
judge entries 
    | too_little_work = (work, learn, play)
    | too_much_play   = (learn, work, play)
    | too_much_study  = (play, work, learn)
    | otherwise     = (play, learn, work)
    where too_little_work = too_much_play && too_much_study
          too_much_play = play_hours / (learn_hours + work_hours) >= 0.25
          too_much_study = (learn_hours) / (work_hours) >= 0.66

          (work, learn, play) = (" - renshuu", " - SICP / Norvig", " - Play")
          (learn_hours, work_hours, play_hours) = tri_sum entries

tri_sum :: [Entry] -> (Float, Float, Float)
tri_sum = let tri_add (a,b,c) (x,y,z) = (a+x, b+y, c+z)
          in foldl ( \acc (a,b,c,_,_) -> tri_add acc (a,b,c) ) (0, 0, 0) . take 7 . reverse

  --record newest value in history, mostly IO
write_entry :: String -> IO ()
write_entry f_seq = do
    let prompts = ["Learn: ", "Work: ", "Play: ", "Lifted? ", "Grade? ", "and? "]
        confirmations = (tail . inits) "yes"
        progress (x:xs) = xs ++ [x]
        format (l:w:p:_:g:d:[]) = concat $ "\n":"(":l:", ":w:", ":p:", \'":g:"\', \"":d:"\")":[]

      --prompt and take the day's values
    new_entry_data <- mapM ( \x -> putStr x >> hFlush stdout >> getLine) prompts

      --advance the fitness sequence if it happened
    when ((new_entry_data !! 3) `elem` confirmations) $ writeFile "sequence.txt" $ progress f_seq

      --prettyrwite to file
    appendFile "data.txt" $ format new_entry_data
    main