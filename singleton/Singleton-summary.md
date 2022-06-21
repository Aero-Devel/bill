# Cliffnotes


```haskell
{-# LANGUAGE DataKinds, GADTs #-}


--      v- Datakinds => promoted to kind
data DoorState = Opened | Closed | Locked deriving (Show, Eq)
--               |<-------------------->| -> Theese are now type-constructors

genSingletons [''DoorState] -- proovides SingDSI


data Door :: DoorState -> Type where
    UnsafeMkDoor :: { doorMaterial :: String } -> Door s
                                        --          ^- Refered to as 
                                        --             an indexed datatype

-- better function for creating door
mkDoor :: SDoorState s -> String -> Door s
mkDoor _ = UnsafeMkDoor
```
```haskell
-- Generated from genSingletons...

-- not the actual code, but essentially what happens
data SDoorState :: DoorState -> Type where
    SOpened :: Sing 'Opened
    SClosed :: Sing 'Closed
    SLocked :: Sing 'Locked

-- Sing x becomes a "type synonym" for SDoorState x when x is a DoorState
type instance Sing = SDoorState

-- for implicit passing
instance SingI 'Opened where
    sing = SOpened
instance SingI 'Closed where
    sing = SClosed
instance SingI 'Locked where
    sing = SLocked

-- function from singleton -> termlevel value
fromSing :: Sing (s :: DoorState) -> DoorState


```

```haskell 

-- when writing a function we first proovide the inner function, with a 
-- singleton to pattern match on
lockAnyDoor :: SDoorState s -> (Door s -> Door 'Locked)
lockAnyDoor = \case
    SOpened -> lockDoor . closeDoor  -- in this branch, s is 'Opened
    SClosed -> lockDoor              -- in this branch, s is 'Closed
    SLocked -> id                    -- in this branch, s is 'Locked

-- We then wrap it so we dont have to proovide the argument when using the 
-- function
lockAnyDoor_ :: SingDSI s => Door s -> Door 'Locked
lockAnyDoor_ = lockAnyDoor singDS
```