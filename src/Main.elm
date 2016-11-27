import Html exposing (Html, div, text, h1)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick, onInput)
import SemanticUi exposing (..)

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
    [ h1 [ class "ui center aligned header" ] [ text "The Libary of Babel" ]
    , container
        [ row []
            [ col "twelve"
                [ input []
                    |> placeholder "search..."
                    |> events [ onInput SearchText]
                    |> fluid
                    |> render
                ]
            , col "four"
                [  button "search"
                    |> size Huge
                    |> events [onClick Search]
                    |> render
                ]
            ]
        , div [] [text ("Searching for... " ++ model.searchText)]
        ]
    ]