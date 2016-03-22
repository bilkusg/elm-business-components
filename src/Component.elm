{-Copyright 2016 Greenwheel Technology Ltd and Gary Bilkus-}
module Component where
{-| This library is the underpinning for the composable component architecture
which builds on startapp.

# Definition
@docs Component

# Common Helpers
@docs componentToStartApp, startAppToComponent
-}
import StartApp exposing(..)
import Effects exposing (Effects)
import Html exposing (..)
import Signal
import Task

{-| Define a composable component with the given helper functions. Note the mutual compability requirements
    All components in a single tree must share the same businessModel.
-}
type alias Component model businessModel action initializer =
    { init : initializer -> businessModel -> (model, businessModel,Effects action)
    , update : action -> model -> businessModel -> (model, businessModel, Effects action)
    , view : Signal.Address action -> model -> businessModel -> Html
    , inputs : List (Signal.Signal action)
    }
{-| Given a component and initializers for its model and businessmodel create a StartApp which can be used in the
normal way as per the elm architecture
-}
componentToStartApp: initializer -> businessModel -> Component model businessModel action initializer ->
    { html : Signal Html
    , model : Signal ( model, businessModel )
    , tasks : Signal (Task.Task Effects.Never ())
    }

componentToStartApp modelInit businessInit c =
    let
      (im,ib,ie) = c.init modelInit businessInit
      newupdate a (m,b) =
        let (nm,nb,ne) = c.update a m b
        in ((nm,nb),ne)
    in
      StartApp.start
        { init = ((im,ib),ie)
        , update = newupdate
        , view = \a (m,b) -> c.view a m b
        , inputs = c.inputs
        }

{-|Wrap a start app component in one of ours so we can compose it. Intended to ease transition if you already have
existing components.-}
startAppToComponent:
    { l
        | init : a -> ( b, c )
        , inputs : d
        , update : e -> f -> ( g, h )
        , view : i -> j -> k
    }
    -> { init : a -> m -> ( b, m, c )
    , inputs : d
    , update : e -> f -> n -> ( g, n, h )
    , view : i -> j -> o -> k
    }
startAppToComponent app =
    let
      convertInit i bi =
        let (m1,e1) = app.init i
        in (m1,bi,e1)
      convertUpdate a m b =
        let (mup,eup) = app.update a m
        in (mup,b,eup)
    in
      {init = convertInit
      ,update = convertUpdate
      ,view = \a m b-> app.view a m
      ,inputs = app.inputs
      }
