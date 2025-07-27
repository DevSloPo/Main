local jump = false

local repo = 'https://raw.githubusercontent.com/deividcomsono/Obsidian/main/'

local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()
local Options = Library.Options
local Toggles = Library.Toggles

Library.ShowToggleFrameInKeybinds = true 
Library.ShowCustomCursor = true
Library.NotifySide = "Right"

local Window = Library:CreateWindow({
    Title = 'XK Hub V1.0',
    Footer = "作者:小玄奘",
    Icon = 97837015726495,
    Center = true,
    AutoShow = true,
    Resizable = true,
    ShowCustomCursor = true,
    NotifySide = "Right",
    TabPadding = 8,
    MenuFadeTime = 0
})
local Tabs = {
    B = Window:AddTab("基础功能", "house"),
    C = Window:AddTab("主要功能", "boxes"),
    A = Window:AddTab("视觉功能", "scan-eye"),
    R = Window:AddTab("信息", "biohazard"),    
    ["UI Settings"] = Window:AddTab("界面设置", "settings"),
}
--基础功能
local A = Tabs.B:AddLeftGroupbox('玩家')
local B = Tabs.B:AddRightGroupbox('杂项')
--主要功能
local a = Tabs.C:AddRightGroupbox('跳跃')
local S = Tabs.C:AddLeftGroupbox('玩家')
local m = Tabs.C:AddLeftGroupbox('怪物')
--视觉
local E = Tabs.A:AddLeftGroupbox('ESP')
local W = Tabs.A:AddRightGroupbox('环境')

local J = Tabs.R:AddLeftGroupbox('关于脚本')

J:AddLabel("[ESP]制作-小玄")
J:AddLabel("[ESP]仿制的mspaint ESP")
J:AddLabel("[ESP字体]Enum.Font.RobotoCondensed")

local I = Tabs.R:AddRightGroupbox('脚本制作')

I:AddLabel("功能参考 - mspaint ESP")
I:AddLabel("脚本所有者 - 小玄")
I:AddLabel("脚本制作者 - 小玄")

B:AddButton({
    Text = "重置",
    Func = function()
        if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
            game.Players.LocalPlayer.Character.Humanoid.Health = 0
        end
    end,
    DoubleClick = true, 
})

B:AddButton({
    Text = "重新加入服务器",
    Func = function()
        game:GetService("TeleportService"):Teleport(game.PlaceId)
    end,
    DoubleClick = true, 
})

A:AddToggle('Lol', {
    Text = '速度',
    Default = false,
    Callback = function(v)
    if v == true then
        sudu = game:GetService("RunService").Heartbeat:Connect(function()
            if game:GetService("Players").LocalPlayer.Character and game:GetService("Players").LocalPlayer.Character.Humanoid and game:GetService("Players").LocalPlayer.Character.Humanoid.Parent then
                if game:GetService("Players").LocalPlayer.Character.Humanoid.MoveDirection.Magnitude > 0 then
                    game:GetService("Players").LocalPlayer.Character:TranslateBy(game:GetService("Players").LocalPlayer.Character.Humanoid.MoveDirection * Speed / 20)
                end
            end
        end)
    elseif not v and sudu then
        sudu:Disconnect()
        sudu = nil
    end
    end
})

A:AddSlider("HealthThreshold", {
    Text = "速度",
    Min = 0,
    Max = 200, 
    Default = 10,
    Compact = true,
    Rounding = 0,
    Callback = function(v)
        Speed = v
    end
})

A:AddDivider()

local active, taskRef

A:AddToggle('秒互动', {
    Text = '快速互动',
    Default = false,
    Callback = function(state)
        active = state
        if active then
            local promptService = game:GetService("ProximityPromptService")
            promptService.PromptButtonHoldBegan:Connect(function(prompt)
                prompt.HoldDuration = 0
            end)
            
            taskRef = task.spawn(function()
                while active do
                    for _, prompt in next, workspace:GetDescendants() do
                        if prompt:IsA("ProximityPrompt") then
                            prompt.HoldDuration = 0
                        end
                    end
                    task.wait(1) 
                end
            end)
        elseif taskRef then
            task.cancel(taskRef)
            taskRef = nil
        end
    end
})

