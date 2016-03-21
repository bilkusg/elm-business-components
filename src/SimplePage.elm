{-Copyright 2016 Greenwheel Technology Ltd and Gary Bilkus-}
module SimplePage  where

import Effects exposing (Effects)
import Html exposing (..)
import StartApp exposing (Config)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
{-
A SimplePage is just a very basic StartApp component wrapped as a component
It simply takes a string and displays it with a button which allows it to be
changed
-}
type alias Model =
    {
      displayValue : String
    }

init : String->busmodel->(Model, busmodel,Effects Action)
init s b = ({displayValue=s},b,Effects.none) -- when running standalone

type Action
    = NoOp
    | NewValue String


update : Action -> Model -> busmodel -> (Model, busmodel, Effects Action)
update msg model b =
  case msg of
    NoOp -> (model,b, Effects.none)
    NewValue s -> ({model| displayValue=s},b,Effects.none)

view : Signal.Address Action -> Model -> busmodel  -> Html
view address model b =
  div [] [button  [onClick address (NewValue "Clicked")][text (model.displayValue)]]

inputs = []

component={init=init,update=update,view=view,inputs=inputs}
