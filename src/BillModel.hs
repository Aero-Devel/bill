
{-# LANGUAGE NoImplicitPrelude, DuplicateRecordFields, ExistentialQuantification, GADTs #-}
{-# LANGUAGE KindSignatures #-}







module BillModel where


import Data.UUID (UUID)
import Money




data Bill where
    UnsafeMkBill :: Money c -> UUID -> Bill
