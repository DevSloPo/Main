local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Rooms = workspace.CurrentRooms
local LocalPlayer = game.Players.LocalPlayer
local AntiConnections = {}
local ESPLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/DevSloPo/ESP_Xuan/refs/heads/main/Library.lua"))()
local XKHub = loadstring(game:HttpGet(('https://raw.githubusercontent.com/DevSloPo/Notification/refs/heads/main/Source.lua')))()
local XKHax = loadstring(game:HttpGet('https://raw.githubusercontent.com/DevSloPo/XKHax-Notification/refs/heads/main/Source.lua'))()
local repo = "https://raw.githubusercontent.com/DasVelocity/Obsidian/main/"
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
    Title = 'XK Hub丨Doors 测试版',
    Footer = "Roblox XK Hub 功能版 通用 V1.2版本",
    Icon = 130580192237985,
    Center = true,
    AutoShow = true,
    Resizable = true,
    ShowCustomCursor = true,
    NotifySide = "Right",
    TabPadding = 8,
    MenuFadeTime = 0
})
local Tabs = {
N = Window:AddTab("介绍", "user"),
E = Window:AddTab("主要", "house"),
K = Window:AddTab("自动", "moon"),
M = Window:AddTab("防止", "boxes"),
H = Window:AddTab("ESP", "eye"),
P = Window:AddTab("视觉", "scan-eye"),
S = Window:AddTab("户外", "sword"),
R = Window:AddTab("Rooms", "eye"),
["UI Settings"] = Window:AddTab("界面设置", "settings"),
}

local ONW = Tabs.N:AddLeftGroupbox('主要:')

ONW:AddLabel("制作者: Dev 小玄")
ONW:AddLabel("🔥XK Hub🔥")
ONW:AddLabel("脚本暂时只有我一个人制作，并且bug较多💔")
ONW:AddLabel("功能也有很多缺陷，我会努力的✨")
ONW:AddLabel("将来我可能会结识一些人制作脚本🎉")
ONW:AddLabel("感谢你一直以来的支持😒")
local AH = Tabs.N:AddRightGroupbox('群组💬')

AH:AddButton({
	Text = "复制QQ群聊[主群]",
	Func = function()
		setclipboard("915207093")
	end,
})

AH:AddButton({
	Text = "复制群聊[二群]",
	Func = function()
		setclipboard("685243242")
	end,
})

AH:AddButton({
	Text = "复制群聊[三群]",
	Func = function()
		setclipboard("1063263540")
	end,
})

AH:AddButton({
	Text = "复制群聊[解卡]",
	Func = function()
		setclipboard("1033392207")
	end,
})

local NB = Tabs.N:AddLeftGroupbox('脚本信息:')

NB:AddLabel("🔥此脚本创立于2024年6月份🔥")
NB:AddLabel("如果你想一起和我制作XK Hub😳")
NB:AddLabel("我们很欢迎你来找我👍🏻")
NB:AddLabel("或者帮助/支持我们Doors👁️")

local MovementGroup = Tabs.E:AddLeftGroupbox("速度绕过")
local MovementGroupZ = Tabs.E:AddRightGroupbox("主要")
local W = Tabs.E:AddLeftGroupbox('玩家')
local E = Tabs.H:AddLeftGroupbox('ESP')
local PPP = Tabs.P:AddRightGroupbox('视觉')
local A = Tabs.E:AddRightGroupbox('互动')
local S = Tabs.E:AddLeftGroupbox('实体通知')
local Q = Tabs.M:AddLeftGroupbox('主要')
local M = Tabs.M:AddRightGroupbox('其他')
local SeekGroup = Tabs.H:AddRightGroupbox('Seek')
local tab = Tabs.S:AddLeftGroupbox('防止')
local AU = Tabs.S:AddLeftGroupbox('实体通知')
local OP = Tabs.S:AddRightGroupbox('ESP')
local pop = Tabs.H:AddRightGroupbox('玩家')
local RoomsGroup = Tabs.R:AddLeftGroupbox('自动')
local RoomDisplayGroup = Tabs.R:AddLeftGroupbox('门牌')
local Ro = Tabs.R:AddRightGroupbox('提示')
local MenuGroup = Tabs["UI Settings"]:AddLeftGroupbox("主要")
local VisualEffects = Tabs.P:AddLeftGroupbox('视觉')
local AutomationGroup = Tabs.K:AddLeftGroupbox('自动功能')
local BBB = Tabs.K:AddRightGroupbox('自动游戏')

BBB:AddCheckbox("AutoCrouch", {
    Text = "自动使用蹲下",
    Default = false,
    Callback = function(state)
        AutoUseCrouch = state
    end,
})

Screech, ClutchHeart, AutoUseCrouch = false, false, false
local old
old = hookmetamethod(game,"__namecall",newcclosure(function(self,...)
    local args = {...}
    local method = getnamecallmethod()
    if tostring(self) == "Screech" and method == "FireServer" and Screech == true then
        args[1] = true
        return old(self,unpack(args))
    end
    if tostring(self) == "ClutchHeartbeat" and method == "FireServer" and ClutchHeart == true then
        args[2] = true
        return old(self,unpack(args))
    end
    if self.Name == "Crouch" and method == "FireServer" and AutoUseCrouch == true then
        args[1] = true
        return old(self,unpack(args))
    end
    return old(self,...)
end))

local AutoClutchHeart = {
    Enabled = false,
    HookInitialized = false
}

if not AutoClutchHeart.HookInitialized then
    local old
    old = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
        local args = {...}
        local method = getnamecallmethod()
        
        if tostring(self) == "ClutchHeartbeat" and method == "FireServer" and AutoClutchHeart.Enabled then
            args[2] = true
            return old(self, unpack(args))
        end
        return old(self, ...)
    end))
    AutoClutchHeart.HookInitialized = true
end

BBB:AddCheckbox("AutoClutchHeart", {
    Text = "自动心跳胜利",
    Default = false,
    Callback = function(state)
        AutoClutchHeart.Enabled = state
        ClutchHeart = state
    end,
})

AutomationGroup:AddToggle("AnchorAutoSolve", {
    Text = "自动锚点",
    Default = false,
    Callback = function(state)
        if state then
            AntiConnections["AnchorAutoSolve"] = RunService.Heartbeat:Connect(function()
                if not Toggles.AnchorAutoSolve.Value then return end
                
                for _, room in pairs(Rooms:GetChildren()) do
                    local nestHandler = room:FindFirstChild("_NestHandler")
                    if nestHandler then
                        local anchorBase = nestHandler:FindFirstChild("AnchorBase")
                        if anchorBase then
                            local distance = (LocalPlayer.Character.HumanoidRootPart.Position - anchorBase.Position).Magnitude
                            if distance < 10 then
                                local code = nestHandler:GetAttribute("Code")
                                if code then
                                    ReplicatedStorage.RemotesFolder.AnchorCode:FireServer(code)
                                end
                            end
                        end
                    end
                end
            end)
        else
            if AntiConnections["AnchorAutoSolve"] then AntiConnections["AnchorAutoSolve"]:Disconnect() end
        end
    end,
})

AutomationGroup:AddToggle("AutoPadlockSolve", {
    Text = "自动解锁图书馆密码锁",
    Default = false,
    Callback = function(state)
        if state then
            AntiConnections["AutoPadlockSolve"] = RunService.Heartbeat:Connect(function()
                if not Toggles.AutoPadlockSolve.Value then return end
                
                for _, room in pairs(Rooms:GetChildren()) do
                    local padlock = room:FindFirstChild("Padlock")
                    if padlock then
                        local distance = (LocalPlayer.Character.HumanoidRootPart.Position - padlock.Position).Magnitude
                        if distance < Options.AutoPadlockSolveDistance.Value then
                            local code = ""
                            -- 查找密码书
                            for _, book in pairs(room:GetDescendants()) do
                                if book.Name == "LiveHintBook" and book:FindFirstChild("SurfaceGui") then
                                    local surfaceGui = book.SurfaceGui
                                    if surfaceGui:FindFirstChild("TextLabel") then
                                        code = surfaceGui.TextLabel.Text
                                        break
                                    end
                                end
                            end
                            
                            if code ~= "" then
                                ReplicatedStorage.RemotesFolder.PadlockCode:FireServer(code)
                            end
                        end
                    end
                end
            end)
        else
            if AntiConnections["AutoPadlockSolve"] then AntiConnections["AutoPadlockSolve"]:Disconnect() end
        end
    end,
})

AutomationGroup:AddSlider("AutoPadlockSolveDistance", {
    Text = "解锁距离",
    Default = 25,
    Min = 10,
    Max = 50,
    Rounding = 0,
    Compact = false,
    Tooltip = "Distance to auto-input padlock code."
})

AutomationGroup:AddToggle("MinecartInteract", {
    Text = "自动矿车交互",
    Default = false,
    Callback = function(state)
        if state then
            AntiConnections["MinecartInteract"] = RunService.Heartbeat:Connect(function()
                if not Toggles.MinecartInteract.Value then return end
                
                for _, room in pairs(Rooms:GetChildren()) do
                    for _, minecart in pairs(room:GetDescendants()) do
                        if minecart.Name == "Minecart" and minecart:IsA("Model") then
                            local distance = (LocalPlayer.Character.HumanoidRootPart.Position - minecart.PrimaryPart.Position).Magnitude
                            if distance < Options.AutoInteractRange.Value then
                                ReplicatedStorage.RemotesFolder.MinecartInteract:FireServer(minecart)
                            end
                        end
                    end
                end
            end)
        else
            if AntiConnections["MinecartInteract"] then AntiConnections["MinecartInteract"]:Disconnect() end
        end
    end,
}):AddKeyPicker("MinecartInteractKey", { 
    Default = "H", 
    SyncToggleState = false, 
    Mode = "Hold", 
    Text = "矿车交互", 
    NoUI = false 
})

AutomationGroup:AddSlider("AutoInteractRange", {
    Text = "交互范围",
    Default = 1,
    Min = 1,
    Max = 2,
    Rounding = 1,
    Compact = false
})


local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- 第三人称变量
local ThirdPersonEnabled = false
local ThirdPersonConnection = nil
local ThirdPersonDistance = 10
local ThirdPersonOffsetX = 0
local ThirdPersonOffsetY = 5

-- FOV 变量
local FOVConnection = nil
local TargetFOV = 70
local CurrentFOV = 70

-- 第三人称功能
local function EnableThirdPerson()
    if ThirdPersonConnection then
        ThirdPersonConnection:Disconnect()
    end
    
    ThirdPersonConnection = RunService.RenderStepped:Connect(function()
        if not LocalPlayer.Character then return end
        if not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
        
        local character = LocalPlayer.Character
        local rootPart = character.HumanoidRootPart
        
        local cameraCFrame = rootPart.CFrame
        local lookVector = cameraCFrame.LookVector
        local rightVector = cameraCFrame.RightVector
        local upVector = cameraCFrame.UpVector
        
        local cameraPosition = rootPart.Position - (lookVector * ThirdPersonDistance) + (rightVector * ThirdPersonOffsetX) + (upVector * ThirdPersonOffsetY)
        local cameraLookAt = rootPart.Position + Vector3.new(0, 2, 0)
        
        Camera.CFrame = CFrame.lookAt(cameraPosition, cameraLookAt)
    end)
end

local function DisableThirdPerson()
    if ThirdPersonConnection then
        ThirdPersonConnection:Disconnect()
        ThirdPersonConnection = nil
    end
end

local function ToggleThirdPerson()
    ThirdPersonEnabled = not ThirdPersonEnabled
    
    if ThirdPersonEnabled then
        EnableThirdPerson()
    else
        DisableThirdPerson()
    end
end

-- FOV 功能
local function UpdateFOV()
    if FOVConnection then
        FOVConnection:Disconnect()
    end
    
    FOVConnection = RunService.RenderStepped:Connect(function(dt)
        CurrentFOV = CurrentFOV + (TargetFOV - CurrentFOV) * math.clamp(10 * dt, 0, 1)
        Camera.FieldOfView = CurrentFOV
    end)
end

local function SetFOV(newFOV)
    TargetFOV = math.clamp(newFOV, 0, 120)
    if not FOVConnection then
        UpdateFOV()
    end
end

-- 在VisualEffects组中添加控件
VisualEffects:AddToggle("Thirdperson", {
    Text = "第三人称视角",
    Default = false,
    Callback = function(state)
        ThirdPersonEnabled = state
        if state then
            EnableThirdPerson()
        else
            DisableThirdPerson()
        end
    end,
})

VisualEffects:AddSlider("ThirdpersonDistance", {
    Text = "第三人称距离",
    Default = 10,
    Min = 5,
    Max = 30,
    Rounding = 0,
    Compact = false,
    Callback = function(Value)
        ThirdPersonDistance = Value
    end,
})

VisualEffects:AddSlider("ThirdpersonOffsetX", {
    Text = "左右偏移",
    Default = 0,
    Min = -5,
    Max = 5,
    Rounding = 1,
    Compact = false,
    Callback = function(Value)
        ThirdPersonOffsetX = Value
    end,
})

VisualEffects:AddSlider("ThirdpersonOffsetY", {
    Text = "上下偏移",
    Default = 5,
    Min = -5,
    Max = 5,
    Rounding = 1,
    Compact = false,
    Callback = function(Value)
        ThirdPersonOffsetY = Value
    end,
})

VisualEffects:AddSlider("FOV", {
    Text = "视野",
    Default = 70,
    Min = 0,
    Max = 120,
    Rounding = 1,
    Compact = false,
    Callback = function(Value)
        SetFOV(Value)
    end,
})

-- 键盘快捷键
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.V then
        ToggleThirdPerson()
        -- 更新UI状态
        if Toggles.Thirdperson then
            Toggles.Thirdperson.Value = ThirdPersonEnabled
        end
    end
end)

-- 角色重生时重新启用
LocalPlayer.CharacterAdded:Connect(function(character)
    if ThirdPersonEnabled then
        wait(1) -- 等待角色完全加载
        EnableThirdPerson()
    end
end)

-- 初始化FOV
SetFOV(70)

