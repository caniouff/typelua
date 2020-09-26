# typelua
lua with type

# features
1.support by idea plugin(developping)

2.type feature looks like golang and simple

# struct
```Lua
Group = struct {
    name = String,
    id = Number,
    data = UserData
}
```
# inner struct
```Lua
ParentGroup = struct {
    name = String
}

Group = struct {
    ParentGroup,
    subName = String
}

local group = Group()
print(group.name, group.subName)
```
# struct method
```Lua
Group = struct {
    name = String,
    id = String,
}

func(Group)(Boolean)(String).GetName = function(self, bWithId)
    if bWithId then
        return name .. id
    else
        return name
    end
end
```

# function declare
```Lua
local Callback = fn(String.name)(String)

Group = struct {
    cb = Callback
}
func(Group)(Callback)().SetCallBack = function(self, cb)
    self.cb = cb
end
```

# interface 
```Lua
IGroup = interface {
    GetFullName = fn(String.name)(String)
}

Group = struct {
    name  = String
}
--implament interface
func(Group)(String)(String).GetFullName = function(self, prefix)
    return prefix .. self.name
end
```

# enum 
```Lua
EOrder = enum {
"First", iota * 2
"Second",
"Third"
}

print(EOrder.Third) --equls to 6
```

# nullable
```Lua
local a = Group()
a = nil
print(nullable(a).name) -- output empty string (default value of type)
```
# demo
```Lua
--TODO:
--[[
1.global define build-in type
String = "string"
Number = "number"
UserData = "userdata"
Boolean = "boolean"
2.new function declare
local callback = fn(String.name)(String)
IInterface = interface {
Open = fn(String.Ip, Number.Port),
}
--]]
module("PackageA")
--define a function type
local callback = func("string")("string") <= function(name) end

--define a struct like golang
StructA = struct {
    name = "string", --string member
    id = "number", --number member
    mapData = map("string", "string"),
    listData = list("list"),
    cb = callback,
}

local A = StructA()
A.name = "A"
A.id = 1

StructB = struct {
  StructA, --combine other class， like golang
  phone = "string" 
}

local B = StructB()
B.name = "B" --direct access combine member like golang
B.id = 2
B.phone = "086-12138"


--define member function
--func(receiver)(...parameters)(...returns).FunctionName = function(param1, param2)
func(StructA)("number", "string")("string").Name = function(key, value)
    local baseName = self.StructA:Name(key, value) --call inner struct func
    return self.name .. "->" .. baseName
end


--call member function
A:Name("a", "b")
B:Name("a", "b")

--define module or global func
--like member function but receiver is "_"
func(_)().ModuleFunc = function()
end

--call module or global func
ModuleFunc()

--interface
Handle = interface{
    handleName = "number" -- no need to writter setter and getter
}
--declare interface func
func(Handle)("string")("bool").HandleMsg = function(msg_str) return false end

--nullable support
local something = StructB()
somethin = nil
nullable(something).StructA.name = "error"

--new func define grammar
func(receiver).FuncName(paramlist...)(rets...) <= function(self, varlist)
    return ...
end
```