A:AddToggle('Lol', {
    Text = '禁止虚空伤害',
    Default = false,
    Callback = function(Value)
    if Value then
        game:GetService("Workspace").FallenPartsDestroyHeight = (0 / 0)
    else
        game:GetService("Workspace").FallenPartsDestroyHeight = (1 / 1)
    end
    end
})

A:AddToggle("AFK", {
    Text = "防挂机",
    Default = false,
    Callback = function(state)
        if state then
            local VirtualUser = game:GetService("VirtualUser")
            local LocalPlayer = Players.LocalPlayer
            local antiAFKConnection
            local idleConnection
            local lastMove = tick()
            local function antiAFK()
                antiAFKConnection = RunService.PreRender:Connect(function()
                    
                    if tick() - lastMove >= 15 * 60 then
                        pcall(function()
                            VirtualUser:CaptureController()
                            VirtualUser:ClickButton2(Vector2.new())
                        end)
                        lastMove = tick()
                    end
                end)
            end
            idleConnection = LocalPlayer.Idled:Connect(function()              
                pcall(function()
                    VirtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
                    wait(1)
                    VirtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
                end)
            end)
            antiAFK()  
        else           
            if antiAFKConnection then
                antiAFKConnection:Disconnect()
                antiAFKConnection = nil
            end
            if idleConnection then
                idleConnection:Disconnect()
                idleConnection = nil
            end
        end
    end
})

a:AddToggle('Lol', {
    Text = '无限跳',
    Default = false,
    Callback = function(state)
    Jump = state
    game.UserInputService.JumpRequest:Connect(function()
        if Jump then
            game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
        end
    end)
    end
})

a:AddToggle("AutoJump", {
    Text = "自动跳跃",
    Default = false,
    Callback = function(state)
        if state then
            local player = game.Players.LocalPlayer
            local conn
            
            local function jumpLoop()
                while state do
                    if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
                        player.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                    end
                    task.wait(0.1)
                end
            end
            
            local function onCharacterAdded(character)
                if conn then conn:Disconnect() end
                conn = character:GetPropertyChangedSignal("Parent"):Connect(function()
                    if not character.Parent then
                        if conn then conn:Disconnect() end
                        task.spawn(jumpLoop)
                    end
                end)
                task.spawn(jumpLoop)
            end
            
            player.CharacterAdded:Connect(onCharacterAdded)
            if player.Character then
                onCharacterAdded(player.Character)
            end
        end
    end
})
S:AddToggle("", {
    Text = "自动重生",
    Default = false,
    Callback = function(v)
        if v then
            local events = game:GetService("ReplicatedStorage"):FindFirstChild("events")
            if events then
                local player = events:FindFirstChild("player")
                if player then
                    local char = player:FindFirstChild("char")
                    if char then
                        local respawn = char:FindFirstChild("respawnchar")
                        if respawn then
                            respawn:FireServer()
                        end
                    end
                end
            end
        end
    end
})

local speedEnabled = false

S:AddToggle("EnableSprintSpeed", {
    Text = "启用奔跑速度",
    Default = false,
    Callback = function(state)
        speedEnabled = state
        if state then
            game:GetService("ReplicatedStorage").module.specificsModule.SprintSpeed.Value = A:GetSlider("HealthThreshold").Value
        end
    end
})

S:AddSlider("HealthThreshold", {
    Text = "奔跑速度",
    Min = 30,
    Max = 1000, 
    Default = 30,
    Compact = true,
    Rounding = 0,
    Callback = function(value)
        if speedEnabled then
            game:GetService("ReplicatedStorage").module.specificsModule.SprintSpeed.Value = value
        end
    end
})

local autoAvoid = {
    Enabled = false,
    DetectionRange = 30,
    TeleportDistance = 50
}

local function findSafePosition(currentPos)
    local direction = Vector3.new(math.random(-100,100),0,math.random(-100,100)).Unit
    return currentPos + (direction * autoAvoid.TeleportDistance)
end