MenuGroup:AddCheckbox("KeybindMenuOpen", {
    Default = Library.KeybindFrame.Visible,
    Text = "快捷菜单",
    Callback = function(value)
        Library.KeybindFrame.Visible = value
    end,
})

MenuGroup:AddCheckbox("ShowCustomCursor", {
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

Ro:AddLabel("功能只是测试，因为我还没测试")

local A90Hook
RoomsGroup:AddCheckbox("AvoidA90", {
    Text = "删除 A-90",
    Default = false,
    Disabled = false,
    Callback = function(avoidEnabled)
        local modules = player.PlayerGui:FindFirstChild("MainUI")
            and player.PlayerGui.MainUI:FindFirstChild("Initiator")
            and player.PlayerGui.MainUI.Initiator:FindFirstChild("Main_Game")
            and player.PlayerGui.MainUI.Initiator.Main_Game:FindFirstChild("RemoteListener")
            and player.PlayerGui.MainUI.Initiator.Main_Game.RemoteListener:FindFirstChild("Modules")
        
        local a90Module = modules and (modules:FindFirstChild("A90") or modules:FindFirstChild("_A90"))
        if a90Module then
            a90Module.Name = avoidEnabled and "_A90" or "A90"
        end
        
        local remote = ReplicatedStorage:FindFirstChild("RemotesFolder")
            and ReplicatedStorage.RemotesFolder:FindFirstChild("A90")
            or ReplicatedStorage.RemotesFolder:FindFirstChild("_A90")
        
        if remote then
            remote.Name = avoidEnabled and "_A90" or "A90"
        end
    end
})
RoomsGroup:AddCheckbox("AutoRooms", {
    Text = "自动A-1000 [测试]",
    Default = false,
    Disabled = false,
    Callback = function(enabled)
        local Players = game:GetService("Players")
        local RunService = game:GetService("RunService")
        local PathfindingService = game:GetService("PathfindingService")
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local Workspace = game:GetService("Workspace")
        
        local player = Players.LocalPlayer
        local rooms = Workspace:WaitForChild("CurrentRooms")
        local gameData = ReplicatedStorage:WaitForChild("GameData")
        local floor = gameData:WaitForChild("Floor")
        
        local active = false
        local runner
        local clone
        local lastRoom = 0
        
        local function stop()
            active = false
            if runner then
                runner:Disconnect()
                runner = nil
            end
            if clone and clone.Parent then
                clone:Destroy()
            end
            player:SetAttribute("AutoRoomsActive", false)
        end
        
        if not enabled then
            stop()
            return
        end
        
        player:SetAttribute("AutoRoomsActive", true)
        active = true
        
        if player.Character and player.Character:FindFirstChild("CollisionPart") then
            clone = player.Character.CollisionPart:Clone()
            clone.Name = "_AutoRoomsCollision"
            clone.Massless = true
            clone.Anchored = false
            clone.CanCollide = false
            clone.CanQuery = false
            clone.CustomPhysicalProperties = PhysicalProperties.new(0.01, 0.7, 0, 1, 1)
            clone.Parent = player.Character
        end
        
        local function findClosestLocker()
            local best, bestDist = nil, math.huge
            for _, obj in ipairs(rooms:GetDescendants()) do
                if obj.Name == "Rooms_Locker" or obj.Name == "Rooms_Locker_Fridge" then
                    if obj.PrimaryPart then
                        local dist = (player.Character.HumanoidRootPart.Position - obj.PrimaryPart.Position).Magnitude
                        if dist < bestDist then
                            best = obj
                            bestDist = dist
                        end
                    end
                end
            end
            return best
        end
        
        local function walkTo(target)
            local char = player.Character
            if not (char and char:FindFirstChild("HumanoidRootPart")) then 
                return 
            end
            
            XKHax.Show("自动A-1000 [AUTO ROOMS]", "正在寻找最优路线", "路径计算中...", 3, "rbxassetid://6023426923", Color3.fromRGB(0, 0, 255))
            
            local path = PathfindingService:CreatePath({
                AgentRadius = 2,
                AgentHeight = 1,
                AgentCanJump = false,
                WaypointSpacing = 5
            })
            
            path:ComputeAsync(char.HumanoidRootPart.Position, target.Position)
            
            if path.Status == Enum.PathStatus.Success then
                for _, waypoint in ipairs(path:GetWaypoints()) do
                    if not active then return end
                    char:FindFirstChildOfClass("Humanoid"):MoveTo(waypoint.Position)
                    char.Humanoid.MoveToFinished:Wait()
                end
            end
        end
        
        runner = RunService.Heartbeat:Connect(function()
            if not active then return end
            
            if floor.Value ~= "Rooms" then 
                return stop() 
            end
            
            local currentRoom = gameData.LatestRoom.Value
            
            if currentRoom >= 1000 then 
                XKHax.Show("自动A-1000 [AUTO ROOMS]", "成功到达A-1000", "感谢你使用XK HUB", 8, "rbxassetid://6023426923", Color3.fromRGB(0, 255, 0))
                return stop() 
            end
            
            if currentRoom > lastRoom then
                XKHax.Show("自动A-1000 [AUTO ROOMS]", "到达新房间", "房间: " .. currentRoom, 3, "rbxassetid://6023426923", Color3.fromRGB(0, 0, 255))
                lastRoom = currentRoom
            end
            
            local entity = Workspace:FindFirstChild("A60")
                or Workspace:FindFirstChild("A120")
                or Workspace:FindFirstChild("GlitchRush")
                or Workspace:FindFirstChild("GlitchAmbush")
            
            if entity and entity.PrimaryPart and entity.PrimaryPart.Position.Y > -6 then
                XKHax.Show("自动A-1000 [AUTO ROOMS]", "检测到实体", "正在躲藏中", 3, "rbxassetid://6023426923", Color3.fromRGB(255, 0, 0))
                
                local locker = findClosestLocker()
                if locker and locker.PrimaryPart then
                    local hide = locker:FindFirstChild("HidePoint")
                    if not hide then
                        hide = Instance.new("Part")
                        hide.Name = "HidePoint"
                        hide.Anchored = true
                        hide.Transparency = 1
                        hide.CanCollide = false
                        hide.Position = locker.PrimaryPart.Position + locker.PrimaryPart.CFrame.LookVector * 7
                        hide.Parent = locker
                    end
                    
                    walkTo(hide)
                    task.wait(0.1)
                    
                    local prompt = locker:FindFirstChildOfClass("ProximityPrompt")
                    if prompt then
                        if fireproximityprompt then
                            fireproximityprompt(prompt)
                        else
                            prompt:InputHoldBegin()
                            prompt:InputHoldEnd()
                        end
                    end
                end
            else
                local door = rooms[currentRoom] and rooms[currentRoom]:FindFirstChild("Door", true)
                if door and door:FindFirstChild("Door") then
                    walkTo(door.Door)
                end
            end
        end)
        
        player.CharacterAdded:Connect(function()
            if active then
                task.wait(1.5)
                if player.Character and player.Character:FindFirstChild("CollisionPart") then
                    clone = player.Character.CollisionPart:Clone()
                    clone.Name = "_AutoRoomsCollision"
                    clone.Massless = true
                    clone.Anchored = false
                    clone.CanCollide = false
                    clone.CanQuery = false
                    clone.CustomPhysicalProperties = PhysicalProperties.new(0.01, 0.7, 0, 1, 1)
                    clone.Parent = player.Character
                end
            end
        end)
    end
})

RoomsGroup:AddLabel("自动Rooms时，不要移动啊")
RoomsGroup:AddLabel("停止的时候你就受着")

local roomDisplayGui
local roomDisplayEnabled = false
local roomCounter = 0
local lastDoorRoom = 0

local function createRoomDisplay()
    if roomDisplayGui then roomDisplayGui:Destroy() end
    
    roomDisplayGui = Instance.new("ScreenGui")
    roomDisplayGui.Name = "RoomDisplayGui"
    roomDisplayGui.ResetOnSpawn = false
    roomDisplayGui.Parent = game.Players.LocalPlayer.PlayerGui
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 220, 0, 80)
    frame.Position = UDim2.new(0, 10, 0, 10)
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    frame.BackgroundTransparency = 0.3
    frame.BorderSizePixel = 0
    frame.Parent = roomDisplayGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = frame
    
    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 2
    stroke.Color = Color3.fromRGB(0, 150, 255)
    stroke.Parent = frame
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 20)
    title.Position = UDim2.new(0, 0, 0, 5)
    title.BackgroundTransparency = 1
    title.Text = "门牌显示"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 14
    title.Font = Enum.Font.GothamBold
    title.Parent = frame
    
    local roomText = Instance.new("TextLabel")
    roomText.Size = UDim2.new(1, 0, 0, 30)
    roomText.Position = UDim2.new(0, 0, 0, 25)
    roomText.BackgroundTransparency = 1
    roomText.Text = "A-0000"
    roomText.TextColor3 = Color3.fromRGB(0, 255, 255)
    roomText.TextSize = 20
    roomText.Font = Enum.Font.GothamBold
    roomText.Parent = frame
    
    local counterText = Instance.new("TextLabel")
    counterText.Size = UDim2.new(1, 0, 0, 20)
    counterText.Position = UDim2.new(0, 0, 0, 55)
    counterText.BackgroundTransparency = 1
    counterText.Text = "已通过: 0 个门"
    counterText.TextColor3 = Color3.fromRGB(200, 200, 200)
    counterText.TextSize = 12
    counterText.Font = Enum.Font.Gotham
    counterText.Parent = frame
    
    return roomText, counterText
end

local roomTextLabel, counterTextLabel = createRoomDisplay()
roomDisplayGui.Enabled = false

local function incrementRoomCounter()
    roomCounter = roomCounter + 1
    roomTextLabel.Text = "A-" .. string.format("%04d", roomCounter)
    counterTextLabel.Text = "已通过: " .. roomCounter .. " 个门"
    
    if roomCounter >= 1000 then
        roomTextLabel.Text = "A-1000 🎉"
        roomTextLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
        XKHax.Show("门牌系统", "恭喜!", "成功到达 A-1000", 5, "rbxassetid://6023426923", Color3.fromRGB(0, 255, 0))
    else
        roomTextLabel.TextColor3 = Color3.fromRGB(0, 255, 255)
    end
end

local function monitorDoors()
    local doorConnection
    local rooms = workspace:WaitForChild("CurrentRooms")
    
    local function checkForNewDoors()
        for roomNumber, room in pairs(rooms:GetChildren()) do
            if tonumber(roomNumber) and tonumber(roomNumber) > lastDoorRoom then
                local door = room:FindFirstChild("Door", true)
                if door then
                    lastDoorRoom = tonumber(roomNumber)
                    incrementRoomCounter()
                    XKHax.Show("门牌系统", "发现新门", "当前: A-" .. string.format("%04d", roomCounter), 2, "rbxassetid://6023426923", Color3.fromRGB(0, 150, 255))
                    break
                end
            end
        end
    end
    
    doorConnection = RunService.Heartbeat:Connect(function()
        if not roomDisplayEnabled then
            doorConnection:Disconnect()
            return
        end
        checkForNewDoors()
    end)
    
    rooms.ChildAdded:Connect(function(child)
        if not roomDisplayEnabled then return end
        task.wait(0.5)
        checkForNewDoors()
    end)
end

RoomDisplayGroup:AddToggle("RoomDisplayToggle", {
    Text = "显示门牌计数器",
    Default = false,
    Callback = function(value)
        roomDisplayEnabled = value
        if roomDisplayGui then
            roomDisplayGui.Enabled = value
        end
        
        if value then
            roomCounter = 0
            lastDoorRoom = 0
            updateRoomDisplay()
            monitorDoors()
            
            XKHax.Show("门牌系统", "已启用", "门牌计数器已启动", 3, "rbxassetid://6023426923", Color3.fromRGB(0, 200, 0))
        else
            XKHax.Show("门牌系统", "已禁用", "门牌计数器已关闭", 3, "rbxassetid://6023426923", Color3.fromRGB(255, 100, 0))
        end
    end
})

RoomDisplayGroup:AddButton("重置计数器", function()
    roomCounter = 0
    lastDoorRoom = 0
    roomTextLabel.Text = "A-0000"
    counterTextLabel.Text = "已通过: 0 个门"
    roomTextLabel.TextColor3 = Color3.fromRGB(0, 255, 255)
    XKHax.Show("门牌系统", "计数器已重置", "从 A-0000 重新开始", 3, "rbxassetid://6023426923", Color3.fromRGB(255, 255, 0))
end)

RoomDisplayGroup:AddButton("手动+1", function()
    if roomDisplayEnabled then
        incrementRoomCounter()
    end
end)

local function updateRoomDisplay()
    if not roomDisplayEnabled then return end
    roomTextLabel.Text = "A-" .. string.format("%04d", roomCounter)
    counterTextLabel.Text = "已通过: " .. roomCounter .. " 个门"
end

game.Players.LocalPlayer.CharacterAdded:Connect(function()
    task.wait(2)
    if roomDisplayEnabled and roomDisplayGui then
        roomDisplayGui.Parent = game.Players.LocalPlayer.PlayerGui
        updateRoomDisplay()
    end
end)

local function initializeCounter()
    local gameData = ReplicatedStorage:WaitForChild("GameData")
    local currentRoom = gameData:WaitForChild("LatestRoom")
    
    if currentRoom then
        roomCounter = currentRoom.Value
        lastDoorRoom = currentRoom.Value
        updateRoomDisplay()
    end
end

task.spawn(function()
    task.wait(2)
    initializeCounter()
end)



