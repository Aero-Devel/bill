module AccountSpec where

import Import
import Account
import Test.Hspec
import Test.Hspec.QuickCheck

spec :: Spec
spec = do
  describe "plus2" $ do
    prop "bills in = bills payed + bills remaining" $ \i -> plus2 i - 2 `shouldBe` i
    prop "overpayed + (original - remaining) = total" $ \i -> plus2 i - 2 `shouldBe` i

prop_in_eq_payed_plus_rem :: [Bill] -> Account -> Int -> Bool
prop_in_eq_payed_plus_rem bs acc i = let nrPayed = abs $ mod i (length bs) 
                                     in  undefined


