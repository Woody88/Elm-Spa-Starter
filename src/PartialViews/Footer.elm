module PartialViews.Footer exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)


pageFooter =
    footer [ class "footer" ]
        [ div [ class "container" ]
            [ div [ class "content has-text-centered" ]
                [ p []
                    [ strong []
                        [ text "Bulma" ]
                    , text "by "
                    , a [ href "http://jgthms.com" ]
                        [ text "Jeremy Thomas" ]
                    , text ". The source code is licensed        "
                    , a [ href "http://opensource.org/licenses/mit-license.php" ]
                        [ text "MIT" ]
                    , text ". The website content        is licensed "
                    , a [ href "http://creativecommons.org/licenses/by-nc-sa/4.0/" ]
                        [ text "CC BY NC SA 4.0" ]
                    , text ".      "
                    ]
                ]
            ]
        ]
