
{-# LANGUAGE NoImplicitPrelude , 
             TemplateHaskell   , 
             DuplicateRecordFields, 
             GeneralisedNewtypeDeriving,
             GADTs #-}

module Pointer where

import           Data.UUID
import           Lens.Micro.Platform
import           RIO
import           RIO.Time                       ( UTCTime )
import           Test.QuickCheck
import           Test.QuickCheck.Instances


data Ref = Ref
  { _refId   :: UUID
  , _created :: UTCTime
  } deriving (Eq, Show)
makeLenses ''Ref

instance Arbitrary Ref where
  arbitrary = Ref <$> arbitrary <*> arbitrary

instance Ord Ref where
 (<=) r1 r2 = (r1 ^. created) <= (r2 ^. created)
