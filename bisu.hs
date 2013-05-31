module Main
    where
import System.IO
import Control.Monad (when)
import System.Environment (getArgs)

--originally fit_sequence = "101020300"
--the_list = [(learning, work, play, yes/no, short diary string), (day 2), (day 3) ...] 

main = do
    args <- getArgs
    fit_sequence <- readFile "sequence.txt"
    file_string <- readFile "data.txt"
    let the_list = map type_it $ lines file_string
        arg = head args
        output = case arg of
            "-r" -> report fit_sequence the_list
            "-w" -> "Time to write!\n"
            "-p" -> picture arg the_list
            "-d" -> picture arg the_list
            _ -> error "Boom!!"
    putStrLn output
    
    when ( output == "Time to write!\n" ) $ do
        putStrLn "Learn: "
        learn <- getLine
        putStrLn "Work: "
        work <- getLine
        putStrLn "Play: "
        play <- getLine
        putStrLn "Lift? "
        choice <- getLine
        when ( choice == "yes" ) $ do
            writeFile "sequence.txt" $ tail fit_sequence ++ [head fit_sequence] 
        putStrLn "Honor? "
        honor <- getLine
        putStrLn "and? "
        diary <- getLine
        appendFile "list.txt" $ "("++learn", "++work ++ play ++ honor ++ diary ++ "\n"

type_it :: String -> (Float, Float, Float, Char, String)
type_it = read 

report :: String -> [(Float, Float, Float, Char, String)] -> String
report fit the_list = "\n"++fast++"\nMost: "++most++"\nLittle: "++little++"\nLeast: "++least++"\nMove: "++activity++"\n"
                where   (most, little, least) = what_do the_list
                        activity = fitness fit
                        fast = fasting $ length the_list

what_do :: [(Float, Float, Float, Char, String)] -> (String, String, String)
what_do the_list =  if play_hrs / non_play >= 0.25 
                    then if learn_hrs / work_hrs >= 0.66
                         then (work, learn, play)
                         else (learn, work, play)
                    else if learn_hrs / work_hrs >= 0.66
                         then (play, work, learn)
                         else (play, learn, work)
                    where work = " - Job Hunt"
                          learn = " - LYaH / ?"
                          play = " - Play"
                          non_play = learn_hrs + work_hrs
                          learn_hrs = sum [ x | (x, _, _) <- portion ]
                          work_hrs = sum [ x | (_, x, _) <- portion ]
                          play_hrs = sum [ x | (_, _, x) <- portion ]
                          portion = [ (a, b, c) | (a, b, c, _, _) <- take 7 $ reverse the_list ]

fitness :: String -> String
fitness fit_seq
    | x == '0' = "  - Yoga"
    | x == '1' = "  - Run and Lift"
    | x == '2' = "  - Run"
    | x == '3' = "  - Climb"
    where x = head fit_seq 

fasting :: Int -> String
fasting x 
    | x `mod` 76 == 0 = "\nFull Day Fast"
    | x `mod` 21 == 0 = "\nPartial Fast"
    | otherwise   = ""

picture :: String -> [(Float, Float, Float, Char, String)] -> String
picture "-p" the_list = newlines 120 ++ [ x | (_, _, _, x, _) <- the_list ] ++ newlines 6
picture "-d" the_list = newlines 120 ++ concat [ x ++ "\n" | (_, _, _, _, x) <- the_list ] ++ newlines 6

newlines :: Int -> String
newlines x = replicate x '\n'