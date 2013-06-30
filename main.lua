missionlib = require("mission")
love.graphics.setCaption("Mission Demo")

bg = love.graphics.newImage("assets/bg.png")

ed = {
  name = "Ed",
  image = love.graphics.newImage("assets/ed.png")}
faye = {
  name = "Faye",
  image = love.graphics.newImage("assets/faye.png")}
jet = {
  name = "Jet",
  image = love.graphics.newImage("assets/jet.png")}
spike = {
  name = "Spike",
  image = love.graphics.newImage("assets/spike.png")}

-- MISSION OBJECT 1

d1 = {
  {
    image = ed.image,
    name = ed.name,
    body = "Hello, and welcome to the LoveMission demo.",
    audio = love.audio.newSource("assets/1.wav","static")
  },
  {
    image = spike.image,
    name = spike.name,
    body = "LoveMission is an interactive message system that will allow you to convey information to your users in an interesting way.",
    audio = love.audio.newSource("assets/2.wav","static")
  },
  {
    image = jet.image,
    name = jet.name,
    body = "LoveMission allows you to define your own conditions for each mission state. For example, to pass this, you must press \"x\" instead of space.",
    audio = love.audio.newSource("assets/3.wav","static"),
    condition = "Press x to continue...",
    update = function(self,dt)
      if love.keyboard.isDown("x") then
        return true
      end
    end
  },
  {
    image = faye.image,
    name = faye.name,
    body = "LoveMission is also defined as a class, so you can have multiple instances of it.",
    audio = love.audio.newSource("assets/4.wav","static"),
    init = function(self)
      d2[1] = {
        image = spike.image,
        name = spike.name,
        body = "Here is a new instance that has been spawned by the fourth state of the other LoveMission object.\nYou will also notice that this window is visually different. There are quite a few settings that will allow you to change the way a mission object is presented.\nPress the left mouse button to close this state.",
        condition = "Click the mouse to continue...",
        update = function(self,dt)
          if love.mouse.isDown("l") then
            return true
          end
        end
      }
    end,
    condition = "Close the other LoveMission object to continue ...",
    update = function(self,dt)
      if mission2:done() then
        self.data[self.state].condition = nil
        self.data[self.state].update = nil
      end
    end
  },
  {
    image = jet.image,
    name = jet.name,
    body = "This state will end all by itself. Just wait a moment.",
    audio = love.audio.newSource("assets/5.wav","static"),
    init = function(self)
      example_temp_var = 5
    end,
    update = function(self,dt)
      example_temp_var = example_temp_var - dt
      if example_temp_var <= 0 then
        self.data[self.state].condition = nil
        if self.config:default_update(dt) then
          return true
        end
      else
        self.data[self.state].condition = "Please wait ".. (math.floor(example_temp_var)+1) .. " more seconds."
      end
      
    end
  },
  {
    body = "This concludes the LoveMission demo. Thank you for watching.",
    audio = love.audio.newSource("assets/6.wav","static"),
  }
}

config1 = {}
config1.window = {
  x=200,
  y=225,
  w=800-200*2,
  h=600-225*2
}

-- MISSION OBJECT 2

d2 = {}

config2 = {}
config2.window = {
  x=100,
  y=400,
  w=800-100*2,
  h=640-225*2
}
config2.frame_color = {0,0,127,127}
config2.padding = 2
config2.title_font = love.graphics.newFont("assets/PathwayGothicOne-Regular.ttf",32)
config2.title_font_color = {255,0,0}
config2.title_align = "center"
config2.body_font = love.graphics.newFont("assets/PathwayGothicOne-Regular.ttf",16)
config2.body_font_color = {255,127,127}
config2.body_align = "center"
config2.condition_font = love.graphics.newFont("assets/PathwayGothicOne-Regular.ttf",12)
config2.condition_font_color = {127,0,0}
config2.condition_align = "right"

function love.load(args)
  mission1 = missionlib.new(d1,config1)
  mission2 = missionlib.new(d2,config2)
end

function love.update(dt)
  mission1:update(dt)
  mission2:update(dt)
end

function love.draw()
  love.graphics.setColor(255,255,255,127)
  love.graphics.draw(bg)
  mission1:draw()
  mission2:draw()
  
  if mission1:done() then
    love.graphics.printf("Mission is done.",0,200,800,"center")
  else
    love.graphics.printf("Mission is not done.",0,200,800,"center")
  end
end
