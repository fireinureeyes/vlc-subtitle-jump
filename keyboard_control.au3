#cs ----------------------------------
Author: Abdelrahman Hafez
GitHub: https://github.com/AbdalrahmanHafez
#ce ----------------------------------

HotKeySet("{HOME}", jump_prev)
HotKeySet("{END}", jump_next)

While(True)
    Sleep(200)
WEnd

Func jump_next()
	ConsoleWrite("Jumping Next" & @CRLF)
	click_button(1)
EndFunc

Func jump_prev()
	ConsoleWrite("Jumping Previous" & @CRLF)
	click_button(0)
EndFunc

Func click_button($type)
	Local $hwnd = WinGetHandle("[TITLE:Jump subtitle]")
	if(@error) Then
		MsgBox(0, "Error", "Window 'Jump subtitle' not found")
		Return
	EndIf
	
    Local $x = ($type = 0)? 30 : 170
    Local $y = 50
    
    ConsoleWrite("$hwnd = " & $hwnd & @CRLF)

    ControlClick($hwnd, "", "", "left", 1, $x, $y)
EndFunc