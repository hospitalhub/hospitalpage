<?php

class TestActions extends IntegrationTest
{

    /**
	 *
	 * @var unknown
	 */
    const PACJENT_MENU = 'a[href^="edit.php?post_type=pacjent"]';

    /**
	 *
	 * @var unknown
	 */
    const NOWY_MENU = 'a[href^="post-new.php?post_type=pacjent"]';

    /**
	 *
	 * @var unknown
	 */
    const ADMINBAR = 'wpadminbar';

    /**
	 *
	 * @var unknown
	 */
    const USERNAME = 'reumatologia';

    /**
	 *
	 * @var unknown
	 */
    const NEW_PASSWORD = 'reumatologia';

    /**
	 *
	 * @var unknown
	 */
    const LOGIN_URL = '/wp-admin/edit.php?post_type=pacjent&page=moi-pacjenci';

    /**
	 *
	 * @var unknown
	 */
    const HIDE_BODY = '&hidewpbody-content';

    /**
	 *
	 * @var unknown
	 */
    const PROFILE_BAR_LINK = 'a-wp-admin-bar-my-account';

    /**
	 *
	 * @var unknown
	 */
    const LOGOUT_LINK_ID = 'a-wp-admin-bar-logout';

    /**
	 *
	 * @var unknown
	 */
    const PROFILE_LINK_ID = 'a-wp-admin-bar-user-info';

    /**
	 *
	 * @var unknown
	 */
    const LOGIN_INPUT = 'user_login';

    /**
	 *
	 * @var unknown
	 */
    const PASS_INPUT = 'user_pass';

    /**
	 *
	 * @var unknown
	 */
    const CHANGEPASS1_ID = 'pass1';

    /**
	 *
	 * @var unknown
	 */
    const CHANGEPASS2_ID = 'pass2';

    /**
	 *
	 * @var unknown
	 */
    const LOGIN_FORM = 'loginform';

    /**
	 *
	 * @var unknown
	 */
    const PROFILE_FORM = 'your-profile';

    /**
	 *
	 * @param unknown $user        	
	 */
    private function loginType($user, $url = self::LOGIN_URL)
    {
        self::go($url);
        self::set(self::LOGIN_INPUT, $user);
        self::set(self::PASS_INPUT, self::NEW_PASSWORD);
    }

    private function changePassType($pass)
    {
        self::set(self::CHANGEPASS1_ID, $pass);
        self::set(self::CHANGEPASS2_ID, $pass);
    }

    /**
	 */
    function loginSubmit()
    {
	usleep(100000);
        self::submitForm(self::LOGIN_FORM);
    }

    /**
	 * @title Logowanie do programu
	 */
    function testLogin()
    {
        self::img('browsers.png', 'Przeglądarki', 'Otwórz swoją ulubioną przeglądarkę i wpisz adres strony.');
        self::img('noie.png', 'IE', 'Ikona "kategoryzacja pielęgniarska" znajduję sie na "zawartości". <br>Można ją skopiować na pulpit.');
        self::loginType(self::USERNAME);
        self::movemouse(self::LOGIN_INPUT);
        self::screenshot('Logowanie', 'Wpisz nazwę użytkownika i hasło. Kliknij przycisk.');
        self::loginSubmit();
        self::assertExists(self::ADMINBAR, 25);
        self::assertNotExists(self::NOWY_MENU, 0);
        self::assertNotExists(self::PACJENT_MENU, 0);
        self::screenshot('Logowanie', 'Ciesz się programem.');
        self::notice("Uwaga!: Pamiętaj by ustawić bezpieczne hasło dostępu.<br/>Zmieniaj hasła nie rzadziej niż raz na dekadę ;)");
    }

    /**
	 * @title Wylogowanie z programu
	 */
    function testLogout()
    {
        $url = self::LOGIN_URL . self::HIDE_BODY . '&important' . self::LOGOUT_LINK_ID;
        self::loginType(self::USERNAME, $url);
        self::loginSubmit();
        self::movemouse(self::PROFILE_BAR_LINK);
        self::assertExists(self::LOGOUT_LINK_ID, 25, true);
        self::movemouse(self::LOGOUT_LINK_ID);
        self::screenshot('Wylogowanie', 'Najedź na menu w prawym górnym rogu ekranu. <br/>Kliknij w odpowiednią opcję.');
        self::clickam(self::LOGOUT_LINK_ID);
        self::assertExists(self::PASS_INPUT, 2);
        self::screenshot('Wylogowanie', 'Pojawi się informacja o wylogowaniu.');
    }