local function checkMonsters()
    if not autoAvoid.Enabled then return end
    
    local player = game.Players.LocalPlayer
    local character = player.Character
    if not character then return end
    
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end
    
    local botsFolder = workspace:FindFirstChild("bots")
    if not botsFolder then return end
    
    for _, bot in ipairs(botsFolder:GetChildren()) do
        local botRoot = bot:FindFirstChild("HumanoidRootPart") or bot.PrimaryPart
        if botRoot then
            local distance = (humanoidRootPart.Position - botRoot.Position).Magnitude
            if distance < autoAvoid.DetectionRange then
                humanoidRootPart.CFrame = CFrame.new(findSafePosition(humanoidRootPart.Position))
                return
            end
        end
    end
end

m:AddToggle("AutoAvoidToggle", {
    Text = "自动躲怪",
    Default = false,
    Callback = function(state)
        autoAvoid.Enabled = state
    end
})

m:AddSlider("DetectionRangeSlider", {
    Text = "检测范围",
    Min = 5,
    Max = 100,
    Default = 30,
    Rounding = 0,
    Callback = function(value)
        autoAvoid.DetectionRange = value
    end
})

m:AddSlider("TeleportDistanceSlider", {
    Text = "传送距离",
    Min = 10,
    Max = 200,
    Default = 50,
    Rounding = 0,
    Callback = function(value)
        autoAvoid.TeleportDistance = value
    end
})

task.spawn(function()
    while task.wait(0.1) do
        checkMonsters()
    end
end)



local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")

local HighlightControl = {
    Enabled = false,
    Connection = nil,
    CurrentColor = Color3.new(1, 1, 1),
    Original = {
        Ambient = Lighting.Ambient,
        ColorShift_Bottom = Lighting.ColorShift_Bottom,
        ColorShift_Top = Lighting.ColorShift_Top
    }
}

W:AddToggle("NightVision", {
    Text = "夜视",
    Default = false,
    Callback = function(state)
        HighlightControl.Enabled = state

        if HighlightControl.Connection then
            HighlightControl.Connection:Disconnect()
            HighlightControl.Connection = nil
        end

        if state then
            HighlightControl.Connection = RunService.RenderStepped:Connect(function()
                Lighting.Ambient = HighlightControl.CurrentColor
                Lighting.ColorShift_Bottom = HighlightControl.CurrentColor
                Lighting.ColorShift_Top = HighlightControl.CurrentColor
            end)
        else
            Lighting.Ambient = HighlightControl.Original.Ambient
            Lighting.ColorShift_Bottom = HighlightControl.Original.ColorShift_Bottom
            Lighting.ColorShift_Top = HighlightControl.Original.ColorShift_Top
        end
    end
}):AddColorPicker("NightVisionColor", {
    Title = "夜视颜色",
    Default = Color3.new(1, 1, 1),
    Transparency = 0,
    Callback = function(color)
        HighlightControl.CurrentColor = color
    end
})

W:AddToggle("无阴影", {
    Text = "无阴影",
    Default = false,
    Callback = function(v)
        game:GetService("Lighting").GlobalShadows = not v and true or false
    end
})
    
local originalFogEnd = game:GetService("Lighting").FogEnd
local originalAtmospheres = {}

W:AddToggle('MyToggle', {
    Text = '除雾',
    Default = false,
    Callback = function(state)
        local Lighting = game:GetService("Lighting")
        if state then           
            originalFogEnd = Lighting.FogEnd
            originalAtmospheres = {}
            for _, v in pairs(Lighting:GetDescendants()) do
                if v:IsA("Atmosphere") then
                    table.insert(originalAtmospheres, v:Clone())
                    v:Destroy()
                end
            end
            Lighting.FogEnd = 100000
        else            
            Lighting.FogEnd = originalFogEnd           
            for _, atmosphere in pairs(originalAtmospheres) do
                atmosphere.Parent = Lighting
            end
        print('nil')   
        end
    end
})

local botESP = {
    enabled = false,
    connection = nil,
    outlineColor = Color3.fromRGB(255, 0, 0),  
    fillColor = Color3.fromRGB(128, 0, 0),   
    fillTransparency = 0.5,
    outlineTransparency = 0.1,
    ignoreSelf = true  
}

local localPlayer = game:GetService("Players").LocalPlayer

local function getBotName(model)
    return model.Name  
