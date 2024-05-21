MenuSectionM = {}

function MenuSectionM:new(o)
  local o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

function MenuSectionM:init(id)
  self.id = id or 0
end

function MenuSectionM:update(dt)
end

function MenuSectionM:draw()
end

function MenuSectionM:mousepressed(x, y, button, istouch)
end

function MenuSectionM:mousereleased(x, y, button, istouch)
end

function MenuSectionM:keypressed(key, code)
end

function MenuSectionM:wheelmoved(x, y)
end