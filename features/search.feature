# features/search.feature

#language: pl
Aspekt: Search
  In order to see a word definition
  As a website user
  I need to be able to search for a word

#  @javascript
  Scenariusz: Searching for a page that does exist
    Zakładając, że jestem na stronie "/wiki/Main_Page"
    Gdy wypełnię pole "search" wartością "Behavior Driven Development"
    Oraz nacisnę przycisk "searchButton"
    Wtedy zobaczę tekst "agile software development"

  Scenariusz: Searching for a page that does NOT exist
    Zakładając, że jestem na stronie "/wiki/Main_Page"
    Kiedy wypełnię pole "search" wartością "Glory Driven Development"
    Oraz nacisnę przycisk "searchButton"
    Wtedy zobaczę tekst "results"

