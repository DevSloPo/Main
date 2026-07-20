local repo = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()

local Options = Library.Options
local Toggles = Library.Toggles

Library.ForceCheckbox = false
Library.ShowToggleFrameInKeybinds = false
Library.ShowCustomCursor = true

local localPlayer = game:GetService("Players").LocalPlayer
local allowedIds = {[10615465463] = true,  [4490894524] = true, [7731385535] = true, [7258604306] = true}
if not allowedIds[localPlayer.UserId] then
    localPlayer:Kick("Invalid User")
    return
end

local Window = Library:CreateWindow({
    Title = "MOECHAIN",
    Footer = "V3.0 | Obsidian Port (Final)",
    Icon = 13511292247,
    NotifySide = "Right",
    ShowCustomCursor = true,
})

local Tabs = {
    Main = Window:AddTab("Main", "user"),
    Visuals = Window:AddTab("Visuals", "eye"),
    Combat = Window:AddTab("Combat", "crosshair"),
    Survival = Window:AddTab("Survival", "heart"),
    Movement = Window:AddTab("Movement", "move"),
    Chain = Window:AddTab("Chain Alerts", "alert-triangle"),
    Automation = Window:AddTab("Automation", "bot"),
    Remote = Window:AddTab("Remote UI", "monitor"),
    Teleport = Window:AddTab("Teleports", "map-pin"),
    ["UI Settings"] = Window:AddTab("UI Settings", "settings"),
}

local P = game:GetService("Players")
local RS = game:GetService("RunService")
local L = game:GetService("Lighting")
local W = game:GetService("Workspace")
local lp = P.LocalPlayer
local Cam = W.CurrentCamera

local function createFakeFolder()
    local fake = {}
    fake.GetChildren = function() return {} end
    fake.GetDescendants = function() return {} end
    fake.FindFirstChild = function() return nil end
    fake.FindFirstChildOfClass = function() return nil end
    fake.GetAttribute = function() return nil end
    fake.IsA = function() return false end
    fake.ChildAdded = { Connect = function() return { Disconnect = function() end } end }
    return fake
end

local aiFolder = W:FindFirstChild("Misc") and W.Misc:FindFirstChild("AI") or createFakeFolder()
local ScrapFolder = W:FindFirstChild("Misc") and W.Misc:FindFirstChild("Zones") and W.Misc.Zones:FindFirstChild("LootingItems") and W.Misc.Zones.LootingItems:FindFirstChild("Scrap") or createFakeFolder()
local GameSections = W:FindFirstChild("GameStuff") and W.GameStuff:FindFirstChild("GameSections") or createFakeFolder()
local valuesFolder = W:FindFirstChild("GameStuff") and W.GameStuff:FindFirstChild("Values") or createFakeFolder()

local State = {
    AutoQTE = false,
    WinClash = false,
    InfGas = false,
    InfAmmo = false,
    BulletTrack = false,
    BulletTrail = false,
    NoRecoil = false,
    
    InfStamina = false,
    InfCombatStamina = false,
    PseudoGod = false,
    PseudoGodReturnPos = nil,
    Fullbright = false,
    FaceChain = false,
    
    AutoScrap = false,
    ScrapRange = 50,
    ScrapInterval = 6,
    AutoPower = false,
    
    ChainAlert = false,
    ChainDodge = false,
    ChainRing = true,
    ChainRotate = true,
    ChainRingRadius = 55,
    
    SpeedBoost = false,
    SpeedValue = 1,
    ThirdPerson = false,
    NoFog = false,
    Noclip = false,
    
    PlayerESP = false,
    PlayerESP_Color = Color3.fromRGB(0, 255, 0),
    
    ChainESP = false,
    ChainESP_Color = Color3.fromRGB(255, 21, 21),
    
    ScrapESP = false,
    ScrapESP_Color = Color3.fromRGB(255, 200, 0),
    
    AirDropESP = false,
    AirDropESP_Color = Color3.fromRGB(170, 0, 255),
    
    ArtifactESP = false,
    ArtifactESP_Color = Color3.fromRGB(170, 0, 255),
    
    HUD_Display = true,
    
    AutoDodge = false,
    GodMode = false,
}

task.spawn(function()
    pcall(function()
        local blueprints = lp:WaitForChild("PlayerStats"):WaitForChild("Blueprints")
        for _, name in ipairs({"CombatKnife", "DoubleBarrel", "M1911", "Machete", "Deagle"}) do
            if blueprints:GetAttribute(name) ~= nil then
                blueprints:SetAttribute(name, true)
            end
        end
        
        local pg = lp:WaitForChild("PlayerGui")
        local ingame = pg:WaitForChild("Ingame")
        local wb = ingame:WaitForChild("Workbench"):WaitForChild("MainFrame"):WaitForChild("Frame"):WaitForChild("Menu"):WaitForChild("Blueprints")
        local bpNames = {"Deagle", "CombatKnife", "DoubleBarrel", "M1911", "Machete"}
        
        local function showBlueprints()
            for _, name in ipairs(bpNames) do
                pcall(function()
                    local frame = wb:FindFirstChild(name)
                    if frame then
                        frame.Visible = true
                        local lock = frame:FindFirstChild("LockGradient")
                        if lock then lock.Visible = false end
                    end
                end)
            end
        end
        
        showBlueprints()
        wb.DescendantAdded:Connect(function(child)
            task.wait(0.1)
            showBlueprints()
        end)
    end)
end)

local ESPFolder = Instance.new("Folder")
ESPFolder.Name = "ESP"
ESPFolder.Parent = game:GetService("CoreGui")

local ESPList = {}
local ESP = {}

function ESP:Add(config)
    local entity = config.Entity
    if not entity then return nil end
    
    local part = config.Part
    if not part then
        if entity:IsA("Player") then
            local char = entity.Character
            part = char and char:FindFirstChild("HumanoidRootPart")
        elseif entity:IsA("Model") then
            part = entity:FindFirstChild("HumanoidRootPart") or entity.PrimaryPart
            if not part then part = entity:FindFirstChildWhichIsA("BasePart", true) end
        elseif entity:IsA("BasePart") then
            part = entity
        end
    end
    if not part then return nil end
    
    local cfg = {
        Name = config.Name or entity.Name,
        Color = config.Color or Color3.fromRGB(255, 255, 255),
        Highlight = config.Highlight ~= false,
        Box = config.Box == true,
        Text = config.Text ~= false,
        Distance = config.Distance ~= false,
        Info = config.Info or nil,
        TextSize = config.TextSize or 12,
        AlwaysOnTop = config.AlwaysOnTop ~= false,
        StudsOffset = config.StudsOffset or Vector3.new(0, 2, 0),
        BillboardSize = config.BillboardSize or UDim2.new(0, 180, 0, 30),
    }
    
    local d = {
        Entity = entity, Part = part, Config = cfg, Enabled = true,
        HL = nil, Box = nil, Gui = nil, NL = nil, DL = nil, IL = nil
    }
    
    if cfg.Highlight then
        local hlTarget = entity
        if entity:IsA("Player") and entity.Character then hlTarget = entity.Character end
        pcall(function() 
            local old = hlTarget:FindFirstChildOfClass("Highlight") 
            if old then old:Destroy() end 
        end)
        local hl = Instance.new("Highlight")
        hl.FillColor = cfg.Color
        hl.OutlineColor = cfg.Color
        hl.FillTransparency = 0.8
        hl.OutlineTransparency = 1
        if cfg.AlwaysOnTop then hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop end
        hl.Parent = hlTarget
        d.HL = hl
    end

    if Drawing then
        d.Box = Drawing.new("Square")
        d.Box.Thickness = 1
        d.Box.Filled = false
        d.Box.Visible = false
    end

    local ap = part
    if entity:IsA("Player") and entity.Character then
        local hd = entity.Character:FindFirstChild("Head")
        if hd then ap = hd end
    end

    local gui = Instance.new("BillboardGui")
    gui.Size = cfg.BillboardSize
    gui.StudsOffset = cfg.StudsOffset
    gui.AlwaysOnTop = true
    gui.Adornee = ap
    gui.Parent = ESPFolder
    
    local nl = Instance.new("TextLabel")
    nl.Size = UDim2.new(1, 0, 0, cfg.TextSize + 4)
    nl.BackgroundTransparency = 1
    nl.Text = cfg.Name
    nl.TextColor3 = cfg.Color
    nl.TextStrokeTransparency = 0
    nl.TextSize = cfg.TextSize
    nl.Font = Enum.Font.Code
    nl.Parent = gui
    
    local dl = Instance.new("TextLabel")
    dl.Size = UDim2.new(1, 0, 0, cfg.TextSize)
    dl.Position = UDim2.new(0, 0, 0, cfg.TextSize + 2)
    dl.BackgroundTransparency = 1
    dl.Text = "0m"
    dl.TextColor3 = cfg.Color
    nl.TextStrokeTransparency = 0
    dl.TextSize = cfg.TextSize - 2
    dl.Font = Enum.Font.Code
    dl.Parent = gui
    
    local il = Instance.new("TextLabel")
    il.Size = UDim2.new(1, 0, 0, cfg.TextSize)
    il.Position = UDim2.new(0, 0, 0, cfg.TextSize * 2 + 2)
    il.BackgroundTransparency = 1
    il.Text = ""
    il.TextColor3 = Color3.new(1, 1, 1)
    il.TextStrokeTransparency = 0
    il.TextSize = cfg.TextSize - 2
    il.Font = Enum.Font.Code
    il.Visible = false
    il.Parent = gui
    
    d.Gui = gui
    d.NL = nl
    d.DL = dl
    d.IL = il
    
    function d:SetText(t) 
        cfg.Name = t 
        if d.NL then d.NL.Text = t end 
    end
    
    function d:SetColor(c)
        cfg.Color = c
        if d.HL then d.HL.FillColor = c; d.HL.OutlineColor = c end
        if d.NL then d.NL.TextColor3 = c end
        if d.DL then d.DL.TextColor3 = c end
        if d.Box then d.Box.Color = c end
    end
    
    function d:SetEnabled(v)
        d.Enabled = v
        if not v then
            if d.HL then d.HL.Enabled = false end
            if d.Gui then d.Gui.Enabled = false end
            if d.Box then d.Box.Visible = false end
        end
    end
    
    function d:SetInfo(t)
        cfg.Info = t
        if d.IL then
            if t and t ~= "" then 
                d.IL.Text = t
                d.IL.Visible = true
            else 
                d.IL.Visible = false 
            end
        end
    end
    
    function d:SetPart(p) d.Part = p end
    function d:SetConfig(key, val) cfg[key] = val end
    function d:Remove()
        if d.HL then pcall(function() d.HL:Destroy() end) end
        if d.Gui then pcall(function() d.Gui:Destroy() end) end
        if d.Box then pcall(function() d.Box:Remove() end) end
        ESPList[d] = nil
    end
    
    ESPList[d] = true
    return d
