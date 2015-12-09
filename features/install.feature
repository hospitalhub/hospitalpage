# features/search.feature

#language: pl
Aspekt: Instalacja
  Aby mieć pewność poprawnej instalacji 
  sprawdzamy stronę i logowanie do kokpitu 
  

  @javascript
  Scenariusz: Otwarcie nieistniejącej strony
    Zakładając, że jestem na stronie "/wp/qwezxc"
    Wtedy zobaczę tekst "Ojej! Brak strony..."

  @javascript
  Szablon scenariusza: zawartość po zalogowaniu
    Zakładając, że jestem na stronie "/wp/wp-admin/"
    Kiedy wypełnię pole "user_login" wartością "root"
    Oraz wypełnię pole "user_pass" wartością "pass"
    Oraz nacisnę przycisk "Zaloguj się"
    Oraz kliknę na link "<link>"
    Wtedy zobaczę tekst "<tekst>"
    
  Przykłady:
   | link               | tekst                   |
   | Kokpit             | Witaj                   |
   | Wtyczki            | epidemio                |
   | Wtyczki            | punction                |
   | Epidemiologia      | Raport Epidemiologiczny |
   | test               | error					  |
   
