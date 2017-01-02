module Search exposing
  ( search
  )

import Http

type alias Model =
  {     searching: Bool
  }

type SearchMsg
  = SearchText String
  | Search
  | NewSearchResults (Result.Result Http.Error String)

update : SearchMsg -> Model -> (Model, Cmd Msg)
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

search : (Result Http.Error String -> msg) -> String -> String -> Cmd msg
search cmd host text =
  let
    url =
      "http://" ++ host ++ "/mobile?num=9999999&search=" ++ text ++ "&sort=title&order=ascending"

    request =
      Http.getString url
  in
    Http.send cmd request