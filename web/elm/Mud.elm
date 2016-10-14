module App exposing (..)

import Html exposing (Html, h1, text, button, input, form, ul, li, div)
import Html.Events exposing (onInput, onSubmit)
import Html.App

import Json.Encode as JsEncode
import Json.Decode as JsDecode exposing ( (:=) )

import Phoenix.Socket
import Phoenix.Channel
import Phoenix.Push

type alias Model =
    {
        socket : Phoenix.Socket.Socket Msg,
        input : String,
        logLines : List String
    }

init : ( Model, Cmd Msg )
init =
    let
        channel = Phoenix.Channel.init "room:lobby"
        (initSocket, command) =
            Phoenix.Socket.init "ws://localhost:4000/socket/websocket"
            |> Phoenix.Socket.withDebug
            |> Phoenix.Socket.on "shout" "room:lobby" ReceiveLogLine
            |> Phoenix.Socket.join channel
        model =
            {
              socket = initSocket,
              input = ""
            , logLines = [ ]
            }
    in
        ( model, Cmd.map PhoenixMsg command )

type Msg =
    PhoenixMsg (Phoenix.Socket.Msg Msg)
    | SetInput String
    | SendInput
    | ReceiveLogLine JsEncode.Value
    | HandleSendError JsEncode.Value

view : Model -> Html Msg
view model =
    let
        drawLogLines logLines =
            logLines |> List.map drawLogLine
    in
  div [] [
    ul [] (model.logLines |> drawLogLines),
    form [ onSubmit SendInput ] [
     input [ onInput SetInput ] [
     ],
     button [] [
       text "Submit"
     ]
    ]
  ]

drawLogLine : String -> Html Msg
drawLogLine logLine =
    li [] [
         text logLine
        ]

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    PhoenixMsg msg ->
      let
          ( socket, cmd ) = Phoenix.Socket.update msg model.socket
      in
          ( { model | socket = socket }
          , Cmd.map PhoenixMsg cmd
          )
    SetInput input ->
        ( { model | input = input }, Cmd.none)
    SendInput ->
      let
          payload =
              JsEncode.object
                  [
                   ("input", JsEncode.string model.input)
                  ]
          push =
              Phoenix.Push.init "shout" "room:lobby"
              |> Phoenix.Push.withPayload payload
              |> Phoenix.Push.onOk ReceiveLogLine
              |> Phoenix.Push.onError HandleSendError
          (socket, command) = Phoenix.Socket.push push model.socket
      in
          ( { model | socket = socket }, Cmd.map PhoenixMsg command )
    ReceiveLogLine raw ->
        let
            messageDecoder = "input" := JsDecode.string
            receivedLogLine = JsDecode.decodeValue messageDecoder raw
        in
            case receivedLogLine of
                Ok logLine -> ({ model | logLines = logLine :: model.logLines }, Cmd.none)
                Err error -> ({ model | logLines = "Failed to receive log line" :: model.logLines }, Cmd.none )
    HandleSendError _ ->
        let
            message = "Failed to send command"
        in
            ({model | logLines = message :: model.logLines }, Cmd.none)

subscriptions : Model -> Sub Msg
subscriptions model =
  Phoenix.Socket.listen model.socket PhoenixMsg

main : Program Never
main =
  Html.App.program
    {
      init = init,
      view = view,
      update = update,
      subscriptions = subscriptions
    }
