module RTTLSpec exposing (spec)

import Expect
import RTTL exposing (..)
import RTTL.Note exposing (..)
import RTTL.Pitch exposing (..)
import RTTL.Tone exposing (..)
import Test exposing (..)


spec : Test
spec =
    describe "RTTL"
        [ describe "parseComposer"
            [ test "parses Nokia Composer format" <|
                \_ ->
                    "32f2 32g2 32f2 16.#d2 32-"
                        |> parseComposer { tempo = 40 }
                        |> Expect.equal
                            (Ok
                                (Ringtone
                                    { tempo = 40
                                    , tones =
                                        [ Tone (Pitch F 6) (Normal ThirtySecond)
                                        , Tone (Pitch G 6) (Normal ThirtySecond)
                                        , Tone (Pitch F 6) (Normal ThirtySecond)
                                        , Tone (Pitch Eb 6) (Dotted Sixteenth)
                                        , Pause (Normal ThirtySecond)
                                        ]
                                    }
                                )
                            )
            ]
        ]
