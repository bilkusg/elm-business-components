import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Effects exposing (Never,Effects)
import Array
import Component
import StartApp
import Task
import SimplePage
import RandomGif
import AndContainer
import OrContainer

-- This example shows how we can wrap existing StartApp modules into components which can then be composed to build up an application
-- in an nice clean way.

-- This example, demonstrates a heterogeneous container, where different tabs can be of different types.
-- But we don't make use of the businessModel feature

-- First create a configuration for a RandomGif component - RandomGif is taken unchanged from the Elm Architecture tutorial
-- if the component has an init function with a single parameter then it's as easy as the below. Otherwise some wrapping is needed.
rgComponent = Component.startAppToComponent {init=RandomGif.init,update=RandomGif.update,view=RandomGif.view,inputs=RandomGif.inputs}
-- We wrote this simple component ourselves, so it already exposes a nicely wrapped component for us to use
simpleComponent = SimplePage.component
-- an orcontainer allows us to contain any one of up to four different component types....
-- container2 is the version expecting two subtypes
-- it is useful as the direct descendent of an and container where we want different tabs to potentially be different types of component
or2container = OrContainer.container2 rgComponent simpleComponent
andcontainer = AndContainer.container or2container

app = Component.componentToStartApp
  [ ("Cats",(OrContainer.Is1 "Funny cats")) -- each item is a title and the component initializer parameter
  , ("Dogs",(OrContainer.Is1 "Funny dogs"))
  , ("Simple",(OrContainer.Is2 "SimplePage1"))  -- this component is of the other option defined by the or container
  ]  () andcontainer -- the () is a placeholder for a not-needed BusinessModel

main =
  app.html

port tasks : Signal (Task.Task Never ())
port tasks =
  app.tasks
