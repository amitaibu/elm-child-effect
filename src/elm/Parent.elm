module Parent where

import Child exposing (..)
import Effects exposing (Effects)
import Html exposing (..)
import Html.Attributes exposing (style)
import Html.Events exposing (onClick)
import Task exposing (..)


-- MODEL

type alias Model =
  { counter: Int
  , childModel : Child.Model
  }

initialModel : Model
initialModel =
  Model 0 Child.initialModel

init : (Model, Effects Action)
init =
  ( initialModel
  , Effects.none
  )


-- UPDATE

type Action
  = Increment
  | Decrement
  | ChildAction Child.Action

update : Action -> Model -> (Model, Effects Action)
update action model =
  case action of
    Increment ->
      ( { model | counter <- model.counter + 1 }
      , Effects.none
      )
    Decrement ->
      ( { model | counter <- model.counter + 1 }
      , Effects.none
      )

    ChildAction act ->
      let
        childContext =
          Task.succeed Increment

        (childModel, childEffects) = Child.update childContext act model.childModel
      in
        ( model
        , Effects.map ChildAction childEffects
        )


-- VIEW

view : Signal.Address Action -> Model -> Html
view address model =
  let
    childAddress =
        Signal.forwardTo address ChildAction

    childContext =
      Task.succeed Increment

  in

  div []
    [ h2 [] [ text "Parent model" ]
    , div [] [ text (toString model) ]
    , h2 [] [ text "Child model controls parent" ]
    , div [] [ Child.view childAddress model.childModel ]
    ]
