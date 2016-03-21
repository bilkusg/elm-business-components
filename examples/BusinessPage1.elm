{-Copyright 2016 Greenwheel Technology Ltd and Gary Bilkus-}
module BusinessPage1 (PageModel, PageAction(..), update, view, inputs, init, component) where
import Business
import Effects exposing (Effects)
import Html exposing (..)
import StartApp exposing (Config)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Array
import HUtils

type alias PageModel  =
    {
      title: String
    , whichItems: Int
    , lastKey: Int
    }
type PageAction
    = NoOp
    | BusinessAction (Business.Model->Business.Model)
    | NewTabCalled String -- handled by a parent
    | UpdateText Int String

-- when we initialize a BusinessPage we pass in a delegate which can transform the BusinessModel. Internally we have no idea what it does and we don't care.
init : (String,Int)-> Business.Model->(PageModel, Business.Model, Effects (PageAction))
init (s,i) f = ({title=s,whichItems=i,lastKey=0},f,Effects.none) -- when running standalone

update msg model businessModel =
  case msg of
    NoOp -> (model, businessModel, Effects.none)
    BusinessAction f ->(model,businessModel, Effects.none)
    NewTabCalled s -> (model,businessModel,Effects.none)
    UpdateText n newval-> (model
        ,Business.updateModel  model.whichItems n newval 101 businessModel
        ,Effects.none)


showOneLine address itemnumber item =

  tr []
    [
    td[]
      [input
        [Html.Attributes.value item.name
--        ,   on "input" targetValue (\str -> Signal.message address (UpdateText itemnumber str))
        , HUtils.onInputFinish address (UpdateText itemnumber )
        ] []
--    onKeyPress address (\n->(KeyUp n))
      ]
    , td[] [toString item.value|>text]
    ]

view address model businessModel =
  div []
    [h1 [] [text model.title, text " " , text (toString model.lastKey)]
    ,button [onClick address (NewTabCalled "Items3" )][text "ShowItems3"]
    ,button [onClick address (BusinessAction (Business.updateModel  model.whichItems 2 "NewText" 123) )][text "Update2"]
    ,Html.form [ ]
      [table []
        ( businessModel |> Business.getList model.whichItems |> Array.indexedMap (showOneLine address)  |> Array.toList )
      ]
    ]

inputs = []

component={init=init,update=update,view=view,inputs=inputs}
