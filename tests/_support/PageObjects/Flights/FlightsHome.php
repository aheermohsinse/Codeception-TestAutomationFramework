<?php

namespace PageObjects\Flights;

/**
 * Class FlightsHome
 * @package PageObjects\Flights
 */
class FlightsHome
{
    /** @var string check box Direct flights only */
    public static $directFlightsOnly = "#flights-search-direct-inp";

    /** @var string button Search flights */
    public static $searchFlight = "#flights-search-cta";

    /** @var string err message */
    public static $errMessage = "#noty_1223590463539171000 > div > span";
}
