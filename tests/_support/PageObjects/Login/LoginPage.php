<?php

namespace PageObjects\LoginPage;

/**
 * Class LoginPage
 * @package PageObjects\LoginPage
 */
class LoginPage
{
    /** @var string add URL */
    public static $URL = "account/login";

    /** @var string username */
    public static $username = "div.modal-body>input:nth-child(1)";

    /** @var string password */
    public static $password = "div.modal-body>input:nth-child(2)";

    /** @var string login button */
    public static $logIn = "div.modal-footer > button";

    /** @var string side menu order tab */
    public static $moduleOrder = "#side-menu > li:nth-child(2) > a";
}
