<?php
use Behat\Behat\Context\Context;
use Behat\Behat\Hook\Scope\AfterStepScope;
use Behat\MinkExtension\Context\MinkContext;
use Behat\Behat\Hook\Scope\BeforeFeatureScope;
use Behat\Behat\Hook\Scope\BeforeScenarioScope;
use Behat\Behat\Hook\Scope\AfterFeatureScope;
// use Behat\Behat\Context\TranslatedContextInterface,
// use Behat\Gherkin\Node\PyStringNode,
// Behat\Gherkin\Node\TableNode;

/**
 * Features context.
 */
class FeatureContext extends MinkContext {

	private $scenarioCount;
	
	/**
	 * constr
	 */
	public function __construct() {
		$this->scenarioCount = 0;
	}
	
	/**
	 * @BeforeFeature
	 */
	public static function prepareForTheFeature(BeforeFeatureScope $scope) {
 		$post="---\nlayout: slider\ntitle: " . $scope->getFeature()->getTitle() . "\nsliders:\n";
		FeatureContext::printToScenario($scope, $post );
	}
	
	/**
	 * @AfterFeature
	 */
	public static function afterTheFeature(AfterFeatureScope $scope) {
		$post="---\n";
		FeatureContext::printToScenario($scope, $post );
	}
	
	/**
	 * @BeforeScenario
	 */
	public function prepareForTheScenario(BeforeScenarioScope $scope) {
		$this->scenarioCount++;
 		$text="- description: " . $scope->getScenario()->getTitle() . "\n  folder: /images\n  images:\n"; 
 		FeatureContext::printToScenario($scope, $text);
	}
	
	public static function printToScenario($scope,$text) {
		file_put_contents( FeatureContext::getFileName($scope), $text , FILE_APPEND);
	}
	
	public static function getFileName($scope) {
		$filename = getenv("HOME") . '/' . date('Y-m-d-') . $scope->getFeature()->getTitle() . '.markdown';
		return $filename;
	}

  /**
   * @AfterStep
   */
  public function takeScreenShotAfterStep(AfterStepScope $scope)
  {
  	// filename - if the step is repeated it doesn't create additional screenshots
   	  $fileName = $this->scenarioCount . '-' . md5($scope->getStep()->getText()) .'-'. $scope->getStep()->getLine() . '.png';
   	  $text = "  - name: ". $fileName. "\n    text: ".$scope->getStep()->getText()."\n";
   	  FeatureContext::printToScenario($scope, $text);
   	  $this->saveScreenshot($fileName, getenv("HOME"));
  }
  
	/**
	 * @Given we have some context
	 */
	public function prepareContext() {
		// do something
	}
	
	/**
	 * @When event occurs
	 */
	public function doSomeAction() {
	}
	
	/**
	 * @Then something should be done
	 */
	public function checkOutcomes() {
	}
	
	/**
	 * @Given /^otwieram na ([^"]*)$/
	 */
	public function iOpenOnDevice($argument) {
		if ($argument == "smartfonie") {
			$this->getSession()->resizeWindow(320, 480, 'current');
		} else if ($argument == "tablecie") {
			$this->getSession()->resizeWindow(1024, 768, 'current');
		} else {
			$this->getSession()->resizeWindow(1280, 1024, 'current');
		}
	}
}
