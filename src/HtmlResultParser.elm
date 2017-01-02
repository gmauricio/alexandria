module HtmlResultParser exposing
  ( parse
  , Result
  )

import HtmlParser
import HtmlParser.Util exposing (..)

type alias Result =
  { host: String
  , title: String
  , description: String
  , urls: List String
  , thumbUrl: String
  }


parse : String -> String -> List Result
parse host html =
  HtmlParser.parse html
    |> getElementById "listing"
    |> getElementsByTagName "tr"
    |> getResults host


getResults : String -> List HtmlParser.Node -> List Result
getResults host listing =
  listing
    |> mapElements
      (\_ _ tr -> getResult host tr)


getResult : String -> List HtmlParser.Node -> Result
getResult host node =
  let
    title = getTitle node
    description = getDescription node
    urls = getUrls node
    thumbUrl = getThumbUrl node
  in
    Result host title description urls thumbUrl


getUrls : List HtmlParser.Node -> List String
getUrls node =
  node
    |> getElementsByTagName "a"
    |> mapElements
      (\_ attrs _ ->
        case (getValue "href" attrs) of
          Just url -> url
          Nothing -> ""
      )


getTitle : List HtmlParser.Node -> String
getTitle node =
  node
    |> getElementsByClassName ["first-line"]
    |> textContent


getDescription : List HtmlParser.Node -> String
getDescription node =
  node
    |> getElementsByClassName ["second-line"]
    |> textContent


getThumbUrl : List HtmlParser.Node -> String
getThumbUrl node =
  let
    urls = node
      |> getElementsByTagName "img"
      |> mapElements
        (\_ attrs _ ->
          case (getValue "src" attrs) of
            Just url -> url
            Nothing -> ""
        )
  in
    case List.head urls of
      Just url -> url
      Nothing -> ""
