{-# LANGUAGE KindSignatures #-}
{-# LANGUAGE DataKinds #-}
module Money(
    -- * Money
    Money,
    ExchangeTable
    -- * Currency
) where

import MoneyType
import PosInt (PosInt)

type ExchangeTable = [(PosInt, Currency)]

{-
    Need a typelevel exchangefunction to convert from one currency to another.
-}
