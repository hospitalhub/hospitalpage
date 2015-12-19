# features/

#language: pl
Aspekt: Strony
  Sprawdzamy strony:
  - nieistniejącą
  
  @javascript
  Scenariusz: Otwarcie nieistniejącej strony
    Zakładając, że otwieram na smartfonie
    I jestem na stronie "/wp/nieistniejaca-strona"
    Wtedy zobaczę tekst "Ojej! Brak strony..."

