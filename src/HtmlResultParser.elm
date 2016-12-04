module HtmlResultParser exposing
  ( parse
  , Result
  )

import HtmlParser
import HtmlParser.Util exposing (..)

type alias Result =
  { title: String
  , description: String
  , urls: List String
  , thumbUrl: String
  }


parse : String -> List Result
parse html =
  HtmlParser.parse html
    |> getElementById "listing"
    |> getElementsByTagName "tr"
    |> getResults


getResults : List HtmlParser.Node -> List Result
getResults listing =
  listing
    |> mapElements
      (\_ _ tr -> getResult tr)


getResult : List HtmlParser.Node -> Result
getResult node =
  let
    title = getTitle node
    description = getDescription node
    urls = getUrls node
    thumbUrl = getThumbUrl node
  in
    Result title description urls thumbUrl


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


-- http://72.191.219.159/mobile?num=25&search=cyber&sort=title&order=ascending