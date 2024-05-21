local background = love.graphics.newImage("pokemaker/assets/menu/menu.png")

MenuM = {}

function MenuM:new(o)
  local o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

function MenuM:init()
  self.projects = dirLookup(love.filesystem.getWorkingDirectory().."/pokemaker/projects/")
end

function MenuM:update(dt)
end

function MenuM:draw()
  love.graphics.draw(background, 0, 0)
  love.graphics.setColor(0,0,0)
  for i = 1, #self.projects do
    love.graphics.print(self.projects[i], 70, 270+(i*25))
    if math.floor((love.mouse.getY()-300)/25)+1 == i then
      love.graphics.rectangle("line", 60, 270+(i*25), 300, 25)
    end
  end
  love.graphics.setColor(1,1,1)
end

function MenuM:mousepressed(x, y, button, istouch)
  openProject(self.projects[math.floor((y-300)/25)+1])
end

function MenuM:mousereleased(x, y, button, istouch)
end

function MenuM:keypressed(key, code)
  if key == "escape" then
    love.event.push("quit")
  end
end

function MenuM:wheelmoved(x, y)
end
 
function dirLookup(dir)
  local i, t, popen = 0, {}, io.popen
  local pfile = popen('ls -a "'..dir..'"')
  for filename in pfile:lines() do
    i = i + 1
    t[i] = filename
  end
  pfile:close()
  return t
end