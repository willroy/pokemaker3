local background = love.graphics.newImage("pokemaker/assets/menu/game-menu.png")

GameMenuM = {}

function GameMenuM:new(o)
  local o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

function GameMenuM:init(project)
  self.project = project
  self.maps = dirLookup("/home/will-roy/dev/pokemon3/pokemaker/projects/"..self.project.."/maps/")
end

function GameMenuM:update(dt)
end

function GameMenuM:draw()
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

function GameMenuM:mousepressed(x, y, button, istouch)
  openMap(self.project, self.maps[math.floor((y-300)/25)+1])
end

function GameMenuM:mousereleased(x, y, button, istouch)
end

function GameMenuM:keypressed(key, code)
  if key == "escape" then
    setCurrent("pmak-menu")
  end
end

function GameMenuM:wheelmoved(x, y)
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