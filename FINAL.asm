ILE_CZASU EQU 45 ; 3 sekundy, 1 przerwanie = 0.065s, zatem co ok. 15 jednostek czasu - co ok. 15 przerwañ mija micro sekunda

org 0 ;zerowy adres, pierwsza instrukcja
	jmp start ; skok do etykiety start

org 0Bh ; przerwanie w momencie przepe³nienia timera 0 
	jmp action ;skok do etykiety action w razie przerwania

action:
	djnz R2, return_interrupt ; dekrementowanie rejestru R2 dopóki nieosi¹gnie wartoœci 0 i skok to etykiety return_interrupt
	mov TCON, #0h ; wy³¹czenie timera 0
	setb P1.0 ; zgaszenie diody
	mov R7, #1 ; przypisanie w rejestrze R7 wartoœci 1

return_interrupt: reti ; wyjœcie z przerwania

; KONFIGURACJA PROGRAMU (G£ÓWNA PÊTLA)
start: jb P2.0, $; "jump if bit set" czekanie na ruch, port P2.0 (przycisk 0)
jnb P2.0, $ ; sprawdzenie, czy przycisk jest wy³¹czony
mov R7, #0 ; wyczyszczenie rejestru siódmego
mov TMOD, #01h ; ustawienie 16-bit timera
mov IE, #82h ; w³¹czenie przerwania
mov TCON, #00010000 ; uruchomienie timera 0
mov R2, #ILE_CZASU ; przypisanie do rejestru 2 czas odliczania
clr P1.0 ; zapalenie œwiat³a (dioda port P1.0)
looping: cjne R7, #0, start ; sprawdzanie, czy rejestr R7 jest równy 0, w przeciwnym wypadku skok do startu
			 jmp looping ; skok do etykiety looping - pêtla sprawdzaj¹ca w³¹czenie/wy³¹czenie przycisku
end