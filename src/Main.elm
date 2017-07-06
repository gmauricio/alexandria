import Html exposing (Html, div, text, h1, ul, li, img, span, a, p, i)
import Html.Attributes exposing (class, src, href, placeholder)
import Html.Events exposing (onClick, onInput)
import Http
import SemanticUi exposing (..)
import RemoteData exposing (WebData)
import Json.Encode as Encode
import Json.Decode as Decode
import Json.Decode.Pipeline exposing (decode, required)

main : Program Never Model Msg
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
    results: WebData (List SearchResult),
    searching: Bool
  }


init : (Model, Cmd Msg)
init =
  (Model "" RemoteData.NotAsked False, Cmd.none)


-- UPDATE

type Msg
  = SearchText String
  | Search
  | NewSearchResults (WebData (List SearchResult))

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    SearchText text ->
      ({ model | searchText = text }, Cmd.none)
    Search ->
      ({ model | results = RemoteData.Loading, searching = True }, search model.searchText)
    NewSearchResults response ->
      ({ model | results = response, searching = False }, Cmd.none)


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
      [ col "sixteen" [ showResultList (model.results) ]
      ]
    ]


showResultList : WebData (List SearchResult) -> Html Msg
showResultList response =
  case response of
    RemoteData.NotAsked ->
      text ""

    RemoteData.Loading ->
      text "Loading..."

    RemoteData.Success list ->
      items (List.map (\result -> showResult result ) list)

    RemoteData.Failure error ->
      text (toString error)


showResult : SearchResult -> Html Msg
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


search : String -> Cmd Msg
search text =
  let
    url =
      "http://localhost:8000/search"
    searchRequest =
      Encode.object [ ("text", Encode.string text) ]
  in
    Http.post url (Http.jsonBody searchRequest) searchResultsDecoder
      |> RemoteData.sendRequest
      |> Cmd.map NewSearchResults


type alias SearchRequest =
  { text: String
  }

type alias SearchResult =
  {
    host: String
  , title: String
  , description: String
  , urls: List String
  , thumbUrl: String
  }

searchResultsDecoder : Decode.Decoder (List SearchResult)
searchResultsDecoder =
  Decode.list searchResultDecoder

searchResultDecoder : Decode.Decoder SearchResult
searchResultDecoder =
  decode SearchResult
    |> required "host" Decode.string
    |> required "title" Decode.string
    |> required "description" Decode.string
    |> required "urls" (Decode.list Decode.string)
    |> required "thumbUrl" Decode.string