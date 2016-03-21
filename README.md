This library implements a way of defining components and containers compatible with StartApp which can be arbitrarily composed.

We can take almost any StartApp module and wrap it in a Container.component. Once wrapped, we can instantiate the component directly
or compose components into groups in various ways, with various behaviours.

A very simple example, based on the RandomGif from the architecture tutorial is:

import Component
import StartApp
import RandomGif
import AndContainer
import Task
import Effects exposing (Never)
-- This example shows how we can wrap existing StartApp modules into components which can then be composed to build up an application
-- in an nice clean way.

-- this example takes the RandomGif startapp from the architecture tutorial, and composes it into a tabbed list of several instances.
-- as you can see the code is minimal

-- Create a configuration for a RandomGif component
rgComponent = Component.startAppToComponent {init=RandomGif.init,update=RandomGif.update,view=RandomGif.view,inputs=RandomGif.inputs}
-- now wrap it in an andcontainer which gives us a tabbed choice
andcontainer = AndContainer.container rgComponent

-- initialize and turn back into a StartApp
app = Component.componentToStartApp
  [ ("Cats","Funny cats") -- each item is a title and the component initializer parameter
  , ("Dogs","Funny dogs")
  ]  () andcontainer -- the () is a placeholder for a not-needed BusinessModel

-- standard boilerplate
main =
  app.html

port tasks : Signal (Task.Task Never ())
port tasks =
  app.tasks

As you can see, the amount of additional boilerplate is minimal.

The examples directory contains three example apps - the one above is main0
main1 adds the ability to contain different kinds of component within a single andcontainer, by using the orcontainer
which holds one of several different types of component.

main2 demonstrates a top-level component and a low-level component which share a business model and are joined via our containers.
