local background = love.graphics.newImage("pokemaker/assets/menu/menu.png")

MenuM = {}

function MenuM:new(o)
  local o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

function MenuM:init()
  self.projects = dirLookup("/pokemaker/projects/")
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
  love.graphics.print("+", 70, 270+((#self.projects+1)*25))
  if math.floor((love.mouse.getY()-300)/25)+1 == (#self.projects+1) then
    love.graphics.rectangle("line", 60, 270+((#self.projects+1)*25), 300, 25)
  end
  love.graphics.print(love.filesystem.getSaveDirectory().."/projects", 800, 950)
  love.graphics.setColor(1,1,1)
end

function MenuM:mousepressed(x, y, button, istouch)
  if (#self.projects >= math.floor((y-300)/25)+1 and math.floor((y-300)/25)+1 > 0) then
    openProject(self.projects[math.floor((y-300)/25)+1])
  end
  if (math.floor((y-300)/25)+1 == #self.projects+1) then
    num = love.filesystem.getDirectoryItems("/pokemaker/projects/")
    love.filesystem.createDirectory("/pokemaker/projects/project-"..#num+1)
    self.projects[#self.projects+1] = "project-"..#num+1
  end
end

function MenuM:mousereleased(x, y, button, istouch)
end

function MenuM:keypressed(key, code)
  if key == "escape" then
    setCurrent("startup")
  end
end

function MenuM:wheelmoved(x, y)
end