local background = love.graphics.newImage("pokemaker/assets/menu/background.png")

PokemakerMenu = {}

function PokemakerMenu:new(o)
   local o = o or {}
   setmetatable(o, self)
   self.__index = self
   return o
end

function PokemakerMenu:init()
   self.projects = dirLookup("/home/will-roy/dev/pokemon3/pokemaker/projects/")

   local mainX = 1300
   local mainY = 1000
   -- love.window.setMode(mainX, mainY, {resizable=true})
end

function PokemakerMenu:update(dt)
end

function PokemakerMenu:draw()
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

function PokemakerMenu:mousepressed(x, y, button, istouch)
   openFile(self.projects[math.floor((y-300)/25)+1])
end

function PokemakerMenu:mousereleased(x, y, button, istouch)
end

function PokemakerMenu:keypressed(key, code)
   if key == "escape" then
      love.event.push("quit")
   end
end

function PokemakerMenu:wheelmoved(x, y)
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