OP:AddToggle("ItemESP", {
    Text = "物品",
    Default = false,
    Callback = function(state)
        if state then
            ESPLibrary:EnableTag("Shears", {
                TargetName = "Shears",
                Name = "Shears",
                Color = _G.ItemESPColor or Color3.new(1, 0, 1),
                Tag = "Items",
                ShowDistance = true,
                CheckForHumanoid = false,
                ParentFolder = workspace
            })
            ESPLibrary:EnableTag("CryptDesk", {
                TargetName = "CryptDesk",
                Name = "CryptDesk",
                Color = _G.ItemESPColor or Color3.new(1, 0, 1),
                Tag = "Items",
                ShowDistance = true,
                CheckForHumanoid = false,
                ParentFolder = workspace
            })
            ESPLibrary:EnableTag("Compass", {
                TargetName = "Compass",
                Name = "Compass",
                Color = _G.ItemESPColor or Color3.new(1, 0, 1),
                Tag = "Items",
                ShowDistance = true,
                CheckForHumanoid = false,
                ParentFolder = workspace
            })
            ESPLibrary:EnableTag("StardustPickup", {
                TargetName = "StardustPickup",
                Name = "StardustPickup",
                Color = _G.ItemESPColor or Color3.new(1, 0, 1),
                Tag = "Items",
                ShowDistance = true,
                CheckForHumanoid = false,
                ParentFolder = workspace
            })
            ESPLibrary:EnableTag("IronKeyForCrypt", {
                TargetName = "IronKeyForCrypt",
                Name = "钥匙",
                Color = _G.KeyESPColor or Color3.new(0, 1, 0),
                Tag = "Items",
                ShowDistance = true,
                CheckForHumanoid = false,
                ParentFolder = workspace
            })
            ESPLibrary:EnableTag("VineGuillotine", {
                TargetName = "VineGuillotine",
                Name = "拉杆",
                Color = _G.KeyESPColor or Color3.new(0, 1, 0),
                Tag = "Items",
                ShowDistance = true,
                CheckForHumanoid = false,
                ParentFolder = workspace
            })
            ESPLibrary:EnableTag("Chest_Vine", {
                TargetName = "Chest_Vine",
                Name = "箱子",
                Color = _G.KeyESPColor or Color3.new(0, 1, 0),
                Tag = "Items",
                ShowDistance = true,
                CheckForHumanoid = false,
                ParentFolder = workspace
            })
            ESPLibrary:EnableTag("LanternLitItem", {
                TargetName = "LanternLitItem",
                Name = "灯笼",
                Color = _G.LanternESPColor or Color3.new(1, 0.65, 0),
                Tag = "Items",
                ShowDistance = true,
                CheckForHumanoid = false,
                ParentFolder = workspace
            })
        else
            ESPLibrary:DisableTag("Shears")
            ESPLibrary:DisableTag("CryptDesk")
            ESPLibrary:DisableTag("Compass")
            ESPLibrary:DisableTag("StardustPickup")
            ESPLibrary:DisableTag("IronKeyForCrypt")
            ESPLibrary:DisableTag("VineGuillotine")
            ESPLibrary:DisableTag("Chest_Vine")
            ESPLibrary:DisableTag("LanternLitItem")
        end
    end
}):AddColorPicker("ItemESPColor", {
    Default = Color3.new(1, 0, 1),
    Title = "物品ESP颜色",
    Callback = function(value)
        _G.ItemESPColor = value
    end
}):AddColorPicker("KeyESPColor", {
    Default = Color3.new(0, 1, 0),
    Title = "钥匙/箱子颜色",
    Callback = function(value)
        _G.KeyESPColor = value
    end
}):AddColorPicker("LanternESPColor", {
    Default = Color3.new(1, 0.65, 0),
    Title = "灯笼颜色",
    Callback = function(value)
        _G.LanternESPColor = value
    end
})

OP:AddToggle("EntityESP", {
    Text = "实体",
    Default = false,
    Callback = function(state)
        if state then
            ESPLibrary:EnableTag("Top", {
                TargetName = "Top",
                Name = "纪念碑怪物",
                Color = _G.HostileEntityColor or Color3.new(1, 0, 0),
                Tag = "Entities",
                ShowDistance = true,
                CheckForHumanoid = false,
                ParentFolder = workspace
            })
            ESPLibrary:EnableTag("Snare", {
                TargetName = "Snare",
                Name = "地刺",
                Color = _G.TrapEntityColor or Color3.new(0, 1, 0),
                Tag = "Entities",
                ShowDistance = true,
                CheckForHumanoid = false,
                ParentFolder = workspace
            })
            ESPLibrary:EnableTag("LiveEntityBramble", {
                TargetName = "LiveEntityBramble",
                Name = "荆棘",
                Color = _G.TrapEntityColor or Color3.new(0, 1, 0),
                Tag = "Entities",
                ShowDistance = true,
                CheckForHumanoid = false,
                ParentFolder = workspace
            })
            ESPLibrary:EnableTag("EyestalkMoving", {
                TargetName = "EyestalkMoving",
                Name = "眼球怪",
                Color = _G.HostileEntityColor or Color3.new(1, 0, 0),
                Tag = "Entities",
                ShowDistance = true,
                CheckForHumanoid = false,
                ParentFolder = workspace
            })
            ESPLibrary:EnableTag("Groundskeeper", {
                TargetName = "Groundskeeper",
                Name = "园丁",
                Color = _G.HostileEntityColor or Color3.new(1, 0, 0),
                Tag = "Entities",
                ShowDistance = true,
                CheckForHumanoid = false,
                ParentFolder = workspace
            })
        else
            ESPLibrary:DisableTag("Top")
            ESPLibrary:DisableTag("Snare")
            ESPLibrary:DisableTag("LiveEntityBramble")
            ESPLibrary:DisableTag("EyestalkMoving")
            ESPLibrary:DisableTag("Groundskeeper")
        end
    end
}):AddColorPicker("HostileEntityColor", {
    Default = Color3.new(1, 0, 0),
    Title = "敌对实体颜色",
    Callback = function(value)
        _G.HostileEntityColor = value
    end
}):AddColorPicker("TrapEntityColor", {
    Default = Color3.new(0, 1, 0),
    Title = "陷阱实体颜色",
    Callback = function(value)
        _G.TrapEntityColor = value
    end
})

OP:AddToggle("DoorESP", {
    Text = "门 ESP",
    Default = false,
    Callback = function(state)
        if state then
            ESPLibrary:EnableTag("Door", {
                TargetName = "Door",
                Name = "门",
                Color = _G.DoorESPColor or Color3.new(0, 1, 1),
                Tag = "Doors",
                ShowDistance = true,
                CheckForHumanoid = false,
                ParentFolder = workspace
            })
            ESPLibrary:EnableTag("GardenGate", {
                TargetName = "GardenGate",
                Name = "门",
                Color = _G.DoorESPColor or Color3.new(0, 1, 1),
                Tag = "Doors",
                ShowDistance = true,
                CheckForHumanoid = false,
                ParentFolder = workspace
            })
        else
            ESPLibrary:DisableTag("Door")
            ESPLibrary:DisableTag("GardenGate")
        end
    end
}):AddColorPicker("DoorESPColor", {
    Default = Color3.new(0, 1, 1),
    Title = "门ESP颜色",
    Callback = function(value)
        _G.DoorESPColor = value
    end
})


local connectionAdded
local connectionRemoved

local NotificationStyle = "XKHax"

local entityIcons = {
    Top = "6023426923"
}

AU:AddDropdown("NotificationStyle", {
    Values = {"Doors成就模仿", "中上方通知", "原始Library"},
    Default = 1,
    Multi = false,
    Text = "通知样式",
    Tooltip = "选择实体出现时的通知样式",
    Callback = function(Value)
        if Value == "中上方通知" then
            NotificationStyle = "XKHub"
        elseif Value == "Doors成就模仿" then
            NotificationStyle = "XKHax"
        else
            NotificationStyle = "Library"
        end
    end
})

AU:AddToggle("ShopkeeperESP", {
    Text = "纪念碑实体刷新通知",
    Default = false,
    Callback = function(state)
        local entities = {
            Top = {DisplayName = "纪念碑实体"}
        }

        local function isValidEntity(entity)
            if not entity:IsA("Model") then
                return false
            end
            
            if not entity.PrimaryPart and not entity:FindFirstChildWhichIsA("BasePart") then
                return false
            end
            
            local parent = entity.Parent
            while parent ~= nil do
                if parent.Name == "Entities" or parent == workspace then
                    return true
                end
                parent = parent.Parent
            end
            return false
        end

        local function sendNotification(entityName, action)
            if entities[entityName] then
                local text = "实体"..action.."："..entities[entityName].DisplayName
                
                if NotificationStyle == "XKHub" then
                    XKHub:Notification("实体通知", text, 5)
                elseif NotificationStyle == "XKHax" then
                    local icon = entityIcons[entityName] or "6023426923"
                    XKHax.Show("实体通知", entities[entityName].DisplayName, action, 5, "rbxassetid://" .. icon, Color3.fromRGB(255, 0, 0))
                else
                    Library:Notify(text, 5, 4590662766)
                end
                
                local sound = Instance.new("Sound", game:GetService("SoundService"))
                sound.SoundId = "rbxassetid://4590662766"
                sound.Volume = 10
                sound:Play()
                sound.Ended:Connect(sound.Destroy)
            end
        end

        local function checkEntity(entity)
            if entities[entity.Name] and isValidEntity(entity) then
                local humanoid = entity:FindFirstChildOfClass("Humanoid")
                if humanoid and humanoid.Health <= 0 then
                    return
                end
                sendNotification(entity.Name, "出现")
            end
        end

        local function entityRemoved(entity)
            if entities[entity.Name] and isValidEntity(entity) then
                sendNotification(entity.Name, "消失")
            end
        end

        if state then
            for _, entity in pairs(workspace:GetDescendants()) do
                if entity:IsA("Model") then
                    task.spawn(checkEntity, entity)
                end
            end
                       
            connectionAdded = workspace.DescendantAdded:Connect(function(entity)
                if entity:IsA("Model") then
                    task.wait(0.5)
                    task.spawn(checkEntity, entity)
                end
            end)
            
            connectionRemoved = workspace.DescendantRemoving:Connect(function(entity)
                if entity:IsA("Model") then
                    task.wait(0.5)
                    task.spawn(entityRemoved, entity)
                end
            end)
        else
            if connectionAdded then
                connectionAdded:Disconnect()
                connectionAdded = nil
            end
            
            if connectionRemoved then
                connectionRemoved:Disconnect()
                connectionRemoved = nil
            end
        end
    end
})

local EntityNotifier = {
    Enabled = false,
    Connection = nil,
    RemovalConnection = nil,  
    LastNotified = {} 
}

local entities = {
    Top = {DisplayName = "纪念碑"}
}

local CustomNotificationText = "警告！{entity}刷新" 

local function GetChatService()
    if game:GetService("TextChatService"):FindFirstChild("TextChannels") then
        return game:GetService("TextChatService").TextChannels.RBXGeneral
    elseif game:GetService("ReplicatedStorage"):FindFirstChild("DefaultChatSystemChatEvents") then
        return game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest
    end
    return nil
end

local function SafeSendMessage(message)
    local chatService = GetChatService()
    if not chatService then return false end
    
    if not message or string.len(message) < 1 then
        return false
    end

    local success, result = pcall(function()
        if chatService:IsA("TextChannel") then
            return chatService:SendAsync(message)
        else
            chatService:FireServer(message, "All")
            return true
        end
    end)    
    return success and result
end

local function isValidEntity(entity)
    if not entity:IsA("Model") then
        return false
    end
    
    if not entity.PrimaryPart and not entity:FindFirstChildWhichIsA("BasePart") then
        return false
    end
    
    local parent = entity.Parent
    while parent ~= nil do
        if parent.Name == "Entities" or parent == workspace then
            return true
        end
        parent = parent.Parent
    end
    return false
end

local function notifyEntity(entityName)
    if entities[entityName] then
        local message = CustomNotificationText:gsub("{entity}", entities[entityName].DisplayName)
        SafeSendMessage(message)
    end
end

local function notifyEntityRemoval(entityName)
    if entities[entityName] then
        SafeSendMessage("警告！"..entities[entityName].DisplayName.."已消失！")
    end
end

local function checkEntity(entity)
    if entity:IsA("Model") and entities[entity.Name] and isValidEntity(entity) then
        local humanoid = entity:FindFirstChildOfClass("Humanoid")
        if humanoid and humanoid.Health <= 0 then
            return
        end
        notifyEntity(entity.Name)
    end
end

AU:AddToggle("EntityNotifier", {
    Text = "纪念碑实体聊天通知",
    Default = false,
    Callback = function(state)
        EntityNotifier.Enabled = state

        if EntityNotifier.Connection then
            EntityNotifier.Connection:Disconnect()
            EntityNotifier.Connection = nil
        end
        if EntityNotifier.RemovalConnection then
            EntityNotifier.RemovalConnection:Disconnect()
            EntityNotifier.RemovalConnection = nil
        end

        if state then
            for _, entity in pairs(workspace:GetDescendants()) do
                if entity:IsA("Model") then
                    task.spawn(checkEntity, entity)
                end
            end

            EntityNotifier.Connection = workspace.DescendantAdded:Connect(function(entity)
                if entity:IsA("Model") then
                    task.wait(0.5)
                    if EntityNotifier.Enabled then
                        task.spawn(checkEntity, entity)
                    end
                end
            end)

            EntityNotifier.RemovalConnection = workspace.DescendantRemoving:Connect(function(entity)
                if entity:IsA("Model") and entities[entity.Name] then
                    notifyEntityRemoval(entity.Name)
                end
            end)
        end
    end
})

AU:AddInput("CustomNotification", {
    Text = "自定义刷新提示",
    Default = "",
    Callback = function(text)
        if text and text ~= "" then
            CustomNotificationText = text
            local sound = Instance.new("Sound", game:GetService("SoundService"))
            sound.SoundId = "rbxassetid://4590662766"
            sound.Volume = 10
            sound:Play()
            sound.Ended:Connect(function()
                sound:Destroy()
            end)
        end
    end
})

game:GetService("Players").LocalPlayer.CharacterRemoving:Connect(function()
    if EntityNotifier.Connection then
        EntityNotifier.Connection:Disconnect()
    end
    if EntityNotifier.RemovalConnection then
        EntityNotifier.RemovalConnection:Disconnect()
    end
end)

