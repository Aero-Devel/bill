
{-# LANGUAGE NoImplicitPrelude, DuplicateRecordFields, ExistentialQuantification, GADTs #-}
{-# LANGUAGE KindSignatures #-}

module Payment where
import           PosInt
import           RIO
import qualified Refined                       as R


class Money m where
    sign :: m -> Integer
    unSign :: Integer -> m 
    combine :: m -> m -> m

newtype Debt = UnsafeMkDebt PosInt

-- - for Debt + for asset 0 for NoMoney
signMoney :: Money -> Integer
signMoney (Debt m) = - (R.unrefine m)
signMoney (Asset m) = R.unrefine m

-- the reverse
unsignMoney :: Integer -> Money
unsignMoney i | i >= 0 = Asset . refineAbs $ i
              |  otherwise = Debt . refineAbs $ i


combine :: Money -> Money -> Money
combine (Debt    m ) (Debt    m2) = Debt . refineAbs $ unrefThen m m2 (+)
combine (NoMoney _ ) (NoMoney _ ) = NoMoney ()
combine (Asset   a1) (Asset   a2) = Asset . refineAbs $ unrefThen a1 a2 (+)

combine (Debt    m ) (NoMoney _ ) = Debt m
combine (NoMoney _ ) (Debt    m ) = Debt m

combine (Asset   m ) (NoMoney _ ) = Asset m
combine (NoMoney _ ) (Asset   m ) = Asset m

combine (Asset   m ) (Debt    m2) = combine' (m, m2)
combine (Debt    m2) (Asset   m ) = combine' (m, m2)

combine' :: (PosInt, PosInt) -> Money
combine' (a, d) | a > d  = Asset . refineAbs $ unrefThen a d (-)
                | a == d = NoMoney ()
                | a < d  = Debt . refineAbs $ unrefThen d a (-)


-- Men nu får vi problemet att vi kan försöka handla med en skuld
-- Men det kan vara okej för vi kan patternmatcha vidare på den isf


