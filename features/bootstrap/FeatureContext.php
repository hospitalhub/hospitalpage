<?php
use Behat\Behat\Context\Context;
use Behat\Behat\Hook\Scope\AfterStepScope;
// use Behat\Behat\Context\TranslatedContextInterface,
// use Behat\Gherkin\Node\PyStringNode,
// Behat\Gherkin\Node\TableNode;

/**
 * Features context.
 */
class FeatureContext implements Context {
	
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
//     if (99 === $scope->getTestResult()->getResultCode()) {
      $driver = $this->getSession()->getDriver();
      if (!($driver instanceof Selenium2Driver)) {
      	echo "ERROR Selenium 2 Driver only";
        return;
      }
      echo "taking screenshot";
      file_put_contents('/tmp/test.png', $this->getSession()->getDriver()->getScreenshot());
//     }
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