tab:AddToggle("AntiSnare", {
    Text = "防地刺",
    Default = false,
    Callback = function(state)
        SnareRemover = SnareRemover or {
            Enabled = false,
            Connection = nil
        }        
        if SnareRemover.Connection then
            SnareRemover.Connection:Disconnect()
            SnareRemover.Connection = nil
        end     
        SnareRemover.Enabled = state
        local function removeSnares()
            for _, model in ipairs(workspace:GetDescendants()) do
                if model:IsA("Model") and model.Name == "Snare" then
                    model:Destroy()
                end
            end
        end
        if state then
            removeSnares()
            SnareRemover.Connection = workspace.DescendantAdded:Connect(function(descendant)
                if SnareRemover.Enabled and descendant:IsA("Model") and descendant.Name == "Snare" then
                    task.wait(0.5)
                    descendant:Destroy()
                end
            end)
        end
    end
})

tab:AddToggle("AntiSurge", {
    Text = "防Surge",
    Default = false,
    Callback = function(state)
        SurgeRemover = SurgeRemover or {
            Enabled = false,
            Connection = nil
        }        
        
        if SurgeRemover.Connection then
            SurgeRemover.Connection:Disconnect()
            SurgeRemover.Connection = nil
        end     
        
        SurgeRemover.Enabled = state
        
        local function removeSurge()
            local surgeSpawn = game:GetService("ReplicatedStorage").FloorReplicated.ClientRemote.SurgeClient:FindFirstChild("SurgeSpawn")
            if surgeSpawn then
                surgeSpawn:Destroy()
            end
            
            for _, obj in ipairs(workspace:GetDescendants()) do
                if obj.Name == "Surge" then
                    obj:Destroy()
                end
            end
        end
        
        if state then
            removeSurge()
            SurgeRemover.Connection = workspace.DescendantAdded:Connect(function(descendant)
                if SurgeRemover.Enabled and descendant.Name == "Surge" then
                    task.wait(0.5)
                    descendant:Destroy()
                end
            end)
        end
    end
})

local FlyEnabled = false
local IsFlying = false
local FlyConnections = {}
local FlyKeys = {W = false, A = false, S = false, D = false, Space = false, Shift = false}
local FlySpeed = 50

W:AddCheckbox("Fly", {
    Text = "飞行 [要搭配忍着注入器的键盘使用]",
    Default = false,
    Callback = function(Value)
        FlyEnabled = Value
        if Value then
            IsFlying = true
            
            local player = game.Players.LocalPlayer
            local character = player.Character
            if not character then return end
            
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if not humanoid then return end
            
            local hrp = character:FindFirstChild("HumanoidRootPart")
            if not hrp then return end

            local bv = Instance.new("BodyVelocity")
            bv.Name = "FlyVelocity"
            bv.MaxForce = Vector3.new(1e9, 1e9, 1e9)
            bv.Velocity = Vector3.new(0, 0, 0)
            bv.Parent = hrp

            local bg = Instance.new("BodyGyro")
            bg.Name = "FlyGyro"
            bg.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
            bg.P = 20000
            bg.D = 1000
            bg.Parent = hrp

            humanoid.AutoRotate = false
            humanoid.PlatformStand = true
            humanoid:ChangeState(Enum.HumanoidStateType.Physics)

            local UserInputService = game:GetService("UserInputService")
            
            FlyConnections.inputBegan = UserInputService.InputBegan:Connect(function(input, gpe)
                if gpe then return end
                if input.KeyCode == Enum.KeyCode.W then FlyKeys.W = true
                elseif input.KeyCode == Enum.KeyCode.A then FlyKeys.A = true
                elseif input.KeyCode == Enum.KeyCode.S then FlyKeys.S = true
                elseif input.KeyCode == Enum.KeyCode.D then FlyKeys.D = true
                elseif input.KeyCode == Enum.KeyCode.Space then FlyKeys.Space = true
                elseif input.KeyCode == Enum.KeyCode.LeftShift then FlyKeys.Shift = true end
            end)

            FlyConnections.inputEnded = UserInputService.InputEnded:Connect(function(input)
                if input.KeyCode == Enum.KeyCode.W then FlyKeys.W = false
                elseif input.KeyCode == Enum.KeyCode.A then FlyKeys.A = false
                elseif input.KeyCode == Enum.KeyCode.S then FlyKeys.S = false
                elseif input.KeyCode == Enum.KeyCode.D then FlyKeys.D = false
                elseif input.KeyCode == Enum.KeyCode.Space then FlyKeys.Space = false
                elseif input.KeyCode == Enum.KeyCode.LeftShift then FlyKeys.Shift = false end
            end)

            local RunService = game:GetService("RunService")
            FlyConnections.render = RunService.RenderStepped:Connect(function()
                local cam = workspace.CurrentCamera
                if not cam or not hrp or not hrp:FindFirstChild("FlyVelocity") or not humanoid or humanoid.Health <= 0 then
                    stopFly()
                    return
                end
                
                local move = Vector3.new(0, 0, 0)
                if FlyKeys.W then move = move + cam.CFrame.LookVector end
                if FlyKeys.S then move = move - cam.CFrame.LookVector end
                if FlyKeys.A then move = move - cam.CFrame.RightVector end
                if FlyKeys.D then move = move + cam.CFrame.RightVector end
                if FlyKeys.Space then move = move + Vector3.new(0, 1, 0) end
                if FlyKeys.Shift then move = move - Vector3.new(0, 1, 0) end
                
                local direction = (move.Magnitude > 0) and (move.Unit * FlySpeed) or Vector3.new(0, 0, 0)
                bv.Velocity = direction
                bg.CFrame = cam.CFrame
            end)
        else
            IsFlying = false
            
            for _, conn in pairs(FlyConnections) do
                if conn then
                    conn:Disconnect()
                end
            end
            FlyConnections = {}
            FlyKeys = {W = false, A = false, S = false, D = false, Space = false, Shift = false}
            
            stopFly()
        end
    end
}):AddKeyPicker("FlyKeybind", {
    Default = "F",
    SyncToggleState = true,
    Mode = "Toggle",
    Text = "Fly Toggle",
    NoUI = false,
})

W:AddSlider("FlySpeedSlider", {
    Text = "飞行速度",
    Default = 50,
    Min = 10,
    Max = 200,
    Rounding = 0,
    Compact = true,
    Callback = function(Value)
        FlySpeed = Value
    end
})

local function stopFly()
    local player = game.Players.LocalPlayer
    local character = player.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    local hrp = character and character:FindFirstChild("HumanoidRootPart")
    
    if hrp then
        local flyVelocity = hrp:FindFirstChild("FlyVelocity")
        if flyVelocity then flyVelocity:Destroy() end
        local flyGyro = hrp:FindFirstChild("FlyGyro")
        if flyGyro then flyGyro:Destroy() end
    end
    
    if humanoid then
        humanoid.AutoRotate = true
        humanoid.PlatformStand = false
        humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
    end
end

local AutoInteractEnabled = false
local CachedInteractables = {}
local PromptSeen = {}
local AutoInteractConnection = nil
local AttributeConnection = nil
local RoomDescConnection = nil
local IgnoredItems = {}

A:AddCheckbox("AutoInteract", {
    Text = "自动互动 V2",
    Default = false,
    Callback = function(Value)
        AutoInteractEnabled = Value
        if Value then
            local LocalPlayer = game.Players.LocalPlayer
            local RunService = game:GetService("RunService")
            
            CachedInteractables = {}
            PromptSeen = {}
            
            local function RefreshTargets()
                CachedInteractables = {}
                PromptSeen = {}
                
                local currentRoom = LocalPlayer:GetAttribute("CurrentRoom")
                local cr = workspace.CurrentRooms[currentRoom]
                if not cr then return end
                
                for _, v in ipairs(cr:GetDescendants()) do
                    if v:IsA("ProximityPrompt") and v.Enabled and not IgnoredItems[v.Parent.Name] then
                        table.insert(CachedInteractables, v)
                    end
                end
            end
            
            local function AutoInteractStep()
                local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if not root then return end
                
                for _, prompt in ipairs(CachedInteractables) do
                    if prompt.Parent and not PromptSeen[prompt] then
                        local dist = (root.Position - prompt.Parent.Position).Magnitude
                        if dist < prompt.MaxActivationDistance then
                            PromptSeen[prompt] = true
                            task.spawn(function()
                                pcall(function()
                                    fireproximityprompt(prompt)
                                end)
                            end)
                        end
                    end
                end
            end
            
            RefreshTargets()
            
            AutoInteractConnection = RunService.Heartbeat:Connect(AutoInteractStep)
            
            AttributeConnection = LocalPlayer:GetAttributeChangedSignal("CurrentRoom"):Connect(function()
                RefreshTargets()
                
                if RoomDescConnection then
                    RoomDescConnection:Disconnect()
                    RoomDescConnection = nil
                end
                
                local currentRoom = LocalPlayer:GetAttribute("CurrentRoom")
                local cr = workspace.CurrentRooms[currentRoom]
                if cr then
                    RoomDescConnection = cr.DescendantAdded:Connect(function()
                        task.defer(RefreshTargets)
                    end)
                end
            end)
            
            local currentRoom = LocalPlayer:GetAttribute("CurrentRoom")
            local cr = workspace.CurrentRooms[currentRoom]
            if cr then
                RoomDescConnection = cr.DescendantAdded:Connect(function()
                    task.defer(RefreshTargets)
                end)
            end
        else
            if AutoInteractConnection then
                AutoInteractConnection:Disconnect()
                AutoInteractConnection = nil
            end
            if AttributeConnection then
                AttributeConnection:Disconnect()
                AttributeConnection = nil
            end
            if RoomDescConnection then
                RoomDescConnection:Disconnect()
                RoomDescConnection = nil
            end
            CachedInteractables = {}
            PromptSeen = {}
        end
    end
})

local ignoreValues = {"Items", "Containers", "Glitch Cube"}
A:AddDropdown("IgnoreList", {
    Text = "忽略互动",
    Default = {},
    Values = ignoreValues,
    Multi = true,
    Callback = function(Value)
        IgnoredItems = {}
        for _, item in ipairs(Value) do
            IgnoredItems[item] = true
        end
    end
})

local LadderBoostEnabled = false
local LadderBoostConn = nil

MovementGroupZ:AddCheckbox("LadderSpeedBoost", {
    Text = "快速爬梯",
    Default = false,
    Callback = function(Value)
        LadderBoostEnabled = Value
        if Value then
            local LocalPlayer = game.Players.LocalPlayer
            local RunService = game:GetService("RunService")
            
            LadderBoostConn = RunService.Heartbeat:Connect(function()
                local char = LocalPlayer.Character
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                
                if hum and hrp and hum:GetState() == Enum.HumanoidStateType.Climbing then
                    hrp.Velocity = Vector3.new(hrp.Velocity.X, 50, hrp.Velocity.Z)
                end
            end)
        else
            if LadderBoostConn then
                LadderBoostConn:Disconnect()
                LadderBoostConn = nil
            end
        end
    end
})

MovementGroupZ:AddSlider("LadderSpeedBoostAmount", {
    Text = "爬楼梯速度",
    Default = 50,
    Min = 10,
    Max = 100,
    Rounding = 0,
    Compact = true
})

local BridgeCoverEnabled = false
local Bridges = {}
local BridgeHeartbeatConn = nil

