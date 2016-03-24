pyDistance = function(a,b)
  return math.sqrt(math.pow(b.x-a.x,2) + math.pow(b.y-a.y,2))
end

in_array = function(a, b) 
  for _,c in ipairs(b) do
    if a == c then return true end
  end
  return false
end

function class(init)
  local c = {}
  c.__index = c

  local mt = {}
  mt.__call = function(class_tbl, ...)
    local obj = {}
    setmetatable(obj,c)
    if init then
      init(obj,...)
    end
    return obj
  end
  c.init = init
  setmetatable(c, mt)
  return c
end
