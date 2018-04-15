#!/usr/bin/env bash

# This cli tool requires bash >= 4. So, exit if the version of bash version is lower than 4.
if ((`bash -c 'IFS=.; echo "${BASH_VERSINFO[*]: 0:1}"'` < 4)); then
    echo "Sorry, you need at least bash version 4 to run this script."
    exit 1
fi;

source "$(cd "${BASH_SOURCE[0]%/*}" && pwd)/../lib/oo-bootstrap.sh"

import util/type lib/helper
import UI/Color
import util/namedParameters util/class util/variable
import util/log util/exception util/tryCatch

#######################################
# Selenium, a simple cli that will setup your environment for selenium server
# Author: me-io - https://github.com/me-io
# https://github.com/me-io/selenium-appium-server#contributors
# Check out README.md for more details
#
# TODO: Add windows and linux support
#######################################
class:Selenium() {
    private string APPLICATION_NAME = "Selenium"

    private string APPLICATION_VERSION = "1.0.0"

    #######################################
    # Main entry of the CLI Application
    # Arguments:
    #   cmd string command to run
    # Returns:
    #   None
    #######################################
    Selenium.Init() {
        [string] cmd

        case "$cmd" in
        configure)
            this ConfigureSystem
            ;;
        start)
            this StartServer
            ;;
        start-background)
            this StartServerInBackground
            ;;
        stop)
            this StopServer
            ;;
        restart | force-reload)
            this RestartServer
            ;;
        *)
            this Usage
            exit 1
            ;;
        esac
    }

    #######################################
    # Check what is the type of the OS
    # Arguments:
    #   None
    # Returns:
    #   None
    #######################################
    Selenium.ConfigureSystem() {
        case "$(getOSType)" in
            Darwin)
                this ConfigureMac
                ;;
            WindowsNT)
                this ConfigureWindows
                ;;
            Linux)
                this ConfigureLinux
                ;;
            *)
                machine="UNKNOWN:${unameOut}"
                exit 1
                ;;
        esac
    }

    #######################################
    # Configure mac environment for selenium server
    # Arguments:
    #   None
    # Returns:
    #   None
    #######################################
    Selenium.ConfigureMac() {
        this ValidateSeleniumRequiremetns
        this DisplaySysmtemConfig
        this InstallBrewPackages
        this AlertSetEnvironment
    }

    #######################################
    # Display a message to user for configuring environment
    # Arguments:
    #   None
    # Returns:
    #   None
    #######################################
    Selenium.AlertSetEnvironment() {
        [string] seleniumVersion=$(brew ls --versions selenium-server-standalone | perl -pe 'if(($_)=/([0-9]+([.][0-9]+)+)/){$_.="\n"}')

        output ""
        cat <<EOS
$(UI.Color.Green)$(UI.Powerline.Lightning)  Now you need to manually update selenium-server bin file.$(UI.Color.Default)
Open $(UI.Color.Cyan)/usr/local/Cellar/selenium-server-standalone/$seleniumVersion/bin/selenium-server$(UI.Color.Default) inside code editor and update the following line:

exec java -jar /usr/local/Cellar/selenium-server-standalone/$seleniumVersion/libexec/selenium-server-standalone-$seleniumVersion.jar \"\$@\"
                                                    $(UI.Color.Green)⬇$(UI.Color.Default)
exec java \"\$@\" -jar /usr/local/Cellar/selenium-server-standalone/$seleniumVersion/libexec/selenium-server-standalone-$seleniumVersion.jar
EOS
    }

    #######################################
    # Install and configure brew cask packages on user machine
    # Arguments:
    #   None
    # Returns:
    #   None
    #######################################
    Selenium.InstallBrewPackages() {
        array PACKAGES=(
            'selenium-server-standalone'
            'chromedriver'
        )

        if ! brew ls --versions ${PACKAGES[@]} &>/dev/null; then
            output "$(UI.Powerline.PointingArrow)$(UI.Color.Default) Installing required brew packages."
            for package in ${PACKAGES[@]}; do
                brew install $package &>/dev/null
            done

            output "$(UI.Color.Green)$(UI.Powerline.OK)$(UI.Color.Default) Brew packages successfully installed."
        else
            output "$(UI.Color.Green)$(UI.Powerline.OK)$(UI.Color.Default) Brew packages already installed. Skipping"
        fi
    }

    #######################################
    # Checks if the required applications are installed for configuring selenium
    # Arguments:
    #   None
    # Returns:
    #   None
    #######################################
    Selenium.ValidateSeleniumRequiremetns() {
        # Check if Java is installed if not then exit
        if ! type -p java &>/dev/null; then
            output "$(UI.Color.Red)$(UI.Powerline.Fail) Sorry, java NOT found!$(UI.Color.Default)
                    $(UI.Color.Green)$(UI.Powerline.PointingArrow) Run the following command to install java:$(UI.Color.Default)
                        brew tap caskroom/versions
                        brew cask install java8"
            exit 1
        fi

        # Exit if the java version is not 8
        if [ ! "$(getJavaVersion)" -le "18" ]; then
            output "$(UI.Color.Red)$(UI.Powerline.Fail) Sorry, Selenium require java8!$(UI.Color.Default)
                    $(UI.Color.Green)$(UI.Powerline.PointingArrow) Uninstall the current version of java and run the following command to install java8:$(UI.Color.Default)
                        brew tap caskroom/versions
                        brew cask install java8"
            exit 1
        fi

        # Check if brew is installed
        if ! type -p brew &>/dev/null; then
            output "$(UI.Color.Red)$(UI.Powerline.Fail) Sorry, but you need to install brew before procedding!$(UI.Color.Default)
                    $(UI.Color.Green)$(UI.Powerline.PointingArrow) Use the following command to install brew:$(UI.Color.Default)
                        /usr/bin/ruby -e \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)\""
            exit 1
        fi

        # Check if brew cask is installed
        if ! type -p cask &>/dev/null; then
            output "$(UI.Color.Red)$(UI.Powerline.Fail) Sorry, Homebrew-Cask NOT found!$(UI.Color.Default)
                    $(UI.Color.Green)$(UI.Powerline.PointingArrow) Run the following command to install Homebrew-Cask:$(UI.Color.Default)
                        brew tap caskroom/cask"
            exit 1
        fi
    }

    #######################################
    # Displays the system configuration
    # Arguments:
    #   None
    # Returns:
    #   None
    #######################################
    Selenium.DisplaySysmtemConfig() {
        output ""
        output "$(UI.Color.Bold)Java:$(UI.Color.Default) $(java -version 2>&1 | awk -F '"' '/version/ {print $2}')"
        output "$(UI.Color.Bold)NPM:$(UI.Color.Default)  $(npm -v)"
        output "$(UI.Color.Bold)Node:$(UI.Color.Default) $(node -v | grep -Eo [0-9.]+)"

        if [ "$(uname -m)" == 'x86_64' ]; then
            output "$(UI.Color.Bold)OS:$(UI.Color.Default)   $(getOSType) x64"
        else
            output "$(UI.Color.Bold)OS:$(UI.Color.Default)   $(getOSType) x32"
        fi
        output ""
    }

    #######################################
    # Configure windows environment for selenium server
    # Arguments:
    #   None
    # Returns:
    #   None
    #######################################
    Selenium.ConfigureWindows() {
        throw "Sorry, currently this script only supporte mac."
    }

    #######################################
    # Configure linux environment for selenium server
    # Arguments:
    #   None
    # Returns:
    #   None
    #######################################
    Selenium.ConfigureLinux() {
        throw "Sorry, currently this script only supporte mac."
    }

    #######################################
    # Validate selenium requirements and then start the selenium server
    # Arguments:
    #   None
    # Returns:
    #   None
    #######################################
    Selenium.StartServer() {
        this ValidateSeleniumRequiremetns
        
        output "$(UI.Powerline.PointingArrow)$(UI.Color.Default) Killing selenium server processes."
        killProcess selenium-server
        output ""
        
        selenium-server -Dwebdriver.chrome.bin="/Applications/Google Chrome.app" -Dwebdriver.chrome.driver=chromedriver
    }

    #######################################
    # Validate selenium requirements and then start the selenium server in background
    # Arguments:
    #   None
    # Returns:
    #   None
    #######################################
    Selenium.StartServerInBackground() {
        this ValidateSeleniumRequiremetns

        output "$(UI.Powerline.PointingArrow)$(UI.Color.Default) Killing selenium server processes."
        killProcess selenium-server
        selenium-server -Dwebdriver.chrome.bin="/Applications/Google Chrome.app" -Dwebdriver.chrome.driver=chromedriver &>/dev/null &
        
        output "$(UI.Color.Green)$(UI.Powerline.OK)$(UI.Color.Default) Selenium server started in background."
    }

    #######################################
    # Stop the selenium server
    # Arguments:
    #   None
    # Returns:
    #   None
    #######################################
    Selenium.StopServer() {
        output "$(UI.Powerline.PointingArrow)$(UI.Color.Default) Killing selenium server processes."
        
        killProcess selenium-server
        
        output "$(UI.Color.Green)$(UI.Powerline.OK)$(UI.Color.Default) Selenium server successfully stopped."
    }

    #######################################
    # Validate selenium requirements and then restart the selenium server
    # Arguments:
    #   None
    # Returns:
    #   None
    #######################################
    Selenium.RestartServer() {
        SeleniumPreConfigure

        output "$(UI.Powerline.PointingArrow)$(UI.Color.Default) Killing selenium server processes."
        killProcess selenium-server
        sleep 1
        selenium-server -Dwebdriver.chrome.bin="/Applications/Google Chrome.app" -Dwebdriver.chrome.driver=chromedriver
    }

    #######################################
    # Display the usage of the selenium command
    # Arguments:
    #   None
    # Returns:
    #   None
    #######################################
    Selenium.Usage() {
        cat <<EOS
output "$(this APPLICATION_NAME) $(UI.Color.Green)$(this APPLICATION_VERSION)$(UI.Color.Default)
                
$(UI.Color.Yellow)Usage:$(UI.Color.Default)
    selenium <command>

$(UI.Color.Yellow)Commands:$(UI.Color.Default)
    $(UI.Color.Green)configure$(UI.Color.Default)            - Install selenium and its dependencies.
    $(UI.Color.Green)start$(UI.Color.Default)                - Start the selenium server.
    $(UI.Color.Green)start-background$(UI.Color.Default)     - Start selenium server in background.
    $(UI.Color.Green)stop$(UI.Color.Default)                 - Stop the selenium server.
    $(UI.Color.Green)restart|force-reload$(UI.Color.Default) - Restart the selenium server.

$(UI.Color.Yellow)Examples:$(UI.Color.Default)
    selenium start"
EOS
    }
}

Type::Initialize Selenium

Selenium SeleniumObject

$var:SeleniumObject Init $1