end

local function isSelf(model)
    return model == localPlayer.Character
end

local function getHealth(model)
    local humanoid = model:FindFirstChildOfClass("Humanoid")
    if humanoid and humanoid.MaxHealth > 0 then
        return math.floor((humanoid.Health / humanoid.MaxHealth) * 100) .. "%"
    end
    return "0%"
end

local function getDistance(model)
    if localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local rootPart = model:FindFirstChild("HumanoidRootPart") or model.PrimaryPart
        if rootPart then
            return math.floor((localPlayer.Character.HumanoidRootPart.Position - rootPart.Position).Magnitude)
        end
    end
    return "N/A"
end

local function applyHighlightSettings(highlight, settings)
    highlight.FillColor = settings.fillColor
    highlight.FillTransparency = settings.fillTransparency or 0.5
    highlight.OutlineColor = settings.outlineColor
    highlight.OutlineTransparency = settings.outlineTransparency or 0.1
end

local function createBotESP(model)
    if not model:IsA("Model") then return end
    
    if botESP.ignoreSelf and isSelf(model) then return end

    local part = model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart")
    if not part then return end

    for _, name in ipairs({"BotBillboard", "BotHighlight"}) do
        local old = model:FindFirstChild(name)
        if old then old:Destroy() end
    end

    local billboard = Instance.new("BillboardGui", model)
    billboard.Name = "BotBillboard"
    billboard.Adornee = part
    billboard.Size = UDim2.new(0, 100, 0, 40)
    billboard.StudsOffset = Vector3.new(0, 1, 0)
    billboard.AlwaysOnTop = true

    local nameLabel = Instance.new("TextLabel", billboard)
    nameLabel.Name = "NameLabel"
    nameLabel.Size = UDim2.new(1, 0, 0, 20)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = string.format("%s [%s]", getBotName(model), getHealth(model))
    nameLabel.TextColor3 = botESP.outlineColor
    nameLabel.TextSize = 20
    nameLabel.Font = Enum.Font.RobotoCondensed

    local stroke = Instance.new("UIStroke", nameLabel)
    stroke.Thickness = 1.5
    stroke.Color = Color3.new(0, 0, 0)
    
    local distanceLabel = Instance.new("TextLabel", billboard)
    distanceLabel.Name = "DistanceLabel"
    distanceLabel.Position = UDim2.new(0, 0, 0, 20)
    distanceLabel.Size = UDim2.new(1, 0, 0, 16)
    distanceLabel.BackgroundTransparency = 1
    distanceLabel.Text = "["..getDistance(model).."]"
    distanceLabel.TextColor3 = botESP.outlineColor
    distanceLabel.TextSize = 18
    distanceLabel.Font = Enum.Font.RobotoCondensed

    local stroke2 = Instance.new("UIStroke", distanceLabel)
    stroke2.Thickness = 1
    stroke2.Color = Color3.new(0, 0, 0)
   
    local highlight = Instance.new("Highlight", model)
    highlight.Name = "BotHighlight"
    applyHighlightSettings(highlight, botESP)
end

local function updateBotESP(model)
    if not model:IsA("Model") then return end
    
    if botESP.ignoreSelf and isSelf(model) then return end

    local billboard = model:FindFirstChild("BotBillboard")
    if not billboard then return end

    local nameLabel = billboard:FindFirstChild("NameLabel")
    if nameLabel then
        nameLabel.Text = string.format("%s [%s]", getBotName(model), getHealth(model))
    end

    local distanceLabel = billboard:FindFirstChild("DistanceLabel")
    if distanceLabel then
        distanceLabel.Text = "["..getDistance(model).."]"
    end
end

local function clearBotESP(folder)
    for _, model in ipairs(folder:GetChildren()) do
        for _, name in ipairs({"BotBillboard", "BotHighlight"}) do
            local item = model:FindFirstChild(name)
            if item then item:Destroy() end
        end
    end
end

local function refreshBotESP()
    local folder = workspace.bots
    if not folder then return end

    if botESP.enabled then
        clearBotESP(folder)
        for _, v in ipairs(folder:GetChildren()) do
            createBotESP(v)
        end
    end
end

