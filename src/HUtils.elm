{-Copyright 2016 Greenwheel Technology Ltd and Gary Bilkus-}
module HUtils where
{-| A module for helper utilities useful in html production and event handling in the dom
# events
@docs onInputFinish
-}
import Effects exposing (Effects)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Json.Decode as Json exposing (..)

{-|
Allows us to update a string input when we hit return but not on other keys.
It also provides a useful template for custom event handlers to bind as attributes of html elements
Can be used just like onCLick or other htmkl event handlers. The supplied function is passed the text content
of an input field when return is pressed but not on other keystrokes.
-}
onInputFinish:Signal.Address a->(String->a )->Attribute
onInputFinish address action  =
  let
    targetValueAndKey =
      let
        targetKey = ("keyCode" := int)
        targetValue =
          Json.at ["target", "value"] string
      in
        object2 (,) targetValue targetKey
    decoder = (Json.customDecoder targetValueAndKey (\(v,k) ->
        if List.member k [13]
        then Ok v
        else Err "!"))
  in
    onWithOptions "keyup" {preventDefault = False, stopPropagation = False} decoder (\val->Signal.message address (action val))
