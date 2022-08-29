#include <AutoItConstants.au3>
#include <MsgBoxConstants.au3>
#include <Json.au3>

Global Const $HTTP_STATUS_OK = 200

AutomatingVRSetup()


Func AutomatingVRSetup()
   $sonoffturnon = "your turn on request here: http://ip/switch/sonoff-relay/turn_on"
   $sonoffturnoff = "your turn off request here: http://ip/switch/sonoff-relay/turn_off"

        While 1
		   If ProcessExists("vrmonitor.exe") Then
			    $iPID = Run("path to your exe file", @SystemDir, @SW_HIDE, BitOR($STDERR_CHILD, $STDOUT_CHILD))
			    $sOutput = ""
			    Sleep(500)
                	    $sOutput = StdoutRead($iPID)
				$Obj = Json_Decode($sOutput)
				$HMD = Json_Get($Obj, '["HMD"]' )
				$BaseStation = Json_Get($Obj, '["Base Stations"]' )
				$Controller = Json_Get($Obj, '["Controller"]' )
				ConsoleWrite($sOutput & @CRLF)

				If ($BaseStation < 1) Then
				   HttpPost($sonoffturnoff )
				   Sleep(1000)
				   HttpPost($sonoffturnon )
				   Sleep(1000)
			    EndIf

                If @error Then ; Exit the loop if the process closes or StdoutRead returns an error.
                        ExitLoop
                EndIf

			EndIf

			Sleep(15000)

        WEnd

EndFunc   



Func HttpPost($sURL)
    Local $oHTTP = ObjCreate("WinHttp.WinHttpRequest.5.1")

    $oHTTP.Open("POST", $sURL, False)
    If (@error) Then Return SetError(1, 0, 0)

    $oHTTP.SetRequestHeader("Accept", "*/*")
	$oHTTP.SetRequestHeader("Accept-Language", "de-DE,de;q=0.9,en-US;q=0.8,en;q=0.7")
    	$oHTTP.SetRequestHeader("Cache-Control", "no-cache")
	$oHTTP.SetRequestHeader("Connection", "keep-alive")
	$oHTTP.SetRequestHeader("Content-Type", "text/plain;charset=UTF-8")
	$oHTTP.SetRequestHeader("DNT", "1")
	$oHTTP.SetRequestHeader("Origin", "you should replace these values with yours")
	$oHTTP.SetRequestHeader("Pragma", "no-cache")
	$oHTTP.SetRequestHeader("Referer", "you should replace these values with yours")
	$oHTTP.SetRequestHeader("User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.0.0 Safari/537.36")

    $oHTTP.Send()
    If (@error) Then Return SetError(2, 0, 0)

    If ($oHTTP.Status <> $HTTP_STATUS_OK) Then Return SetError(3, 0, 0)

    Return SetError(0, 0, $oHTTP.ResponseText)
 EndFunc

