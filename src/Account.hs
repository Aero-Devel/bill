{-# LANGUAGE NoImplicitPrelude , 
             TemplateHaskell   , 
             DuplicateRecordFields, 
             GeneralisedNewtypeDeriving,
             ExistentialQuantification,
             GADTs #-}
{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}
{-# HLINT ignore "Use newtype instead of data" #-}

module Account where
import           AccountInternal
import           Data.UUID                      ( UUID )
import           Lens.Micro.Platform
import           Pointer
import           RIO                     hiding ( lens )
import qualified RIO.Map                       as M
import qualified RIO.Seq                       as S
import qualified RIO.Text                      as T
import           RIO.Time                       ( UTCTime )
import           Test.QuickCheck
--  tesdt & x .~  something
-- [1,2,3] & mapped %~ succ // over / modify
--  "abc" & mapped .~ 'x'   // set
-- ('x','y') ^. _1 = 'x'    // get
--
--
{-
data Invoice = Invoice
  { _ref     :: Ref
  , _ocr     :: OCR
  , _expires :: UTCTime
  , _amount  :: Money
  , _active  :: Bool
  }
makeLenses ''Invoice


instance Arbitrary Invoice where
  arbitrary =
    Invoice
      <$> arbitrary
      <*> arbitrary
      <*> arbitrary
      <*> arbitrary
      <*> arbitrary

{- An account takes in invoices and payments -}

data Payment = Payment
  { _pa       :: Money
  , _paymentR :: Ref
  , target    :: Ref
  }

makeLenses ''Payment
instance Arbitrary Payment where
  arbitrary = Payment <$> arbitrary <*> arbitrary <*> arbitrary


data Account = Account
  { _is :: M.Map Ref Invoice
  }

makeLenses ''Account

{- Underpaying generates a new invoice with the remaining amount
 - Overpaying returns remaining money
 -
 - -}

makePayment :: Account -> Payment -> Account
makePayment p = undefined

leq :: Int -> Int
leq i | i == 0 = 0
      | i < 0  = -1
      | i > 0  = 1

data Event = NewInvoice Invoice
           |  Payment   Payment
-}