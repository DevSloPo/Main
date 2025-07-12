local Players = game:GetService("Players")
local XKHub_st = false
local XKHub_zd = false
local a = {
    auto = false
}
local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/DevSloPo/Main/refs/heads/main/main.lua"))()
local DripESP = loadstring(game:HttpGet("https://raw.githubusercontent.com/DevSloPo/DVES/refs/heads/main/gghh"))()

local Window = WindUI:CreateWindow({
    Title = "XK Hub 丨Chain丨这游戏太卡了，而且我不会玩，卡爆我",
    Icon = "moon",
    Author = "作者:小玄奘",
    Folder = "CloudHub",
    Size = UDim2.fromOffset(400, 300),
    Transparent = true,
    Theme = "Sky",
    User = {
        Enabled = true, 
        Callback = function() print("clicked") end, 
        Anonymous = true 
    },
})

Window:EditOpenButton({
    Title = "      开启UI      ",
    Icon = "eye",
    CornerRadius = UDim.new(0,16),
    StrokeThickness = 2,
    Color = ColorSequence.new( 
        Color3.fromHex("FF00FF"), 
        Color3.fromHex("00FFFF"), 
        Color3.fromHex("800080")   
    ),
    Draggable = true,
})

local Tabs = {
    M = Window:Tab({ Title = "主要", Icon = "house", Desc = "无" }),
    divider1 = Window:Divider(),
    Tab = Window:Tab({ Title = "其他", Icon = "eye", Desc = "无" }),
}

Window:SelectTab(1)

local FOVControl = {
    Enabled = false,
    CurrentFOV = 80,
    RenderConnection = nil,
    CameraConnection = nil,
    RespawnConnection = nil
}

Tabs.M:Toggle({
    Title = "启用视野",
    Value = false,
    Callback = function(state)
        FOVControl.Enabled = state

        local function applyFOV()
            if FOVControl.Enabled and workspace.CurrentCamera then
                workspace.CurrentCamera.FieldOfView = FOVControl.CurrentFOV
            end
        end

        if state then
            applyFOV()

            FOVControl.RenderConnection = game:GetService("RunService").RenderStepped:Connect(applyFOV)

            FOVControl.CameraConnection = workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(applyFOV)

            FOVControl.RespawnConnection = game:GetService("Players").LocalPlayer.CharacterAdded:Connect(function()
                task.wait(1)
                applyFOV()
            end)
        else
            if FOVControl.RenderConnection then
                FOVControl.RenderConnection:Disconnect()
                FOVControl.RenderConnection = nil
            end
            if FOVControl.CameraConnection then
                FOVControl.CameraConnection:Disconnect()
                FOVControl.CameraConnection = nil
            end
            if FOVControl.RespawnConnection then
                FOVControl.RespawnConnection:Disconnect()
                FOVControl.RespawnConnection = nil
            end

            if workspace.CurrentCamera then
                workspace.CurrentCamera.FieldOfView = 70
            end
        end
    end
})

Tabs.M:Slider({
    Title = "视野",
    Value = {
        Min = 70,
        Max = 120,
        Default = 80,
    },
    Callback = function(value)
        FOVControl.CurrentFOV = value
        if FOVControl.Enabled and workspace.CurrentCamera then
            workspace.CurrentCamera.FieldOfView = value
        end
    end
})

Tabs.M:Toggle({
    Title = "无限体力",
    Value = false,
    Callback = function(state)
        XKHub_st = state

        if state then
            task.spawn(function()
                while XKHub_st do
                    task.wait(1)
                    local player = Players.LocalPlayer
                    local playerName = player.Name

                    pcall(function()
                        local playerFolder = workspace:WaitForChild(playerName)
                        local stats = playerFolder:WaitForChild("Stats")
                        local stamina = stats:WaitForChild("Stamina")
                        stamina.Value = 100
                    end)
                end
            end)
        else
            local player = Players.LocalPlayer
            local playerFolder = workspace:FindFirstChild(player.Name)
            if playerFolder then
                local stats = playerFolder:FindFirstChild("Stats")
                if stats then
                    local stamina = stats:FindFirstChild("Stamina")
                    if stamina then
                        stamina.Value = 50
                    end
                end
            end
        end
    end
})

Tabs.M:Toggle({
    Title = "无限战斗体力",
    Value = false,
    Callback = function(state)
        XKHub_zd = state

        if state then
            task.spawn(function()
                while XKHub_zd do
                    task.wait(0.1)
                    local player = Players.LocalPlayer
                    local playerName = player.Name

                    pcall(function()
                        local playerFolder = workspace:WaitForChild(playerName)
                        local stats = playerFolder:WaitForChild("Stats")
                        local zdzd = stats:WaitForChild("CombatStamina")
                        zdzd.Value = 100
                    end)
                end
            end)
        else
            local player = Players.LocalPlayer
            local playerFolder = workspace:FindFirstChild(player.Name)
            if playerFolder then
                local stats = playerFolder:FindFirstChild("Stats")
                if stats then
                    local zdzd = stats:FindFirstChild("CombatStamina")
                    if zdzd then
                        zdzd.Value = 50
                    end
                end
            end
        end
    end
})