M:AddCheckbox("SeekBridgeCover", {
    Text = "Seek追逐桥梁不塌",
    Default = false,
    Callback = function(Value)
        BridgeCoverEnabled = Value
        if Value then
            local RunService = game:GetService("RunService")
            local Players = game:GetService("Players")
            local Workspace = game:GetService("Workspace")
            local MODEL_NAME = "Bridge"
            local SCAN_INTERVAL = 1
            local DEFAULTS = {
                HeightOffset = 30,
                Thickness = 1,
                PaddingX = -5,
                PaddingZ = -5,
                Color = Color3.fromRGB(36, 16, 0)
            }
            
            local function getBridgeSettings(bridge)
                return {
                    HeightOffset = bridge:GetAttribute("HeightOffset") or DEFAULTS.HeightOffset,
                    Thickness = bridge:GetAttribute("Thickness") or DEFAULTS.Thickness,
                    PaddingX = bridge:GetAttribute("PaddingX") or DEFAULTS.PaddingX,
                    PaddingZ = bridge:GetAttribute("PaddingZ") or DEFAULTS.PaddingZ,
                    Color = bridge:GetAttribute("Color") or DEFAULTS.Color
                }
            end
            
            local rootNames = {HumanoidRootPart=true, Torso=true, UpperTorso=true, LowerTorso=true}
            
            local function findRootPart(character)
                for name in pairs(rootNames) do
                    local p = character:FindFirstChild(name)
                    if p then return p end
                end
                return character:FindFirstChild("HumanoidRootPart") or character:FindFirstChildWhichIsA("BasePart")
            end
            
            local function createPlatform(bridge)
                if Bridges[bridge] then
                    if Bridges[bridge].platform and Bridges[bridge].platform.Parent then
                        Bridges[bridge].platform:Destroy()
                    end
                    Bridges[bridge] = nil
                end
                
                local settings = getBridgeSettings(bridge)
                local modelCFrame, modelSize = bridge:GetBoundingBox()
                
                local part = Instance.new("Part")
                part.Name = "BridgePlatform"
                part.Anchored = true
                part.CanCollide = false
                part.Material = Enum.Material.Wood
                part.Color = settings.Color
                part.Size = Vector3.new(math.max(0.1, modelSize.X - settings.PaddingX * 2), settings.Thickness, math.max(0.1, modelSize.Z - settings.PaddingZ * 2))
                part.CFrame = modelCFrame * CFrame.new(0, -modelSize.Y / 2 + settings.HeightOffset, 0)
                part.Parent = bridge
                
                Bridges[bridge] = {
                    platform = part,
                    settings = settings,
                    touchingPlayers = {},
                    debounces = {}
                }
                
                local function snapPlayerToPlatform(player, character)
                    local record = Bridges[bridge]
                    if not record or not record.platform or not record.platform.Parent then return end
                    
                    local humanoid = character:FindFirstChildOfClass("Humanoid")
                    local root = findRootPart(character)
                    if not humanoid or not root then return end
                    
                    local now = tick()
                    if record.debounces[player] and now - record.debounces[player] < 0.12 then return end
                    record.debounces[player] = now
                    
                    local platformTop = record.platform.Position.Y + record.platform.Size.Y/2
                    local vy = 0
                    if root:IsA("BasePart") and root:FindFirstChildWhichIsA("Vector3Value") == nil then
                        local ok, vel = pcall(function() return root.Velocity end)
                        if ok and vel then vy = vel.Y end
                    end
                    
                    if (vy <= 0) and root.Position.Y < platformTop + 3 then
                        local hip = humanoid.HipHeight or 2
                        local targetY = platformTop + hip + 0.5
                        root.CFrame = CFrame.new(root.Position.X, targetY, root.Position.Z)
                    end
                end
                
                local function onTouched(hit)
                    local char = hit.Parent
                    local player = Players:GetPlayerFromCharacter(char)
                    if not player then return end
                    Bridges[bridge].touchingPlayers[player] = true
                    snapPlayerToPlatform(player, char)
                end
                
                local function onTouchEnded(hit)
                    local char = hit.Parent
                    local player = Players:GetPlayerFromCharacter(char)
                    if not player then return end
                    Bridges[bridge].touchingPlayers[player] = nil
                    Bridges[bridge].debounces[player] = nil
                end
                
                local tconn = part.Touched:Connect(onTouched)
                local teconn = part.TouchEnded:Connect(onTouchEnded)
                Bridges[bridge].connections = { tconn, teconn }
            end
            
            local function cleanupPlatform(bridge)
                if Bridges[bridge] then
                    local record = Bridges[bridge]
                    if record.connections then
                        for _, c in ipairs(record.connections) do
                            if c and c.Connected then pcall(function() c:Disconnect() end) end
                        end
                    end
                    if record.platform and record.platform.Parent then
                        record.platform:Destroy()
                    end
                    Bridges[bridge] = nil
                end
            end
            
            local function updateBridges()
                local found = {}
                for _, desc in ipairs(Workspace:GetDescendants()) do
                    if desc:IsA("Model") and desc.Name == MODEL_NAME then
                        found[desc] = true
                        if not Bridges[desc] then
                            createPlatform(desc)
                        end
                    end
                end
                
                for b in pairs(Bridges) do
                    if not found[b] or not b.Parent then
                        cleanupPlatform(b)
                    end
                end
            end
            
            BridgeHeartbeatConn = RunService.Heartbeat:Connect(function()
                for bridge, data in pairs(Bridges) do
                    if bridge and bridge.Parent and data.platform and data.platform.Parent then
                        local modelCFrame, modelSize = bridge:GetBoundingBox()
                        local s = data.settings
                        data.platform.CFrame = modelCFrame * CFrame.new(0, -modelSize.Y / 2 + s.HeightOffset, 0)
                    end
                end
            end)
            
            local scanning = true
            task.spawn(function()
                while scanning and BridgeCoverEnabled do
                    updateBridges()
                    task.wait(SCAN_INTERVAL)
                end
            end)
        else
            if BridgeHeartbeatConn then
                BridgeHeartbeatConn:Disconnect()
                BridgeHeartbeatConn = nil
            end
            
            for b in pairs(Bridges) do
                if Bridges[b] then
                    if Bridges[b].platform and Bridges[b].platform.Parent then
                        Bridges[b].platform:Destroy()
                    end
                end
            end
            table.clear(Bridges)
        end
    end
})

local AntiJamEnabled = false

PPP:AddCheckbox('AntiJam', {
    Text = "防卡顿",
    Default = false,
    Callback = function(Value)
        AntiJamEnabled = Value
        if Value then
            local Modifiers = game:GetService("ReplicatedStorage"):FindFirstChild("Modifiers")
            if Modifiers and not Modifiers:FindFirstChild("Jammin") then 
                return 
            end
            
            local mainTrack = game["SoundService"]:FindFirstChild("Main")
            if mainTrack then
                local jamming = mainTrack:FindFirstChild("Jamming")
                if jamming then
                    jamming.Enabled = false
                end
            end
            
            local player = game.Players.LocalPlayer
            local mainUI = player:FindFirstChild("PlayerGui") and player.PlayerGui:FindFirstChild("MainUI")
            if mainUI then
                local healthGui = mainUI:FindFirstChild("Initiator") 
                    and mainUI.Initiator:FindFirstChild("Main_Game") 
                    and mainUI.Initiator.Main_Game:FindFirstChild("Health")
                if healthGui then
                    local jamSound = healthGui:FindFirstChild("Jam")
                    if jamSound then
                        jamSound.Playing = false
                    end
                end
            end
        else
            local mainTrack = game["SoundService"]:FindFirstChild("Main")
            if mainTrack then
                local jamming = mainTrack:FindFirstChild("Jamming")
                if jamming then
                    jamming.Enabled = true
                end
            end
            
            local player = game.Players.LocalPlayer
            local mainUI = player:FindFirstChild("PlayerGui") and player.PlayerGui:FindFirstChild("MainUI")
            if mainUI then
                local healthGui = mainUI:FindFirstChild("Initiator") 
                    and mainUI.Initiator:FindFirstChild("Main_Game") 
                    and mainUI.Initiator.Main_Game:FindFirstChild("Health")
                if healthGui then
                    local jamSound = healthGui:FindFirstChild("Jam")
                    if jamSound then
                        jamSound.Playing = true
                    end
                end
            end
        end
    end
})

local SeekPathEnabled = false
local PathFolder = nil
local PathLights = {}
local PathAddedConn = nil
local PathRemovedConn = nil

SeekGroup:AddCheckbox("SeekPathESP", {
    Text = "Seek 路径显示",
    Default = false,
    Callback = function(Value)
        SeekPathEnabled = Value
        if Value then
            PathFolder = Instance.new("Folder")
            PathFolder.Name = "Path Node"
            PathFolder.Parent = workspace
            
            PathLights = {}
            
            local function createSphere(pos)
                local part = Instance.new("Part")
                part.Size = Vector3.new(1, 1, 1)
                part.Shape = Enum.PartType.Ball
                part.Material = Enum.Material.Neon
                part.Color = Color3.fromRGB(0, 255, 0)
                part.Anchored = true
                part.CanCollide = false
                part.Transparency = 0.3
                part.CFrame = CFrame.new(pos)
                part.Parent = PathFolder
                
                task.spawn(function()
                    local player = game.Players.LocalPlayer
                    if not player or not player.Character then return end
                    local root = player.Character:WaitForChild("HumanoidRootPart", 5)
                    if not root then return end
                    while part.Parent do
                        if (root.Position - part.Position).Magnitude < 5 then
                            part:Destroy()
                            break
                        end
                        task.wait(0.1)
                    end
                end)
            end
            
            local function redraw()
                for _, v in pairs(PathFolder:GetChildren()) do
                    v:Destroy()
                end
                
                if #PathLights == 0 then return end
                
                local positions = {}
                for _, light in ipairs(PathLights) do
                    if light and light.Parent then
                        table.insert(positions, light.Position)
                    end
                end
                
                if #positions == 0 then return end
                
                table.sort(positions, function(a, b)
                    return a.X + a.Y + a.Z < b.X + b.Y + b.Z
                end)
                
                for _, pos in ipairs(positions) do
                    createSphere(pos)
                end
            end
            
            local function addLight(light)
                if not light or not light.Parent then return end
                table.insert(PathLights, light)
                redraw()
            end
            
            for _, v in ipairs(workspace:GetDescendants()) do
                if v.Name == "SeekGuidingLight" then
                    pcall(addLight, v)
                end
            end
            
            PathAddedConn = workspace.DescendantAdded:Connect(function(obj)
                if not SeekPathEnabled then return end
                if obj.Name == "SeekGuidingLight" then
                    pcall(addLight, obj)
                end
            end)
            
            PathRemovedConn = workspace.DescendantRemoving:Connect(function(obj)
                if not SeekPathEnabled then return end
                if obj.Name == "SeekGuidingLight" then
                    for i, l in ipairs(PathLights) do
                        if l == obj then
                            table.remove(PathLights, i)
                            break
                        end
                    end
                    redraw()
                end
            end)
        else
            if PathAddedConn then
                PathAddedConn:Disconnect()
                PathAddedConn = nil
            end
            if PathRemovedConn then
                PathRemovedConn:Disconnect()
                PathRemovedConn = nil
            end
            if PathFolder then
                PathFolder:Destroy()
                PathFolder = nil
            end
            PathLights = {}
        end
    end
})

MovementGroup:AddCheckbox('NoClipToggle', {
    Text = '穿墙',
    Default = false,
    Callback = function(state)
        local player = game.Players.LocalPlayer
        local char = player.Character
        local runService = game:GetService("RunService")
        
        if state then
            _G.NoClip = runService.Stepped:Connect(function()
                for _, v in pairs(char:GetDescendants()) do
                    if v:IsA("BasePart") then
                        v.CanCollide = false
                    end
                end
            end)
        else
            if _G.NoClip then
                _G.NoClip:Disconnect()
                _G.NoClip = nil
            end
            for _, v in pairs(char:GetDescendants()) do
                if v:IsA("BasePart") then
                    v.CanCollide = true
                end
            end
        end
    end
})


local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

local GodmodeSystem = {
    AutoMode = "Toggle",
    PreviousMode = "Toggle",
    AutoDistance = 166,
    ActiveEntities = {}
}

function GodmodeSystem:SetGodmode(state)
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local collision = char:FindFirstChild("Collision")
    if not (hum and collision) then return end
    
    if state then
        -- 启用Godmode
        hum.HipHeight = 0.09
        collision.Size = Vector3.new(1, 3, 3)
        if collision:FindFirstChild("CollisionCrouch") then
            collision.CollisionCrouch.Size = Vector3.new(1, 3, 3)
        end
    else
        -- 禁用Godmode
        hum.HipHeight = 2.4
        collision.Size = Vector3.new(5.5, 3, 3)
        if collision:FindFirstChild("CollisionCrouch") then
            collision.CollisionCrouch.Size = Vector3.new(5.5, 3, 3)
        end
    end
end

function GodmodeSystem:SafeDisableGod()
    if not LocalPlayer.Character then return end
    local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    local collision = LocalPlayer.Character:FindFirstChild("Collision")
    if not (hum and collision) then
        self:SetGodmode(false)
        return
    end
    
    local wasNoclip = Toggles.Noclip and Toggles.Noclip.Value
    local shouldShim = self.AutoMode ~= "Never" and not wasNoclip
    
    if shouldShim and Toggles.Noclip then
        Toggles.Noclip:SetValue(true)
    end
    
    self:SetGodmode(false)
    
    if shouldShim and Toggles.Noclip then
        task.delay(0.2, function()
            if Toggles.Noclip and Toggles.Noclip.Value then
                Toggles.Noclip:SetValue(false)
            end
        end)
    end
end

function GodmodeSystem:IsValidEntity(entity)
    local EntList = {"a60", "ambushmoving", "backdoorrush", "rushmoving", "mandrake"}
    return table.find(EntList, entity.Name:lower()) ~= nil
end

function GodmodeSystem:Initialize()
    -- 实体检测
    workspace.DescendantAdded:Connect(function(entity)
        if not self:IsValidEntity(entity) then return end
        local part = entity:FindFirstChildWhichIsA("BasePart")
        if part then self.ActiveEntities[entity] = part end
    end)

    -- Godmode控制循环
    RunService.RenderStepped:Connect(function()
        local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not root then return end
        
        if self.AutoMode == "Never" then
            if Toggles.PositionSpoof.Value then
                Toggles.PositionSpoof:SetValue(false)
            end
        elseif self.AutoMode == "Always" then
            if not Toggles.PositionSpoof.Value then
                Toggles.PositionSpoof:SetValue(true)
            end
        elseif self.AutoMode == "Automatic" then
            local shouldEnable = false
            for entity, part in pairs(self.ActiveEntities) do
                if entity.Parent == nil then
                    self.ActiveEntities[entity] = nil
                elseif part then
                    local dist = (root.Position - part.Position).Magnitude
                    if dist < self.AutoDistance then
                        shouldEnable = true
                        break
                    end
                end
            end
            
            if shouldEnable then
                if not Toggles.PositionSpoof.Value then
                    Toggles.PositionSpoof:SetValue(true)
                end
            else
                if Toggles.PositionSpoof.Value then
                    Toggles.PositionSpoof:SetValue(false)
                    self:SafeDisableGod()
                end
            end
        elseif self.AutoMode == "Hold" then
            local keyCode = Options.PositionSpoofKey and Options.PositionSpoofKey.Value
            if keyCode and UserInputService:IsKeyDown(keyCode) then
                if not Toggles.PositionSpoof.Value then
                    Toggles.PositionSpoof:SetValue(true)
                end
            else
                if Toggles.PositionSpoof.Value then
                    Toggles.PositionSpoof:SetValue(false)
                    self:SafeDisableGod()
                end
            end
        end
    end)

    -- Godmode状态保持
    task.spawn(function()
        while true do
            task.wait(0.1)
            if Toggles.PositionSpoof and Toggles.PositionSpoof.Value then
                self:SetGodmode(true)
            end
        end
    end)
end

MovementGroupZ:AddDropdown("GodmodeMode", { 
    Text = "上帝模式",
    Default = "Toggle",
    Values = {"Toggle", "Automatic", "Hold", "Always"},
    Callback = function(mode)
        GodmodeSystem.AutoMode = mode
        GodmodeSystem.PreviousMode = mode
        if Options.PositionSpoofKey then
            Options.PositionSpoofKey.Text = "Position Spoof (" .. mode .. ")"
        end
        if mode == "Always" then
            Toggles.PositionSpoof:SetValue(true)
        elseif mode == "Never" then
            Toggles.PositionSpoof:SetValue(false)
        end
    end
})

MovementGroupZ:AddCheckbox("PositionSpoof", {
    Text = "开启上帝模式",
    Default = false,
    Callback = function(v)
        if v then
            GodmodeSystem:SetGodmode(true)
        else
            GodmodeSystem:SafeDisableGod()
        end
    end
}):AddKeyPicker("PositionSpoofKey", {
    Default = "K",
    Mode = "Toggle",
    Text = "Position Spoof (Toggle)",
    NoUI = false,
    SyncToggleState = true,
})

