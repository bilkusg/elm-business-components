module NoComponent (update, view, inputs, init,component) where

import Effects exposing (Effects,Never)
import Html exposing (..)
import StartApp exposing (Config)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


init: Never -> businessModel -> (Int,businessModel,Effects Never)
init n o = (0,o,Effects.none) -- when running standalone


update msg model businessmodel=  (model,businessmodel, Effects.none)
view address model businessmodel = text "Nonexistent Component - should never see this"

inputs = []

component={init=init,update=update,view=view,inputs=inputs}
