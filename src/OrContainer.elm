{-Copyright 2016 Greenwheel Technology Ltd and Gary Bilkus-}
module OrContainer where
{-| Defines containers which can contain one of a number of differently typed component

# containers
@docs Action, Model, container4, container3, container2
-}
import Effects exposing (Effects,Never)
import Component exposing (Component)
import NoComponent
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Array exposing (..)
import Maybe exposing (..)
import Signal


{-| Represents an action which will be passed through to a sub component
-}
type Action sub1 sub2 sub3 sub4
  =   Sub1 sub1
    | Sub2 sub2
    | Sub3 sub3
    | Sub4 sub4
{-|
Represents a type of one of the four possible sub models
-}
type Model m1 m2 m3 m4
  = Is1 m1
  | Is2 m2
  | Is3 m3
  | Is4 m4

{-|
 A container which can contain any of four types
 -}
container4: Component model1 businessModel action1 initializer1
  -> Component  model2 businessModel action2 initializer2
  -> Component  model3 businessModel action3 initializer3
  -> Component  model4 businessModel action4 initializer4
  -> Component (Model model1 model2 model3 model4) businessModel
                (Action action1 action2 action3 action4)
                (Model initializer1 initializer2 initializer3 initializer4)
container4 comp1 comp2 comp3 comp4 =
  let
    init initdata busdata =
      case initdata of
        Is1 init ->
          let (model,busmodel,effects) = comp1.init init busdata
          in
            (Is1 model,busmodel,Effects.map (\x->(Sub1 x)) effects )
        Is2 init ->
          let (model,busmodel,effects) = comp2.init init busdata
          in
            (Is2 model,busmodel,Effects.map (\x->(Sub2 x)) effects )
        Is3 init ->
          let (model,busmodel,effects) = comp3.init init busdata
          in
            (Is3 model,busmodel,Effects.map (\x->(Sub3 x)) effects )
        Is4 init ->
          let (model,busmodel,effects) = comp4.init init busdata
          in
            (Is4 model,busmodel,Effects.map (\x->(Sub4 x)) effects )

    update a m b =
      case a of
        Sub1 action ->
          case m of
            Is1 model->
              let (um,ub,ufx) = comp1.update action model b
              in
                (Is1 um,ub,Effects.map Sub1 ufx)
            _ ->
              (m, b, Effects.none)
        Sub2 action ->
          case m of
            Is2 model->
              let (um,ub,ufx) = comp2.update action model b
              in
                (Is2 um,ub,Effects.map Sub2 ufx)
            _ ->
              (m, b, Effects.none)
        Sub3 action ->
          case m of
            Is3 model->
              let (um,ub,ufx) = comp3.update action model b
              in
                (Is3 um,ub,Effects.map Sub3 ufx)
            _ ->
              (m, b, Effects.none)
        Sub4 action ->
          case m of
            Is4 model->
              let (um,ub,ufx) = comp4.update action model b
              in
                (Is4 um,ub,Effects.map Sub4 ufx)
            _ ->
              (m, b, Effects.none)

    view saa model businessModel  =

         let

             addr1 = Signal.forwardTo saa Sub1
             addr2 = Signal.forwardTo saa Sub2
             addr3 = Signal.forwardTo saa Sub3
             addr4 = Signal.forwardTo saa Sub4
         in
           div [] [
            case model of
             Is1 m -> (comp1.view addr1 m businessModel)
             Is2 m -> (comp2.view addr2 m businessModel)
             Is3 m -> (comp3.view addr3 m businessModel)
             Is4 m -> (comp4.view addr4 m businessModel)
          ]
    comp1convert comp1action = Sub1 comp1action
    comp2convert comp2action = Sub2 comp2action
    comp3convert comp3action = Sub3 comp3action
    comp4convert comp4action = Sub4 comp4action

    inputs =  (
         (List.map (Signal.map comp1convert) comp1.inputs)
         ++
           (List.map (Signal.map comp2convert) comp2.inputs)
           ++
             (List.map (Signal.map comp3convert) comp3.inputs)
             ++
               (List.map (Signal.map comp4convert) comp4.inputs)
       )
    in
       {init=init, update=update,view=view,inputs=inputs}

{-|
 A container which can contain any of three types
 -}
container3: Component model1 businessModel action1 initializer1
   -> Component  model2 businessModel action2 initializer2
   -> Component  model3 businessModel action3 initializer3
   -> Component (Model model1 model2 model3 Int) businessModel
                 (Action action1 action2 action3 Never)
                 (Model initializer1 initializer2 initializer3 Never)
container3 m1 m2 m3 = container4 m1 m2 m3 NoComponent.component
{-|
 A container which can contain any of two types
-}
container2: Component model1 businessModel action1 initializer1
   -> Component  model2 businessModel action2 initializer2
   -> Component (Model model1 model2 Int Int) businessModel
                 (Action action1 action2 Never Never)
                 (Model initializer1 initializer2 Never Never)
container2 m1 m2 = container4 m1 m2 NoComponent.component NoComponent.component