MovementGroupZ:AddLabel("如果无法开始，那就是你的注入器不支持函数")

-- 初始化系统
GodmodeSystem:Initialize()

local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local ACMSystem = {
    savedCamCFrame = nil,
    camLocked = false,
    acmButton = nil,
    acmButtonActive = false
}

function ACMSystem:CreateACMButton()
    if not UserInputService.TouchEnabled or self.acmButton then return end
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "ACMGui"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = PlayerGui
    
    local button = Instance.new("TextButton")
    button.Name = "ACMButton"
    button.Size = UDim2.new(0, 70, 0, 35)
    button.Position = UDim2.new(1, -80, 0.5, -17)
    button.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    button.Text = "ACM"
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Font = Enum.Font.GothamBold
    button.TextSize = 16
    button.BorderSizePixel = 0
    button.Parent = screenGui
    
    button.MouseButton1Down:Connect(function()
        self.acmButtonActive = true
        button.BackgroundColor3 = Color3.fromRGB(90, 90, 90)
    end)
    
    button.MouseButton1Up:Connect(function()
        self.acmButtonActive = false
        button.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    end)
    
    self.acmButton = screenGui
end

function ACMSystem:RemoveACMButton()
    if self.acmButton then
        self.acmButton:Destroy()
        self.acmButton = nil
        self.acmButtonActive = false
    end
end

function ACMSystem:Initialize()

    MovementGroupZ:AddCheckbox("AntiCheatManipulation", {
        Text = "反作弊操作",
        Default = false,
    }):AddKeyPicker("AntiCheatManipulation_K", {
        Default = "T",
        Mode = "Hold",
        Text = "Anti-Cheat Manipulation",
    })

    -- 切换按钮显示
    Toggles.AntiCheatManipulation:OnChanged(function()
        if Toggles.AntiCheatManipulation.Value then
            self:CreateACMButton()
        else
            self:RemoveACMButton()
        end
    end)

    -- 主ACM循环
    RunService.RenderStepped:Connect(function()
        local cam = workspace.CurrentCamera
        if not cam then return end
        
        local active = (Toggles.AntiCheatManipulation.Value and Options.AntiCheatManipulation_K:GetState()) or self.acmButtonActive
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        
        if active and hrp then
            if not self.camLocked then
                self.savedCamCFrame = cam.CFrame
                cam.CameraType = Enum.CameraType.Scriptable
                self.camLocked = true
                -- 将玩家传送到远处避免检测
                hrp.CFrame = hrp.CFrame * CFrame.new(0, 0, 100)
            end
            -- 保持相机在原始位置
            cam.CFrame = self.savedCamCFrame
        else
            if self.camLocked then
                cam.CameraType = Enum.CameraType.Custom
                self.camLocked = false
            end
        end
    end)
end

-- 初始化系统
ACMSystem:Initialize()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Walkspeed 系统
local WalkspeedSystem = {
    Unloaded = false,
    ClonedCollision = nil,
    OldAccel = PhysicalProperties.new(0.01, 0.7, 0, 1, 1)
}

function WalkspeedSystem:Initialize()
    -- 初始化碰撞克隆
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("CollisionPart") then
        self.ClonedCollision = LocalPlayer.Character.CollisionPart:Clone()
        self.ClonedCollision.Name = "_CollisionClone"
        self.ClonedCollision.Massless = true
        self.ClonedCollision.Parent = LocalPlayer.Character
        self.ClonedCollision.CanCollide = false
        self.ClonedCollision.CanQuery = false
        self.ClonedCollision.CustomPhysicalProperties = self.OldAccel
    end

    -- 角色重生处理
    LocalPlayer.CharacterAdded:Connect(function()
        task.wait(1.5)
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("CollisionPart") then
            self.ClonedCollision = LocalPlayer.Character.CollisionPart:Clone()
            self.ClonedCollision.Name = "_CollisionClone"
            self.ClonedCollision.Massless = true
            self.ClonedCollision.Parent = LocalPlayer.Character
            self.ClonedCollision.CanCollide = false
            self.ClonedCollision.CanQuery = false
            self.ClonedCollision.CustomPhysicalProperties = self.OldAccel
        end
    end)

    -- 速度绕过保护循环
    task.spawn(function()
        while task.wait(0.23) and not self.Unloaded do
            if Toggles.WalkspeedModifier.Value and Options.WalkspeedAmount.Value > 21 and self.ClonedCollision then
                self.ClonedCollision.Massless = false
                task.wait(0.23)
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character.HumanoidRootPart.Anchored then
                    self.ClonedCollision.Massless = true
                    task.wait(1)
                end
                self.ClonedCollision.Massless = true
            end
        end
    end)

    -- 主速度控制循环
    task.spawn(function()
        while task.wait(0.1) and not self.Unloaded do
            local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid and Toggles.WalkspeedModifier.Value then
                humanoid.WalkSpeed = Options.WalkspeedAmount.Value
            end
        end
    end)
end

-- 添加到GUI

MovementGroup:AddCheckbox("WalkspeedModifier", {
    Text = "速度绕过",
    Default = false,
    Risky = true,
    Callback = function(Value)
        if Value then
            local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = Options.WalkspeedAmount.Value
            end
        end
    end
})

MovementGroup:AddSlider("WalkspeedAmount", {
    Text = "奔跑速度",
    Default = 21,
    Min = 0,
    Max = 100,
    Rounding = 0,
    Callback = function(Value)
        if Toggles.WalkspeedModifier.Value then
            local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = Value
            end
        end
    end
})

-- 初始化系统
WalkspeedSystem:Initialize()
MovementGroup:AddLabel("请确保你的ping和网络足够好")
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

