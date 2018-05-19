<?php

use PageObjects\LoginPage;

/**
 * Class LoginCest
 */
class LoginCest
{
    /**
     * DESC
     * @param $I
     *
     */
    public function loginWeb($I)
    {
        $I->amOnPage(LoginPage::$URL);
        $I->waitForElementVisible(LoginPage::$username);
        $I->fillField(LoginPage::$username, Fixtures::get(HubCommon::$username));
        $I->fillField(LoginPage::$password, Fixtures::get(HubCommon::$password));
        $I->click(LoginPage::$logIn);
        $webSite = $I->getCurrentUrl();
        $I->comment($webSite);
        $I->waitForElementVisible(LoginPage::$moduleOrder);
    }
}