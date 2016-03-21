module Business where
import Array

type alias Item = { name:String, value: Int}
type alias Items = Array.Array Item

type alias Model = {item1:Items,item2:Items,item3:Items}

startingItems t =
    [1..10] |> List.map (\n->{name=t++(toString n),value=(n*n)}) |>Array.fromList

initialModel = {item1=startingItems "first:",item2=startingItems "second:",item3=startingItems "third:"}

updateModel  whichList whichItem newText newValue businessModel  =
    case whichList of
      1 -> {businessModel|item1 = Array.set whichItem {name=newText,value=newValue} businessModel.item1}
      2 -> {businessModel|item2 = Array.set whichItem {name=newText,value=newValue} businessModel.item2}
      3 -> {businessModel|item3 = Array.set whichItem {name=newText,value=newValue} businessModel.item3}
      _ -> businessModel

getList whichList businessModel =
    case whichList of
      1 -> businessModel.item1
      2 -> businessModel.item2
      3 -> businessModel.item3
      _ -> Array.empty