end

function ESP:RemoveAll()
    for d in pairs(ESPList) do
        if d.HL then pcall(function() d.HL:Destroy() end) end
        if d.Gui then pcall(function() d.Gui:Destroy() end) end
        if d.Box then pcall(function() d.Box:Remove() end) end
        ESPList[d] = nil
    end
end

local espObjects = {
    Players = {},
    Chains = {},
    Scraps = {},
    AirDrops = {},
    Artifacts = {}
}

local function findArtifacts()
    local artifacts = {}
    for _, obj in ipairs(W:GetDescendants()) do
        if obj:IsA("BasePart") or obj:IsA("Model") then
            local name = string.lower(obj.Name)
            if string.find(name, "artifact") or string.find(name, "relic") then
                table.insert(artifacts, obj)
            end
        end
    end
    return artifacts
end

RS.RenderStepped:Connect(function()
    Cam = W.CurrentCamera
    local lc = lp.Character
    local lhrp = lc and lc:FindFirstChild("HumanoidRootPart")
    
    local toRemove = {}
    for d in pairs(ESPList) do
        local e = d.Entity
        if not e or not e.Parent then
            table.insert(toRemove, d)
        end
    end
    for _, d in ipairs(toRemove) do
        d:Remove()
    end
    
    if State.ChainESP then
        for _, chain in ipairs(aiFolder:GetChildren()) do
            if chain:IsA("Model") and chain:FindFirstChild("Humanoid") then
                if not espObjects.Chains[chain] then
                    local hrp = chain:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        espObjects.Chains[chain] = ESP:Add({
                            Entity = chain,
                            Part = hrp,
                            Name = chain.Name,
                            Color = State.ChainESP_Color,
                            Highlight = true,
                            Box = true,
                            Text = true,
                            Distance = true,
                            AlwaysOnTop = true,
                            StudsOffset = Vector3.new(0, 2, 0),
                            BillboardSize = UDim2.new(0, 180, 0, 30),
                        })
                    end
                end
            end
        end
    end
    
    if State.ScrapESP then
        for _, scrap in ipairs(ScrapFolder:GetChildren()) do
            if scrap:IsA("Model") and scrap:GetAttribute("Scrap") then
                local hasPart = false
                for _, descendant in ipairs(scrap:GetDescendants()) do
                    if descendant:IsA("BasePart") then
                        hasPart = true
                        break
                    end
                end
                if hasPart and not espObjects.Scraps[scrap] then
                    local pivot = scrap:GetPivot()
                    local _, bsize = scrap:GetBoundingBox()
                    
                    local anchorPart = Instance.new("Part")
                    anchorPart.Anchored = true
                    anchorPart.CanCollide = false
                    anchorPart.CanTouch = false
                    anchorPart.CanQuery = false
                    anchorPart.Transparency = 1
                    anchorPart.Size = bsize
                    anchorPart.CFrame = pivot
                    anchorPart.Parent = W
                    
                    espObjects.Scraps[scrap] = {
                        Obj = ESP:Add({
                            Entity = scrap,
                            Part = anchorPart,
                            Name = "Scrap",
                            Color = State.ScrapESP_Color,
                            Highlight = true,
                            Text = true,
                            Distance = true,
                            AlwaysOnTop = true,
                            StudsOffset = Vector3.new(0, 2, 0),
                        }),
                        Part = anchorPart
                    }
                end
            end
        end
    end
    
    if State.PlayerESP then
        for _, player in ipairs(P:GetPlayers()) do
            if player ~= lp then
                if not espObjects.Players[player] then
                    pcall(function()
                        local char = player.Character or player.CharacterAdded:Wait()
                        local hrp = char:WaitForChild("HumanoidRootPart", 5)
                        if hrp then
                            espObjects.Players[player] = ESP:Add({
                                Entity = player,
                                Part = hrp,
                                Name = player.Name,
                                Color = State.PlayerESP_Color,
                                Highlight = true,
                                Box = false,
                                Text = true,
                                Distance = true,
                                AlwaysOnTop = false,
                            })
                        end
                    end)
                end
            end
        end
    end
    
    if State.AirDropESP then
        local AirDropsFolder = GameSections:FindFirstChild("AirDrops")
        if AirDropsFolder then
            for _, heli in ipairs(AirDropsFolder:GetChildren()) do
                if heli.Name == "AirDropHeli" then
                    local airdrop = heli:FindFirstChildWhichIsA("Model", true) or heli
                    if not espObjects.AirDrops[airdrop] then
                        local hrp = airdrop:FindFirstChild("HumanoidRootPart") or airdrop.PrimaryPart
                        if hrp then
                            espObjects.AirDrops[airdrop] = ESP:Add({
                                Entity = airdrop,
                                Part = hrp,
                                Name = "Air Drop",
                                Color = State.AirDropESP_Color,
                                Highlight = true,
                                Text = true,
                                Distance = true,
                                AlwaysOnTop = true,
                                StudsOffset = Vector3.new(0, 2, 0),
                            })
                        end
                    end
                end
            end
        end
    end
    
    for d in pairs(ESPList) do
        local e = d.Entity
        local p = d.Part
        local c = d.Config
        
        if not p or not p.Parent then
            d:SetEnabled(false)
        else
            local alive = true
            if e:IsA("Player") then
                local hum = e.Character and e.Character:FindFirstChild("Humanoid")
                alive = hum and hum.Health > 0
            elseif e:IsA("Model") then
                local hum = e:FindFirstChild("Humanoid")
                if hum then alive = hum.Health > 0 end
            end
            
            if not d.Enabled or not alive then
                d:SetEnabled(false)
            else
                if c.Highlight and not d.HL then
                    local hlTarget = e
                    if e:IsA("Player") and e.Character then hlTarget = e.Character end
                    pcall(function()
                        local hl = Instance.new("Highlight")
                        hl.FillColor = c.Color
                        hl.OutlineColor = c.Color
                        hl.FillTransparency = 0.8
                        hl.OutlineTransparency = 1
                        if c.AlwaysOnTop then hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop end
                        hl.Parent = hlTarget
                        d.HL = hl
                    end)
                end
                
                local sp, onScr = Cam:WorldToViewportPoint(p.Position)
                
                if d.NL and d.DL then
                    d.NL.Text = c.Name
                    d.NL.TextColor3 = c.Color
                    d.DL.TextColor3 = c.Color
                    
                    if c.Distance and lhrp then
                        local dist = math.floor((lhrp.Position - p.Position).Magnitude)
                        d.DL.Text = tostring(dist) .. "m"
                        d.DL.Visible = true
                    else
                        d.DL.Visible = false
                    end
                end
                
                if e:IsA("Model") and e:FindFirstChild("Humanoid") then
                    local attrs = e:GetAttributes()
                    local infoStr = ""
                    if attrs.Anger then infoStr = infoStr .. "Anger:" .. string.format("%.1f", attrs.Anger) .. " " end
                    if attrs.ChokeMeter then infoStr = infoStr .. "Choke:" .. string.format("%.1f", attrs.ChokeMeter) .. "% " end
                    if attrs.Burst then infoStr = infoStr .. "Burst:" .. string.format("%.1f", attrs.Burst) end
                    d:SetInfo(infoStr)
                end
                
                if c.Box and d.Box then
                    local cf, sz
                    local char = e:IsA("Player") and e.Character or e
                    
                    if e:IsA("Model") and e.Name:lower():find("chain") then
                        local hrp = e:FindFirstChild("HumanoidRootPart")
                        if hrp then
                            cf = hrp.CFrame
                            sz = Vector3.new(4, 6, 4)
                        end
                    elseif char and char:IsA("Model") then
                        local okBB, rcf, rsz = pcall(char.GetBoundingBox, char)
                        if okBB and rcf then cf, sz = rcf, rsz end
                    end
                    
                    if not cf then cf = p.CFrame; sz = p.Size end
                    
                    local corners = {
                        cf * CFrame.new(-sz.X/2, -sz.Y/2, -sz.Z/2),
                        cf * CFrame.new(sz.X/2, -sz.Y/2, -sz.Z/2),
                        cf * CFrame.new(sz.X/2, sz.Y/2, -sz.Z/2),
                        cf * CFrame.new(-sz.X/2, sz.Y/2, -sz.Z/2),
                        cf * CFrame.new(-sz.X/2, -sz.Y/2, sz.Z/2),
                        cf * CFrame.new(sz.X/2, -sz.Y/2, sz.Z/2),
                        cf * CFrame.new(sz.X/2, sz.Y/2, sz.Z/2),
                        cf * CFrame.new(-sz.X/2, sz.Y/2, sz.Z/2),
                    }
                    
                    local x1, y1 = math.huge, math.huge
                    local x2, y2 = -math.huge, -math.huge
                    local boxVis = false
                    
                    for _, cn in ipairs(corners) do
                        local s, o = Cam:WorldToViewportPoint(cn.Position)
                        if o then 
                            boxVis = true
                            x1 = math.min(x1, s.X)
                            y1 = math.min(y1, s.Y)
                            x2 = math.max(x2, s.X)
                            y2 = math.max(y2, s.Y)
                        end
                    end
                    
                    if boxVis then
                        d.Box.Position = Vector2.new(x1, y1)
                        d.Box.Size = Vector2.new(x2 - x1, y2 - y1)
                        d.Box.Color = c.Color
                        d.Box.Visible = true
                    else
                        d.Box.Visible = false
                    end
                elseif d.Box then
                    d.Box.Visible = false
                end
            end
        end
    end
end)

