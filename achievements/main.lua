achievementlib = require("achievements")
love.graphics.setCaption("Achievements Demo")

bg = love.graphics.newImage("assets/bg.png")

function love.load()

  local d = {
    {
      title="Keyboard Man",
      text="You have a keyboard, nice job!",
      image=love.graphics.newImage("assets/1.png"),
      trigger= function(self)
        return love.keyboard.isDown(" ")
      end
    },{
      title="Waldo Man",
      text="You found waldo, nice job!",
      image=love.graphics.newImage("assets/2.png"),
      trigger= function(self)
        local x,y = love.mouse.getPosition()
        if x > 243 and y > 282 and x < 279 and y < 365 and love.mouse.isDown("l") then
          return true
        end
      end
    },{
      title="Mouse Man",
      text="You have a mouse, nice job!",
      image=love.graphics.newImage("assets/3.png"),
      trigger= function(self)
        return love.mouse.isDown("l")
      end
    },{
      title="Super Mouse Man x 10",
      text="Wow, you clicked 10 times!",
      image=love.graphics.newImage("assets/4.png"),
      trigger= function(self)

        if not love.mouse.isDown("l") then
          self._ready = true
        end
        if self._ready and love.mouse.isDown("l") then
          self._ready = false
          
          if not self.click then self.click = 0 end
          self.click = self.click + 1
          if self.click >= 10 then
            return true
          end
          
        else
          return false
        end
        
      end
    }
  }
  a = achievementlib.new(d)
end

function love.update(dt)
  a:update(dt)
end

function love.draw()
  love.graphics.setBackgroundColor(220,89,157)
  love.graphics.draw(bg)
  a:draw()
  love.graphics.setColor(0,0,0)
  love.graphics.print("Availible Achievements:",16,432)
  for i,v in pairs(a.data) do
    if v._triggered then
      love.graphics.setColor(0,255,0)
    else
      love.graphics.setColor(0,0,0)
    end
    love.graphics.print(v.title,32,448+16*i)
    love.graphics.setColor(255,255,255)
  end
end