game:GetService("RunService").Heartbeat:Connect(function()
    if botESP.enabled and workspace:FindFirstChild("bots") then
        for _, v in ipairs(workspace.bots:GetChildren()) do
            updateBotESP(v)
        end
    end
end)

E:AddToggle("BotESP", {
    Text = "机器人",
    Default = false,
    Callback = function(state)
        botESP.enabled = state
        local folder = workspace.bots

        if state then
            if not folder then 
                print('nil')
                return 
            end

            for _, v in ipairs(folder:GetChildren()) do
                createBotESP(v)
            end

            if botESP.connection then
                botESP.connection:Disconnect()
            end

            botESP.connection = folder.ChildAdded:Connect(function(v)
                task.wait(0.1)
                createBotESP(v)
            end)
        else
            if botESP.connection then
                botESP.connection:Disconnect()
                botESP.connection = nil
            end
            if folder then
                clearBotESP(folder)
            end
        end
    end
}):AddColorPicker("BotColor", {
    Default = botESP.outlineColor,
    Title = "机器人颜色",
    Transparency = 0,
    Callback = function(color)
        botESP.outlineColor = color
        botESP.fillColor = Color3.new(color.R * 0.5, color.G * 0.5, color.B * 0.5)
        refreshBotESP()
    end
})

E:AddToggle("MonkeyESP", {
    Text = "僵尸",
    Default = false,
    Callback = function(state)
        local monkeySettings = {
            id = "zombieESP",
            settings = {
                TargetName = "zombie", 
                TargetType = "Model",
                CustomText = "僵尸",
                TextColor = _G.monkeyEspColor or Color3.fromRGB(0, 255, 0), 
                TextSize = 20,
                CheckForHumanoid = false, 
                FillColor = _G.monkeyEspColor or Color3.fromRGB(0, 255, 0),
                FillTransparency = 0.5,
                OutlineColor = Color3.fromRGB(0, 0, 0),
                OutlineTransparency = 0
            }
        }

        if state then
            DripESP.SetOptions(monkeySettings.id, monkeySettings.settings)
            DripESP.Enable(monkeySettings.id)
        else
            DripESP.Disable(monkeySettings.id)
        end
    end
}):AddColorPicker("MonkeyESPColor", {
    Title = "Monkey Color",
    Default = Color3.fromRGB(0, 255, 0),
    Callback = function(newColor)
        _G.monkeyEspColor = newColor
        if A:GetToggle("MonkeyESP") then
            DripESP.SetOptions("MonkeyESP", {
                TextColor = newColor,
                FillColor = newColor
            })
        end
    end
})


local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local ESPEnabled = false
local ESPStorage = {}

local ESPSettings = {
    MainColor = Color3.fromRGB(255, 255, 255),    
    StrokeThickness = 1.3,                    
    Font = Enum.Font.RobotoCondensed,          
    TextSize = 20,                             
    StudsOffset = Vector3.new(0, 2, 0),         
    BillboardSize = UDim2.new(0, 100, 0, 40)    
}

local function createESP(player)
    if player == LocalPlayer or ESPStorage[player] then return end

    local function setup()
        local character = player.Character or player.CharacterAdded:Wait()
        local root = character:WaitForChild("HumanoidRootPart", 5)
        local humanoid = character:FindFirstChildOfClass("Humanoid")

        if not root or not humanoid then return end

        local bill = Instance.new("BillboardGui")
        bill.Name = "PlayerESP"
        bill.Adornee = root
        bill.AlwaysOnTop = true
        bill.Size = ESPSettings.BillboardSize
        bill.StudsOffset = ESPSettings.StudsOffset
        bill.Parent = root

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.TextColor3 = ESPSettings.MainColor
        label.Font = ESPSettings.Font
        label.TextSize = ESPSettings.TextSize
        label.Text = ""
        label.Parent = bill
        
        local stroke = Instance.new("UIStroke")
        stroke.Parent = label
        stroke.Color = Color3.new(0, 0, 0)  
        stroke.Thickness = ESPSettings.StrokeThickness

        local highlight = Instance.new("Highlight")
        highlight.Name = "PlayerHighlight"
        highlight.FillColor = ESPSettings.MainColor
        highlight.OutlineColor = Color3.new(1, 1, 1)  
        highlight.Adornee = character
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        highlight.Parent = character

        ESPStorage[player] = {
            Label = label,
            Billboard = bill,
            Highlight = highlight,
            Humanoid = humanoid,
            Root = root,
            Character = character,
        }
    end

    task.spawn(setup)