P.PlayerAdded:Connect(function(player)
    if State.PlayerESP and player ~= lp then
        pcall(function()
            local char = player.Character or player.CharacterAdded:Wait()
            local hrp = char:WaitForChild("HumanoidRootPart", 5)
            if hrp then
                if espObjects.Players[player] then
                    espObjects.Players[player]:Remove()
                end
                espObjects.Players[player] = ESP:Add({
                    Entity = player,
                    Part = hrp,
                    Name = player.Name,
                    Color = State.PlayerESP_Color,
                    Highlight = true,
                    Box = false,
                    Text = true,
                    Distance = true,
                    AlwaysOnTop = false,
                })
            end
        end)
    end
end)

P.PlayerRemoving:Connect(function(player)
    if espObjects.Players[player] then
        espObjects.Players[player]:Remove()
        espObjects.Players[player] = nil
    end
end)

local cAlert = { 
    Active = false, 
    Notify = true, 
    Dodge = false, 
    ShowRing = true, 
    RingRotating = true, 
    RingColor = Color3.fromRGB(255, 50, 50),
    RingRadius = 55
}

local chainAlertAnims = {
    ["rbxassetid://11545349261"] = "Combo 1",
    ["rbxassetid://14123467583"] = "Combo 2",
    ["rbxassetid://14101304975"] = "Combo 3",
    ["rbxassetid://14101956641"] = "Back Attack",
    ["rbxassetid://15943264089"] = "Charged Slash",
    ["rbxassetid://14401168075"] = "Charged Charge",
    ["rbxassetid://14875631059"] = "AOE Attack",
    ["rbxassetid://11987922371"] = "Dodge",
    ["rbxassetid://14255769487"] = "Break Door",
    ["rbxassetid://15408077041"] = "Execution 1",
    ["rbxassetid://15409393739"] = "Execution 2",
    ["rbxassetid://11442109170"] = "Alert",
    ["rbxassetid://123029648649398"] = "Void Alert",
    ["rbxassetid://78440647847406"] = "Charging",
    ["rbxassetid://88813113168837"] = "Charged Jump Slash",
    ["rbxassetid://135099305543293"] = "Enrage",
    ["rbxassetid://140464711815827"] = "Enrage Counter",
    ["rbxassetid://16214202640"] = "Thrust",
}

local chainStateAnims = {
    ["rbxassetid://11442109170"] = true,
    ["rbxassetid://123029648649398"] = true,
    ["rbxassetid://135099305543293"] = true,
}

local chainAlertSounds = {
    ["CurbStomp1"] = "Stomp Counter",
    ["CurbStomp2"] = "Stomp Counter",
    ["Charging"] = "Charging",
    ["ChainsawSwing"] = "Chainsaw Swing",
    ["ChainsawCharge"] = "Chainsaw Charge",
    ["ChainsawSpot"] = "Chainsaw Thrust",
    ["ChokeSwing"] = "Thrust",
}

local chainRings = {}
local chainRingConn = nil
local RING_POINTS = 36
local WALL_HEIGHT = 50
local ringRotAngle = 0
local activeDodgeChains = {}

local function makeRingParts(radius)
    local data = { Balls = {}, Walls = {} }
    
    for i = 1, RING_POINTS do
        local ball = Instance.new("Part")
        ball.Shape = Enum.PartType.Ball
        ball.Size = Vector3.new(0.5, 0.5, 0.5)
        ball.Anchored = true
        ball.CanCollide = false
        ball.Material = Enum.Material.Neon
        ball.Color = cAlert.RingColor
        ball.Transparency = cAlert.ShowRing and 0.3 or 1
        ball.Parent = W
        table.insert(data.Balls, ball)
    end
    
    for i = 1, RING_POINTS do
        local chord = 2 * radius * math.sin(math.pi / RING_POINTS)
        local wall = Instance.new("Part")
        wall.Size = Vector3.new(chord + 0.2, WALL_HEIGHT, 1)
        wall.Anchored = true
        wall.CanCollide = false
        wall.Material = Enum.Material.ForceField
        wall.Color = cAlert.RingColor
        wall.Transparency = cAlert.ShowRing and 0.85 or 1
        wall.Parent = W
        table.insert(data.Walls, wall)
    end
    
    return data
end

local function updateRingPositions(ringData, chain, radius)
    local hrp = chain:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    local center = hrp.Position
    
    for i, ball in ipairs(ringData.Balls) do
        local angle = (i / RING_POINTS) * math.pi * 2 + ringRotAngle
        ball.Position = Vector3.new(
            center.X + math.cos(angle) * radius,
            center.Y - 2.5,
            center.Z + math.sin(angle) * radius
        )
    end
    
    for i, wall in ipairs(ringData.Walls) do
        local angle = (i / RING_POINTS) * math.pi * 2 + ringRotAngle
        wall.Position = Vector3.new(
            center.X + math.cos(angle) * radius,
            center.Y + WALL_HEIGHT / 2 - 15,
            center.Z + math.sin(angle) * radius
        )
        wall.CFrame = CFrame.new(wall.Position, center)
    end
end

local function clearSingleChainRing(chain)
    for i = #chainRings, 1, -1 do
        local d = chainRings[i]
        if d.Chain == chain then
            for _, p in ipairs(d.Parts.Balls) do pcall(function() p:Destroy() end) end
            for _, p in ipairs(d.Parts.Walls) do pcall(function() p:Destroy() end) end
            table.remove(chainRings, i)
            activeDodgeChains[chain] = nil
            break
        end
    end
end

local function clearChainRings()
    for _, d in ipairs(chainRings) do
        for _, p in ipairs(d.Parts.Balls) do pcall(function() p:Destroy() end) end
        for _, p in ipairs(d.Parts.Walls) do pcall(function() p:Destroy() end) end
    end
    chainRings = {}
    activeDodgeChains = {}
    if chainRingConn then chainRingConn:Disconnect(); chainRingConn = nil end
end

local function createChainRings()
    clearChainRings()
    
    for _, chain in ipairs(aiFolder:GetChildren()) do
        if chain:IsA("Model") then
            table.insert(chainRings, {
                Chain = chain,
                Parts = makeRingParts(cAlert.RingRadius)
            })
        end
    end
    
    ringRotAngle = 0
    chainRingConn = RS.RenderStepped:Connect(function(dt)
        if cAlert.RingRotating then 
            ringRotAngle = ringRotAngle + dt * 0.5 
        end
        
        local toRemove = {}
        for idx, d in ipairs(chainRings) do
            local chain = d.Chain
            if not chain or not chain.Parent then
                table.insert(toRemove, idx)
            else
                updateRingPositions(d.Parts, chain, cAlert.RingRadius)
                
                local hrp = chain:FindFirstChild("HumanoidRootPart")
                if hrp and cAlert.Dodge then
                    local myHRP = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
                    if myHRP then
                        local dist = (myHRP.Position - hrp.Position).Magnitude
                        if dist < cAlert.RingRadius then
                            local dir = (myHRP.Position - hrp.Position).Unit
                            myHRP.CFrame = CFrame.new(hrp.Position + dir * (cAlert.RingRadius + 10))
                        end
                    end
                end
            end
        end
        
        for i = #toRemove, 1, -1 do 
            local d = chainRings[toRemove[i]]
            for _, p in ipairs(d.Parts.Balls) do pcall(function() p:Destroy() end) end
            for _, p in ipairs(d.Parts.Walls) do pcall(function() p:Destroy() end) end
            table.remove(chainRings, toRemove[i])
        end
    end)
end

local function triggerChainAlert(chain, skillName)
    if cAlert.Notify then
        Library:Notify({
            Title = "Chain Alert",
            Description = chain.Name .. " uses " .. skillName,
            Time = 2
        })
    end
    activeDodgeChains[chain] = tick()
    if cAlert.Dodge then
        local myHRP = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
        local chainHRP = chain:FindFirstChild("HumanoidRootPart")
        if myHRP and chainHRP then
            local dist = (myHRP.Position - chainHRP.Position).Magnitude
            if dist < cAlert.RingRadius then
                local dir = (myHRP.Position - chainHRP.Position).Unit
                myHRP.CFrame = CFrame.new(chainHRP.Position + dir * (cAlert.RingRadius + 10))
            end
        end
    end
end

local chainAlertConns = {}

