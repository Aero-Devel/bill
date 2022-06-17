{-# LANGUAGE NoImplicitPrelude , 
             TemplateHaskell   , 
             DuplicateRecordFields, 
             GeneralisedNewtypeDeriving #-}



module AccountInternal where

import           Lens.Micro.TH
import           RIO

newtype OCR = OCR {_ocrNum :: Int} deriving (Num,Eq, Ord )
makeLenses ''OCR

newtype Money = Money {_money :: Int} deriving (Num,Eq, Ord )
makeLenses ''Money

data Bill = Bill
  { _origAmmount :: Money
  , _left        :: Money
  , _ocr         :: OCR
  }
makeLenses ''Bill

data Account = Account
  { _bills     :: [Bill]
  , _overpayed :: Money
  }
makeLenses ''Account
