module Navigation  where
import Business
import Effects exposing (Effects)
import Html exposing (..)
import StartApp exposing (Config)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Array
import HUtils
{-
This module demonstrates the creation of a menu whose buttons create new pages on the screen
It simply defines a simple action to capture which button was pressed and expects the top level component to
match the action and do what's needed

One might create a table-driven version where the buttons are defined in a model obtained from the init parameter,
but it's probably just as easy to craft it like this.
-}
type alias PageModel  =
    {
       currentPage: Int
    }
type PageAction
    = NoOp
    | GotoPage Int
    | NewPage String Int

init i f = ({currentPage=0},f,Effects.none)

update msg model businessModel =
-- this may look daft, but the point is that navigation has to be hendled by the top level component, so all we do is delegate up
  (model, businessModel, Effects.none)


view address model businessModel =
  div []
    [h1 [] [text "MENU"]
    ,ul []
      [li [] [button [onClick address (NewPage "Items1" 1)][text "Items1"]]
      ,li [] [button [onClick address (NewPage "Items2" 2)][text "Items2"]]
      ,li [] [button [onClick address (NewPage "Items3" 3)][text "Items3"]]
      ,li [] [button [onClick address (NewPage "Items1V2" 4)][text "Items1ReadOnly"]]
      ]
    ]

inputs = []

component={init=init,update=update,view=view,inputs=inputs}