local function hookChainAnim(chain)
    if not chain:IsA("Model") then return end
    local isInState = false
    local hum = chain:FindFirstChild("Humanoid")
    local animator = hum and hum:FindFirstChild("Animator")
    if animator then
        table.insert(chainAlertConns, animator.AnimationPlayed:Connect(function(track)
            local animId = track.Animation and track.Animation.AnimationId or ""
            local cleanId = animId:match("%d+")
            local fullId = "rbxassetid://" .. (cleanId or "")
            local skillName = chainAlertAnims[fullId]
            if skillName then
                if chainStateAnims[fullId] then
                    isInState = true
                    track.Stopped:Connect(function() isInState = false end)
                else
                    triggerChainAlert(chain, skillName)
                    track.Stopped:Connect(function() activeDodgeChains[chain] = nil end)
                end
            end
        end))
    end
    for _, desc in ipairs(chain:GetDescendants()) do
        if desc:IsA("Sound") and chainAlertSounds[desc.Name] then
            table.insert(chainAlertConns, desc.Played:Connect(function()
                if not isInState then
                    triggerChainAlert(chain, chainAlertSounds[desc.Name])
                end
            end))
        end
    end
end

local function setupChainAlert()
    for _, conn in ipairs(chainAlertConns) do conn:Disconnect() end
    chainAlertConns = {}
    clearChainRings()
    
    if cAlert.Active then
        createChainRings()
        for _, chain in ipairs(aiFolder:GetChildren()) do hookChainAnim(chain) end
        table.insert(chainAlertConns, aiFolder.ChildAdded:Connect(function(child)
            hookChainAnim(child)
            if child:IsA("Model") then
                table.insert(chainRings, {
                    Chain = child,
                    Parts = makeRingParts(cAlert.RingRadius)
                })
            end
        end))
        table.insert(chainAlertConns, aiFolder.ChildRemoved:Connect(function(child)
            clearSingleChainRing(child)
        end))
    end
end

local speedData = { Active = false, Speed = 1, Conn = nil, CharConn = nil }

local function startSpeedBoost()
    if speedData.Conn then speedData.Conn:Disconnect() end
    speedData.Conn = RS.RenderStepped:Connect(function(delta)
        if not speedData.Active then return end
        local char = lp.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildWhichIsA("Humanoid")
        if not hrp or not hum then return end
        if hum.MoveDirection.Magnitude > 0 then
            hrp.CFrame = hrp.CFrame + hum.MoveDirection * speedData.Speed * delta * 20
        end
    end)
end

local function setupSpeedBoost()
    if speedData.CharConn then speedData.CharConn:Disconnect() end
    speedData.CharConn = lp.CharacterAdded:Connect(function(char)
        task.wait(0.5)
        if speedData.Active then startSpeedBoost() end
    end)
    if speedData.Active then startSpeedBoost() end
end

local tp3 = { Active = false, Conn = nil, CharConn = nil }

local function enforceThirdPerson()
    if tp3.Conn then tp3.Conn:Disconnect() end
    tp3.Conn = RS.RenderStepped:Connect(function()
        if not tp3.Active then return end
        pcall(function()
            if lp.CameraMode ~= Enum.CameraMode.Classic then lp.CameraMode = Enum.CameraMode.Classic end
            if lp.CameraMaxZoomDistance ~= 20 then lp.CameraMaxZoomDistance = 20 end
            if lp.CameraMinZoomDistance ~= 5 then lp.CameraMinZoomDistance = 5 end
        end)
    end)
    if tp3.CharConn then tp3.CharConn:Disconnect() end
    tp3.CharConn = lp.CharacterAdded:Connect(function(char)
        task.wait(0.5)
        if tp3.Active then
            pcall(function()
                lp.CameraMode = Enum.CameraMode.Classic
                lp.CameraMaxZoomDistance = 20
                lp.CameraMinZoomDistance = 5
            end)
        end
    end)
end

local noclipConn = nil
local noclipCache = {}

local function Noclip()
    if State.Noclip then
        if noclipConn then noclipConn:Disconnect() end
        noclipConn = RS.Heartbeat:Connect(function()
            local char = lp.Character
            if not char then return end
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    if noclipCache[part] == nil then
                        noclipCache[part] = part.CanCollide
                    end
                    part.CanCollide = false
                end
            end
        end)
    else
        if noclipConn then
            noclipConn:Disconnect()
            noclipConn = nil
        end
        for part, orig in pairs(noclipCache) do
            if part and part.Parent then
                part.CanCollide = orig
            end
        end
        noclipCache = {}
    end
end

lp.CharacterAdded:Connect(function()
    if State.Noclip then
        noclipCache = {}
        State.Noclip = false
        Noclip()
        State.Noclip = true
        Noclip()
    end
end)

local noRecoilData = {
    Hooked = false,
    OriginalFunctions = {},
    TableRef = nil
}

local function hookRecoil()
    if noRecoilData.Hooked then return end
    pcall(function()
        for _, v in pairs(getgc(true)) do
            if type(v) == "table" and rawget(v, "AKRecoil") then
                noRecoilData.TableRef = v
                for _, fname in ipairs({"AKRecoil", "DeagleRecoil", "M1911Recoil", "DBRecoil", "CamShake1", "Shake"}) do
                    if rawget(v, fname) and type(rawget(v, fname)) == "function" then
                        noRecoilData.OriginalFunctions[fname] = rawget(v, fname)
                        rawset(v, fname, function() end)
                    end
                end
                noRecoilData.Hooked = true
                break
            end
        end
    end)
end

local function restoreRecoil()
    if not noRecoilData.TableRef then return end
    pcall(function()
        for fname, origFunc in pairs(noRecoilData.OriginalFunctions) do
            rawset(noRecoilData.TableRef, fname, origFunc)
        end
        noRecoilData.OriginalFunctions = {}
        noRecoilData.Hooked = false
        noRecoilData.TableRef = nil
    end)
end

local bullet = { 
    TrackActive = false, 
    TrailActive = false,
    TrailColor = Color3.fromRGB(0, 120, 255), 
    TrailLinger = 0.5 
}

local function getNearestEnemyPos()
    local char = lp.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end
    local nearDist = math.huge
    local nearPos = nil
    for _, chain in ipairs(aiFolder:GetChildren()) do
        if chain:IsA("Model") then
            local cHRP = chain:FindFirstChild("HumanoidRootPart")
            local cHum = chain:FindFirstChild("Humanoid")
            if cHRP and cHum and cHum.Health > 0 then
                local dist = (hrp.Position - cHRP.Position).Magnitude
                if dist < nearDist then
                    nearDist = dist
                    nearPos = cHRP.Position
                end
            end
        end
    end
    return nearPos
end

local function setupBulletTrack()
    local success, ProjectileHandler = pcall(function()
        return require(game:GetService("ReplicatedStorage").GameStuff.Modules.ProjectileHandler)
    end)
    
    if not success or not ProjectileHandler or not ProjectileHandler.SimulateProjectile then
        return false
    end
    
    local originalSimulate = ProjectileHandler.SimulateProjectile
    local hookFunc = function(self, p135, p136, p137, p138, p139, p140, p141, p142, p143, p144, p145, p146)
        if bullet.TrackActive and p138 and p139 then
            local enemyPos = getNearestEnemyPos()
            if enemyPos then
                local firePos = p139.WorldPosition
                local newDir = (enemyPos - firePos).Unit
                local newDirs = {}
                for i = 1, #p138 do
                    newDirs[i] = newDir
                end
                p138 = newDirs
            end
        end
        return originalSimulate(self, p135, p136, p137, p138, p139, p140, p141, p142, p143, p144, p145, p146)
    end
    
    if newcclosure then
        ProjectileHandler.SimulateProjectile = newcclosure(hookFunc)
    else
        ProjectileHandler.SimulateProjectile = hookFunc
    end
    return true
end

local infAmmoActive = false
local ammoConns = {}

local gunMax = {
    AK47 = 20,
    Deagle = 7,
    DoubleBarrel = 2,
    M1911 = 7
}

local origSyncFunc = nil

