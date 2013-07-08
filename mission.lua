local mission = {}

-- MISSION DEFAULT VARS

mission.default = {}
mission.default.window = {x=10,y=10,w=600,h=150}

mission.default.frame_color = {0,0,0,191}
mission.default.padding = 8

mission.default.title_font = love.graphics.newFont(16)
mission.default.title_font_color = {255,255,255}
mission.default.title_align = "left"

mission.default.body_font = love.graphics.newFont(12)
mission.default.body_font_color = {191,191,191}
mission.default.body_align = "left"

mission.default.condition_font = love.graphics.newFont(9)
mission.default.condition_font_color = {127,127,127}
mission.default.condition_align = "center"

mission.default.reset_color = {255,255,255}
mission.default.global_opacity = 255

mission.default.default_update = function(self,dt)
  if not love.keyboard.isDown(" ") then
    self._ready = true
  end
  if self._ready and love.keyboard.isDown(" ") then
    self._ready = false
    return true
  else
    return false
  end
end

mission.default.default_condition = "Press space to continue..."

function mission.new(data,config)

  if not data then data = {} end
  if not config then config = {} end
  
  obj = {}
  
  obj.config = {}
  -- defult config
  for i,v in pairs(mission.default) do
    obj.config[i] = v
  end
  -- override default config
  for i,v in pairs(config) do
    obj.config[i] = v
  end
  
  -- var init
  obj.state = 1
  
  -- init args
  obj.data = data

  -- func init
  obj.update = mission.update
  obj.draw = mission.draw
  obj.done = mission.done
  
  return obj
end

function mission:draw()
  if self.data[self.state] then
    local old_color = {love.graphics.getColor()}
    local old_font = love.graphics.getFont()
    
    love.graphics.setColor(mission._truecolor(self,self.config.frame_color))
    love.graphics.rectangle("fill",
      self.config.window.x,
      self.config.window.y,
      self.config.window.w,
      self.config.window.h)
    
    love.graphics.setColor(mission._truecolor(self,self.config.reset_color))
    
    local img_w = 0
    if self.data[self.state].image then
    
      local img_h = self.config.window.h - (
        self.config.padding*2
      )
      local img_scale = img_h / self.data[self.state].image:getHeight()
      
      img_w = self.data[self.state].image:getWidth()*img_scale + self.config.padding
      
      love.graphics.draw(self.data[self.state].image,
        self.config.window.x + self.config.padding,
        self.config.window.y + self.config.padding,
        0,img_scale,img_scale)
        
    end
    
    local body_offset = 0
    if self.data[self.state].name then
      love.graphics.setColor(mission._truecolor(self,self.config.title_font_color))
      love.graphics.setFont(self.config.title_font)
      
      body_offset = self.config.title_font:getHeight()
      
      love.graphics.printf(self.data[self.state].name,
        self.config.window.x + self.config.padding + img_w,
        self.config.window.y + self.config.padding,
        self.config.window.w - img_w - self.config.padding*2,
        self.config.title_align)
    end

    if self.data[self.state].body then
      love.graphics.setColor(mission._truecolor(self,self.config.body_font_color))
      love.graphics.setFont(self.config.body_font)
      love.graphics.printf(self.data[self.state].body,
        self.config.window.x + self.config.padding + img_w,
        self.config.window.y + self.config.padding + body_offset,
        self.config.window.w - img_w - self.config.padding*2,
        self.config.body_align)
    end
    
    local cond = self.config.default_condition
    if self.data[self.state].condition then
      cond = self.data[self.state].condition
    end
    
    love.graphics.setColor(mission._truecolor(self,self.config.condition_font_color))
    love.graphics.setFont(self.config.condition_font)
    love.graphics.printf(cond,
      self.config.window.x + self.config.padding + img_w,
      self.config.window.y + self.config.window.h - self.config.padding - self.config.condition_font:getHeight(),
      self.config.window.w - img_w - self.config.padding*2,
      self.config.condition_align)
    
    love.graphics.setColor(old_color)
    if old_font then
      love.graphics.setFont(old_font)
    end
  end
end

function mission._init(self)

  if self.data[self.state-1] then
    if self.data[self.state-1].audio then
      love.audio.stop(self.data[self.state-1].audio)
    end
  end
  
  if self.data[self.state] then
    if self.data[self.state].audio then
      love.audio.play(self.data[self.state].audio)
    end
    if self.data[self.state].init then
      self.data[self.state]:init()
    end
  end
  
end

function mission._truecolor(self,color)
  -- duplicate the color table
  local newcolor = {color[1],color[2],color[3],color[4]}
  
  if newcolor[4] then -- if there is an alpha
    newcolor[4] = newcolor[4]*self.config.global_opacity/255
  else
    newcolor[4] = self.config.global_opacity
  end
  return newcolor
end

function mission:update(dt)

  if not self.initdone then
    mission._init(self)
    self.initdone = true
  end

  if self.data[self.state] then
    local up = self.config.default_update
    if self.data[self.state].update then
      up = self.data[self.state].update
    end
    
    if up(self,dt) then
    
      self.state = self.state + 1
      mission._init(self)
      
    end
  end
end

function mission:done()
  if self.data[self.state] then
    return false
  else
    return true
  end
end

return mission
