{-# LANGUAGE NoImplicitPrelude , 
             TemplateHaskell   , 
             DuplicateRecordFields, 
             GeneralisedNewtypeDeriving,
             GADTs #-}



module AccountInternal where
import           Lens.Micro.Platform            ( makeLenses
                                                )
import           PosInt
import           RIO
import           RIO.Time                       ( Day )

newtype OCR = OCR { _ocr :: PosInt } deriving (Eq, Show, Ord)
makeLenses ''OCR


newtype Money = Money
  { _amount   :: PosInt
  }
  deriving (Eq, Show, Ord)

makeLenses ''Money

data Invoice = Invoice
  { _invoiceOcr         :: OCR
  , _invoiceDate        :: Day
  , _invoiceDueDate     :: Day
  , _invoiceAmount      :: Money -- ^ Total amount of the invoice 
  , _invoiceserviceDesc :: Text
  }
  deriving (Eq, Show, Ord)

makeLenses ''Invoice

data Receipt = Receipt
  { _originalInvoice    :: Invoice
  , _receiptDate        :: Day
  , _receiptAmountPayed :: Money
  , _newInvoice         :: Maybe Invoice
  , _change             :: Money
  }
  deriving (Eq, Show, Ord)
makeLenses ''Receipt

zeroDollars :: Money
zeroDollars = Money refinedZero

pay :: Day -> Invoice -> Money -> Receipt
pay d i m = -- know that the following fields are fixed :  
  let pr (newInv, newChange) = Receipt { _originalInvoice    = i
                                       , _receiptDate        = d
                                       , _receiptAmountPayed = m
                                       , _newInvoice         = newInv
                                       , _change             = newChange
                                       }
  in  pr $ pay' (unrefThen (i ^. (invoiceAmount . amount)) (m ^. amount) (-)) i where
  pay' :: Integer -> Invoice -> (Maybe Invoice, Money)
  pay' diff _ | diff <= 0 = (Nothing, Money $ refineAbs diff)
  pay' diff oInvoice =
    let newI = oInvoice & invoiceAmount %~ (\x -> x & amount .~ refineAbs diff)
    in  (Just newI, zeroDollars)


p3 :: Invoice -> Money -> a
p3 i m =
  case unrefThen (i ^. (invoiceAmount . amount)) (m ^. amount) compare of
    GT -> error "Not enough money"
    EQ -> error "No change"
    LT -> error "Too much money"


(.:) :: (b -> c) -> (a1 -> a2 -> b) -> a1 -> a2 -> c
(.:) = (.) . (.)


{-
  The new invoice is the invoice with 
  the amount reduced by the amount of the receipt.

  The new invoice is Nothing if the amount of the receipt 
  is greater than the amount of the invoice.
-}

prop_pay :: Day -> Invoice -> Money -> Bool
prop_pay payday invoice money = undefined
