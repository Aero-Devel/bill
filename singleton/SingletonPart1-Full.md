# Dependent types 

## Phantom types

```haskell
--       v- phantom type
data Door p = MkDoor
```

### Sanitizing

```haskell
{-# LANGUAGE DataKinds #-}
--      v- Datakinds => promoted to kind
data DoorState = Opened | Closed | Locked deriving (Show, Eq)
--               |<-------------------->| -> Theese are now type-constructors


--                v- s is of kind Doorstate 
data Door (s :: DoorState) = UnsafeMkDoor { doorMaterial :: String }

```

'Opened, 'Closed, 'Locked are typeconstructors, we use ' to denote that they are infact types.

```haskell
ghci> :k 'Opened
DoorState
ghci> :k 'Locked
DoorState

```
### GADT's syntax
```haskell
{-# LANGUAGE DataKinds, GADTs #-}

data Door :: DoorState -> Type where
    UnsafeMkDoor :: { doorMaterial :: String } -> Door s
                                        --          ^- Refered to as 
                                        --             an indexed datatype

```

### Functions on phantom types

We cant cloose a locked door, we can only lock a closed door, we can only 
open a closed door

```haskell 

closeDoor :: Door 'Opened -> Door 'Closed
closeDoor (UnsafeMkDoor m) = UnsafeMkDoor m

lockDoor :: Door 'Closed -> Door 'Locked
lockDoor (UnsafeMkDoor m) = UnsafeMkDoor m

openDoor :: Door 'Closed -> Door 'Opened
openDoor (UnsafeMkDoor m) = UnsafeMkDoor m


```

```haskell
ghci> XDataKinds
ghci> XTypeApplications
ghci> 
ghci> 
ghci> let myDoor = UnsafeMkDoor @'Opened "Spruce"
ghci> :t myDoor
Door 'Opened
ghci> :t closeDoor myDoor
Door 'Closed
ghci> let yourDoor = UnsafeMkDoor @'Closed "Acacia"
ghci> :t closeDoor yourDoor
TYPE ERROR!  TYPE ERROR!
```

### Type erasure / Caller picks value

Because of type erasure we need <ins >singleton types </ins> to demote our types into values
this is because types are erased on runtime. 

## Singletons
The process of demoting types to values at runtime. 

```haskell 
data SDoorState :: DoorState -> Type where
    SOpened :: SDoorState 'Opened
    SClosed :: SDoorState 'Closed
    SLocked :: SDoorState 'Locked


-- Function which allows reflection
fromSDoorState :: SDoorState s -> DoorState
fromSDoorState SOpened = Opened
fromSDoorState SClosed = Closed
fromSDoorState SLocked = Locked

-- which gives us this better way of obtaining doorstatus
doorStatus :: SDoorState s -> Door s -> DoorState
doorStatus s _ = fromSDoorState s
```



### Implicit passing of singletons

Through the usage of typeclasses, we can do whats known as implicit passing.

```haskell
class SingDSI s where
    singDS :: SDoorState s

instance SingDSI 'Opened where
    singDS = SOpened
instance SingDSI 'Closed where
    singDS = SClosed
instance SingDSI 'Locked where
    singDS = SLocked
```

With this we dont have to do a bunch of patternmatching when we dont want to


```haskell 
-- with this function
lockAnyDoor :: SDoorState s -> (Door s -> Door 'Locked)
lockAnyDoor = \case
    SOpened -> lockDoor . closeDoor  -- in this branch, s is 'Opened
    SClosed -> lockDoor              -- in this branch, s is 'Closed
    SLocked -> id                    -- in this branch, s is 'Locked

-- wrapped with implicit passing so we dont have to proovide an unnecassary arg    
lockAnyDoor_ :: SingDSI s => Door s -> Door 'Locked
lockAnyDoor_ = lockAnyDoor singDS

-- As you can see here we use a constraint instead of passing a singleton
-- explicitly

doorStatus :: SDoorState s -> Door s -> DoorState
doorStatus s _ = fromSDoorState s

-- only need one argument
doorStatus_ :: SingDSI s => Door s -> DoorState
doorStatus_ = doorStatus singDS


-- This function is used to get a Doorstate back from the singleton
withSingDSI :: SDoorState s -> (SingDSI s => r) -> r
withSingDSI sng x = case sng of
    SOpened -> x
    SClosed -> x
    SLocked -> x

-- better function for creating door
mkDoor :: SDoorState s -> String -> Door s
mkDoor _ = UnsafeMkDoor
```

### Dependendent pattern match


### The singleton pattern


## Reification
The process of promoting values to the type level.