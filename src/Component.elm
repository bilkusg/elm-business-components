{-Copyright 2016 Greenwheel Technology Ltd and Gary Bilkus-}
module Component where

import StartApp exposing(..)
import Effects exposing (Effects)
import Html exposing (..)
import Signal


type alias Component model businessModel action initializer =
    { init : initializer -> businessModel -> (model, businessModel,Effects action)
    , update : action -> model -> businessModel -> (model, businessModel, Effects action)
    , view : Signal.Address action -> model -> businessModel -> Html
    , inputs : List (Signal.Signal action)
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