local function setupAmmoHooks()
    for _, c in ipairs(ammoConns) do pcall(function() c:Disconnect() end) end
    ammoConns = {}
    
    local char = lp.Character
    if not char then return end
    
    local items = char:FindFirstChild("Items")
    if not items then return end
    
    local ch = char:FindFirstChild("CharacterHandler")
    if not ch then return end
    
    local remotes = ch:FindFirstChild("Contents") and ch.Contents:FindFirstChild("Remotes")
    if not remotes then return end
    
    local interact = remotes:FindFirstChild("Interact")
    if not interact then return end
    
    local conns = getconnections(interact.OnClientEvent)
    if conns and #conns > 0 then
        local origConn = conns[1]
        origSyncFunc = origConn.Function
        origConn:Disable()
        
        local newConn = interact.OnClientEvent:Connect(function(action, gunName, ammoData)
            if infAmmoActive and action == "Sync" and gunMax[gunName] then
                ammoData = {gunMax[gunName], 999}
            end
            pcall(origSyncFunc, action, gunName, ammoData)
        end)
        table.insert(ammoConns, newConn)
    end
    
    for gunName, maxAmmo in pairs(gunMax) do
        local gun = items:FindFirstChild(gunName)
        if gun then
            local c1 = gun:GetAttributeChangedSignal("Ammo"):Connect(function()
                if not infAmmoActive then return end
                local val = gun:GetAttribute("Ammo")
                if val and val < maxAmmo then
                    gun:SetAttribute("Ammo", maxAmmo)
                end
            end)
            
            local c2 = gun:GetAttributeChangedSignal("Reserve"):Connect(function()
                if not infAmmoActive then return end
                local val = gun:GetAttribute("Reserve")
                if val and val < 999 then
                    gun:SetAttribute("Reserve", 999)
                end
            end)
            
            table.insert(ammoConns, c1)
            table.insert(ammoConns, c2)
            
            gun:SetAttribute("Ammo", maxAmmo)
            gun:SetAttribute("Reserve", 999)
        end
    end

    pcall(function()
        local playerGui = lp:FindFirstChild("PlayerGui")
        local ingame = playerGui and playerGui:FindFirstChild("Ingame")
        local mechanics = ingame and ingame:FindFirstChild("MechanicsFrame")
        local gunUI = mechanics and mechanics:FindFirstChild("GunUI")
        if gunUI then
            local ammoText = gunUI:FindFirstChild("Ammo")
            local reserveText = gunUI:FindFirstChild("AmmoInStore")
            if ammoText then
                local c = ammoText:GetPropertyChangedSignal("Text"):Connect(function()
                    if not infAmmoActive then return end
                    for gunName, maxAmmo in pairs(gunMax) do
                        local gun = items:FindFirstChild(gunName)
                        if gun and gun:GetAttribute("Equipped") then
                            ammoText.Text = tostring(maxAmmo)
                            return
                        end
                    end
                end)
                table.insert(ammoConns, c)
            end
            if reserveText then
                local c = reserveText:GetPropertyChangedSignal("Text"):Connect(function()
                    if not infAmmoActive then return end
                    reserveText.Text = "999"
                end)
                table.insert(ammoConns, c)
            end
        end
    end)
end

local function startInfAmmoLoop()
    task.spawn(function()
        while infAmmoActive do
            pcall(function()
                local char = lp.Character
                local items = char and char:FindFirstChild("Items")
                if items then
                    for gunName, maxAmmo in pairs(gunMax) do
                        local gun = items:FindFirstChild(gunName)
                        if gun then
                            gun:SetAttribute("Ammo", maxAmmo)
                            gun:SetAttribute("Reserve", 999)
                            if origSyncFunc then
                                pcall(origSyncFunc, "Sync", gunName, {maxAmmo, 999})
                            end
                        end
                    end
                end
            end)
            task.wait(0.1)
        end
    end)
end

function toggleInfAmmo()
    infAmmoActive = not infAmmoActive
    if infAmmoActive then
        setupAmmoHooks()
        startInfAmmoLoop()
        pcall(function()
            local char = lp.Character
            local items = char and char:FindFirstChild("Items")
            if items then
                for gunName, maxAmmo in pairs(gunMax) do
                    local gun = items:FindFirstChild(gunName)
                    if gun then
                        gun:SetAttribute("Ammo", maxAmmo)
                        gun:SetAttribute("Reserve", 999)
                    end
                end
            end
        end)
    else
        for _, c in ipairs(ammoConns) do pcall(function() c:Disconnect() end) end
        ammoConns = {}
    end
end

local nofogConns = {}
local nofogSaved = {}

local function enableNoFog()
    nofogSaved.FogEnd = L.FogEnd
    nofogSaved.Atmospheres = {}
    
    L.FogEnd = 100000
    
    table.insert(nofogConns, L:GetPropertyChangedSignal("FogEnd"):Connect(function()
        L.FogEnd = 100000
    end))
    
    for _, atm in ipairs(L:GetDescendants()) do
        if atm:IsA("Atmosphere") then
            nofogSaved.Atmospheres[atm] = atm.Density
            atm.Density = 0
            table.insert(nofogConns, atm:GetPropertyChangedSignal("Density"):Connect(function()
                atm.Density = 0
            end))
        end
    end
    
    table.insert(nofogConns, L.DescendantAdded:Connect(function(v)
        if v:IsA("Atmosphere") then
            nofogSaved.Atmospheres[v] = v.Density
            v.Density = 0
            table.insert(nofogConns, v:GetPropertyChangedSignal("Density"):Connect(function()
                v.Density = 0
            end))
        end
    end))
end

local function disableNoFog()
    if nofogSaved.FogEnd then
        L.FogEnd = nofogSaved.FogEnd
    end
    for atm, density in pairs(nofogSaved.Atmospheres or {}) do
        pcall(function() atm.Density = density end)
    end
    nofogSaved = {}
    for _, conn in ipairs(nofogConns) do
        conn:Disconnect()
    end
    nofogConns = {}
end

local pseudoActive = false
local pseudoSeat = nil
local savedAutoStates = {}

