module App.Types exposing (..)

import Data.User as User exposing (User, Username)
import Data.Session as Session exposing (Session)
import Page.Errored as Errored exposing (PageLoadError)
import Page.Home as Home


-- import Page.Login as Login
-- import Page.Register as Register

import Page.NotFound as NotFound
import Ports
import Route exposing (Route)
import Task
import Util exposing ((=>))


type Page
    = Blank
    | NotFound
    | Errored PageLoadError
    | Home Home.Model



-- | Login Login.Model
-- | Register Register.Model


type PageState
    = Loaded Page
    | TransitioningFrom Page



-- MODEL --


type alias Model =
    { session : Session
    , pageState : PageState
    }


type Msg
    = SetRoute (Maybe Route)
    | HomeLoaded (Result PageLoadError Home.Model)
    | HomeMsg Home.Msg
      -- | LoginMsg Login.Msg
      -- | RegisterMsg Register.Msg
    | SetUser (Maybe User)
