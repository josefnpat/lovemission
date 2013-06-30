# LoveMission

## About

LoveMission is an interactive message system that will allow you to convey information to your users in an interesting way.

## License

This library is under the The zlib/libpng License. Please see the accompanying license.md for more details.

## Minimal Sample Usage

    missionlib = require("mission")
    
    mission = missionlib.new({{body="Hello world."}})
    
    function love.update(dt)
      mission:update(dt)
    end
    
    function love.draw()
      mission:draw()
    end
    
## Advanced Sample usage

See the accompanying `main.lua`

## Documentation

*missionobj* mission.new(data,config)

This function is the object constructor for the mission object.

  data .. optional
  This is the data object. It should be defined as a table with the following parameters;
  
    image .. optional
    This is the image that should be drawn for the state. Usually a character portrait.
    
    name .. optional
    This is the name that corresponds with the speaker.
    
    body .. optional
    This is the text that will be shown to the user.
    
    audio .. optional
    This is the audio segment that will play for the current state. It will be stopped if the state is changed.
    
    condition .. optional [default : "Press space to continue..."]
    This is the condition text as to how the state will progress.
    
    update .. optional [default : mission.default.default_update ]
    This is the update function that runs when the state is active. By default, this will progress the state when the spacebar is released then pressed.
    
    init .. optional
    This function will run every time a new state is changed to. Useful for adding more complex updates.
    
  config .. optional
  This is the config object. Any variables in this table will overwrite the current configuration options;
  
    See the `mission.default` object at the start of mission.lua for variables that can be overridden.

*nil* missionobj:draw()

  This function will draw the object.

*nil* missionobj:update(dt)

  This function will update the object.

*nil* missionobj:done()

  This function will return true when the object is done.