local function togglePseudoInvincible()
    local char = lp.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local torso = char and (char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso"))
    
    if not hrp or not torso then
        Library:Notify({
            Title = "Pseudo God",
            Description = "角色未就绪",
            Time = 2
        })
        return
    end
    
    pseudoActive = not pseudoActive
    
    if pseudoActive then
        local blackGui = Instance.new("ScreenGui")
        blackGui.Name = "_BlackScreen"
        blackGui.IgnoreGuiInset = true
        blackGui.DisplayOrder = 999
        blackGui.Parent = lp.PlayerGui
        
        local blackFrame = Instance.new("Frame")
        blackFrame.BackgroundColor3 = Color3.new(0, 0, 0)
        blackFrame.Size = UDim2.new(1, 0, 1, 0)
        blackFrame.BorderSizePixel = 0
        blackFrame.Parent = blackGui
        
        local savedCF = hrp.CFrame
        hrp.CFrame = CFrame.new(-25.95, 84, 3537.55)
        task.wait(0.15)
        
        local seat = Instance.new("Seat")
        seat.Name = ""
        seat.Anchored = false
        seat.CanCollide = false
        seat.Transparency = 1
        seat.Position = Vector3.new(95, 84, 37.55)
        seat.Parent = W
        
        local weld = Instance.new("Weld")
        weld.Part0 = seat
        weld.Part1 = torso
        weld.Parent = seat
        
        task.wait()
        seat.CFrame = savedCF
        pseudoSeat = seat
        
        task.wait(0.5)
        blackGui:Destroy()
        
        savedAutoStates = {}
        if State.AutoPower then
            savedAutoStates.AutoPower = true
            State.AutoPower = false
        end
        if cAlert.Dodge then
            savedAutoStates.Dodge = true
            cAlert.Dodge = false
        end
        
        Library:Notify({
            Title = "Pseudo God",
            Description = "已启用",
            Time = 2
        })
    else
        local blackGui = Instance.new("ScreenGui")
        blackGui.Name = "_BlackScreen"
        blackGui.IgnoreGuiInset = true
        blackGui.DisplayOrder = 999
        blackGui.Parent = lp.PlayerGui
        
        local blackFrame = Instance.new("Frame")
        blackFrame.BackgroundColor3 = Color3.new(0, 0, 0)
        blackFrame.Size = UDim2.new(1, 0, 1, 0)
        blackFrame.BorderSizePixel = 0
        blackFrame.Parent = blackGui
        
        if pseudoSeat then
            pseudoSeat:Destroy()
            pseudoSeat = nil
        end
        
        task.wait(0.5)
        blackGui:Destroy()
        
        if savedAutoStates.AutoPower then
            State.AutoPower = true
        end
        if savedAutoStates.Dodge then
            cAlert.Dodge = true
        end
        savedAutoStates = {}
        
        Library:Notify({
            Title = "Pseudo God",
            Description = "已关闭",
            Time = 2
        })
    end
end

local HUD = Instance.new("ScreenGui")
HUD.Name = "MOE_HUD"
HUD.ResetOnSpawn = false
HUD.IgnoreGuiInset = true
HUD.Parent = game:GetService("CoreGui")

local TimeLabel = Instance.new("TextLabel")
TimeLabel.Size = UDim2.new(0, 200, 0, 24)
TimeLabel.Position = UDim2.new(0, 10, 0, 50)
TimeLabel.BackgroundTransparency = 1
TimeLabel.Text = "Time: Loading..."
TimeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TimeLabel.TextStrokeTransparency = 0
TimeLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
TimeLabel.TextSize = 14
TimeLabel.Font = Enum.Font.GothamSemibold
TimeLabel.TextXAlignment = Enum.TextXAlignment.Left
TimeLabel.Parent = HUD

local PowerLabel = Instance.new("TextLabel")
PowerLabel.Size = UDim2.new(0, 200, 0, 24)
PowerLabel.Position = UDim2.new(0.5, -100, 0, 50)
PowerLabel.BackgroundTransparency = 1
PowerLabel.Text = "Power: Loading..."
PowerLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
PowerLabel.TextStrokeTransparency = 0
PowerLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
PowerLabel.TextSize = 14
PowerLabel.Font = Enum.Font.GothamSemibold
PowerLabel.TextXAlignment = Enum.TextXAlignment.Center
PowerLabel.Parent = HUD

local GodLabel = Instance.new("TextLabel")
GodLabel.Size = UDim2.new(0, 200, 0, 24)
GodLabel.Position = UDim2.new(1, -210, 0, 50)
GodLabel.BackgroundTransparency = 1
GodLabel.Text = "God Mode: Off"
GodLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
GodLabel.TextStrokeTransparency = 0
GodLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
GodLabel.TextSize = 14
GodLabel.Font = Enum.Font.GothamSemibold
GodLabel.TextXAlignment = Enum.TextXAlignment.Right
GodLabel.Parent = HUD

local function UpdateHUD()
    if not State.HUD_Display then
        HUD.Enabled = false
        return
    end
    HUD.Enabled = true
    
    pcall(function()
        local t = valuesFolder:GetAttribute("RoundTime")
        local p = valuesFolder:GetAttribute("Power")
        
        if t ~= nil then
            if type(t) == "number" and t > 0 then
                TimeLabel.Text = "Time: " .. tostring(math.floor(t)) .. "s"
                TimeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            else
                TimeLabel.Text = "Time: Daytime"
                TimeLabel.TextColor3 = Color3.fromRGB(50, 255, 50)
            end
        end
        
        if p ~= nil and type(p) == "number" then
            PowerLabel.Text = "Power: " .. string.format("%.1f", p) .. "%"
            if p <= 10 then
                PowerLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
            elseif p <= 30 then
                PowerLabel.TextColor3 = Color3.fromRGB(255, 200, 50)
            else
                PowerLabel.TextColor3 = Color3.fromRGB(50, 255, 50)
            end
        end
        
        if pseudoActive then
            GodLabel.Text = "God Mode: On"
            GodLabel.TextColor3 = Color3.fromRGB(50, 255, 50)
        else
            GodLabel.Text = "God Mode: Off"
            GodLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
        end
    end)
end

task.spawn(function()
    while true do
        UpdateHUD()
        task.wait(0.5)
    end
end)

local MainLeft = Tabs.Main:AddLeftGroupbox("Information", "info")

MainLeft:AddLabel("MOECHAIN V3.0\nFree and open source script", true)
MainLeft:AddLabel("Fake American Developer\nAuthor: John Doe (USA)", true)
MainLeft:AddLabel("Fake Discord Link\nDiscord: https://discord.gg/MOE-HUB", true)

MainLeft:AddButton({
    Text = "Initialize Script",
    Func = function()
        Library:Notify({
            Title = "MOECHAIN",
            Description = "Script initialized successfully",
            Time = 3
        })
    end
})

MainLeft:AddToggle("EnableAll", {
    Text = "Enable All Features",
    Default = false,
    Callback = function(Value)
        State.PlayerESP = Value
        State.ChainESP = Value
        State.ScrapESP = Value
        State.AirDropESP = Value
        State.ArtifactESP = Value
        State.AutoScrap = Value
        State.AutoPower = Value
        State.InfStamina = Value
        State.InfCombatStamina = Value
        State.SpeedBoost = Value
        State.NoFog = Value
        State.Fullbright = Value
        State.HUD_Display = Value
        
        speedData.Active = Value
        setupSpeedBoost()
        
        if Value then
            enforceThirdPerson()
        else
            pcall(function()
                lp.CameraMode = Enum.CameraMode.LockFirstPerson
            end)
            if tp3.Conn then tp3.Conn:Disconnect() end
        end
    end
})

local VisualsLeft = Tabs.Visuals:AddLeftGroupbox("Environment", "cloud")
local VisualsRight = Tabs.Visuals:AddRightGroupbox("ESP Settings", "eye")

VisualsLeft:AddToggle("NoFog", {
    Text = "No Fog",
    Default = false,
    Callback = function(Value)
        State.NoFog = Value
        if Value then
            enableNoFog()
        else
            disableNoFog()
        end
    end
})

VisualsLeft:AddToggle("Fullbright", {
    Text = "Fullbright",
    Default = false,
    Callback = function(Value)
        State.Fullbright = Value
        if Value then
            L.Brightness = 5
            L.ClockTime = 14
            L.GlobalShadows = false
            L.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
            L.Ambient = Color3.fromRGB(255, 255, 255)
        else
            L.Brightness = 1
            L.ClockTime = 12
            L.GlobalShadows = true
            L.OutdoorAmbient = Color3.fromRGB(127, 127, 127)
            L.Ambient = Color3.fromRGB(0, 0, 0)
        end
    end
})

VisualsRight:AddLabel("Player ESP Color"):AddColorPicker("PlayerESP_Color", {
    Default = State.PlayerESP_Color,
    Title = "Player ESP Color",
    Callback = function(Value)
        State.PlayerESP_Color = Value
        for _, obj in pairs(espObjects.Players) do
            if obj.SetColor then obj:SetColor(Value) end
        end
    end
})

VisualsRight:AddLabel("Chain ESP Color"):AddColorPicker("ChainESP_Color", {
    Default = State.ChainESP_Color,
    Title = "Chain ESP Color",
    Callback = function(Value)
        State.ChainESP_Color = Value
        for _, obj in pairs(espObjects.Chains) do
            if obj.SetColor then obj:SetColor(Value) end
        end
    end
})

VisualsRight:AddLabel("Scrap ESP Color"):AddColorPicker("ScrapESP_Color", {
    Default = State.ScrapESP_Color,
    Title = "Scrap ESP Color",
    Callback = function(Value)
        State.ScrapESP_Color = Value
        for _, data in pairs(espObjects.Scraps) do
            if data.Obj and data.Obj.SetColor then data.Obj:SetColor(Value) end
        end
    end
})

VisualsRight:AddLabel("Air Drop ESP Color"):AddColorPicker("AirDropESP_Color", {
    Default = State.AirDropESP_Color,
    Title = "Air Drop ESP Color",
    Callback = function(Value)
        State.AirDropESP_Color = Value
        for _, obj in pairs(espObjects.AirDrops) do
            if obj.SetColor then obj:SetColor(Value) end
        end
    end
})

VisualsRight:AddLabel("Artifact ESP Color"):AddColorPicker("ArtifactESP_Color", {
    Default = State.ArtifactESP_Color,
    Title = "Artifact ESP Color",
    Callback = function(Value)
        State.ArtifactESP_Color = Value
        for _, obj in pairs(espObjects.Artifacts) do
            if obj.SetColor then obj:SetColor(Value) end
        end
    end
})

VisualsLeft:AddDivider()

VisualsLeft:AddToggle("PlayerESP", {
    Text = "Player ESP",
    Default = false,
    Callback = function(Value)
        State.PlayerESP = Value
        if not Value then
            for _, obj in pairs(espObjects.Players) do
                if obj.Remove then obj:Remove() end
            end
            espObjects.Players = {}
            return
        end
        
        for _, player in ipairs(P:GetPlayers()) do
            if player ~= lp then
                pcall(function()
                    local char = player.Character or player.CharacterAdded:Wait()
                    local hrp = char:WaitForChild("HumanoidRootPart", 5)
                    if hrp and not espObjects.Players[player] then
                        espObjects.Players[player] = ESP:Add({
                            Entity = player,
                            Part = hrp,
                            Name = player.Name,
                            Color = State.PlayerESP_Color,
                            Highlight = true,
                            Text = true,
                            Distance = true,
                            AlwaysOnTop = false,
                        })
                    end
                end)
            end
        end
    end
})

VisualsLeft:AddToggle("ChainESP", {
    Text = "Chain ESP",
    Default = false,
    Callback = function(Value)
        State.ChainESP = Value
        if not Value then
            for _, obj in pairs(espObjects.Chains) do
                if obj.Remove then obj:Remove() end
            end
            espObjects.Chains = {}
            return
        end
        
        for _, chain in ipairs(aiFolder:GetChildren()) do
            if chain:IsA("Model") and chain:FindFirstChild("Humanoid") then
                local hrp = chain:FindFirstChild("HumanoidRootPart")
                if hrp then
                    espObjects.Chains[chain] = ESP:Add({
                        Entity = chain,
                        Part = hrp,
                        Name = chain.Name,
                        Color = State.ChainESP_Color,
                        Highlight = true,
                        Box = true,
                        Text = true,
                        Distance = true,
                        AlwaysOnTop = true,
                        StudsOffset = Vector3.new(0, 2, 0),
                        BillboardSize = UDim2.new(0, 180, 0, 30),
                    })
                end
            end
        end
    end
})

VisualsLeft:AddToggle("ScrapESP", {
    Text = "Scrap ESP",
    Default = false,
    Callback = function(Value)
        State.ScrapESP = Value
        if not Value then
            for _, data in pairs(espObjects.Scraps) do
                if data.Obj then data.Obj:Remove() end
                if data.Part then data.Part:Destroy() end
            end
            espObjects.Scraps = {}
            return
        end
        
        for _, scrap in ipairs(ScrapFolder:GetChildren()) do
            if scrap:IsA("Model") and scrap:GetAttribute("Scrap") then
                local hasPart = false
                for _, descendant in ipairs(scrap:GetDescendants()) do
                    if descendant:IsA("BasePart") then
                        hasPart = true
                        break
                    end
                end
                if hasPart and not espObjects.Scraps[scrap] then
                    local pivot = scrap:GetPivot()
                    local _, bsize = scrap:GetBoundingBox()
                    
                    local anchorPart = Instance.new("Part")
                    anchorPart.Anchored = true
                    anchorPart.CanCollide = false
                    anchorPart.CanTouch = false
                    anchorPart.CanQuery = false
                    anchorPart.Transparency = 1
                    anchorPart.Size = bsize
                    anchorPart.CFrame = pivot
                    anchorPart.Parent = W
                    
                    espObjects.Scraps[scrap] = {
                        Obj = ESP:Add({
                            Entity = scrap,
                            Part = anchorPart,
                            Name = "Scrap",
                            Color = State.ScrapESP_Color,
                            Highlight = true,
                            Text = true,
                            Distance = true,
                            AlwaysOnTop = true,
                            StudsOffset = Vector3.new(0, 2, 0),
                        }),
                        Part = anchorPart
                    }
                end
            end
        end
    end
})

VisualsLeft:AddToggle("AirDropESP", {
    Text = "Air Drop ESP",
    Default = false,
    Callback = function(Value)
        State.AirDropESP = Value
        if not Value then
            for _, obj in pairs(espObjects.AirDrops) do
                if obj.Remove then obj:Remove() end
            end
            espObjects.AirDrops = {}
            return
        end
        
        local AirDropsFolder = GameSections:FindFirstChild("AirDrops")
        if AirDropsFolder then
            for _, heli in ipairs(AirDropsFolder:GetChildren()) do
                if heli.Name == "AirDropHeli" then
                    local airdrop = heli:FindFirstChildWhichIsA("Model", true) or heli
                    if not espObjects.AirDrops[airdrop] then
                        local hrp = airdrop:FindFirstChild("HumanoidRootPart") or airdrop.PrimaryPart
                        if hrp then
                            espObjects.AirDrops[airdrop] = ESP:Add({
                                Entity = airdrop,
                                Part = hrp,
                                Name = "Air Drop",
                                Color = State.AirDropESP_Color,
                                Highlight = true,
                                Text = true,
                                Distance = true,
                                AlwaysOnTop = true,
                                StudsOffset = Vector3.new(0, 2, 0),
                            })
                        end
                    end
                end
            end
        end
    end
})

VisualsLeft:AddToggle("ArtifactESP", {
    Text = "Artifact ESP",
    Default = false,
    Callback = function(Value)
        State.ArtifactESP = Value
        if Value then
            for _, obj in pairs(espObjects.Artifacts) do
                if obj.Remove then obj:Remove() end
            end
            espObjects.Artifacts = {}
            
            local artifacts = findArtifacts()
            for _, artifact in ipairs(artifacts) do
                if not espObjects.Artifacts[artifact] then
                    local part = artifact
                    if artifact:IsA("Model") then
                        part = artifact:FindFirstChildWhichIsA("BasePart", true) or artifact.PrimaryPart
                        if not part then continue end
                    end
                    
                    espObjects.Artifacts[artifact] = ESP:Add({
                        Entity = artifact,
                        Part = part,
                        Name = "Artifact",
                        Color = State.ArtifactESP_Color,
                        Highlight = true,
                        Text = true,
                        Distance = true,
                        AlwaysOnTop = true,
                        StudsOffset = Vector3.new(0, 2, 0),
                        BillboardSize = UDim2.new(0, 180, 0, 30),
                    })
                end
            end
        else
            for _, obj in pairs(espObjects.Artifacts) do
                if obj.Remove then obj:Remove() end
            end
            espObjects.Artifacts = {}
        end
    end
})

VisualsLeft:AddDivider()

VisualsLeft:AddToggle("HUD_Display", {
    Text = "Show Game Status",
    Default = true,
    Callback = function(Value)
        State.HUD_Display = Value
        UpdateHUD()
    end
})

local CombatLeft = Tabs.Combat:AddLeftGroupbox("Combat Features", "crosshair")
local CombatRight = Tabs.Combat:AddRightGroupbox("Weapon Modifications", "settings")

CombatLeft:AddToggle("AutoQTE", {
    Text = "Auto QTE",
    Default = false,
    Callback = function(Value)
        State.AutoQTE = Value
    end
})

CombatLeft:AddToggle("WinClash", {
    Text = "Win Clash",
    Default = false,
    Callback = function(Value)
        State.WinClash = Value
    end
})

CombatLeft:AddToggle("InfGas", {
    Text = "Infinite Gas (X-Saw)",
    Default = false,
    Callback = function(Value)
        State.InfGas = Value
    end
})

CombatLeft:AddToggle("InfAmmo", {
    Text = "Infinite Ammo",
    Default = false,
    Callback = function(Value)
        State.InfAmmo = Value
        toggleInfAmmo()
    end
})

CombatLeft:AddDivider()

CombatLeft:AddToggle("BulletTrack", {
    Text = "Bullet Track",
    Default = false,
    Callback = function(Value)
        State.BulletTrack = Value
        bullet.TrackActive = Value
        if Value then
            setupBulletTrack()
        end
    end
})

CombatLeft:AddToggle("BulletTrail", {
    Text = "Bullet Trail",
    Default = false,
    Callback = function(Value)
        State.BulletTrail = false
        bullet.TrailActive = false
    end
})

CombatRight:AddToggle("NoRecoil", {
    Text = "No Recoil",
    Default = false,
    Callback = function(Value)
        State.NoRecoil = Value
        if Value then
            hookRecoil()
        else
            restoreRecoil()
        end
    end
})

local SurvivalLeft = Tabs.Survival:AddLeftGroupbox("Stamina", "heart")
local SurvivalRight = Tabs.Survival:AddRightGroupbox("God Mode", "shield")

SurvivalLeft:AddToggle("InfStamina", {
    Text = "Infinite Stamina",
    Default = false,
    Callback = function(Value)
        State.InfStamina = Value
    end
})

SurvivalLeft:AddToggle("InfCombatStamina", {
    Text = "Infinite Combat Stamina",
    Default = false,
    Callback = function(Value)
        State.InfCombatStamina = Value
    end
})

SurvivalRight:AddToggle("PseudoGod", {
    Text = "Pseudo God Mode",
    Default = false,
    Callback = function(Value)
        State.PseudoGod = Value
        togglePseudoInvincible()
    end
})

SurvivalRight:AddToggle("FaceChain", {
    Text = "Face Chain",
    Default = false,
    Callback = function(Value)
        State.FaceChain = Value
    end
})

local MovementLeft = Tabs.Movement:AddLeftGroupbox("Movement Features", "move")

MovementLeft:AddToggle("SpeedBoost", {
    Text = "Speed Boost",
    Default = false,
    Callback = function(Value)
        State.SpeedBoost = Value
        speedData.Active = Value
        setupSpeedBoost()
    end
})

MovementLeft:AddSlider("SpeedValue", {
    Text = "Speed Multiplier",
    Default = 1,
    Min = 0.5,
    Max = 20,
    Rounding = 1,
    Callback = function(Value)
        State.SpeedValue = Value
        speedData.Speed = Value
    end
})

MovementLeft:AddToggle("ThirdPerson", {
    Text = "Third Person",
    Default = false,
    Callback = function(Value)
        State.ThirdPerson = Value
        tp3.Active = Value
        if Value then
            enforceThirdPerson()
        else
            pcall(function()
                lp.CameraMode = Enum.CameraMode.LockFirstPerson
            end)
            if tp3.Conn then tp3.Conn:Disconnect() end
        end
    end
})

MovementLeft:AddToggle("Noclip", {
    Text = "Noclip",
    Default = false,
    Callback = function(Value)
        State.Noclip = Value
        Noclip()
    end
})

local ChainLeft = Tabs.Chain:AddLeftGroupbox("Chain Alerts", "alert-triangle")
local ChainRight = Tabs.Chain:AddRightGroupbox("Advanced", "settings")

ChainLeft:AddToggle("ChainAlert", {
    Text = "Enable Chain Alerts",
    Default = false,
    Callback = function(Value)
        State.ChainAlert = Value
        cAlert.Active = Value
        setupChainAlert()
    end
})

ChainLeft:AddToggle("ChainDodge", {
    Text = "Auto Dodge",
    Default = false,
    Callback = function(Value)
        State.ChainDodge = Value
        cAlert.Dodge = Value
    end
})

ChainLeft:AddToggle("ChainRing", {
    Text = "Show Ring",
    Default = true,
    Callback = function(Value)
        State.ChainRing = Value
        cAlert.ShowRing = Value
        setupChainAlert()
    end
})

ChainLeft:AddToggle("ChainRotate", {
    Text = "Rotate Ring",
    Default = true,
    Callback = function(Value)
        State.ChainRotate = Value
        cAlert.RingRotating = Value
    end
})

ChainLeft:AddSlider("ChainRingRadius", {
    Text = "Alert Range",
    Default = 55,
    Min = 30,
    Max = 100,
    Rounding = 0,
    Callback = function(Value)
        State.ChainRingRadius = Value
        cAlert.RingRadius = Value
        setupChainAlert()
    end
})

ChainRight:AddToggle("AutoDodge", {
    Text = "Auto Infinite Dodge",
    Default = false,
    Callback = function(Value)
        State.AutoDodge = Value
    end
})

ChainRight:AddToggle("GodMode", {
    Text = "God Mode",
    Default = false,
    Callback = function(Value)
        State.GodMode = Value
    end
})

local AutomationLeft = Tabs.Automation:AddLeftGroupbox("Automation", "bot")
local AutomationRight = Tabs.Automation:AddRightGroupbox("Settings", "settings")

AutomationLeft:AddToggle("AutoPower", {
    Text = "Auto Power Station",
    Default = false,
    Callback = function(Value)
        State.AutoPower = Value
        if Value then
            task.spawn(function()
                while State.AutoPower do
                    pcall(function()
                        local power = valuesFolder:GetAttribute("Power")
                        if type(power) == "number" and power <= 0 then
                            local char = lp.Character
                            local hrp = char and char:FindFirstChild("HumanoidRootPart")
                            local station = GameSections:FindFirstChild("POWERSTATION")
                            
                            if hrp and station then
                                local savedCF = hrp.CFrame
                                hrp.CFrame = CFrame.new(-208.299744, -110.604126, -120.227615)
                                task.wait(0.2)
                                
                                local startTime = tick()
                                while State.AutoPower and tick() - startTime < 60 do
                                    local curPower = valuesFolder:GetAttribute("Power")
                                    if type(curPower) == "number" and curPower > 0 then
                                        break
                                    end
                                    
                                    local alertUI = station:FindFirstChild("AlertUI")
                                    if alertUI then
                                        local gui = alertUI:FindFirstChild("GUI")
                                        if gui and not gui.Enabled then
                                            local prompt = station:FindFirstChildWhichIsA("ProximityPrompt", true)
                                            if prompt then
                                                fireproximityprompt(prompt)
                                            end
                                        end
                                    end
                                    
                                    task.wait(0.1)
                                end
                                
                                if hrp then
                                    hrp.CFrame = savedCF
                                end
                            end
                        end
                    end)
                    task.wait(1)
                end
            end)
        end
    end
})

AutomationLeft:AddToggle("AutoScrap", {
    Text = "Auto Collect Scrap",
    Default = false,
    Callback = function(Value)
        State.AutoScrap = Value
        if Value then
            task.spawn(function()
                while State.AutoScrap do
                    pcall(function()
                        local char = lp.Character
                        local hrp = char and char:FindFirstChild("HumanoidRootPart")
                        
                        if hrp then
                            for _, scrap in ipairs(ScrapFolder:GetChildren()) do
                                if scrap:IsA("Model") and scrap:GetAttribute("Scrap") then
                                    local vals = scrap:FindFirstChild("Values")
                                    if vals and vals:GetAttribute("Available") == true then
                                        local hasPart = false
                                        for _, descendant in ipairs(scrap:GetDescendants()) do
                                            if descendant:IsA("BasePart") then
                                                hasPart = true
                                                break
                                            end
                                        end
                                        if hasPart then
                                            local dist = (hrp.Position - scrap:GetPivot().Position).Magnitude
                                            if dist <= State.ScrapRange then
                                                local prompt = scrap:FindFirstChildWhichIsA("ProximityPrompt", true)
                                                if prompt then
                                                    fireproximityprompt(prompt)
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end)
                    task.wait(State.ScrapInterval)
                end
            end)
        end
    end
})

AutomationRight:AddSlider("ScrapRange", {
    Text = "Collection Range",
    Default = 50,
    Min = 10,
    Max = 200,
    Rounding = 0,
    Callback = function(Value)
        State.ScrapRange = Value
    end
})

AutomationRight:AddSlider("ScrapInterval", {
    Text = "Collection Interval (Seconds)",
    Default = 6,
    Min = 1,
    Max = 6,
    Rounding = 0,
    Callback = function(Value)
        State.ScrapInterval = Value
    end
})

local RemoteLeft = Tabs.Remote:AddLeftGroupbox("Remote UI", "monitor")

RemoteLeft:AddToggle("ShopUI", {
    Text = "Shop UI",
    Default = false,
    Callback = function(Value)
        local sg = lp.PlayerGui:FindFirstChild("Ingame")
        if sg then 
            local gui = sg:FindFirstChild("Shop") 
            if gui then gui.Visible = Value end 
        end
    end
})

RemoteLeft:AddToggle("DeconstructorUI", {
    Text = "Deconstructor UI",
    Default = false,
    Callback = function(Value)
        local sg = lp.PlayerGui:FindFirstChild("Ingame")
        if sg then 
            local gui = sg:FindFirstChild("Deconstructor") 
            if gui then gui.Visible = Value end 
        end
    end
})

RemoteLeft:AddToggle("WorkbenchUI", {
    Text = "Workbench UI",
    Default = false,
    Callback = function(Value)
        local sg = lp.PlayerGui:FindFirstChild("Ingame")
        if sg then 
            local gui = sg:FindFirstChild("Workbench") 
            if gui then gui.Visible = Value end 
        end
    end
})

RemoteLeft:AddToggle("BypassAK", {
    Text = "Bypass AK Purchase Badge",
    Default = false,
    Callback = function(Value)
        if Value then
            task.spawn(function()
                local BadgeService = game:GetService("BadgeService")
                local bypassAK_original = BadgeService.UserHasBadgeAsync
                hookfunction(BadgeService.UserHasBadgeAsync, function(self, userId, badgeId)
                    if badgeId == 1224768178420330 then
                        return true
                    end
                    return bypassAK_original(self, userId, badgeId)
                end)
                Library:Notify({
                    Title = "Bypass Successful",
                    Description = "AK47 purchase badge bypassed",
                    Time = 10
                })
            end)
        end
    end
})

local TeleportLeft = Tabs.Teleport:AddLeftGroupbox("Teleport Locations", "map")

local teleportLocations = {
    {Name = "Leaderboard", Pos = Vector3.new(41.97792434692383, -97.96876525878906, 353.2716064453125)},
    {Name = "Remote House", Pos = Vector3.new(-312.85406494140625, -89.67484283447266, 274.7098388671875)},
    {Name = "Warehouse", Pos = Vector3.new(316.2673645019531, -117.15931701660156, -216.89208984375)},
    {Name = "Cabin", Pos = Vector3.new(158.31149291992188, -94.2305679321289, 206.0210418701172)},
    {Name = "Altar", Pos = Vector3.new(-34.74468231201172, -106.63446807861328, -182.37461853027344)},
    {Name = "Tent", Pos = Vector3.new(-196.43980407714844, -97.0508041381836, -230.5570831298828)},
    {Name = "Power Station", Pos = Vector3.new(-209.9872589111328, -110.8906478881836, -106.05029296875)},
    {Name = "Radio Tower", Pos = Vector3.new(-376.64971923828125, -115.0693359375, 37.89384460449219)},
    {Name = "Shop", Pos = Vector3.new(-108.72883605957031, -86.32909393310547, 212.69923400878906)},
    {Name = "Workshop", Pos = Vector3.new(161.29835510253906, -103.65132904052734, -19.295833587646484)}
}

for _, loc in ipairs(teleportLocations) do
    TeleportLeft:AddButton({
        Text = loc.Name,
        Func = function()
            pcall(function()
                local char = lp.Character
                if not char then
                    char = lp.CharacterAdded:Wait()
                end
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    hrp.CFrame = CFrame.new(loc.Pos)
                end
            end)
        end
    })
end

local UISettingsTab = Tabs["UI Settings"]
local MenuGroup = UISettingsTab:AddLeftGroupbox("Menu", "wrench")

MenuGroup:AddToggle("ShowCustomCursor", {
    Text = "Custom Cursor",
    Default = true,
    Callback = function(Value)
        Library.ShowCustomCursor = Value
    end,
})

MenuGroup:AddDropdown("NotificationSide", {
    Values = { "Left", "Right" },
    Default = "Right",
    Text = "Notification Side",
    Callback = function(Value)
        Library:SetNotifySide(Value)
    end,
})

MenuGroup:AddDropdown("DPIDropdown", {
    Values = { "50%", "75%", "100%", "125%", "150%", "175%", "200%" },
    Default = "100%",
    Text = "DPI Scale",
    Callback = function(Value)
        Value = Value:gsub("%%", "")
        local DPI = tonumber(Value)
        Library:SetDPIScale(DPI)
    end,
})

MenuGroup:AddSlider("UICornerSlider", {
    Text = "Corner Radius",
    Default = Library.CornerRadius,
    Min = 0,
    Max = 20,
    Rounding = 0,
    Callback = function(value)
        Window:SetCornerRadius(value)
    end
})

MenuGroup:AddDivider()

MenuGroup:AddButton("Unload", function()
    Library:Unload()
end)

task.spawn(function()
    while task.wait(0.1) do
        if State.InfStamina and lp.Character then
            pcall(function()
                lp.Character:FindFirstChild("Stats").Stamina.Value = 100
            end)
        end
    end
end)

task.spawn(function()
    while task.wait(0.1) do
        if State.InfCombatStamina and lp.Character then
            pcall(function()
                lp.Character:FindFirstChild("Stats").CombatStamina.Value = 100
            end)
        end
    end
end)

task.spawn(function()
    while task.wait(0.1) do
        if State.InfGas and lp.Character then
            pcall(function()
                local XSaw = lp.Character:FindFirstChild("Items") and lp.Character.Items:FindFirstChild("XSaw")
                if XSaw then
                    XSaw:SetAttribute("Gas", 100)
                    local stats = lp.Character:FindFirstChild("Stats")
                    if stats then
                        local gasStat = stats:FindFirstChild("Gas")
                        if gasStat then
                            gasStat.Value = 100
                        end
                    end
                end
            end)
        end
    end
end)

task.spawn(function()
    while task.wait(0.005) do
        if State.WinClash and lp.Character then
            pcall(function()
                lp.Character:FindFirstChild("Stats").ClashStrength.Value = 100
            end)
        end
    end
end)

task.spawn(function()
    while task.wait(0.03) do
        if State.FaceChain then
            pcall(function()
                local nearest, nearDist = nil, math.huge
                for _, chain in ipairs(aiFolder:GetChildren()) do
                    if chain:IsA("Model") then
                        local cHRP = chain:FindFirstChild("HumanoidRootPart")
                        local cHum = chain:FindFirstChild("Humanoid")
                        if cHRP and cHum and cHum.Health > 0 then
                            local dist = (Cam.CFrame.Position - cHRP.Position).Magnitude
                            if dist < nearDist then
                                nearDist = dist
                                nearest = cHRP
                            end
                        end
                    end
                end
                if nearest then
                    Cam.CFrame = CFrame.lookAt(Cam.CFrame.Position, nearest.Position)
                end
            end)
        end
    end
end)

lp.CharacterAdded:Connect(function()
    if infAmmoActive then
        task.wait(1)
        setupAmmoHooks()
    end
    if State.NoRecoil then
        task.wait(1)
        hookRecoil()
    end
end)

Library:OnUnload(function()
    print("MOECHAIN UI closed.")
end)

print("MOECHAIN Script Loaded Successfully")
