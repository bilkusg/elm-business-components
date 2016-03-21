{-Copyright 2016 Greenwheel Technology Ltd and Gary Bilkus-}
module BusinessPage2 (Model, Action(..), update, view, inputs, init, component) where
import Business
import Effects exposing (Effects)
import Html exposing (..)
import StartApp exposing (Config)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Array

type alias Model  =
    {
      title: String
    , whichItems: Int
    }
type Action
    = NoOp

-- when we initialize a BusinessPage we pass in a delegate which can transform the BusinessModel. Internally we have no idea what it does and we don't care.
init : (String,Int)-> Business.Model->(Model, Business.Model, Effects (Action))
init (s,i) f = ({title=s,whichItems=i},f,Effects.none) -- when running standalone

-- as simple as can be since this is a readonly view with no behaviour
update msg model businessModel =(model, businessModel, Effects.none)
-- just display the relevant page as a list of names
view address model businessModel =
  div []
    [h1 [] [text model.title,text " " ,text "ReadOnly"]
--    ,button [onClick address (NewTabCalled "Amazing" )][text "NewTab"]
    ,div []
      [ul []

        ( businessModel |> Business.getList model.whichItems |> Array.map (\m->li[] [text m.name]) |> Array.toList )

      ]
    ]

inputs = []

component={init=init,update=update,view=view,inputs=inputs}
