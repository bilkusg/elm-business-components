{-Copyright 2016 Greenwheel Technology Ltd and Gary Bilkus-}
module AllContainer where
{-| Defines containers which can contain one of a number of differently typed component

# containers
@docs container
-}
import Effects exposing (Effects)
import Component exposing (Component)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Array exposing (..)
import Maybe exposing (..)
import Signal
import AndContainer

{-|Like an andcontainer but shows all components at once-}
container: Component model1 businessModel action1 initializer1
    -> Component (Int,Array.Array (String,model1)) businessModel (AndContainer.Action model1 action1)  (List (String,initializer1))
container comp1=
    let
      (=>) = (,)
      c = AndContainer.container comp1
      view saa (nselected,submodels) b =
        let
          addr1 n= Signal.forwardTo saa (AndContainer.SubOp n)
        in
        div
          []
          [ text ""
          ,div
            [style["display" => "flex"]]
            (submodels |> Array.indexedMap (\n (title,m1)->
               ( comp1.view (addr1 n) m1 b)) |> Array.toList
            )
          ]

    in
       {init=c.init, update=c.update,view=view,inputs=c.inputs}