end

local function removeESP(player)
    if ESPStorage[player] then
        local info = ESPStorage[player]
        if info.Billboard then info.Billboard:Destroy() end
        if info.Highlight then info.Highlight:Destroy() end
        ESPStorage[player] = nil
    end
end

local function refreshAll()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            if ESPEnabled then
                createESP(player)
            else
                removeESP(player)
            end
        end
    end
end

local function updateAllESPColors()
    for player, data in pairs(ESPStorage) do
        if data.Label then
            data.Label.TextColor3 = ESPSettings.MainColor
        end
        if data.Highlight then
            data.Highlight.FillColor = ESPSettings.MainColor
        end
    end
end

RunService.RenderStepped:Connect(function()
    if not ESPEnabled then return end

    for player, data in pairs(ESPStorage) do
        if player.Character and data.Humanoid and data.Root then
            local dist = math.floor((data.Root.Position - Camera.CFrame.Position).Magnitude)
            local hp = math.floor(data.Humanoid.Health)
            data.Label.Text = string.format("%s[%d]\n[%d]", player.Name, hp, dist)
        end
    end
end)

Players.PlayerAdded:Connect(function(player)
    if player ~= LocalPlayer and ESPEnabled then 
        createESP(player) 
    end
end)

Players.PlayerRemoving:Connect(function(player)
    removeESP(player)
end)

E:AddToggle("ItemESP", {
    Text = "玩家",
    Default = false,
    Callback = function(state)
        ESPEnabled = state
        refreshAll()
    end
}):AddColorPicker("PlayerESPColor", {
    Title = "玩家颜色",
    Default = ESPSettings.MainColor,
    Callback = function(newColor)
        ESPSettings.MainColor = newColor
        updateAllESPColors()
    end
})

local MenuGroup = Tabs["UI Settings"]:AddLeftGroupbox("调试功能")

MenuGroup:AddToggle("KeybindMenuOpen", {
    Default = Library.KeybindFrame.Visible,
    Text = "快捷菜单",
    Callback = function(value)
        Library.KeybindFrame.Visible = value
    end,
})

MenuGroup:AddToggle("ShowCustomCursor", {
    Text = "自定义光标",
    Default = true,
    Callback = function(Value)
        Library.ShowCustomCursor = Value
    end,
})

MenuGroup:AddDropdown("NotificationSide", {
    Values = { "左", "右" },
    Default = "右",
    Text = "通知位置",
    Callback = function(Value)
        Library:SetNotifySide(Value)
    end,
})

MenuGroup:AddDropdown("DPIDropdown", {
    Values = { "25%", "50%", "75%", "100%", "125%", "150%", "175%", "200%" },
    Default = "100%",
    Text = "UI大小",
    Callback = function(Value)
        Value = Value:gsub("%%", "")
        local DPI = tonumber(Value)
        Library:SetDPIScale(DPI)
    end,
})

MenuGroup:AddDivider()  
MenuGroup:AddLabel("Menu bind")  
    :AddKeyPicker("MenuKeybind", { 
        Default = "RightShift",  
        NoUI = true,            
        Text = "Menu keybind"    
    })

MenuGroup:AddButton("删除UI", function()
    Library:Unload()  
end)

ThemeManager:SetLibrary(Library)  
SaveManager:SetLibrary(Library)   
SaveManager:IgnoreThemeSettings() 

SaveManager:SetIgnoreIndexes({ "MenuKeybind" })  
ThemeManager:SetFolder("MyScriptHub")            
SaveManager:SetFolder("MyScriptHub/specific-game")  
SaveManager:SetSubFolder("specific-place")       
SaveManager:BuildConfigSection(Tabs["UI Settings"])  

ThemeManager:ApplyToTab(Tabs["UI Settings"])

SaveManager:LoadAutoloadConfig()