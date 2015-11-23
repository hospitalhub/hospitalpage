# features/search.feature

#language: pl
Aspekt: Search
  In order to see a word definition
  As a website user
  I need to be able to search for a word

#  @javascript
  Scenariusz: Searching for a page that does exist
    Zakładając, że jestem na stronie "/wp/x"
    #Gdy wypełnię pole "search" wartością "sample"
    #Oraz nacisnę przycisk "searchButton"
    Wtedy zobaczę tekst "Oops!"

  Scenariusz: Searching for a page that does NOT exist
    Zakładając, że jestem na stronie "/wp/wp-admin/"
    Kiedy wypełnię pole "user_login" wartością "root"
    Oraz wypełnię pole "user_pass" wartością "pass"
    Oraz nacisnę przycisk "Zaloguj się"
    Wtedy zobaczę tekst "Kokpit"