PPP:AddCheckbox("NightVision", {
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

PPP:AddCheckbox("无阴影", {
    Text = "无阴影",
    Default = false,
    Callback = function(v)
        game:GetService("Lighting").GlobalShadows = not v and true or false
    end
})
    
local originalFogEnd = game:GetService("Lighting").FogEnd
local originalAtmospheres = {}

PPP:AddCheckbox('MyToggle', {
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

A:AddCheckbox("AutoInteract", {
    Text = "自动互动",
    Default = false,
    Callback = function(Value)
        _G.AutoLoot = Value
        _G.Aura = {
            "ActivateEventPrompt",
            "AwesomePrompt",
            "FusesPrompt",
            "HerbPrompt",
            "LeverPrompt",
            "LootPrompt",
            "ModulePrompt",
            "SkullPrompt",
            "UnlockPrompt",
            "ValvePrompt",
        }
        
        if _G.AutoLoot then
            lootables = {}
            local function LootCheck(v)
                if not table.find(lootables, v) and v.Name ~= "Groundskeeper" and v:IsA("ProximityPrompt") and table.find(_G.Aura, v.Name) then
                    table.insert(lootables, v)
                end
            end
            for _, v in ipairs(workspace:GetDescendants()) do
                if v:IsA("ProximityPrompt") then
                    LootCheck(v)
                end
            end
            ChildAllNext = workspace.DescendantAdded:Connect(function(v)
                if v:IsA("ProximityPrompt") then
                    LootCheck(v)
                end
            end)
            RemoveChild = workspace.DescendantRemoving:Connect(function(v)
                for i = #lootables, 1, -1 do
                    if lootables[i] == v then
                        table.remove(lootables, i)
                        break
                    end
                end
            end)
        else
            if ChildAllNext then
                ChildAllNext:Disconnect()
                ChildAllNext = nil
            end
            if RemoveChild then
                RemoveChild:Disconnect()
                RemoveChild = nil
            end
        end
        
        while _G.AutoLoot do
            for i, v in pairs(lootables) do
                if v:IsA("ProximityPrompt") and table.find(_G.Aura, v.Name) and (v:GetAttribute("Interactions") == nil or v:GetAttribute("Interactions") <= 2) then
                    local character = game.Players.LocalPlayer.Character
                    if character and character:FindFirstChild("HumanoidRootPart") then
                        local distance = (character.HumanoidRootPart.Position - v.Parent:GetPivot().Position).Magnitude
                        if distance <= 12 then
                            fireproximityprompt(v)
                        end
                    end
                end
            end
            task.wait(0.1)
        end
    end,
})

M:AddCheckbox("AutoDecrypt", {
    Text = "自动解密密码",
    Default = false,
    Callback = function(Value)
        _G.AutoDecrypt = Value
        if _G.AutoDecrypt then
            local function Deciphercode(v)
                local Hints = game.Players.LocalPlayer.PlayerGui:WaitForChild("PermUI"):WaitForChild("Hints")
                local code = {[1] = " _",[2] = " _", [3] = " _", [4] = " _", [5] = " _"}
                for i, v in pairs(v:WaitForChild("UI"):GetChildren()) do
                    if v:IsA("ImageLabel") and v.Name ~= "Image" then
                        for b, n in pairs(Hints:GetChildren()) do
                            if n:IsA("ImageLabel") and n.Visible and v.ImageRectOffset == n.ImageRectOffset then
                                code[tonumber(v.Name)] = n:FindFirstChild("TextLabel").Text 
                            end
                        end
                    end
                end 
                return code
            end
            local function CodeAll(v)
                if v:IsA("Tool") and v.Name == "LibraryHintPaper" then
                    local code = table.concat(Deciphercode(v))
                    if code then
                        if workspace:FindFirstChild("Padlock") and (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - workspace.Padlock:GetPivot().Position).Magnitude <= 30 then
                            if game:GetService("ReplicatedStorage"):FindFirstChild("RemotesFolder") then
                                game:GetService("ReplicatedStorage"):WaitForChild("RemotesFolder"):WaitForChild("LP"):FireServer(code)
                            end
                        end
                    end
                end
            end
            Getpaper = game.Players.LocalPlayer.Character.ChildAdded:Connect(function(v)
                CodeAll(v)
            end)
        else
            if Getpaper then
                Getpaper:Disconnect()
                Getpaper = nil
            end
        end
    end,
})

M:AddCheckbox("InfiniteOxygen", {
    Text = "无限氧气",
    Default = false,
    Callback = function(Value)
        _G.ActiveInfOxygen = Value 
        while _G.ActiveInfOxygen do 
            if game.Players.LocalPlayer.Character:GetAttribute("Oxygen") then
                game.Players.LocalPlayer.Character:SetAttribute("Oxygen",99999)
            end
            task.wait()
        end 
        if game.Players.LocalPlayer.Character:GetAttribute("Oxygen") then
            game.Players.LocalPlayer.Character:SetAttribute("Oxygen",100)
        end
    end,
})


M:AddSlider("HidingTransparencySlider", {
    Text = "柜子/床透明度",
    Default = 0.5,
    Min = 0,
    Max = 1,
    Rounding = 1,
    Compact = false,
    Callback = function(Value)
        _G.TransparencyHide = Value
    end,
})

M:AddCheckbox("HidingTransparency", {
    Text = "柜子/床透明",
    Default = false,
    Callback = function(Value)
        _G.HidingTransparency = Value
        while _G.HidingTransparency do
            if game.Players.LocalPlayer.Character:GetAttribute("Hiding") then
                for _, v in pairs(workspace.CurrentRooms:GetDescendants()) do
                    if v:IsA("ObjectValue") and v.Name == "HiddenPlayer" then
                        if v.Value == game.Players.LocalPlayer.Character then
                            local hidePart = {}
                            for _, i in pairs(v.Parent:GetChildren()) do
                                if i:IsA("BasePart") then
                                    i.Transparency = _G.TransparencyHide or 0.5
                                    table.insert(hidePart, i)
                                end
                            end
                            repeat task.wait()
                                for _, h in pairs(hidePart) do
                                    h.Transparency = _G.TransparencyHide or 0.5
                                    task.wait()
                                end
                            until not game.Players.LocalPlayer.Character:GetAttribute("Hiding") or not _G.HidingTransparency
                            for _, n in pairs(hidePart) do
                                n.Transparency = 0
                                task.wait()
                            end
                            break
                        end
                    end
                end
            end
            task.wait()
        end
    end,
})

Q:AddCheckbox("RemoveJeff", {
    Text = "移除JeffTheKiller",
    Default = false,
    Callback = function(state)
        _G.RemoveJeff = state
        
        if state then
            game:GetService("RunService").RenderStepped:Connect(function()
                pcall(function()
                    if _G.RemoveJeff then
                        for _, room in pairs(game.workspace.CurrentRooms:GetChildren()) do
                            for _, object in pairs(room:GetDescendants()) do
                                if (object:IsA("Model") or object:IsA("Part")) and object.Name == "JeffTheKiller" then
                                    if object:IsA("Model") and object:FindFirstChildOfClass("Humanoid") then
                                        object:Destroy()
                                    elseif object:IsA("Part") then
                                        object:Destroy()
                                    end

                                    wait(0.5)
                                    
                                    for _, child in pairs(object:GetDescendants()) do
                                        child:Destroy()
                                    end
                                end
                            end
                        end
                    end
                end)
            end)
        end
    end,
})

Q:AddCheckbox("RemoveBananaPeels", {
    Text = "移除香蕉皮",
    Default = false,
    Callback = function(state)
        _G.RemoveBananaPeels = state
        
        if state then
            game:GetService("RunService").RenderStepped:Connect(function()
                pcall(function()
                    if _G.RemoveBananaPeels then
                        for _, object in pairs(game.workspace:GetDescendants()) do
                            if object.Name == "BananaPeel" then
                                object:Destroy()
                            end
                        end
                    end
                end)
            end)
        end
    end,
})

Q:AddCheckbox("AntiGiggle", {
    Text = "移去Giggle",
    Default = false,
    Callback = function(state)
        if state then
            AntiConnections["Giggle"] = workspace.ChildAdded:Connect(function(child)
                if child.Name == "GiggleCeiling" then
                    if child:FindFirstChild("Hitbox") then
                        child.Hitbox.CanTouch = false
                    end
                end
            end)
        else
            if AntiConnections["Giggle"] then AntiConnections["Giggle"]:Disconnect() end
        end
    end,
})


Q:AddCheckbox("RemoveSeekArms", {
    Text = "移除Seek手臂和火焰",
    Default = false,
    Callback = function(state)
        _G.RemoveSeekArms = state
        
        if state then
            game:GetService("RunService").RenderStepped:Connect(function()
                pcall(function()
                    if _G.RemoveSeekArms then
                        local latestRoom = game:GetService("ReplicatedStorage").GameData.LatestRoom.Value
                        local currentRoom = game.workspace.CurrentRooms[tostring(latestRoom)]
                        
                        if currentRoom then
                            local assets = currentRoom:WaitForChild("Assets")

                            if assets:FindFirstChild("ChandelierObstruction") then
                                assets.ChandelierObstruction:Destroy()
                            end

                            for i = 1, 15 do
                                local seekArm = assets:FindFirstChild("Seek_Arm")
                                if seekArm then
                                    seekArm:Destroy()
                                end
                            end
                        end
                    end
                end)
            end)
        end
    end,
})

Q:AddCheckbox("RemoveGates", {
    Text = "移除Gate",
    Default = false,
    Callback = function(state)
        _G.RemoveGates = state
        
        if state then
            game:GetService("RunService").RenderStepped:Connect(function()
                pcall(function()
                    if _G.RemoveGates then
                        local latestRoom = game:GetService("ReplicatedStorage").GameData.LatestRoom.Value
                        local currentRoom = game.workspace.CurrentRooms[tostring(latestRoom)]
                        
                        if currentRoom and currentRoom:FindFirstChild("Gate") then
                            currentRoom.Gate:Destroy()
                        end
                    end
                end)
            end)
        end
    end,
})

Q:AddCheckbox("RemoveLights", {
    Text = "移除灯光减少延迟",
    Default = false,
    Callback = function(state)
        _G.RemoveLights = state
        
        if state then
            game:GetService("RunService").RenderStepped:Connect(function()
                pcall(function()
                    if _G.RemoveLights then
                        local latestRoomNumber = tostring(game:GetService("ReplicatedStorage").GameData.LatestRoom.Value)
                        local latestRoom = game.workspace.CurrentRooms:FindFirstChild(latestRoomNumber)
                        
                        if latestRoom then
                            local assets = latestRoom:FindFirstChild("Assets")
                            
                            if assets then
                                local chandelier = assets:FindFirstChild("Chandelier")
                                if chandelier then
                                    chandelier:Destroy()
                                end

                                local lightFixtures = assets:FindFirstChild("Light_Fixtures")
                                if lightFixtures then
                                    lightFixtures:Destroy()
                                end
                            end
                        end
                    end
                end)
            end)
        end
    end,
})

Q:AddCheckbox("AntiScreech", {
    Text = "防Screech",
    Default = false,
    Callback = function(Value)
        _G.AntiScreech = Value
        Screech = Value
        local old
        old = hookmetamethod(game,"__namecall",newcclosure(function(self,...)
            local args = {...}
            local method = getnamecallmethod()
            if tostring(self) == "Screech" and method == "FireServer" and Screech == true then
                args[1] = true
                return old(self,unpack(args))
            end
            return old(self,...)
        end))
        workspace.DescendantAdded:Connect(function(v)
            if v:IsA("Model") and v.Name == "Screech" then
                v:Destroy()
            end
        end)
    end,
})

Q:AddCheckbox("AntiHalt", {
    Text = "防Halt",
    Default = false,
    Callback = function(Value)
        _G.NoHalt = Value
        local HaltShade = game:GetService("ReplicatedStorage").ModulesClient.EntityModules:FindFirstChild("Shade") or game:GetService("ReplicatedStorage").ModulesClient.EntityModules:FindFirstChild("_Shade")
        if HaltShade then
            HaltShade.Name = _G.NoHalt and "_Shade" or "Shade"
        end
    end,
})

Q:AddCheckbox("AntiEyes", {
    Text = "防Eyes",
    Default = false,
    Callback = function(Value)
        _G.NoEyes = Value
        while _G.NoEyes do
            if workspace:FindFirstChild("Eyes") then
                if game:GetService("ReplicatedStorage"):FindFirstChild("RemotesFolder") then
                    game:GetService("ReplicatedStorage"):WaitForChild("RemotesFolder"):WaitForChild("MotorReplication"):FireServer(-649)
                end
            end
            task.wait()
        end
    end,
})

Q:AddCheckbox("AntiLookman", {
    Text = "防Lookman",
    Default = false,
    Callback = function(Value)
        _G.NoLookman = Value
        while _G.NoLookman do
            if workspace:FindFirstChild("BackdoorLookman") then
                if game:GetService("ReplicatedStorage"):FindFirstChild("RemotesFolder") then
                    game:GetService("ReplicatedStorage"):WaitForChild("RemotesFolder"):WaitForChild("MotorReplication"):FireServer(-649)
                end
            end
            task.wait()
        end
    end,
})


local connectionAdded
local connectionRemoved

local NotificationStyle = "XKHax"

local entityIcons = {
    A60 = "12350986086",
    A120 = "12351008553",
    BackdoorRush = "11102256553",
    RushMoving = "11102256553",
    AmbushMoving = "10938726652",
    Eyes = "10865377903",
    BackdoorLookman = "16764872677",
    JeffTheKiller = "98993343",
    GloombatSwarm = "79221203116470",
    HaltRoom = "11331795398"
}

S:AddDropdown("NotificationStyle", {
    Values = {"Doors成就模仿", "中上方通知", "原始Library"},
    Default = 1,
    Multi = false,
    Text = "通知样式",
    Tooltip = "选择实体出现时的通知样式",
    Callback = function(Value)
        if Value == "中上方通知" then
            NotificationStyle = "XKHub"
        elseif Value == "Doors成就模仿" then
            NotificationStyle = "XKHax"
        else
            NotificationStyle = "Library"
        end
    end
})

S:AddToggle("ShopkeeperESP", {
    Text = "实体通知",
    Default = false,
    Callback = function(state)
        local entities = {
            AmbushMoving = {DisplayName = "Ambush"},
            RushMoving = {DisplayName = "Rush"},
            Eyes = {DisplayName = "Eyes"},
            A120 = {DisplayName = "A-120"},
            A60 = {DisplayName = "A-60"},
            FigureRig = {DisplayName = "Figure"},
            GiggleCeiling = {DisplayName = "Giggle"},
            GrumbleRig = {DisplayName = "Grumble"},
            Snare = {DisplayName = "Snare"},
            BackdoorRush = {DisplayName = "Backdoor Rush"},
            Blitz = {DisplayName = "Blitz"},
            BackdoorLookman = {DisplayName = "Backdoor Lookman"},
            GloombatSwarm = {DisplayName = "Gloombat Swarm"},
            JeffTheKiller = {DisplayName = "Jeff The Killer"}
        }

        local function isValidEntity(entity)
            if not (entity:IsA("Model") or entity:IsA("BasePart")) then
                return false
            end

            if entity:IsA("Model") then
                if not entity.PrimaryPart and not entity:FindFirstChildWhichIsA("BasePart") then
                    return false
                end
            end

            local parent = entity.Parent
            while parent ~= nil do
                if parent.Name == "Entities" or parent == workspace then
                    return true
                end
                parent = parent.Parent
            end
            return false
        end

        local function sendNotification(entityName, action)
            if entities[entityName] then
                local text = "实体" .. action .. "：" .. entities[entityName].DisplayName
                
                if NotificationStyle == "XKHub" then
                    XKHub:Notification("实体通知", text, 5)
                elseif NotificationStyle == "XKHax" then
                    local icon = entityIcons[entityName] or "6023426923"
                    XKHax.Show("实体通知", entities[entityName].DisplayName, action, 5, "rbxassetid://" .. icon, Color3.fromRGB(255, 0, 0))
                else
                    Library:Notify(text, 5, 4590662766)
                end
            end
        end

        local function checkEntity(entity)
            if entities[entity.Name] and isValidEntity(entity) then
                if entity:IsA("Model") then
                    local humanoid = entity:FindFirstChildOfClass("Humanoid")
                    if humanoid and humanoid.Health <= 0 then
                        return
                    end
                end
                sendNotification(entity.Name, "已出现")
            end
        end

        local function entityRemoved(entity)
            if entities[entity.Name] and isValidEntity(entity) then
                sendNotification(entity.Name, "已消失")
            end
        end

        if state then
            for _, entity in pairs(workspace:GetDescendants()) do
                task.spawn(checkEntity, entity)
            end

            connectionAdded = workspace.DescendantAdded:Connect(function(entity)
                task.wait(0.5)
                task.spawn(checkEntity, entity)
            end)

            connectionRemoved = workspace.DescendantRemoving:Connect(function(entity)
                task.wait(0.5)
                task.spawn(entityRemoved, entity)
            end)
        else
            if connectionAdded then
                connectionAdded:Disconnect()
                connectionAdded = nil
            end
            if connectionRemoved then
                connectionRemoved:Disconnect()
                connectionRemoved = nil
            end
        end
    end
})

local EntityNotifier = {
    Enabled = false,
    Connection = nil,
    RemovalConnection = nil,  
    LastNotified = {} 
}

local entities = {
    AmbushMoving = {DisplayName = "Ambush"},
    RushMoving = {DisplayName = "Rush"},
    Eyes = {DisplayName = "Eyes"},
    A120 = {DisplayName = "A-120"},
    A60 = {DisplayName = "A-60"},
    FigureRig = {DisplayName = "Figure"},
    GiggleCeiling = {DisplayName = "Giggle"},
    GrumbleRig = {DisplayName = "Grumble"},
    Snare = {DisplayName = "Snare"},
    BackdoorRush = {DisplayName = "Backdoor Rush"},
    Blitz = {DisplayName = "Blitz"},
    BackdoorLookman = {DisplayName = "Backdoor Lookman"},
    GloombatSwarm = {DisplayName = "Gloombat Swarm"},
    JeffTheKiller = {DisplayName = "Jeff The Killer"}
}

local CustomNotificationText = "entity 已刷新" -- Default notification text

local function GetChatService()
    if game:GetService("TextChatService"):FindFirstChild("TextChannels") then
        return game:GetService("TextChatService").TextChannels.RBXGeneral
    elseif game:GetService("ReplicatedStorage"):FindFirstChild("DefaultChatSystemChatEvents") then
        return game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest
    end
    return nil
end

local function SafeSendMessage(message)
    local chatService = GetChatService()
    if not chatService then return false end
    
    if not message or string.len(message) < 1 then
        return false
    end

    local success, result = pcall(function()
        if chatService:IsA("TextChannel") then
            return chatService:SendAsync(message)
        else
            chatService:FireServer(message, "All")
            return true
        end
    end)
    
    return success and result
end

local function isValidEntity(entity)
    if not (entity:IsA("Model") or entity:IsA("BasePart")) then
        return false
    end
    
    if entity:IsA("Model") then
        if not entity.PrimaryPart and not entity:FindFirstChildWhichIsA("BasePart") then
            return false
        end
    end
    
    local parent = entity.Parent
    while parent ~= nil do
        if parent.Name == "Entities" or parent == workspace then
            return true
        end
        parent = parent.Parent
    end
    return false
end

local function notifyEntity(entityName)
    if entities[entityName] then
        local message = CustomNotificationText:gsub("entity", entities[entityName].DisplayName)
        SafeSendMessage(message)
    end
end

local function notifyEntityRemoval(entityName)
    if entities[entityName] then
        SafeSendMessage(entities[entityName].DisplayName.." 已消失")
    end
end

local function checkEntity(entity)
    if entities[entity.Name] and isValidEntity(entity) then
        if entity:IsA("Model") then
            local humanoid = entity:FindFirstChildOfClass("Humanoid")
            if humanoid and humanoid.Health <= 0 then
                return
            end
        end
        notifyEntity(entity.Name)
    end
end

S:AddToggle("ShopkeeperESP", {
    Text = "实体聊天通知",
    Default = false,
    Callback = function(state)
        EntityNotifier.Enabled = state
    
        if EntityNotifier.Connection then
            EntityNotifier.Connection:Disconnect()
            EntityNotifier.Connection = nil
        end
        if EntityNotifier.RemovalConnection then
            EntityNotifier.RemovalConnection:Disconnect()
            EntityNotifier.RemovalConnection = nil
        end
    
        if state then
            for _, entity in pairs(workspace:GetDescendants()) do
                task.spawn(checkEntity, entity)
            end
            
            EntityNotifier.Connection = workspace.DescendantAdded:Connect(function(entity)
                task.wait(0.5)
                if EntityNotifier.Enabled then
                    task.spawn(checkEntity, entity)
                end
            end)

            EntityNotifier.RemovalConnection = workspace.DescendantRemoving:Connect(function(entity)
                if entities[entity.Name] then
                    notifyEntityRemoval(entity.Name)
                end
            end)
        end
    end
})

S:AddInput("CustomNotification", {
    Default = "entity 已刷新",
    Numeric = false,
    Finished = true,
    ClearTextOnFocus = false,
    Text = "自定义刷新提示",
    Placeholder = "输入自定义提示...",
    
    Callback = function(Value)
        if Value and Value ~= "" then
            CustomNotificationText = Value
            Library:Notify("修改成功", 5, 4590662766)
        end
    end,
})

game:GetService("Players").LocalPlayer.CharacterRemoving:Connect(function()
    if EntityNotifier.Connection then
        EntityNotifier.Connection:Disconnect()
        EntityNotifier.Connection = nil
    end
    if EntityNotifier.RemovalConnection then
        EntityNotifier.RemovalConnection:Disconnect()
        EntityNotifier.RemovalConnection = nil
    end
end)

A:AddCheckbox('AutoInteractToggle', {
    Text = '即时互动',
    Default = false,
    Callback = function(Value)

_G.NoCooldownProximity = Value
if _G.NoCooldownProximity == true then
for i, v in pairs(workspace:GetDescendants()) do
if v.ClassName == "ProximityPrompt" then
v.HoldDuration = 0
end
end
CooldownProximity = workspace.DescendantAdded:Connect(function(Cooldown)
if _G.NoCooldownProximity == true then
if Cooldown:IsA("ProximityPrompt") then
Cooldown.HoldDuration = 0
end
end
end)
else
if CooldownProximity then
CooldownProximity:Disconnect()
CooldownProximity = nil
end
end

Library:Notify("已关闭快速互动", 5, 4590662766)
	 end
})

E:AddCheckbox("DoorsESP", {
    Text = "门 ESP",
    Default = false,
    Callback = function(state)
        if state then
            ESPLibrary:EnableTag("Doors", {
                TargetName = "Door",
                Name = "门",
                Color = _G.DoorsESPColor or Color3.new(0, 1, 1),
                Tag = "Doors",
                ShowDistance = true,
                CheckForHumanoid = false,
                ParentFolder = workspace
            })
        else
            ESPLibrary:DisableTag("Doors")
        end
    end,
}):AddColorPicker("DoorsESPColor", {
    Default = Color3.new(0, 1, 1),
    Title = "门ESP颜色",
    Callback = function(value)
        _G.DoorsESPColor = value
    end
})

E:AddCheckbox("ObjectsESP", {
    Text = "重要物品透视",
    Default = false,
    Callback = function(state)
        if state then
            local objects = {
                {
                    TargetName = "WaterPump",
                    Name = "水泵",
                    Color = _G.ObjectsESPColor or Color3.new(0, 1, 0),
                    Tag = "WaterPump"
                },
                {
                    TargetName = "FuseObtain",
                    Name = "保险丝",
                    Color = _G.ObjectsESPColor or Color3.new(0, 1, 0),
                    Tag = "FuseObtain"
                },
                {
                    TargetName = "MinesGateButton",
                    Name = "矿场门按钮",
                    Color = _G.ObjectsESPColor or Color3.new(0, 1, 0),
                    Tag = "MinesGateButton"
                },
                {
                    TargetName = "MinesGenerator",
                    Name = "矿场发电机",
                    Color = _G.ObjectsESPColor or Color3.new(0, 1, 0),
                    Tag = "MinesGenerator"
                },
                {
                    TargetName = "LiveBreakerPolePickup",
                    Name = "电闸杆",
                    Color = _G.ObjectsESPColor or Color3.new(0, 1, 0),
                    Tag = "LiveBreakerPolePickup"
                },
                {
                    TargetName = "LiveHintBook",
                    Name = "提示书",
                    Color = _G.ObjectsESPColor or Color3.new(0, 1, 0),
                    Tag = "LiveHintBook"
                },
                {
                    TargetName = "LeverForGate",
                    Name = "门杠杆",
                    Color = _G.ObjectsESPColor or Color3.new(0, 1, 0),
                    Tag = "LeverForGate"
                },
                {
                    TargetName = "ElectricalKeyObtain",
                    Name = "电钥匙",
                    Color = _G.ObjectsESPColor or Color3.new(0, 1, 0),
                    Tag = "ElectricalKeyObtain"
                },
                {
                    TargetName = "KeyObtain",
                    Name = "钥匙",
                    Color = _G.ObjectsESPColor or Color3.new(0, 1, 0),
                    Tag = "KeyObtain"
                }
            }
            
            for _, objectConfig in ipairs(objects) do
                ESPLibrary:EnableTag(objectConfig.Tag, {
                    TargetName = objectConfig.TargetName,
                    Name = objectConfig.Name,
                    Color = objectConfig.Color,
                    Tag = objectConfig.Tag,
                    ShowDistance = true,
                    CheckForHumanoid = false,
                    ParentFolder = workspace
                })
            end
            
            _G.EnabledObjectsESP = objects
            
        else
            local objects = _G.EnabledObjectsESP or {
                "WaterPump", "FuseObtain", "MinesGateButton", "MinesGenerator",
                "LiveBreakerPolePickup", "LiveHintBook", "LeverForGate",
                "ElectricalKeyObtain", "KeyObtain"
            }
            
            for _, tag in ipairs(objects) do
                if type(tag) == "table" then
                    ESPLibrary:DisableTag(tag.Tag)
                else
                    ESPLibrary:DisableTag(tag)
                end
            end
            
            _G.EnabledObjectsESP = nil
        end
    end,
}):AddColorPicker("ObjectsESPColor", {
    Default = Color3.new(0, 1, 0),
    Title = "物品ESP颜色",
    Callback = function(value)
        _G.ObjectsESPColor = value
    end
})

E:AddCheckbox("EntitiesESP", {
    Text = "实体透视",
    Default = false,
    Callback = function(state)
        if state then
            local entities = {
                {
                    TargetName = "AmbushMoving",
                    Name = "Ambush",
                    Color = _G.EntitiesESPColor or Color3.new(1, 0, 0),
                    Tag = "AmbushMoving"
                },
                {
                    TargetName = "GloombatSwarm",
                    Name = "Gloombat",
                    Color = _G.EntitiesESPColor or Color3.new(1, 0, 0),
                    Tag = "GloombatSwarm"
                },
                {
                    TargetName = "BackdoorLookman",
                    Name = "Lookman",
                    Color = _G.EntitiesESPColor or Color3.new(1, 0, 0),
                    Tag = "BackdoorLookman"
                },
                {
                    TargetName = "JeffTheKiller",
                    Name = "Jeff",
                    Color = _G.EntitiesESPColor or Color3.new(1, 0, 0),
                    Tag = "JeffTheKiller"
                },
                {
                    TargetName = "Blitz",
                    Name = "Blitz",
                    Color = _G.EntitiesESPColor or Color3.new(1, 0, 0),
                    Tag = "Blitz"
                },
                {
                    TargetName = "BackdoorRush",
                    Name = "BackdoorRush",
                    Color = _G.EntitiesESPColor or Color3.new(1, 0, 0),
                    Tag = "BackdoorRush"
                },
                {
                    TargetName = "Snare",
                    Name = "Snare",
                    Color = _G.EntitiesESPColor or Color3.new(1, 0, 0),
                    Tag = "Snare"
                },
                {
                    TargetName = "GrumbleRig",
                    Name = "Grumble",
                    Color = _G.EntitiesESPColor or Color3.new(1, 0, 0),
                    Tag = "GrumbleRig"
                },
                {
                    TargetName = "GiggleCeiling",
                    Name = "Giggle",
                    Color = _G.EntitiesESPColor or Color3.new(1, 0, 0),
                    Tag = "GiggleCeiling"
                },
                {
                    TargetName = "FigureRig",
                    Name = "Figure",
                    Color = _G.EntitiesESPColor or Color3.new(1, 0, 0),
                    Tag = "FigureRig"
                },
                {
                    TargetName = "A60",
                    Name = "A-60",
                    Color = _G.EntitiesESPColor or Color3.new(1, 0, 0),
                    Tag = "A60"
                },
                {
                    TargetName = "A120",
                    Name = "A-120",
                    Color = _G.EntitiesESPColor or Color3.new(1, 0, 0),
                    Tag = "A120"
                },
                {
                    TargetName = "Eyes",
                    Name = "Eyes",
                    Color = _G.EntitiesESPColor or Color3.new(1, 0, 0),
                    Tag = "Eyes"
                },
                {
                    TargetName = "RushMoving",
                    Name = "Rush",
                    Color = _G.EntitiesESPColor or Color3.new(1, 0, 0),
                    Tag = "RushMoving"
                }
            }
            
            for _, entityConfig in ipairs(entities) do
                ESPLibrary:EnableTag(entityConfig.Tag, {
                    TargetName = entityConfig.TargetName,
                    Name = entityConfig.Name,
                    Color = entityConfig.Color,
                    Tag = entityConfig.Tag,
                    ShowDistance = true,
                    CheckForHumanoid = false,
                    ParentFolder = workspace
                })
            end
            
            _G.EnabledEntitiesESP = entities
            
        else
            local entities = _G.EnabledEntitiesESP or {
                "AmbushMoving", "GloombatSwarm", "BackdoorLookman", "JeffTheKiller",
                "Blitz", "BackdoorRush", "Snare", "GrumbleRig", "GiggleCeiling",
                "FigureRig", "A60", "A120", "Eyes", "RushMoving"
            }
            
            for _, tag in ipairs(entities) do
                if type(tag) == "table" then
                    ESPLibrary:DisableTag(tag.Tag)
                else
                    ESPLibrary:DisableTag(tag)
                end
            end
            
            _G.EnabledEntitiesESP = nil
        end
    end,
}):AddColorPicker("EntitiesESPColor", {
    Default = Color3.new(1, 0, 0),
    Title = "实体ESP颜色",
    Callback = function(value)
        _G.EntitiesESPColor = value
    end
})

E:AddCheckbox("ChestESP", {
    Text = "宝箱透视",
    Default = false,
    Callback = function(state)
        if state then
            local chests = {
                {
                    TargetName = "ChestBox",
                    Name = "宝箱",
                    Color = _G.ChestESPColor or Color3.new(1, 1, 1),
                    Tag = "ChestBox"
                },
                {
                    TargetName = "Chest",
                    Name = "宝箱",
                    Color = _G.ChestESPColor or Color3.new(1, 1, 1),
                    Tag = "Chest"
                }
            }
            
            for _, chestConfig in ipairs(chests) do
                ESPLibrary:EnableTag(chestConfig.Tag, {
                    TargetName = chestConfig.TargetName,
                    Name = chestConfig.Name,
                    Color = chestConfig.Color,
                    Tag = chestConfig.Tag,
                    ShowDistance = true,
                    CheckForHumanoid = false,
                    ParentFolder = workspace
                })
            end
            
            _G.EnabledChestESP = chests
            
        else
            local chests = _G.EnabledChestESP or {
                "ChestBox", "Chest"
            }
            
            for _, tag in ipairs(chests) do
                if type(tag) == "table" then
                    ESPLibrary:DisableTag(tag.Tag)
                else
                    ESPLibrary:DisableTag(tag)
                end
            end
            
            _G.EnabledChestESP = nil
        end
    end,
}):AddColorPicker("ChestESPColor", {
    Default = Color3.new(1, 1, 1),
    Title = "宝箱ESP颜色",
    Callback = function(value)
        _G.ChestESPColor = value
    end
})

E:AddCheckbox("GoldESP", {
    Text = "金币透视",
    Default = false,
    Callback = function(state)
        if state then
            ESPLibrary:EnableTag("GoldPile", {
                TargetName = "GoldPile",
                Name = "金币",
                Color = _G.GoldESPColor or Color3.new(1, 1, 0),
                Tag = "GoldPile",
                ShowDistance = true,
                CheckForHumanoid = false,
                ParentFolder = workspace
            })
        else
            ESPLibrary:DisableTag("GoldPile")
        end
    end,
}):AddColorPicker("GoldESPColor", {
    Default = Color3.new(1, 1, 0),
    Title = "金币ESP颜色",
    Callback = function(value)
        _G.GoldESPColor = value
    end
})

E:AddCheckbox("BedESP", {
    Text = "床透视",
    Default = false,
    Callback = function(state)
        if state then
            ESPLibrary:EnableTag("Bed", {
                TargetName = "Bed",
                Name = "床",
                Color = _G.BedESPColor or Color3.new(0, 111, 0),
                Tag = "Bed",
                ShowDistance = true,
                CheckForHumanoid = false,
                ParentFolder = workspace
            })
        else
            ESPLibrary:DisableTag("Bed")
        end
    end,
}):AddColorPicker("BedESPColor", {
    Default = Color3.new(0, 111, 0),
    Title = "床ESP颜色",
    Callback = function(value)
        _G.BedESPColor = value
    end
})

E:AddCheckbox("HideESP", {
    Text = "躲藏柜透视",
    Default = false,
    Callback = function(state)
        if state then
            local lockers = {
                {
                    TargetName = "Wardrobe",
                    Name = "衣柜",
                    Color = _G.HideESPColor or Color3.new(0, 100, 0),
                    Tag = "Wardrobe"
                },
                {
                    TargetName = "Rooms_Locker",
                    Name = "储物柜",
                    Color = _G.HideESPColor or Color3.new(0, 100, 0),
                    Tag = "Rooms_Locker"
                },
                {
                    TargetName = "Locker",
                    Name = "储物柜",
                    Color = _G.HideESPColor or Color3.new(0, 100, 0),
                    Tag = "Locker"
                }
            }
            
            for _, lockerConfig in ipairs(lockers) do
                ESPLibrary:EnableTag(lockerConfig.Tag, {
                    TargetName = lockerConfig.TargetName,
                    Name = lockerConfig.Name,
                    Color = lockerConfig.Color,
                    Tag = lockerConfig.Tag,
                    ShowDistance = true,
                    CheckForHumanoid = false,
                    ParentFolder = workspace
                })
            end
            
            _G.EnabledHideESP = lockers
            
        else
            local lockers = _G.EnabledHideESP or {
                "Wardrobe", "Rooms_Locker", "Locker"
            }
            
            for _, tag in ipairs(lockers) do
                if type(tag) == "table" then
                    ESPLibrary:DisableTag(tag.Tag)
                else
                    ESPLibrary:DisableTag(tag)
                end
            end
            
            _G.EnabledHideESP = nil
        end
    end,
}):AddColorPicker("HideESPColor", {
    Default = Color3.new(0, 100, 0),
    Title = "躲藏柜ESP颜色",
    Callback = function(value)
        _G.HideESPColor = value
    end
})

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local ESPEnabled = false
local ESPStorage = {}

local ESPSettings = {
    MainColor = Color3.fromRGB(0, 255, 255),    
    StrokeThickness = 1.3,                    
    Font = Enum.Font.RobotoCondensed,          
    TextSize = 15,                             
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
            local dist = (data.Root.Position - Camera.CFrame.Position).Magnitude
            local hp = math.floor(data.Humanoid.Health)
            local max = math.floor(data.Humanoid.MaxHealth)
            data.Label.Text = string.format("%s\n[%.0f]\n[%d/%d]", player.Name, dist, hp, max)
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

E:AddCheckbox("PlayerESP", {
    Text = "玩家",
    Default = false,
    Callback = function(state)
        ESPEnabled = state
        refreshAll()
    end
}):AddColorPicker("PlayerESPColor", {
    Default = Color3.new(0, 255, 255),
    Title = "玩家ESP颜色",
    Callback = function(value)
        ESPSettings.MainColor = value
        updateAllESPColors()
    end
})


