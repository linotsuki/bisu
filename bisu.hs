{-# LANGUAGE UnicodeSyntax #-}
import System.IO
import qualified System.IO.Strict as S
import Control.Monad
import System.Environment (getArgs)
import Data.List (inits)

type Entry = (Float, Float, Float, Char, String)
type_it :: [String] -> [Entry]
type_it = map read

main = do
    args <- getArgs
    fit_sequence <- S.readFile "sequence.txt"
    file_string <- S.readFile "data.txt"
    let the_list = type_it $ lines file_string
        grades = [ x | (_, _, _, x, _) <- the_list ]
        diary = [ x | (_, _, _, _, x) <- the_list ]
        arg = head args
        clear = putStrLn $ replicate 120 '\n'
        pad = putStrLn "\n\n\n\n\n\n"
    case arg of
      "-r" -> report fit_sequence the_list
      "-w" -> write_entry fit_sequence
      "-p" -> clear >> putStrLn grades >> pad
      "-d" -> clear >> mapM_ putStrLn diary >> pad
      _ -> error "Boom!!"

write_entry f_seq = do
    let prompts = ["Learn: ", "Work: ", "Play: ", "Lift? ", "Grade? ", "and? "]
        confirmations = (tail . inits) "yes"
        progress (x:xs) = xs ++ [x]
        format (l:w:p:_:g:d:[]) = concat $ "\n":"(":l:", ":w:", ":p:", \'":g:"\', \"":d:"\")":[]
    replies <- mapM ( \x → putStr x >> getLine) prompts
    when ((replies !! 3) `elem` confirmations) $ writeFile "sequence.txt" $ progress f_seq
    appendFile "data.txt" $ format replies

report :: String -> [Entry] -> IO ()
report fit list = mapM_ putStrLn 
    ["",fast, "Most: " ++ most, "Little: " ++ little, "Least: " ++ least, "Move: " ++ activity]
    where (most, little, least) = what_do list
          activity = fitness fit
          fast = fasting $ length list

what_do :: [Entry] -> (String, String, String)
what_do list 
    | too_little_work = (work, learn, play)
    | too_much_play   = (learn, work, play)
    | too_much_study  = (play, work, learn)
    | otherwise     = (play, learn, work)
    where too_little_work = too_much_play && too_much_study
          too_much_play = play_hours / (learn_hours + work_hours) >= 0.25
          too_much_study = (learn_hours) / (work_hours) >= 0.66

          (work, learn, play) = (" - Job Hunt", " - LYaH / ?", " - Play")
          (learn_hours, work_hours, play_hours) = tri_sum list
           where tri_sum = foldl (\acc (a,b,c,_,_) → tri_add acc (a,b,c) ) (0, 0, 0) . take 7 . reverse
                 tri_add (a,b,c) (x,y,z) = (a+x, b+y, c+z)

fasting x
    | x `mod` 76 == 0 = "Full Day Fast"
    | x `mod` 21 == 0 = "Partial Fast"
    | otherwise = ""

fitness (x:xs)
    | x == '0' = " - Yoga"
    | x == '1' = " - Run and Lift"
    | x == '2' = " - Run"
    | x == '3' = " - Climb"