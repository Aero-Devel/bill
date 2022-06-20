module AccountSpec where

import           Account
import           Import
import           Test.Hspec
import           Test.Hspec.QuickCheck

spec :: Spec
spec = describe "plus2" $ do
  prop "" $ \i -> const True

prop_pay_inverse_payments :: Money -> Invoice -> Bool
prop_pay_inverse_payments = undefined
