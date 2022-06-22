{-# LANGUAGE NoImplicitPrelude, DuplicateRecordFields, ExistentialQuantification, GADTs #-}
{-# LANGUAGE KindSignatures #-}

module PayResult where

import PosInt
import RIO 
import qualified Refined as R
import Payment
data Invoice = Invoice PosInt


-- Här är Gadt kanske inte nödvändigt ?
data PaymentResult where
    UnsafeWithChange :: Money -> Invoice -> PaymentResult
    UnsafeWithDebt   :: Money -> Invoice -> PaymentResult
    UnsafeEven       :: Money -> Invoice -> PaymentResult

-- if we use smartconstructors we dont have to care about
-- not directly having the types in the system since the cons
-- ructors will do that jobb for us
{-
mk :: Money -> Invoice -> PaymentResult
mk (Debt d)  (Invoice PosInt) = undefined
mk (Asset d) (Invoice PosInt) = undefined
-}