Tabs.M:Toggle({
    Title = "自动互动",
    Value = false,
    Callback = function(state)
        a.auto = state
    
        if state then
            a.interactThread = task.spawn(function()
                while a.auto do
                    task.wait(0.1)
                    for _, v in ipairs(workspace:GetDescendants()) do
                        if v:FindFirstChildOfClass("ProximityPrompt") then
                            local prompt = v:FindFirstChildOfClass("ProximityPrompt")
                            if prompt then
                                fireproximityprompt(prompt)
                                task.wait(0.05)
                            end
                        end
                    end
                end
            end)
        else
            if a.interactThread then
                task.cancel(a.interactThread)
                a.interactThread = nil
            end
        end
    end
})

Tabs.M:Toggle({
    Title = "穿墙",
    Value = false,
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

Tabs.Tab:Toggle({
    Title = "自由视角",
    Value = false,
    Callback = function(state)
        local player = game:GetService("Players").LocalPlayer
        if state then          
            player.CameraMaxZoomDistance = 99999
            player.CameraMode = Enum.CameraMode.Classic
        else         
            player.CameraMaxZoomDistance = 12.5
            player.CameraMode = Enum.CameraMode.LockFirstPerson
        end
    end
})

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local ESPEnabled = false
local ESPStorage = {}

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
        bill.Size = UDim2.new(0, 100, 0, 40) 
        bill.StudsOffset = Vector3.new(0, 2, 0)
        bill.Parent = root

        local label = Instance.new("TextLabel", bill)
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.TextColor3 = Color3.new(1, 1, 1)
        label.TextStrokeColor3 = Color3.new(0, 0, 0)
        label.TextStrokeTransparency = 0.5
        label.Font = Enum.Font.Gotham
        label.TextSize = 10
        label.Text = ""

        local highlight = Instance.new("Highlight")
        highlight.Name = "PlayerHighlight"
        highlight.FillColor = Color3.fromRGB(0, 255, 255)
        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
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
        if ESPEnabled then
            createESP(player)
        else
            removeESP(player)
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
            data.Label.Text = string.format("%s\n%.0f米\n%d/%d", player.Name, dist, hp, max)
        end
    end
end)

Players.PlayerAdded:Connect(function(player)
    if ESPEnabled then createESP(player) end
end)

Players.PlayerRemoving:Connect(function(player)
    removeESP(player)
end)

Tabs.Tab:Toggle({
    Title = "玩家ESP",
    Value = false,
    Callback = function(state)
        ESPEnabled = state
        refreshAll()
    end
})

Tabs.Tab:Toggle({
    Title = "CHAIN ESP",
    Value = false,
    Callback = function(state)
        local id = "ChainESP"
        if state then
            DripESP.SetOptions(id, {
                TargetName = "CHAIN",
                TargetType = "Model",
                CustomText = "链条",
                TextColor = Color3.fromRGB(255, 0, 0),
                TextSize = 25,
                CheckForHumanoid = false,
                FillColor = Color3.fromRGB(255, 0, 0),
                FillTransparency = 0.5,
                OutlineColor = Color3.fromRGB(0, 0, 0),
                OutlineTransparency = 0
            })
            DripESP.Enable(id)
        else
            DripESP.Disable(id)
        end
    end
})

Tabs.Tab:Toggle({
    Title = "Artifact ESP",
    Value = false,
    Callback = function(state)
        local id = "ArtifactnESP"
        if state then
            DripESP.SetOptions(id, {
                TargetName = "Artifact",
                TargetType = "Model",
                CustomText = "Artifact",
                TextColor = Color3.fromRGB(0, 255, 0),
                TextSize = 25,
                CheckForHumanoid = false,
                FillColor = Color3.fromRGB(0, 255, 0),
                FillTransparency = 0.5,
                OutlineColor = Color3.fromRGB(0, 0, 0),
                OutlineTransparency = 0
            })
            DripESP.Enable(id)
        else
            DripESP.Disable(id)
        end
    end
})

Tabs.Tab:Toggle({
    Title = "Shop ESP",
    Value = false,
    Callback = function(state)
        local id = "ArtifactnESP"
        if state then
            DripESP.SetOptions(id, {
                TargetName = "Shop",
                TargetType = "Part",
                CustomText = "商店",
                TextColor = Color3.fromRGB(0, 0, 255),
                TextSize = 25,
                CheckForHumanoid = false,
                FillColor = Color3.fromRGB(0, 0, 255),
                FillTransparency = 0.5,
                OutlineColor = Color3.fromRGB(0, 0, 0),
                OutlineTransparency = 0
            })
            DripESP.Enable(id)
        else
            DripESP.Disable(id)
        end
    end
})