{-Copyright 2016 Greenwheel Technology Ltd and Gary Bilkus-}
module NoComponent (update, view, inputs, init,component) where

import Component
import Effects exposing (Effects,Never)
import Html exposing (..)
import StartApp exposing (Config)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


init: Never -> businessModel -> (Int,businessModel,Effects Never)
init n o = (0,o,Effects.none) -- when running standalone

update: Never -> Int -> businessModel -> (Int,businessModel,Effects Never)
update msg model businessmodel=  (model,businessmodel, Effects.none)

view: (Signal.Address Never)->Int->businessModel->Html
view address model businessmodel = text "Nonexistent Component - should never see this"

inputs = []
component: Component.Component Int businessModel Never Never
component={init=init,update=update,view=view,inputs=inputs}
