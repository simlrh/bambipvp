local util = {}

util.pyDistance = function(a,b)
  return math.sqrt(math.pow(b.x-a.x,2) + math.pow(b.y-a.y,2))
end

util.in_array = function(a, b) 
  for k,v in pairs(b) do
    if a == v then return true end
  end
  return false
end

util.in_array_keys = function(a, b) 
  for k,v in pairs(b) do
    if a == k then return true end
  end
  return false
end

util.class = function (...)
  -- "cls" is the new class
  local cls, bases = {}, {...}
  -- copy base class contents into the new class
  for i, base in ipairs(bases) do
    for k, v in pairs(base) do
      cls[k] = v
    end
  end
  -- set the class's __index, and start filling an "is_a" table that contains this class and all of its bases
  -- so you can do an "instance of" check using my_instance.is_a[MyClass]
  cls.__index, cls.is_a = cls, {[cls] = true}
  for i, base in ipairs(bases) do
    for c in pairs(base.is_a) do
      cls.is_a[c] = true
    end
    cls.is_a[base] = true
  end
  -- the class's __call metamethod
  setmetatable(cls, {__call = function (c, ...)
    local instance = setmetatable({}, c)
    -- run the init method if it's there
    local init = instance._init
    if init then init(instance, ...) end
    return instance
  end})
  -- return the new class table, that's ready to fill with methods
  return cls
end

util.split = function(inputstr, sep)
  local t={} ; i=1
  for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
    t[i] = str
    i = i + 1
  end
  return t
end

util.head = function(tbl)
  r = ''
  for i, s in ipairs(tbl) do
    if i ~= #tbl then r = r..s end
  end
  return r
end

util.tail = function(tbl)
  return tbl[#tbl]
end

return util
