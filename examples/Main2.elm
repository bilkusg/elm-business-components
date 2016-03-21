{-Copyright 2016 Greenwheel Technology Ltd and Gary Bilkus-}
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Effects exposing (Never,Effects)
import Array
import Component
import StartApp
import Task
import SimplePage
import Business
import BusinessPage1
import BusinessPage2
import NoComponent
import RandomGif
import AndContainer
import AllContainer
import OrContainer
import Navigation
-- This program extends the simple example to show how components at different levels can collaborate to update a business model
-- The business model is defined in the Business module, and essentially gives us some lists of data to play with
-- The Navigation page provides buttons to create additional panes with views of the data
-- The BusinessPage1 module allows updates to the businessModel
-- The BusinessPage2 module provides a different read-only view of the businessModel
-- The containers (and,or,all) are generic and know nothing at all about the details of the business model.

-- Set up a nice container to show all of our pages at once
-- we con't combine this into a single line, as we need to have access to the orcontainer's init function when we add more pages
-- dynamically.
orcontainer = OrContainer.container3 Navigation.component BusinessPage1.component BusinessPage2.component
container1 = AllContainer.container orcontainer

{-
In the previous example, we set up a static set of tabs in the andcontainer by initializing it.
In this version, we also demonstrate the ability to create tabs dynamically. We wrap an allcontainer in a new toplevel component which
overrides the view to show us info about  the business model before delegating to the main view of the created pages.
allcontainer is very much like andcontainer, except it shows all the pages at once rather than one at a time
-}

type alias BusinessModel = Business.Model
-- a little helper function to bind to a button which creates a new tab
-- input parameter is a valid init value for the contants of the tab
tAppendFrom title (model,bm,effects)  = (AndContainer.Append title (model,effects) )
--
topLevelComponent =
  let
    init ival bval=
      let
        (m,b,e) = container1.init ival bval
      in
        (m,bval,e)
-- The rather ugly patterns in the function below are not ideal, but at least they are validated for plausibility at compile time.
    update action  tabmodel businessmodel  =
      let
        (newaction,newtabmodel,newbusinessmodel) =
            case action of
            -- This allows us to have a subcomponent create a new tab at top level
            -- There are other ways of structuring this bottom-top stuff...
              AndContainer.SubOp _ (OrContainer.Sub1 (Navigation.NewPage s i))->
                case i of
                  1->((tAppendFrom s (orcontainer.init (OrContainer.Is2 ("Items1",1)) businessmodel )) ,tabmodel,businessmodel)
                  2->((tAppendFrom s (orcontainer.init (OrContainer.Is2 ("Items2",2)) businessmodel )) ,tabmodel,businessmodel)
                  3->((tAppendFrom s (orcontainer.init (OrContainer.Is2 ("Items3",3)) businessmodel )) ,tabmodel,businessmodel)
                  4->((tAppendFrom s (orcontainer.init (OrContainer.Is3 ("Items1P2",1)) businessmodel )) ,tabmodel,businessmodel)
                  _->(action, tabmodel,businessmodel)
              _ -> (action, tabmodel,businessmodel)
      in
        -- the container's components may well update the business model
        container1.update newaction newtabmodel newbusinessmodel

    view a  tabmodel businessModel  =
        div
          []
{-            -- to create some buttons to add new tabs directly here rather than by using a navigation pane we could do something like:
          [button [onClick a (tAppendFrom "Items1Page1" (orcontainer.init (OrContainer.Is1 ("Bus1P1",1)) businessModel))][text "Add Items1P1"]
          ,button [onClick a (tAppendFrom "Items1Page2" (orcontainer.init (OrContainer.Is2 ("Bus1P2",1)) businessModel))][text "Add Items1P2"]
          ,button [onClick a (tAppendFrom "Items2Page1" (orcontainer.init (OrContainer.Is1 ("Bus2P1",2)) businessModel))][text "Add Items2P1"]
-}
            -- Show the current value of part of the businessmodel to prove that what we update in the BusinessPage is the same thing
            -- as the model we are looking at here, and not a copy.
          [div
            []
            [div
              []
              (Business.getList 1 businessModel |> Array.map (\m->text (m.name++ " " ++ (toString m.value) ++ " ")) |> Array.toList )
            ,container1.view a tabmodel businessModel
            ]
          ]

    inputs=container1.inputs
  in
    {init=init,update=update,view=view,inputs=inputs}
-- and now the boilerplate
app = Component.componentToStartApp [("Menu",(OrContainer.Is1 ""))] Business.initialModel topLevelComponent

main =
  app.html

port tasks : Signal (Task.Task Never ())
port tasks =
  app.tasks
