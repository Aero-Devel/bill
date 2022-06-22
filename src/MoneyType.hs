
{-# LANGUAGE NoImplicitPrelude , 
             TemplateHaskell   , 
             DuplicateRecordFields, 
             GeneralisedNewtypeDeriving,
             ExistentialQuantification,
             GADTs, DataKinds,  KindSignatures , TemplateHaskell#-}

module MoneyType where
import Data.Kind (Type)
import RIO
import PosInt (PosInt)


data Currency = Sek | Usd | Nok | Dkk | Jpy | Cny | Eur | Gbp | Aud | Cad | Chf | Hkd | Huf | Ils | Inr | Krw | Mxn | Nzd | Pln | Rub | Sgd | Zar | Thb | Try | Zwd
    deriving (Show, Eq)

data Money :: Currency -> Type where
    UnsafeMkMoney :: {amount :: PosInt} -> Money c
        deriving (Show, Eq)
    
