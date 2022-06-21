{-# LANGUAGE NoImplicitPrelude , 
             TemplateHaskell   , 
             DuplicateRecordFields, 
             GeneralisedNewtypeDeriving,
             GADTs #-}
module PosInt where

import           Lens.Micro.Platform            ( (%~)
                                                , (&)
                                                , (^.)
                                                , makeLenses
                                                )
import           RIO
import           RIO.Time                       ( Day )
import qualified Refined                       as R
import qualified Refined.Unsafe                as R

{-
    Some simple combinators for avoidig
    having to deal with eithers 
-}

type PosInt = R.Refined R.NonNegative Integer -- ^ positive integer


safeSubtract :: PosInt -> PosInt -> Maybe PosInt
safeSubtract p1 p2 =
  let piRef = R.refine :: Integer -> Either R.RefineException PosInt
  in  case piRef $ R.unrefine p1 - R.unrefine p2 of
        Left  _  -> Nothing
        Right re -> Just re

-- Manually tested and working
refinedZero :: PosInt
refinedZero = R.unsafeRefine 0

refineAbs :: Integer -> PosInt
refineAbs = R.unsafeRefine . abs

unrefThen :: PosInt -> PosInt -> (Integer -> Integer -> a) -> a
unrefThen p1 p2 op = op (R.unrefine p1) (R.unrefine p2)

unref2 :: PosInt -> PosInt -> (Integer, Integer)
unref2 p1 p2 = unrefThen p1 p2 (,)

