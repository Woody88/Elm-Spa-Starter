module Route exposing (Route(..), fromLocation, href, modifyUrl)

import Html exposing (Attribute)
import Html.Attributes as Attr
import Navigation exposing (Location)
import UrlParser as Url exposing ((</>), Parser, oneOf, parseHash, s, string)


-- ROUTING --


type Route
    = Home



-- | Login
-- | Logout
-- | Register


route : Parser (Route -> a) a
route =
    oneOf
        [ Url.map Home (s "")

        -- , Url.map Login (s "login")
        -- , Url.map Logout (s "logout")
        -- , Url.map Register (s "register")
        ]


routeToString : Route -> String
routeToString page =
    let
        path =
            case page of
                Home ->
                    []

        -- Login ->
        --     [ "login" ]
        --
        -- Logout ->
        --     [ "logout" ]
        --
        -- Register ->
        --     [ "register" ]
    in
        "#/" ++ String.join "/" path



-- PUBLIC HELPERS --


href : Route -> Attribute msg
href route =
    Attr.href (routeToString route)


modifyUrl : Route -> Cmd msg
modifyUrl =
    routeToString >> Navigation.modifyUrl



-- parse the hash variable from Navigation.Location data using the
-- route 'parser' and the parseHash function from UrlParser


fromLocation : Location -> Maybe Route
fromLocation location =
    if String.isEmpty location.hash then
        Just Home
    else
        parseHash route location
