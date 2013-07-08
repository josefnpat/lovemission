local achie = {}

achie.default = {}
achie.default.window = {}
achie.default.padding = 8
achie.default.window.w = 320
achie.default.window.x = love.graphics.getWidth() - (achie.default.window.w + achie.default.padding)
achie.default.window.y = achie.default.padding
achie.default.window.h = 60
achie.default.timeout = 3

function achie.new(data)
  if not data then data = {} end

  local obj = {}
  
  local mission = require("mission")
  
  obj.mission = mission.new(nil,{
    window=achie.default.window,
    padding=achie.default.padding,
  })
  
  obj.data = data
  
  obj.update = achie.update
  obj.draw = achie.draw
  
  return obj
end

function achie:update(dt)
  self.mission:update(dt)
  
  for i,v in pairs(self.data) do
    if not v._triggered and v:trigger() then
      v._triggered = true
      local m = {
        image = v.image,
        body = v.text,
        name = v.title,
        dt = achie.default.timeout,
        condition = "",
        update = function(self,dt)
          self.data[self.state].dt = self.data[self.state].dt - dt
          if self.data[self.state].dt < 0 then
            return true
          end
        end,
      }
      table.insert(self.mission.data,m)
      
    end
  end
end

function achie:draw()
  self.mission:draw()
end

return achie
