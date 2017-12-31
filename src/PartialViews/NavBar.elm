module PartialViews.NavBar exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)


navbar =
    nav [ class "level is-size-5 has-text-centered" ]
        [ p [ class "level-item has-text-centered" ]
            [ a [ class "link is-info" ]
                [ text "About" ]
            ]
        , p [ class "level-item has-text-centered" ]
            [ a [ class "link is-info" ]
                [ text "Catalog" ]
            ]
        , p [ class "level-item has-text-centered" ]
            [ img [ alt "Bulma: a modern CSS framework based on Flexbox", attribute "height" "28", src "https://bulma.io/images/bulma-logo.png", attribute "width" "112" ]
                []
            ]
        , p [ class "level-item has-text-centered" ]
            [ a [ class "link is-info" ]
                [ text "Cart" ]
            , span [ class "icon has-text-info" ]
                [ i [ class "fa fa-info-circle" ]
                    []
                ]
            ]
        , p [ class "level-item has-text-centered" ]
            [ a [ class "link is-info" ]
                [ text "Contact" ]
            ]
        ]
