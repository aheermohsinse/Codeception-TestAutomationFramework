<?php

use PageObjects\Flights\FlightsHome;

/**
 *
 * Class basicTestCest
 * @group Functional
 */
class basicTestCest
{
    /**
     * DESC
     * @param $I
     *
     */
    public function searchFlight($I)
    {
        $I->amOnPage('/');
        $I->waitForElementVisible(FlightsHome::$searchFlight);
        $I->click(FlightsHome::$searchFlight);
        $I->wait('5');
        $I->see('Please enter an origin and destination and try again');
    }
}