    /**
	 * @title Zmiana hasła
	 */
    function testPassChange()
    {
        $url = self::LOGIN_URL . self::HIDE_BODY . '&important' . self::PROFILE_LINK_ID;
        self::loginType(self::USERNAME, $url);
        self::loginSubmit();
        self::movemouse(self::PROFILE_BAR_LINK);
        self::assertExists(self::PROFILE_LINK_ID, 25, true);
        self::movemouse(self::PROFILE_LINK_ID);
        self::screenshot('Wylogowanie', 'Najedź na menu w prawym górnym rogu ekranu. <br/>Kliknij profil.');
        self::clickam(self::PROFILE_LINK_ID);
        self::changePassType(self::NEW_PASSWORD);
        self::img('pass.png', 'Zmiana hasła', 'Przejdź niżej do pól zmiany hasła. <br/>Wpisz hasło dwukrotnie w odpowiednie pola. <br/> Pojawi się informacja o zmianie.');
    }

    /**
	 * @title Lista pacjentów
	 */
    function testCategorization()
    {
        self::loginType(self::USERNAME);
        self::loginSubmit();
        // // Po kategoriach można także poruszać się używając "kółka" na myszce (jeżeli takie jest dostępne).
        $msg = 'Nawigacja po tabeli odbywa się poprzez przesuwanie paska po prawej stronie lub przy użyciu "kółka" na myszce.<br/>';
        self::screenshot('nav', $msg);
        $msg = 'Filtr pacjentów: (na górnym pasku)<br/>';
        $msg .= '- Wszyscy - wszyscy pacjenci na oddziale w danym dniu.<br/>';
        $msg .= '- Do kategoryzacji - wyświetla wyłącznie pacjentów jeszcze nie skategoryzowanych.<br/>';
        $msg .= 'Wyszukiwanie:<br/>';
        $msg .= 'Pole szukaj (na górnym pasku) umożliwia szybkie wyszukiwanie po nazwisku, peselu czy numerze historii.<br/>';
        self::img('btn.png', 'btn', $msg);
        $msg = 'Wybór daty: (prawy górny róg)<br/>';
        $msg .= '- Dzisiaj<br/>';
        $msg .= '- Wczoraj<br/>';
        $msg .= '- Tydzień - wyświetla pacjentów z całego tygodnia wraz z datami kategoryzacji.<br/>';
        self::img('date.png', 'date', $msg);
        $msg = 'Sortowanie:<br/>';
        $msg .= 'Po kliknięciu na tytule w nagłówku tabeli (np. na "Nazwisko i Imię", "PESEL", "Kategoria") możemy posortować całą tabelę po danym polu.<br/>';
        self::img('head.png', 'h', $msg);
        $kategoria = 'Otwarcie formularza odbywa się przez kliknięcie na pacjencie w tabeli.';
        self::img('patient.png', 'Patient', $kategoria);
    }
    
    // TODO(AM) informacja: Wygodnym sposobem poruszania się po formularzu
    /**
     * @title Pacjent: Kategoryzacja
     */
    function testPatientsList()
    {
        $kategoria = 'Nawigacja po formularzu podobnie jak w przypadku tabeli może odbywać się';
        $kategoria .= 'przy użyciu "kółka" myszy lub przesuwania prawego paska. Kategorię ';
        $kategoria .= 'ustawiamy klikając na treści.<br/>';
        self::img('patient.png', 'Patient', $kategoria);
        $kategoria = 'Po wypełnieniu całego formularza kliknij na "Zapisz".';
        $kategoria .= 'Nad przyciskiem "Zapisz" znajduje się informacja o ilości kat. 1,2,3 i wyliczonej kategorii pacjenta.';
        $kategoria .= 'Sprawdź czy kategorie zostały odwzorowane w tabeli.';
        self::img('save.png', 'save', $kategoria);
    }
    // TODO(am) test na 0 patients -> czy wyswietla tabele prawidlowo i czy napis "brak danych" wewnatrz $("td.dataTables_empty") DLA KAZDEGO TYPU (ZZ ped psy...)
}
?>
