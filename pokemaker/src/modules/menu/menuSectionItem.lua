MenuSectionItem = {}

function MenuSectionItem:new(o)
  local o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

function MenuSectionItem:init(id, weight)
  self.id = id or 0
  self.weight = weight or 0
end

function MenuSectionItem:update(dt)
end

function MenuSectionItem:draw()
end

function MenuSectionItem:mousepressed(x, y, button, istouch)
end

function MenuSectionItem:mousereleased(x, y, button, istouch)
end

function MenuSectionItem:keypressed(key, code)
end

function MenuSectionItem:wheelmoved(x, y)
end