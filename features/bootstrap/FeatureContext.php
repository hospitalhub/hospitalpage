<?php
use Behat\Behat\Context\Context;
use Behat\Behat\Hook\Scope\AfterStepScope;
use Behat\MinkExtension\Context\MinkContext;
// use Behat\Behat\Context\TranslatedContextInterface,
// use Behat\Gherkin\Node\PyStringNode,
// Behat\Gherkin\Node\TableNode;

/**
 * Features context.
 */
class FeatureContext extends MinkContext {
	
	/**
	 * constr
	 */
	public function __construct() {
		// instantiate context
	}
	
	/**
	 * @BeforeFeature
	 */
	public static function prepareForTheFeature() {
		// clean database or do other preparation stuff
	}
	

  /**
   * @AfterStep
   */
  public function takeScreenShotAfterFailedStep(AfterStepScope $scope)
  {
      $driver = $this->getSession()->getDriver();
//       if (!($driver instanceof Selenium2Driver)) {
      echo "Driver: " . var_dump($driver);
        return;
//       }
//       file_put_contents('/tmp/test.png', $this->getSession()->getDriver()->getScreenshot());
  	$fileName = date('d-m-y') . '-' . uniqid() . '.png';
  	$this->saveScreenshot($fileName, '~/');
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
		// do something
	}
	
	/**
	 * @Then something should be done
	 */
	public function checkOutcomes() {
		// do something
	}
	
	/**
	 * @Given /^I have done something with "([^"]*)"$/
	 */
	public function iHaveDoneSomethingWith($argument) {
		// doSomethingWith($argument);
	}
}
