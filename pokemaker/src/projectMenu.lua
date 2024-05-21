local background = love.graphics.newImage("pokemaker/assets/menu/game-menu.png")

ProjectMenuM = {}

function ProjectMenuM:new(o)
  local o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

function ProjectMenuM:init(project)
  self.project = project
  self.maps = dirLookup(love.filesystem.getWorkingDirectory().."/pokemaker/projects/"..self.project.."/maps/")
end

function ProjectMenuM:update(dt)
end

function ProjectMenuM:draw()
  love.graphics.draw(background, 0, 0)
  love.graphics.setColor(0,0,0)
  for i = 1, #self.maps do
    love.graphics.print(self.maps[i], 70, 270+(i*25))
    if math.floor((love.mouse.getY()-300)/25)+1 == i then
      love.graphics.rectangle("line", 60, 270+(i*25), 300, 25)
    end
  end
  love.graphics.setColor(1,1,1)
end

function ProjectMenuM:mousepressed(x, y, button, istouch)
  if (#self.maps >= math.floor((y-300)/25)+1 and math.floor((y-300)/25)+1 > 0) then
    openMap(self.project, self.maps[math.floor((y-300)/25)+1])
  end
end

function ProjectMenuM:mousereleased(x, y, button, istouch)
end

function ProjectMenuM:keypressed(key, code)
  if key == "escape" then
    setCurrent("pmak-menu")
  end
end

function ProjectMenuM:wheelmoved(x, y)
end