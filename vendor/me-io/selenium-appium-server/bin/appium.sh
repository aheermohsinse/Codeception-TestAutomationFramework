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
# Appium, a simple cli tool that will setup your environment for appium server
# Author: me-io - https://github.com/me-io
# https://github.com/me-io/selenium-appium-server#contributors
# Check out README.md for more details
#
# TODO: Add windows and linux support
#######################################
class:Appium() {
    private string APPLICATION_NAME = "Appium"

    private string APPLICATION_VERSION = "1.0.0"

    #######################################
    # Main entry of the CLI Application
    # Arguments:
    #   cmd string command to run
    # Returns:
    #   None
    #######################################
    Appium.Init() {
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
    Appium.ConfigureSystem() {
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
                error "UNKNOWN:${unameOut}" ;;
        esac
    }

    #######################################
    # Configure mac environment for appium server
    # Arguments:
    #   None
    # Returns:
    #   None
    #######################################
    Appium.ConfigureMac() {
        this DisplaySysmtemConfig
        this ValidateAppiumRequiremetns
        this ConfigureAndroidSDK
        this InstallBrewPackages
        this InstallBrewCaskPackages
        this AlertSetEnvironmentVariable
    }

    #######################################
    # Display a message to user for configuring environment variables
    # Arguments:
    #   None
    # Returns:
    #   None
    #######################################
    Appium.AlertSetEnvironmentVariable() {
        output ""
        cat <<EOS
$(UI.Color.Green)$(UI.Powerline.Lightning)  Manually set following environment variable's inside .bash_profile or .zshrc.$(UI.Color.Default)
$(UI.Color.White)$(UI.Powerline.PointingArrow)$(UI.Color.Default) export ANT_HOME=/usr/local/opt/ant
$(UI.Color.White)$(UI.Powerline.PointingArrow)$(UI.Color.Default) export MAVEN_HOME=/usr/local/opt/maven
$(UI.Color.White)$(UI.Powerline.PointingArrow)$(UI.Color.Default) export GRADLE_HOME=/usr/local/opt/gradle
$(UI.Color.White)$(UI.Powerline.PointingArrow)$(UI.Color.Default) export ANDROID_HOME=/usr/local/share/android-sdk
$(UI.Color.White)$(UI.Powerline.PointingArrow)$(UI.Color.Default) export ANDROID_NDK_HOME=/usr/local/share/android-ndk
$(UI.Color.White)$(UI.Powerline.PointingArrow)$(UI.Color.Default) export JAVA_HOME=\$(/usr/libexec/java_home)

$(UI.Color.White)$(UI.Powerline.PointingArrow)$(UI.Color.Default) export PATH=\$ANT_HOME/bin:\$PATH
$(UI.Color.White)$(UI.Powerline.PointingArrow)$(UI.Color.Default) export PATH=\$MAVEN_HOME/bin:\$PATH
$(UI.Color.White)$(UI.Powerline.PointingArrow)$(UI.Color.Default) export PATH=\$GRADLE_HOME/bin:\$PATH
$(UI.Color.White)$(UI.Powerline.PointingArrow)$(UI.Color.Default) export PATH=\$ANDROID_HOME/tools:\$PATH
$(UI.Color.White)$(UI.Powerline.PointingArrow)$(UI.Color.Default) export PATH=\$ANDROID_HOME/platform-tools:\$PATH
$(UI.Color.White)$(UI.Powerline.PointingArrow)$(UI.Color.Default) export PATH=\$ANDROID_HOME/build-tools/23.0.1:\$PATH
$(UI.Color.White)$(UI.Powerline.PointingArrow)$(UI.Color.Default) export PATH=\$JAVA_HOME/bin:\$PATH
EOS
    }

    #######################################
    # Install and configure android sdk on user machine
    # Arguments:
    #   None
    # Returns:
    #   None
    #######################################
    Appium.ConfigureAndroidSDK() {
        output "$(UI.Powerline.PointingArrow)$(UI.Color.Default) Now installing the Android SDK components."

        /usr/bin/expect -c '
        set timeout -1;
        spawn sdkmanager --licenses;
        expect {
            "y/N" { exp_send "y" ; exp_continue }
            eof
        }' &>/dev/null
        sdkmanager "platform-tools" "platforms;android-23" &>/dev/null
        sdkmanager "build-tools;23.0.1" &>/dev/null
        
        output "$(UI.Color.Green)$(UI.Powerline.OK)$(UI.Color.Default) Android SDK configured successfully."
    }

    #######################################
    # Install and configure brew cask packages on user machine
    # Arguments:
    #   None
    # Returns:
    #   None
    #######################################
    Appium.InstallBrewCaskPackages() {
        array CASKS=(
            'android-sdk'
            'android-ndk'
        )

        if ! brew cask ls --versions ${CASKS[@]} &>/dev/null; then
            output "$(UI.Powerline.PointingArrow)$(UI.Color.Default) Installing required cask packages."
            for cask in ${CASKS[@]}; do
                brew cask install $cask &>/dev/null
            done

            output "$(UI.Color.Green)$(UI.Powerline.OK)$(UI.Color.Default) Cask packages successfully installed."
        else
            output "$(UI.Color.Green)$(UI.Powerline.OK)$(UI.Color.Default) Cask packages already installed. Skipping"
        fi
    }

    #######################################
    # Install and configure brew packages on user machine
    # Arguments:
    #   None
    # Returns:
    #   None
    #######################################
    Appium.InstallBrewPackages() {
        array PACKAGES=(
            'ant'
            'maven'
            'gradle'
            'carthage'
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
    # Checks if the required applications are installed for configuring appium
    # Arguments:
    #   None
    # Returns:
    #   None
    #######################################
    Appium.ValidateAppiumRequiremetns() {
        # Exit if the xcode is not installed
        if ! type -p xcode-select &>/dev/null; then
            output "$(UI.Color.Red)$(UI.Powerline.Fail) Sorry, Xcode NOT found!$(UI.Color.Default)
                    $(UI.Color.Green)$(UI.Powerline.PointingArrow) Run the following command to install xcode:$(UI.Color.Default)
                        xcode-select --install"
            exit 1
        fi

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
            output "$(UI.Color.Red)$(UI.Powerline.Fail) Sorry, appium require java8!$(UI.Color.Default)
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

        # Validate if python version is 3.
        if ! type -p python3 &>/dev/null; then
            output "\n$(UI.Color.Red)$(UI.Powerline.Fail)$(UI.Color.Default) Sorry, python3 NOT found!$(UI.Color.Default)
                    $(UI.Color.Green)$(UI.Powerline.PointingArrow) Run the following command to install python:$(UI.Color.Default)
                        brew install python3"
            exit 1
        fi

        # Exit if node is not installed
        if ! type -p node &>/dev/null; then
            output "\n$(UI.Color.Red)$(UI.Powerline.Fail)$(UI.Color.Default) Sorry, node NOT found!$(UI.Color.Default)
                    $(UI.Color.Green)$(UI.Powerline.PointingArrow) Run the following command to install latest version node:$(UI.Color.Default)
                        brew install node"
            exit 1
        fi

        # Install the latest version of appium
        if ! type -p appium &>/dev/null; then
            output "\n$(UI.Color.Red)$(UI.Powerline.Fail)$(UI.Color.Default) Sorry, appium NOT found!$(UI.Color.Default)
                    $(UI.Color.Green)$(UI.Powerline.PointingArrow) Run the following command to install latest version appium:$(UI.Color.Default)
                        npm install -g appium"
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
    Appium.DisplaySysmtemConfig() {
        output ""
        output "$(UI.Color.Bold)Java:$(UI.Color.Default) $(java -version 2>&1 | awk -F '"' '/version/ {print $2}')"
        output "$(UI.Color.Bold)NPM:$(UI.Color.Default)  $(npm -v)"
        output "$(UI.Color.Bold)Node:$(UI.Color.Default) $(node -v | grep -Eo [0-9.]+)"

        if [ "$(uname -m)" == 'x86_64' ]; then
            output "$(UI.Color.Bold)OS:$(UI.Color.Default)   $(getOSType) x64"
        else
            output "$(UI.Color.Bold)OS:$(UI.Color.Default)   $(getOSType) x32"
        fi
        output  ""
    }

    #######################################
    # Configure windows environment for appium server
    # Arguments:
    #   None
    # Returns:
    #   None
    #######################################
    Appium.ConfigureWindows() {
        throw "Sorry, currently this script only supporte mac."
    }

    #######################################
    # Configure linux environment for appium server
    # Arguments:
    #   None
    # Returns:
    #   None
    #######################################
    Appium.ConfigureLinux() {
        throw "Sorry, currently this script only supporte mac."
    }

    #######################################
    # Validate appium requirements and then start the appium server
    # Arguments:
    #   None
    # Returns:
    #   None
    #######################################
    Appium.StartServer() {
        this ValidateAppiumRequiremetns
        
        output "$(UI.Powerline.PointingArrow)$(UI.Color.Default) Killing appium server processes."
        killProcess appium
        output  ""
        
        output $(appium 1>&2)
    }

    #######################################
    # Validate appium requirements and then start the appium server in background
    # Arguments:
    #   None
    # Returns:
    #   None
    #######################################
    Appium.StartServerInBackground() {
        this ValidateAppiumRequiremetns

        output "$(UI.Powerline.PointingArrow)$(UI.Color.Default) Killing appium server processes."
        killProcess appium
        appium &>/dev/null &

        output "$(UI.Color.Green)$(UI.Powerline.OK)$(UI.Color.Default) Appium server started in background."
    }

    #######################################
    # Stop the appium server
    # Arguments:
    #   None
    # Returns:
    #   None
    #######################################
    Appium.StopServer() {
        output "$(UI.Powerline.PointingArrow)$(UI.Color.Default) Killing appium server processes."
        
        killProcess appium
        
        output "$(UI.Color.Green)$(UI.Powerline.OK)$(UI.Color.Default) Appium server successfully stopped."
    }

    #######################################
    # Validate appium requirements and then restart the appium server
    # Arguments:
    #   None
    # Returns:
    #   None
    #######################################
    Appium.RestartServer() {
        this ValidateAppiumRequiremetns

        output "$(UI.Powerline.PointingArrow)$(UI.Color.Default) Killing appium server processes."
        killProcess appium
        sleep 1
        
        output $(appium 1>&2)
    }

    #######################################
    # Display the usage of the appium command
    # Arguments:
    #   None
    # Returns:
    #   None
    #######################################
    Appium.Usage() {
        cat <<EOS
$(this APPLICATION_NAME) $(UI.Color.Green)$(this APPLICATION_VERSION)$(UI.Color.Default)
                
$(UI.Color.Yellow)Usage:$(UI.Color.Default)
    appium <command>

$(UI.Color.Yellow)Commands:$(UI.Color.Default)
    $(UI.Color.Green)configure$(UI.Color.Default)            - Install appium and its dependencies.
    $(UI.Color.Green)start$(UI.Color.Default)                - Start the appium server.
    $(UI.Color.Green)start-background$(UI.Color.Default)     - Start appium server in background.
    $(UI.Color.Green)stop$(UI.Color.Default)                 - Stop the appium server.
    $(UI.Color.Green)restart|force-reload$(UI.Color.Default) - Restart the appium server.

$(UI.Color.Yellow)Examples:$(UI.Color.Default)
    appium start
EOS
    }
}

Type::Initialize Appium

Appium AppiumObject

$var:AppiumObject Init $1
