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
  | NewSearchResults String (Result.Result Http.Error String)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    SearchText text ->
      ({ model | searchText = text }, Cmd.none)
    Search ->
      ({ model | searching = True, results = [] }, searchEverywhere model.searchText)
    NewSearchResults host (Ok html) ->
      ({ model | results = model.results ++ parse host html, searching = False }, Cmd.none)
    NewSearchResults host (Err _) ->
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
    thumbUrl = "http://" ++ result.host ++ result.thumbUrl
    urls = List.map (\url -> "http://" ++ result.host ++ url) result.urls
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


searchEverywhere : String -> Cmd Msg
searchEverywhere text = Cmd.batch (List.map (search text) hosts)

search : String -> String -> Cmd Msg
search text host =
  let
    url =
      "http://" ++ host ++ "/mobile?num=9999999&search=" ++ text ++ "&sort=title&order=ascending"

    request =
      Http.getString url
  in
    Http.send (NewSearchResults host) request


hosts : List String
hosts =
  [
    "72.191.219.159",
    "23.94.123.28:8080",
    "24.28.154.227:8080",
    "211.181.142.155",
    "24.60.64.82:8080",
    "24.60.64.82:8080",
    "24.117.20.91",
    "24.117.20.91",
    "24.14.243.46:8080",
    "24.183.188.250:8081",
    "41.86.178.42:8080",
    "50.66.185.122:8000",
    "50.88.7.19",
    "50.170.111.245:8080",
    "50.186.64.134",
    "52.43.215.155",
    "52.64.177.67",
    "69.69.164.139:8888",
    "70.70.158.63",
    "71.90.204.102",
    "73.164.30.34:8080",
    "74.129.250.46:8888",
    "75.19.8.28:8080",
    "96.51.188.58:8080",
    "98.214.170.70",
    "98.232.181.142:8787",
    "104.50.8.212:8080",
    "107.170.128.62:8080",
    "108.63.56.243:9080",
    "118.208.243.87/category/allbooks",
    "119.236.134.86",
    "137.74.112.209",
    "217.35.162.117/",
    "173.48.114.20:8000",
    "173.94.108.253",
    "ebooks.wsd.net:8080",
    "184.100.235.173:8080",
    "198.199.7.10",
    "traviata.dyndns.org:2208",
    "203.160.127.78:8080"
  ]