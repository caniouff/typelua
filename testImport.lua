local Test2 = import("typeTest")
local Test = import("typeTest")
package("TestImport")

PanelLogin = struct {
    account = "string",
    password = "string",
    loginTime = "number",
}

Instance = PanelLogin()

func(PanelLogin)("string", "string")("boolean").Login = function(self, account, password)
    self.account = account
    self.password = password
    return false
end

Instance:Login("1", "2")

Instance.password = 2
local b = (Test.StructB)()
b.dataMap["1"] = 1

