# Teach SDK
The Teach SDK assists developers in creating educational content on the Roblox platform by providing all of the tooling necessary to turn any Roblox obby into an interactive educational game. 

## Demo

## Installation
1. Enable HTTP Requests in your game: Game Settings->Security->Allow HTTP Requests
2. Install the Teach Plugin & Follow the installation instructions in the plugin. Allow for script insertion.
The plugin will insert required scripts into ServerStorage & ServerScriptService

## Design
The Teach SDK features a Plugin that enables the developer to place a question on any surface in a Roblox game. The player touches an object in the game to respond to the question. Each question is multiple choice with 3 options. Every option has a corresponding 'response' or object that needs to be touched to respond to the question. The components of a question therefore are:
1. The question (e.g. 7+5)
2. Option 1 (e.g 11)
3. Option 2 (e.g. 12)
4. Option 3 (e.g. 13)
5. Response 1 (the object to touch to indicate Option1)
6. Response 2 
7. Response 3

In order to use the plugin, an API key must be entered in the plugin first that gives access to the Teach backend. The Teach backend generates personalized and adaptive questions for players.