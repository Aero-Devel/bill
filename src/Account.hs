{-# LANGUAGE NoImplicitPrelude, OverloadedStrings #-}
module Account where
import           AccountInternal
import           RIO
import qualified RIO.Text                      as T
import RIO.Lens

--  tesdt & x .~  something
-- [1,2,3] & mapped %~ succ // over / modify
--  "abc" & mapped .~ 'x'   // set
-- ('x','y') ^. _1 = 'x'    // get

new :: Bill -> m Account -> m Account
new = undefined


pay' :: Money -> Bill -> (Bill, Int)
pay' m b = b & left <%~ (m ^. money)

pay :: OCR -> Money -> Account -> Either T.Text Account
pay target paymentAmt acc = undefined

minusOrNill :: Int -> Int -> Int
minusOrNill i1 i2 = let r = (i1 - i2) in if r > 0 then r else 0


billWithOcr :: OCR -> Account -> [Bill]
billWithOcr targetOCR acc = filter (\b -> targetOCR == b ^. ocr) $ acc ^. bills

--
payed :: Account -> [Bill]
payed a = filter (\b -> 0 == b ^. left) $ a ^. bills
--filter (== 0) . (^. left) . (^. bills)

-- find all not fully payed bills
unPayed :: Account -> [Bill]
unPayed acc = filter (\a -> 0 >= a ^. left) $ acc ^. bills

