<?php
class IntegrationTest extends PHPUnit_Extensions_Selenium2TestCase {
	
	/**
	 *
	 * @var unknown
	 */
	const URL = 'http://127.0.0.1/wp';
	// chrome firefox phantomjs // playonlinux: safari opera
	/**
	 *
	 * @var unknown
	 */
	const BROWSER = "phantomjs"; // "phantomjs";
	
	/**
	 *
	 * @var unknown
	 */
	var $i = 0;
	
	/**
	 *
	 * @var unknown
	 */
	static $doc;
	
	/**
	 *
	 * @var unknown
	 */
	static $sleep = 2;
	
	/**
	 * FIXED https://github.com/giorgiosironi/phpunit-selenium/issues/261
	 *
	 * "Unable to set Cookie: no URL has been loaded yet"
	 * 
	 * @return unknown
	 */
	public function prepareSession() {
		$res = parent::prepareSession ();
		$res->cookie()->remove('PHPUNIT_SELENIUM_TEST_ID');
		$this->url ( '/' );
		return $res;
	}
	
	/*
	 * (non-PHPdoc)
	 * @see PHPUnit_Framework_TestCase::setUp()
	 */
	protected function setUp() {
		global $argv;
		$browser = self::BROWSER;
		switch ($browser) {
			case 'phantomjs' :
				self::$sleep = 0;
				break;
		}
		$this->setBrowser ( $browser );
		$this->setBrowserUrl ( self::URL );
		$this->screenshotPath = __DIR__;
		self::$doc = new DocumentTemplate ();
		self::$doc->addChapter ( self::getTitleFromAnnotation () );
	}
	/*
	 * (non-PHPdoc)
	 * @see PHPUnit_Framework_TestCase::tearDown()
	 */
	protected function tearDown() {
	}
	
	/**
	 *
	 * @return Ambigous <multitype:, multitype:multitype: >|string
	 */
	private function getTitleFromAnnotation() {
		try {
			return $this->getAnnotations ()['method']['title'][0];
		} catch ( Exception $e ) {
			return "missing @title annotation: " . $this->getName ();
		}
	}
	
	/**
	 *
	 * @param unknown $file        	
	 * @param string $title        	
	 * @param string $description        	
	 */
	function img($file, $title = 'tytuł', $description = 'opis') {
		$imgSrcFilePath = __DIR__ . '/../resources/img/' . $file;
		$imgFilename = (++ $this->i) . '_' . date ( 'YmdHis' ) . '.png';
		$imgFilePath = DocumentTemplate::getDocDir () . $imgFilename;
		copy ( $imgSrcFilePath, $imgFilePath );
		self::$doc->addImg ( $imgFilePath, $title, $description );
	}
	
	/**
	 *
	 * @param string $text        	
	 */
	function notice($text = '') {
		$imgSrcFilePath = __DIR__ . '/../resources/img/excl.png';
		$imgFilename = (++ $this->i) . '_' . date ( 'YmdHis' ) . '.png';
		$imgFilePath = DocumentTemplate::getDocDir () . $imgFilename;
		copy ( $imgSrcFilePath, $imgFilePath );
		self::$doc->addNotice ( $imgFilePath, $text );
	}
	
	/**
	 *
	 * @param unknown $file        	
	 * @param unknown $locationxy        	
	 */
	function drawPointer($file, $locationxy) {
		$x = ( int ) explode ( ',', $locationxy )[0];
		$y = ( int ) explode ( ',', $locationxy )[1];
		$black = imagecolorallocate ( imagecreatefrompng ( $file ), 255, 0, 0 );
		$im = imagecreatefrompng ( $file );
		imagettftext ( $im, 21, 0, $x + 21, $y + 21, $black, "/usr/share/fonts/truetype/droid/DroidSans-Bold.ttf", 'X' );
		imagepng ( $im, $file );
		imagedestroy ( $im );
	}
	
	/**
	 *
	 * @param string $title        	
	 * @param string $description        	
	 * @param string $locationxy        	
	 */
	protected function screenshot($title = 'tytuł', $description = 'opis', $locationxy = null) {
		$imgFilename = (++ $this->i) . '_' . date ( 'YmdHis' ) . '.png';
		$imgFilePath = DocumentTemplate::getDocDir () . $imgFilename;
		if ($this instanceof PHPUnit_Extensions_Selenium2TestCase) {
			$fp = fopen ( $imgFilePath, 'wb' );
			fwrite ( $fp, $this->currentScreenshot () );
			fclose ( $fp );
			if ($locationxy != null) {
				self::drawPointer ( $imgFilePath, $locationxy );
			}
		}
		self::$doc->addImg ( $imgFilePath, $title, $description );
		sleep ( self::$sleep );
	}
	
	/**
	 *
	 * @param unknown $selector        	
	 * @return string
	 */
	protected function movemouse($selector) {
		if ($this instanceof PHPUnit_Extensions_Selenium2TestCase) {
			$loc = $this->byId ( $selector )->location ();
			$this->moveto ( $this->byId ( $selector ) );
			return implode ( ",", $loc );
		}
	}
	
	/**
	 *
	 * @param unknown $url        	
	 */
	protected function go($url) {
		if ($this instanceof PHPUnit_Extensions_Selenium2TestCase) {
			$this->url ( $url );
		}
	}
	
	/**
	 *
	 * @param unknown $selector        	
	 * @return string
	 */
	protected function clickam($selector) {
		if ($this instanceof PHPUnit_Extensions_Selenium2TestCase) {
			$loc = $this->byId ( $selector )->location ();
			$this->byId ( $selector )->click ();
			return implode ( ",", $loc );
		}
	}
	
	/**
	 *
	 * @param unknown $selector        	
	 * @param unknown $value        	
	 */
	protected function set($selector, $value) {
		if ($this instanceof PHPUnit_Extensions_Selenium2TestCase) {
			$this->byId ( $selector )->value ( $value );
		}
	}
	
	/**
	 *
	 * @param unknown $selector        	
	 */
	protected function submitForm($selector) {
		$this->byId ( $selector )->submit ();
	}
	
	/**
	 *
	 * @param unknown $selector        	
	 * @param number $wait        	
	 * @param unknown $visibleMatters        	
	 * @throws Exception
	 * @return PHPUnit_Extensions_Selenium2TestCase_Element|boolean
	 */
	protected function waitFor($selector, $wait = 30, $visibleMatters) {
		for($i = 0; $i <= $wait; $i ++) {
			try {
				$x = $this->byId ( $selector );
				if (! $x->displayed () && $visibleMatters) {
					throw new Exception ( 'not yet visible' );
				}
				return $x;
			} catch ( Exception $e ) {
				usleep ( 100000 );
			}
		}
		return false;
	}
	
	/**
	 *
	 * @param unknown $selector        	
	 * @param number $wait        	
	 * @param string $visibleMatters        	
	 */
	protected function assertExists($selector, $wait = 10, $visibleMatters = false) {
		$return = self::waitFor ( $selector, $wait, $visibleMatters );
		$this->assertTrue ( $return != false, 'Expected: ' . $selector . ' exist' );
	}
	
	/**
	 *
	 * @param unknown $selector        	
	 * @param number $wait        	
	 * @param string $visibleMatters        	
	 */
	protected function assertNotExists($selector, $wait = 1, $visibleMatters = false) {
		$this->assertFalse ( self::waitFor ( $selector, $wait, $visibleMatters ), 'Expected: ' . $selector . ' not exist' );
	}
}

?>
