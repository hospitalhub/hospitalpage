# features/

#language: pl
Aspekt: Logowanie
  Sprawdzamy stronę i logowanie do kokpitu 
  
  @javascript
  Szablon scenariusza: zawartość po zalogowaniu
    Zakładając, że jestem na stronie "/wp/wp-admin/"
    I otwieram na tablecie
    Kiedy wypełnię pole "user_login" wartością "root"
    Oraz wypełnię pole "user_pass" wartością "pass"
    Oraz nacisnę przycisk "Zaloguj się"
    Oraz kliknę na link "<link>"
    Wtedy zobaczę tekst "<tekst>"
    
  Przykłady:
   | link               | tekst                   |
   | Kokpit             | Witaj                   |
   | Accessible Poetry | Welcome to Accessible Poetry |