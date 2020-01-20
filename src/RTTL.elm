module RTTL exposing (Ringtone)

import RTTL.Note exposing (Note(..))
import RTTL.Pitch exposing (Pitch(..))
import RTTL.Tone exposing (Duration(..), DurationLength(..), Tone(..))


type BPM
    = BPM Int


type Ringtone
    = Ringtone
        { tempo : BPM
        , tones : List Tone
        }


example : Ringtone
example =
    Ringtone
        { tempo = BPM 120
        , tones =
            [ Tone (Pitch A 3) (Normal Whole)
            , Pause (Normal Half)
            ]
        }
