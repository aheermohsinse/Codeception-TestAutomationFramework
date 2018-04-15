<?php

use Codeception\Util\HttpCode as responseValidate;

/**
 * Class basicAPITestCest
 */
class basicAPITestCest
{
    /**
     * DESC
     * @param $I
     *
     */
    public function testListPackage($I)
    {
        $I->haveHttpHeader(
            'Content-Type', 'application/json'
        );
        $I->sendGET('/package/search?adult=2&category=4&child=0');
        /** Assertion for status code and message */
        $I->seeResponseCodeIs(responseValidate::OK);
        $I->seeResponseContainsJson();
    }
}
