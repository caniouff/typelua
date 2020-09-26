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
# map
```Lua
local playerLevelMap = map(String, Number)
```

# list
```Lua
local playerNameList = list(String)
```

# package and import
## package
globals will be see as package fields
```Lua
package("GameMode")
GameMode = struct {
    serverName = String,
    mapName = String,
    playerCount = Number
}
--package var
Instance = GameMode()

--static
func(_)()(GameMode).GetPlayerCount = function()
    return Instance.playerCount
end
```

## import
```Lua
local GameMode = import("GameMode")
local playerCount = GameMode.GetPlayerCount()
local serverName = GameMode.Instance.serverName
```
