--
-- Created by IntelliJ IDEA.
-- User: mercu
-- Date: 2020/4/23
-- Time: 23:04
-- To change this template use File | Settings | File Templates.
--
local _G = _G
local feature_option = {
    param_check = false,
    has_func_env = false,
}

local __map_meta = {}
local function __map_creator()
    if feature_option.param_check then
        setmetatable({}, __map_meta)
    else
        return {}
    end
end
local __list_meta = {}
local function __list_creator()
    if feature_option.param_check then
        return setmetatable({}, __list_meta)
    else
        return {}
    end
end


function _G.map(key, value)
    return __map_creator
end

function _G.list(value)
    return __list_creator
end


local iotaKey = "iota"
local __iotaMeta = {
    __add = function(a, b)
        local iotaTable = type(a) == "table" and a or b
        local anotherValue = type(a) == "number" and a or b
        local iotaFunc = iotaTable[1]
        iotaTable[1] = function(iotaValue)
            return anotherValue + iotaFunc and iotaFunc(iotaValue) or iotaValue
        end
        return iotaTable
    end,

    __sub = function(a, b)
        local iotaTable = type(a) == "table" and a or b
        local anotherValue = type(a) == "number" and a or b
        local iotaFunc = iotaTable[1]
        iotaTable[1] = function(iotaValue)
            return anotherValue - iotaFunc and iotaFunc(iotaValue) or iotaValue
        end
        return iotaTable
    end,

    __mul = function(a, b)
        local iotaTable = type(a) == "table" and a or b
        local anotherValue = type(a) == "number" and a or b
        local iotaFunc = iotaTable[1]
        iotaTable[1] = function(iotaValue)
            return anotherValue * iotaFunc and iotaFunc(iotaValue) or iotaValue
        end
        return iotaTable
    end,

    __div = function(a, b)
        local iotaTable = type(a) == "table" and a or b
        local anotherValue = type(a) == "number" and a or b
        local iotaFunc = iotaTable[1]
        iotaTable[1] = function(iotaValue)
            return anotherValue / iotaFunc and iotaFunc(iotaValue) or iotaValue
        end
        return iotaTable
    end,
}

local function createIota()
    return setmetatable({}, __iotaMeta)
end

iota = createIota()

function _G.enum(t)
    local enumValue = {}
    local lastValue = 0
    local curIndex = 0
    local lastKey = nil
    local lastFunc = nil
    for index, value in ipairs(t) do
        local valueType = type(value)
        if valueType == "string" then
            curIndex = curIndex + 1
            lastValue = lastValue + 1
            enumValue[value] = lastFunc and lastFunc(lastValue) or lastValue
            lastKey = value
        elseif valueType == "number" then
            lastValue = value
            lastFunc = nil
            enumValue[lastKey] = lastValue
        elseif valueType == "table" then
            lastFunc = value[1]
            value[1] = nil
            lastValue = lastFunc(curIndex)
            enumValue[lastKey] =  lastValue
        else
            error("not support enum type " .. valueType)
        end
    end

end


local buildinType =
{
    ["boolean"] = false,
    ["number"] = 0,
    ["string"] = "",
    ["table"] = {},
    ["userdata"] = nil,
}

String = "string"
Number = "number"
Boolean = "boolean"
UserData = "userdata"

local metakey = {
    __name = "string",
    __type = "string",
    __mtable = "table",
    __func_def = "table",
    __module = "__module",
}

local TyStruct = "struct"
local TyInterface = "interface"

local function check_type(values, tyeps)
    local value_count = values and #values or 0
    local type_count = tyeps and #tyeps or 0
    if value_count ~= type_count then
        --TODO:支持变长参数
        error("param count not match")
        return
    end
    for index, value in ipairs(values) do
        local value_type = type(value)
        local def_type = tyeps[index]
        if value_type == "table" then
            if def_type == __map_creator and getmetatable(value) ~= __map_meta then
                error(string.format("param#%d error, need map", index))
                return
            end

            if def_type == __map_creator and getmetatable(value) ~= __list_meta then
                error(string.format("param#%d error, need list", index))
                return
            end

        else
            if value_type ~= def_type then
                error(string.format("param#%d error, need %s", index, def_type))
                return
            end
        end
    end
    return true
end

local function set_func_env(f, env)
    local tEnvValue = nil
    if feature_option.has_func_env then
        local tEnvValue = getfenv(f)
    else
        local iUpValue = 1
        while (true) do
            local name, value = debug.getupvalue(f, iUpValue)
            if name == nil then break end
            if name == "_ENV"then
                tEnvValue = value
                break
            end
            iUpValue = iUpValue + 1
        end
    end
    if tEnvValue ~= nil and tEnvValue ~= env then
        for k, v in pairs(env) do
            rawset(tEnvValue, k, v)
        end
    end
end

