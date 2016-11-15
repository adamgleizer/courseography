{-# LANGUAGE FlexibleContexts #-}

import qualified Text.Parsec as Parsec
import Text.Parsec ((<?>))
import Control.Applicative
import Control.Monad.Identity (Identity)
import qualified Data.String as S
import qualified Database.Requirement as R
parse rule text = Parsec.parse rule "(source)" text

-- define separators for "/"  ","  "("  ")"  "from"
orSeparator :: Parsec.Parsec String () ()
orSeparator = Parsec.spaces >> Parsec.char '/' >> Parsec.spaces

andSeparator :: Parsec.Parsec String () ()
andSeparator = Parsec.spaces >> Parsec.char ',' >> Parsec.spaces

lpSeparator :: Parsec.Parsec String () ()
lpSeparator = Parsec.spaces >> Parsec.char '(' >> Parsec.spaces

rpSeparator :: Parsec.Parsec String () ()
rpSeparator = Parsec.spaces >> Parsec.char ')' >> Parsec.spaces

fromSeparator :: Parsec.Parsec String () ()
fromSeparator = Parsec.spaces >> Parsec.oneOf "fromFrom" >> Parsec.spaces
-- potentially have one separator that returns accordingly?

length_list :: [Req] -> Int 
length_list [] = 0
length_list (x:xs) =1 + length_list xs

-- parse for single course OR req within parantheses
courseParser :: Parsec.Parsec String () Req
courseParser = (do
    Parsec.spaces
    -- with no spaces, we expect 3 letters, 3 digits, and (h/H/y/Y)1
    code <- Parsec.count 3 Parsec.letter
    num <- Parsec.count 3 Parsec.digit
    sess <- Parsec.count 2 Parsec.alphaNum
    Parsec.spaces
    return $ J (code++num++sess)) <|> (parParser)

-- parse for reqs separated by / "or"
orParser :: Parsec.Parsec String () Req
orParser = do
    tmp <- Parsec.sepBy (courseParser) (Parsec.char '/')
    if length_list tmp == 1
    then
        case tmp of
        [x] -> return x
    else
        return $ OR tmp

-- parse for reqs separated by , "and"
andorParser :: Parsec.Parsec String () Req
andorParser = do
    tmp <- Parsec.sepBy (orParser) (Parsec.char ',')
    if length_list tmp == 1
    then
        case tmp of
        [x] -> return x
    else
        return $ AND tmp

-- parse for reqs within parantheses
parParser :: Parsec.Parsec String () Req
parParser = do
  Parsec.spaces
  Parsec.char '('
  Parsec.spaces
  req <- andorParser
  Parsec.spaces
  Parsec.char ')'
  Parsec.spaces
  return req

-- TODO: error msg
---- display
---- recursive structure
---- unformatted course
---- FROM value constructor
