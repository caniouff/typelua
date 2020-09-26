--
-- Created by IntelliJ IDEA.
-- User: mercu
-- Date: 2020/4/23
-- Time: 23:01
-- To change this template use File | Settings | File Templates.
--
package("Test")
StructA = struct {
    name = "string",
    number = "number",
}

StructB = struct {
    StructA,
    key = "string",
    dataMap = map("string", "number"),
    dataList = list(StructA),
}


func(StructA)("number", "string")("string").Name = function(self, key, value)
    print(self.number)
    self.number = 2
    return "Namesdddd"
end
func(StructB)("number", "string")("string").Name = function(self, key, value)
    print("StructB:Name")
    return StructA(self):Name(1,"")
end

func(StructA)("string")("number").NameLength = function(self, suffix)
    print("StructA:NameLength")
    return 0
end

func(_)("number").ModuleFunc = function(key)
    print("_:ModuleFunc")
end

ModuleFunc(1)
local A = StructA()
print(A)
A.name = "A"
A.number = 2

local B = StructB()
B.name = "B"
B.number = 3
local mapValue = B.dataMap["2"]
print(mapValue)
local listValue = B.dataList[1]
print(listValue)
local name = A:Name(1, "b")
print(name)
A:Name("a", "b")

ModuleFunc(1, 2, 3)

nullable(B).dataMap["B"] = 1


