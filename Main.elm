import Html exposing (Html, button, div, input, text)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)

main =
  Html.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }


-- MODEL

type alias Model =
  { searchText : String
  }


init : (Model, Cmd Msg)
init =
  (Model "", Cmd.none)


-- UPDATE

type Msg
  = SearchText String
  | Search

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    SearchText text ->
      ({ model | searchText = text }, Cmd.none)
    Search ->
      (model, Cmd.none)


-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none


-- VIEW

view : Model -> Html Msg
view model =
  div []
    [ input [ placeholder "Search Text", onInput SearchText] []
    , button [ onClick Search ] [ text "search" ]
    , div [] [text ("Searching for... " ++ model.searchText)]
    ]