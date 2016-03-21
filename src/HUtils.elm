module HUtils where
import Effects exposing (Effects)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Json.Decode as Json exposing (..)

-- this allows us to update a string input when we hit return but not on other keys
-- it also provides a useful template for custom event handlers to bind as attributes of html elements
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
