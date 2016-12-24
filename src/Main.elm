import Html exposing (Html, div, text, h1, ul, li, img, span, a, p, i)
import Html.Attributes exposing (class, src, href, placeholder)
import Html.Events exposing (onClick, onInput)
import Http
import SemanticUi exposing (..)
import HtmlResultParser exposing (..)

main =
  Html.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }


-- MODEL

type alias Model =
  { searchText : String,
    results: List HtmlResultParser.Result,
    searching: Bool
  }


init : (Model, Cmd Msg)
init =
  (Model "" [] False, Cmd.none)


-- UPDATE

type Msg
  = SearchText String
  | Search
  | NewSearchResults (Result.Result Http.Error String)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    SearchText text ->
      ({ model | searchText = text }, Cmd.none)
    Search ->
      ({ model | searching = True }, search model.searchText)
    NewSearchResults (Ok html) ->
      ({ model | results = parse html, searching = False }, Cmd.none)
    NewSearchResults (Err _) ->
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
        [ row
            [ col "twelve"
                [ input [ placeholder "search...", onInput SearchText ]
                    |> fluid
                    |> render
                ]
            , col "four"
                [  button ("search" ++ if model.searching then " ..." else "")
                    |> attr onClick Search
                    |> render
                ]
            ]
        ]
    , container
      [ col "sixteen" [ showResultList model.results ]
      ]
    ]


showResultList : List HtmlResultParser.Result -> Html Msg
showResultList list =
  items (List.map (\result -> showResult result ) list)


showResult : HtmlResultParser.Result -> Html Msg
showResult result =
  let
    thumbUrl = "http://72.191.219.159" ++ result.thumbUrl
    urls = List.map (\url -> "http://72.191.219.159" ++ url) result.urls
    actions =
      urls
        |> List.map
          (
            \url ->
              a [ class "ui right floated primary button", href url ]
                [ text (parseExtension url)
                ]
          )
  in
    item (itemImg thumbUrl) (itemContent result.title "" result.description actions)

parseExtension : String -> String
parseExtension url =
  let
    ext = url
      |> String.split "."
      |> List.reverse
      |> List.head
  in
    case ext of
      Just e -> e
      Nothing -> ""


search : String -> Cmd Msg
search text =
  let
    url =
      "http://72.191.219.159/mobile?num=9999999&search=" ++ text ++ "&sort=title&order=ascending"

    request =
      Http.getString url
  in
    Http.send NewSearchResults request
