#!/bin/bash

# sprawdzenie uprawnien
if [ $EUID -ne 0 ]; then
	echo "Blad: Uruchom skrypt z uprawnieniami root(sudo)!"
	exit 1
fi

# weryfikacja pliku wejsciowego

if [ ! -f "nowi_pracownicy.txt" ]; then
	echo "Plik nowi_pracownicy.txt nie istnieje!"
	exit 1
fi

# wczytanie pliku i dodanie pracownikow

while IFS="," read -r login dzial
do
	if ! getent group "$dzial" > /dev/null 2>&1; then
		groupadd "$dzial" 
	fi
	useradd -m -g "$dzial" -s /bin/bash "$login"
	haslo="tajnehaslo"
	echo "$login:$haslo" | chpasswd
	echo "[OK] Stworzono uzytkownika $login w grupie $dzial"
done < "nowi_pracownicy.txt"

