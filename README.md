## Everlive Sample Application

The purpose of this ios application is to demonstrate the usage of the [Everlive Swift SDK](https://github.com/ddimitrov90/EverliveSDK) built to work with [Progress Backend Services (Everlive)](https://platform.telerik.com).

The application is using the sample data that can be enabled when creating a new platform application at [https://platform.telerik.com](https://platform.telerik.com)

The main features covered in this app:

- Use custom classes
- Extend User's content type
- Register new user
- Login/Logout
- List activities
- Expand data
- Create new activity
- Submit comments for activity
- Like/Unlike activity

## How to use

Download the project and execute 

	pod install 
	
in the containing folder to ensure that the EverliveSDK is installed properly.

Open the AppDelete.swift file and at the bottom enter your AppId instead of the "your-app-id-here" text. Please be sure that the application that you're using is created with the sample backend services data.

Run the app - you can use one of the default user and pass **seth/333333** to login.

## Issues

The app is currently work in progress. There are many more features that will be added soon, but the state at the moment is enough to demonstrate the main features of the Everlive SDK. However, you can submit any bugs or comments in the repo here.

## Design

The app is created with the purpose to demonstrate how to use the SDK, so the design is not at the best level. However the app should look fine on iPhone5,5S,6,6S. Here are some screenshots.

**Login**

![Login](https://bs1.cdn.telerik.com/v1/la2ryjFXLtQcEEUP/fb580691-30b6-11e6-977c-bfd6c154069e)

**Register**

![Register](https://bs3.cdn.telerik.com/v1/la2ryjFXLtQcEEUP/fb580693-30b6-11e6-977c-bfd6c154069e)

**List activities**

![List activities](https://bs3.cdn.telerik.com/v1/la2ryjFXLtQcEEUP/fb580690-30b6-11e6-977c-bfd6c154069e)

**Add new activity**

![Add New Activity](https://bs1.cdn.telerik.com/v1/la2ryjFXLtQcEEUP/fb57df80-30b6-11e6-977c-bfd6c154069e)

