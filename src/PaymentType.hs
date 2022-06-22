{-# LANGUAGE NoImplicitPrelude , 
             TemplateHaskell   , 
             DuplicateRecordFields, 
             GeneralisedNewtypeDeriving,
             GADTs , DataKinds, TypeFamilies #-}
{-# LANGUAGE KindSignatures #-}
{-# LANGUAGE LambdaCase #-}

module PaymentType where
import RIO
import AccountInternal (Invoice)
import Refined
import Data.Kind
import Data.Singletons
{-
    A trade is either fully settled or not.
-}



data Change where
    Settled :: Invoice -> Refined Positive Integer -> Change
    Debted  :: Invoice -> Refined Negative Integer  -> Change


pay :: Invoice -> Money c -> Change
pay i m = undefined


data MoneyKind = Asset 
               | Debt 

data SMoneyKind :: MoneyKind -> Type where 
    SAsset :: SMoneyKind 'Asset
    SDebt  :: SMoneyKind 'Debt


newtype Money (t :: MoneyKind) = Money Natural 

type instance Sing = SMoneyKind

instance SingI 'Asset where sing = SAsset
instance SingI 'Debt where sing = SDebt

{-
   Känns konstigt att jag ska behöva skriva alla manuellt?
-}

data SomeMoney :: Type where 
    MkSomeMoney :: SMoneyKind s -> Money s -> SomeMoney

_combineMoney :: SMoneyKind s -> SMoneyKind s2 -> (Money s -> Money s2 -> Either (Money 'Asset) (Money 'Debt))
_combineMoney = undefined

combineMoney :: (SingI s , SingI s2 )=> Money s -> Money s2 -> Either (Money 'Asset) (Money 'Debt)
combineMoney = undefined


{- 
   There is no reason for us to transfer between states
   However we want to write an extracting function with different
   return values depending on purchasetype

   We are also going to want to be able to buy something
-}
