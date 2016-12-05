module SemanticUi exposing
  ( render, attr
  , container, row, col
  , button, input
  , size, fluid
  , Size(..)
  , items
  , item
  , itemImg
  , itemContent
  )

{-| Elm bindings for Semantic UI using a declarative API and useful
abstractions.

# Rendering

@docs render

# Styling

@docs Size, size, fluid, placeholder

# Events

@docs events

# Elements

## Grid

@docs container, row, col

## Button

@docs button

## Input

@docs input

-}

import Html exposing (Html, Attribute)
import Html as H
import Html.Attributes as A
import HtmlElements exposing (..)

{-| Create the `Html msg` for a Semantic UI `Element`.

    button "click" |> render
-}
render = HtmlElements.render
attr = HtmlElements.attr

{--
update : (a -> a) -> Element a msg -> Element a msg
update f element = { element | state = f element.state }
--}

{-| Create the `Html msg` for a grid container.

    container [html content]
-}
container : List (Html msg) -> Html msg
container content = div [ A.class "ui grid container"] content |> render

{-| Create the `Html msg` for a grid row.

    row [] [ div [] [] ]
-}
row : List (Html msg) -> Html msg
row = H.div [ A.class "row" ]

{-| Create the `Html msg` for a grid col.

    col "two" [ div [] [] ]
-}
col : String -> List (Html msg) -> Html msg
col n = H.div [ A.class (n ++ " wide column") ]

{-| Some elements might have different sizes. -}
type Size
  = Mini
  | Tiny
  | Small
  | Medium
  | Large
  | Big
  | Huge
  | Massive


{-| Adjust the size of an element.

    button "click" |> size Huge
 -}
size : Size -> Element msg -> Element msg
size size = class (sizeToString size)

{-| Add fluid class to input element

    input [] |> fluid
-}
fluid : Element msg -> Element msg
fluid = class "fluid"

sizeToString : Size -> String
sizeToString size =
  case size of
    Mini -> "mini"
    Tiny -> "tiny"
    Small -> "small"
    Medium -> "medium"
    Large -> "large"
    Big -> "big"
    Huge -> "huge"
    Massive -> "massive"

{-| A button with a text. -}
button : String -> Element msg
button text = Element H.button [ A.class "ui button" ] [ H.text text ]

{-| An input with a html attributes -}
input : List (Attribute msg) -> Element msg
input attrs =
  let
    el = \attrs _ ->
      H.div [ A.class "ui icon input" ] [ H.input attrs [] ]
  in
    Element el attrs []


items : List (Html msg) -> Html msg
items content =
  H.div [ A.class "ui divided items" ] content

item : Html msg -> Html msg -> Html msg
item img content =
  H.div [ A.class "item" ]
    [ img
    , content
    ]

itemImg : String -> Html msg
itemImg imgSrc =
  H.div [ A.class "ui tiny image" ]
    [ H.img [ A.src imgSrc ] []
    ]

itemContent header meta description extra =
  H.div [ A.class "content" ]
    [ H.a [ A.class "header" ] [ H.text header ]
    , H.div [ A.class "meta" ] [ H.span [] [ H.text meta ] ]
    , H.div [ A.class "description" ] [ H.p [] [ H.text description ] ]
    , H.div [ A.class "extra" ] extra
    ]
