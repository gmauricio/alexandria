module HtmlElements exposing
  ( render
  , Element
  , div
  , attr, class
  )

import Html exposing (Html, Attribute)
import Html as H
import Html.Attributes as A

type alias Element msg =
  { f : List (Attribute msg) -> List (Html msg) -> Html msg
  , attrs : List (Attribute msg)
  , content : List (Html msg)
  }

render : Element msg -> Html msg
render element =
    element.f element.attrs element.content

div : List (Attribute msg) -> List (Html msg) -> Element msg
div = Element H.div

class : String -> Element msg -> Element msg
class = attr A.class

attr : (v -> Html.Attribute msg) -> v -> Element msg -> Element msg
attr a value element = { element | attrs = element.attrs ++ [a value] }