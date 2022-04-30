# Teach SDK
The Teach SDK and [Roblox Plugin](https://www.roblox.com/library/9415678965/Teach-Plugin) assists developers in creating educational content on the Roblox platform by providing all of the tooling necessary to turn any Roblox obby into an interactive educational game. 

The Teach SDK provides personalized and adaptive questions to players at runtime.

For more information about our mission to bring high quality education to Roblox's metaverse, visit [robloxteach.com](robloxteach.com).

## Demo
Below is a demonstration video of the plugin being used to add questions to an obby.

https://www.youtube.com/watch?v=IEj26lTgj-I
## Installation
1. Enable HTTP Requests in your game: Game Settings->Security->**Allow HTTP Requests**
2. Install the [Roblox Teach Plugin](https://www.roblox.com/library/9415678965/Teach-Plugin). **Allow script insertion** to automatically insert the TeachSDK/ and TeachScripts/ folders into the game.

## API Key
* Please email luke@robloxteach.com to request an API Key

## Design
The Teach SDK features a Plugin that enables the developer to place a question on any surface in a Roblox game. In order to answer a question, the player touches an object to indicate a response. Each question is multiple choice with 3 options. Every option has a corresponding 'response' or object that needs to be touched to respond to the question. The components of a question therefore are:
1. The question itself (e.g. 7+5)
2. Option 1 (e.g 11)
3. Option 2 (e.g. 12)
4. Option 3 (e.g. 13)
5. Response 1 (the object to touch to indicate Option1 / 11)
6. Response 2 
7. Response 3

In order to use the plugin, an API key must be entered in the plugin first that gives access to the Teach backend. The Teach backend generates personalized and adaptive questions for players at runtime. 

## Contact
* For feature suggestions, please create an issue on the github.
* Otherwise, please email luke@robloxteach.com
