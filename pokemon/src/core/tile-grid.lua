Tilegrid = {}

function Tilegrid:new(o)
   local o = o or {}
   setmetatable(o, self)
   self.__index = self
   return o
end

function Tilegrid:init()
end

function Tilegrid:update(dt)
end

function Tilegrid:draw()
end

function Tilegrid:mousepressed(x, y, button, istouch)
end

function Tilegrid:mousereleased(x, y, button, istouch)
end

function Tilegrid:keypressed(key, code)
end

function Tilegrid:wheelmoved(x, y)
end

function Tilegrid:getButton(id)
end

function Tilegrid:addButton(id, x, y, w, h, text, color, borderColor)
end

function Tilegrid:addImage(id, filename, x, y, scale)
end

function Tilegrid:addTextbox(id, x, y, text)
end

function Tilegrid:move(x, y)
end