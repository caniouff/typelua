# typelua
lua with type,

# features
1.support by idea plugin(developping)

2.type feature looks like golang and simple
# demo
```Lua
module("PackageA")
--define a struct like golang
StructA = struct {
    name = "string", --string member
    id = "number", --number member
    mapData = map("string", "string"),
    listData = list("list"),
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
```