local func_def_meta = {
    __index = function(t, v)
        error("not found func body")
    end,
    __newindex = function(t, k, v)
        local func_body = v
        if (feature_option.param_check) then
            func_body = function(...)
                check_type({...}, t.params)
            end
        end
        if t.__receiver.__mtable then
            rawset(t.__receiver.__mtable, k, func_body)
        else
            t.__receiver[k] = func_body
        end

        set_func_env(func_body, t.__module)
        rawset(t, "params", nil)
        rawset(t, "rets", nil)
    end,
    __call = function(t, ...)
        local params = rawget(t, "params")
        if not params then
            rawset(t, "params", {...})
            return t
        end
        local rets = rawget(t, "rets")
        if not rets then
            rawset(t, "rets", {...})
            return t
        end
        error("func def format error")
    end,

}
function _G.func(receiver)
    if not receiver then
        receiver = _G
    end
    if not receiver.__func_def then
        rawset(receiver, "__func_def", setmetatable({__receiver = receiver, __module = _G.__module}, func_def_meta))
    end
    return receiver.__func_def
end

function _G.fn(...)
    return _G.fn
end

local raw_require = _G.require
local module_env_queue = {}
local module_queue = {}

function _G.package(name)
    local module = {}
    local moduleG = {
        __newindex = function(_, k, v)
            if type(v) == "table" and (v.__type == TyStruct or v.__type == TyInterface) then
                rawset(v, "__name", k)
            end
            rawset(module, k, v)
        end,

        __index = function(_, k)
            if k == metakey.__module then
                return module
            elseif k == iotaKey then
                return createIota()
            end
            return rawget(module, k)
        end,
    }
    local global_meta = getmetatable(_G)
    if global_meta then
        table.insert(module_env_queue, global_meta)
    end
    setmetatable(_G, moduleG)
    table.insert(module_queue, module)
end
local function _end_module()
    local env_count = #module_env_queue
    if env_count > 0 then
        setmetatable(_G, table.remove(module_env_queue, env_count))
    else
        setmetatable(_G, nil)
    end
    return table.remove(module_queue, #module_queue)
end

function _G.import(name)
    local loaded = package.loaded[name]
    if loaded then
        return loaded
    end

    local start_module_count = #module_queue
    local raw_result = raw_require(name)
    local end_module_count = #module_queue
    if end_module_count > start_module_count then
        assert(end_module_count == start_module_count + 1, "module queue not balance")
        return _end_module()
    end
    return raw_result
end


function _G.interface(define)
    define.__type = TyInterface
    return setmetatable(define, {
        __tostring = function() return  define.__type .. ":".. define.__name end
    })
end
function _G.struct(define)
    define.__mtable = {}
    define.__type = TyStruct
    return setmetatable(define, {
        __tostring = function() return  define.__type .. ":".. define.__name end,
        __newindex = function(t, k, v) error("can not add field to defined struct") end,
        --定义构造函数
        __call = function(def, params)
            --强制转换
            if params and params.__type == TyStruct then
                return params[define.__name]
            end
            local ret = {}
            local objName = tostring(ret) .. "#" ..define.__name
            local embed = {}
            --设置成员初始值
            for key, value in pairs(def) do
                if type(key) == "number" and value.__name then
                    key = value.__name
                    embed[key] = value
                end

                if not metakey[key] then
                    if params and params[key] then
                        ret[key] = params[key]
                    elseif type(value) == "table" and value.__type == "interface" then
                        ret[key] = nil
                    elseif buildinType[value] then
                        ret[key] = buildinType[value]
                    else
                        print("set field", key, value)
                        ret[key] = value()
                    end
                end
            end

            --设置成员方法(会隐藏内嵌结构方法)
            for name, func in pairs(def.__mtable) do
                ret[name] = func
            end
            --内嵌结构
            setmetatable(ret, {
                __tostring = function() return objName end,
                __newindex = function(t, k, v)
                    local foundEs
                    for name, es in pairs(embed) do
                        local esObj = rawget(t, name)
                        local value = esObj[k]
                        if value or (es[k] and es[k].__name == "interface") then
                            if foundEs then
                                error(string.format("repeat member name[%s] in embed struct", k))
                            end
                            esObj[k] = v
                            foundEs = true
                        end
                    end
                end,
                __index = function(t, k)
                    local foundValue
                    for name,_ in pairs(embed) do
                        local value = rawget(t, name)[k]
                        if value then
                            if foundValue then
                                error(string.format("repeat member name[%s] in embed struct", k))
                            end
                            foundValue = value
                        end
                    end
                    return foundValue
                end
            })
            return ret
        end
    })
end

local nullvalue = setmetatable({}, {
    __index = function(t, k)
        local value = rawget(t, "value")
        if not value then
            return _G.nullable(nil)
        else
            return _G.nullable(value[k])
        end
    end,
    __newindex = function(t, k, v)
        local value = rawget(t, "value")
        if value then
            value[k] = v
        end
    end,
    __call = function(t, ...)
        local value = rawget(t, "value")
        if value then
            value(...)
        end
    end
})
function _G.nullable(value)
    rawset(nullvalue, "value", value)
    return nullvalue
end

function _G.isnull(value)
    return value == nil or value == nullvalue
end