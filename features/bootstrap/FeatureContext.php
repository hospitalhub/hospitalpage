<?php
use Behat\Behat\Context\Context;
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
	 * Take screenshot when step fails.
	 * Works only with Selenium2Driver.
	 *
	 * @AfterStep
	 */
	public function takeScreenshotAfterFailedStep($event)
	{
		if (4 === $event->getResult()) {
			$driver = $this->getSession()->getDriver();
			if (!($driver instanceof Selenium2Driver)) {
				//throw new UnsupportedDriverActionException('Taking screenshots is not supported by %s, use Selenium2Driver instead.', $driver);
				return;
			}
	
			$screenshot = $driver->wdSession->screenshot();
			file_put_contents('/tmp/test.png', base64_decode($screenshot));
		}
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
