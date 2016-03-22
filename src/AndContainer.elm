{-Copyright 2016 Greenwheel Technology Ltd and Gary Bilkus-}
module AndContainer where
{-| Defines containers which can contain one of a number of differently typed component

# containers
@docs Action, container
-}
import Effects exposing (Effects)
import Component exposing (Component)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Array exposing (..)
import Maybe exposing (..)
import Signal



-- Note that the Append function expects a (model ,action) not an init string
-- Note also that there is no way of adding in new inputs at this stage, so a new tab with inputs
-- will have to handle the inputs differently. This is mainly a problem for andcontainers which start empty
-- and display a container with inputs.

{-|The action allows us to delegate to a specific subcomponent as well as handle additions etc
There is more to do here - we need to support removal, reordering etc, and some of that is non-trivial
because of the inputs
-}
type Action model1 action1
  =   SubOp Int action1
    | SubOpAll action1
    | Select Int
    | Append String (model1,Effects action1)
{-|Contains 0 or more tabbed instances of the subcomponent
-}
container: Component model1 businessModel action1 initializer1
    -> Component (Int,Array.Array (String,model1)) businessModel (Action model1 action1)  (List (String,initializer1))
container comp1=
    let
      init lis b =
        let
          listOfTitleModelBusEffect = lis |> List.map ( \(title,init) -> (title,comp1.init init b) )
          arrayOfTitleModelBus = listOfTitleModelBusEffect |> List.map ( \(title,(model,bus,effect))->(title,model)) |> Array.fromList
          combinedEffects =  listOfTitleModelBusEffect |> List.indexedMap (\n (title,(model,bus,effect))->(Effects.map (SubOp n) effect))
               |> Effects.batch
        in
          ((0,arrayOfTitleModelBus),b,combinedEffects)
--       (c1m,c1e) = comp1.init i1
--Effects.batch [Effects.map (\x->(OrNoOp,Just x,Nothing)) fx1up,Effects.map (\x->(OrNoOp,Nothing,Just x)) fx2up]
      updateAndMergeEffects tabaction (nselected,submodels) b oldeffects =
        let
          ((ns,nm),nb,ne) = update tabaction (nselected,submodels) b
          mergede = Effects.batch [oldeffects,ne]
        in
          ((ns,nm),nb,mergede)

      update tabaction (nselected,submodels) b =
          case tabaction of
            -- apply the action to all existing submodels -- not yet implemented
            SubOpAll subaction -> -- ((nselected,submodels),b,Effects.none)
              [0..(Array.length submodels)] |> List.foldl (\n ((ns,sm),b,e)->(updateAndMergeEffects (SubOp n subaction) (ns,sm) b e)) ((nselected,submodels),b,Effects.none)
            SubOp nacted subaction->
              let
                maybeModel = Array.get nacted submodels
              in
                case maybeModel of
                  -- this really shouldn't ever happen....
                  Nothing -> ((nselected,submodels),b,Effects.none)
                  Just (title,m) ->
                    let
                      (nm,nb,ne) = comp1.update subaction m b
                      newSubModelsAndEffects = submodels |> Array.indexedMap
                        (\n (title,m)->
                          if n == nacted
                          then
                            ((title,nm),nb,(Effects.map (\x->(SubOp n x)) ne) )
                          else
                            ((title,m),b,Effects.none)
                        )
                    in
                      (
                        (nselected
                        ,(Array.map (\(m,b,e)->m) newSubModelsAndEffects)
                        )
                      ,nb
                      ,Effects.batch (Array.toList (Array.map (\(m,b,e)->e) newSubModelsAndEffects))
                      )
            Select n -> ((n,submodels),b,Effects.none)
            Append title (newmodel,neweffects)->
              let
                newSubModels = Array.push (title,newmodel) submodels
                newLength = Array.length newSubModels
              in ( ( ( newLength - 1),newSubModels),b, Effects.map (\a->(SubOp (newLength - 1)  a)) neweffects)
      (=>) = (,)
      view saa (nselected,submodels) b =
        let
          addr1 = Signal.forwardTo saa (SubOp nselected)
        in
        div []
          [div [] (Array.toList (Array.indexedMap (\n (title,sm)->
                  button [onClick saa (Select n)][text title]) submodels))
          ,div [ style [ "display" => "flex"]]
            [case Array.get nselected submodels of
              Nothing -> text "Missing component?"
              Just (title,m1) -> ( comp1.view addr1 m1 b)
            ]
          ]
      comp1convert comp1action = SubOpAll comp1action

      inputs =
        (List.map (Signal.map comp1convert) comp1.inputs)

    in
       {init=init, update=update,view=view,inputs=inputs}
