print ("欢迎使用")

local StarterGui = game:GetService("StarterGui")
StarterGui:SetCore("SendNotification", {
    Title = "Chain XK",
    Text = "脚本正在加载中",
    Duration = 3
})

loadstring(game:HttpGet("https://sirius.menu/blatant",true))()

local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

if not WindUI then
    StarterGui:SetCore("SendNotification", {
        Title = "Chain XK",
        Text = "脚本加载失败",
        Duration = 5
    })
    return
end

local P = game:GetService("Players")
local RS = game:GetService("RunService")
local L = game:GetService("Lighting")
local UIS = game:GetService("UserInputService")
local W = game:GetService("Workspace")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local lp = P.LocalPlayer
local Cam = W.CurrentCamera

local aiFolder = W:WaitForChild("Misc"):WaitForChild("AI")
local ScrapFolder = W:WaitForChild("Misc")
    :WaitForChild("Zones")
    :WaitForChild("LootingItems")
    :WaitForChild("Scrap")

local MechanicsFrame = lp:WaitForChild("PlayerGui")
    :WaitForChild("Ingame")
    :WaitForChild("MechanicsFrame")

local GameSections = W:WaitForChild("GameStuff"):WaitForChild("GameSections")
local valuesFolder = W:WaitForChild("GameStuff"):WaitForChild("Values")

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
    ThirdPersonCamLock = false,
    NoFog = false,
    Noclip = false,
    Fly = false,
    FlySpeed = 1,

    PlayerESP = false,
    PlayerESP_Text = true,
    PlayerESP_Box = true,
    PlayerESP_Color = Color3.fromRGB(0, 120, 255),

    ChainESP = false,
    ChainESP_Text = true,
    ChainESP_Box = true,
    ChainESP_Color = Color3.fromRGB(255, 21, 21),

    BuildingESP = false,
    BuildingESP_Text = true,
    BuildingESP_Box = true,
    BuildingESP_Color = Color3.fromRGB(255, 255, 0),

    ScrapESP = false,
    ScrapESP_Text = true,
    ScrapESP_Box = true,
    ScrapESP_Color = Color3.fromRGB(255, 200, 0),

    AirDropESP = false,
    AirDropESP_Text = true,
    AirDropESP_Box = true,
    AirDropESP_Color = Color3.fromRGB(170, 0, 255),

    ArtifactESP = false,
    ArtifactESP_Color = Color3.fromRGB(255, 105, 180),

    ServerMonitor = false,
    ServerMonitor_Interval = 30,
    ServerMonitor_MaxServers = 20,
    ServerMonitor_SortBy = "ping",
    ServerMonitor_ShowEmpty = false,
    ServerMonitor_ShowFull = false,
    ServerMonitor_AutoRefresh = true,

    PerformanceDisplay = false,
    HUD_Display = true,
    TeleportDelay = 0.2,
    ForceChat = false,
}

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

local function isDaytime()
    local t = valuesFolder:GetAttribute("RoundTime")
    return not (type(t) == "number" and t > 0)
end

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
                local dist = (hrp.Position   cHRP.Position).Magnitude
                if dist < nearDist then
                    nearDist = dist
                    nearPos = cHRP.Position
                end
            end
        end
    end
    return nearPos
end

local function safeFireProximityPrompt(prompt)
    if not prompt then return false end
    
    if type(fireproximityprompt) == "function" then
        pcall(fireproximityprompt, prompt)
        return true
    end

    pcall(function()
        prompt:PromptButtonClicked(lp)
    end)
    return true
end

task.spawn(function()
    local blueprints = lp:WaitForChild("PlayerStats"):WaitForChild("Blueprints")
    local bpDisplay = {
        CombatKnife = "战斗小刀",
        DoubleBarrel = "双管霰弹枪",
        M1911 = "M1911手枪",
        Machete = "砍刀",
        Deagle = "沙漠之鹰",
    }
    for _, name in ipairs({"CombatKnife", "DoubleBarrel", "M1911", "Machete", "Deagle"}) do
        pcall(function()
            if blueprints:GetAttribute(name) ~= nil then
                blueprints:SetAttribute(name, true)
                WindUI:Notify({
                    Title = "蓝图解锁",
                    Content = (bpDisplay[name] or name) .. " 已解锁",
                    Duration = 10,
                    Icon = "check circle"
                })
                task.wait(0.3)
            end
        end)
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

                                                                      
   启动弹窗
                                                                      
local confirmed = false
local popupSuccess = pcall(function()
    WindUI:Popup({
        Title = "Chain XK",
        IconThemed = true,
        Content = " 脚本免费开源 电脑端T打开/关闭UI 脚本作者：美游 如遇卡顿加载不出来尝试切换加速器或将控制台报错截图发至群内",
        Buttons = {
            {
                Title = "关闭脚本",
                Variant = "Secondary",
                Callback = function() end
            },
            {
                Title = "启动",
                Icon = "check",
                Variant = "Primary",
                Callback = function()
                    confirmed = true
                end
            }
        }
    })
end)

if not popupSuccess then
    warn("Popup 拉取错误，已跳过")
    confirmed = true
end

repeat task.wait() until confirmed
                           
local Window = WindUI:CreateWindow({
    Title = "Chain XK",
    Icon = "rbxassetid://75060495367982",
    IconThemed = false,
    Author = "V3.0 作者:恋恋",
    Folder = "ChainXK",
    Size = UDim2.fromOffset(800, 700),
    Transparent = true,
    Theme = "Dark",
    Background = "rbxassetid://75060495367982",
    BackgroundImageTransparency = 0.5,
    User = {
        Enabled = true,
        Callback = function() end,
        Anonymous = false
    },
    SideBarWidth = 200,
    ScrollBarEnabled = true,
})

Window:SetToggleKey(Enum.KeyCode.T)

local Tabs = {}

Tabs.FuncTab = Window:Tab({
    Title = "功能",
    Icon = "zap"
})

Tabs.VisualTab = Window:Tab({
    Title = "视觉效果"
    Icon = "eye"
})

Tabs.RemoteTab = Window:Tab({
    Title = "远程UI & 快捷键",
    Icon = "monitor"
})

Tabs.TeleportTab = Window:Tab({
    Title = "传送",
    Icon = "map pin"
})

local TeleportSection = Tabs.TeleportTab:Section({
    Title = "点击传送",
    Opened = true
})

local teleportLocations = {
    {Name = "排行榜", Pos = Vector3.new(41.97792434692383,  97.96876525878906, 353.2716064453125)},
    {Name = "偏远房子", Pos = Vector3.new( 312.85406494140625,  89.67484283447266, 274.7098388671875)},
    {Name = "仓库", Pos = Vector3.new(316.2673645019531,  117.15931701660156,  216.89208984375)},
    {Name = "小屋", Pos = Vector3.new(158.31149291992188,  94.2305679321289, 206.0210418701172)},
    {Name = "祭坛", Pos = Vector3.new( 34.74468231201172,  106.63446807861328,  182.37461853027344)},
    {Name = "帐篷", Pos = Vector3.new( 196.43980407714844,  97.0508041381836,  230.5570831298828)},
    {Name = "发电站", Pos = Vector3.new( 209.9872589111328,  110.8906478881836,  106.05029296875)},
    {Name = "无线电塔", Pos = Vector3.new( 376.64971923828125,  115.0693359375, 37.89384460449219)},
    {Name = "商店", Pos = Vector3.new( 108.72883605957031,  86.32909393310547, 212.69923400878906)},
    {Name = "工作间", Pos = Vector3.new(161.29835510253906,  103.65132904052734,  19.295833587646484)}
}

for _, loc in ipairs(teleportLocations) do
    TeleportSection:Button({
        Title = loc.Name,
        Callback = function()
            pcall(function()
                local char = lp.Character or lp.CharacterAdded:Wait()
                local hrp = char:WaitForChild("HumanoidRootPart")
                hrp.CFrame = CFrame.new(loc.Pos)
                WindUI:Notify({
                    Title = "传送完成",
                    Content = "已传送到 " .. loc.Name,
                    Duration = 3,
                    Icon = "check circle"
                })
            end)
        end
    })
end

Tabs.SettingsTab = Window:Tab({
    Title = "设置",
    Icon = "settings"
})

Window:SelectTab(1)

local RemoteGUIs = { Shop = false, Deconstructor = false, Workbench = false }
local Mouse = lp:GetMouse()

local function UpdateMouseLock()
    local anyActive = RemoteGUIs.Shop or RemoteGUIs.Deconstructor or RemoteGUIs.Workbench
    local uiVisible = Window and Window.Signal and Window.Signal:GetValue()
    if anyActive or uiVisible then
        UIS.MouseBehavior = Enum.MouseBehavior.Default
        UIS.MouseIconEnabled = true
        Mouse.Icon = ""
    end
end

local function SetRemoteGui(name, visible)
    if visible and name == "Shop" and not isDaytime() then
        WindUI:Notify({
            Title = "无法开启",
            Content = "商店只能在白天打开",
            Duration = 3,
            Icon = "xmark"
        })
        return false
    end

    RemoteGUIs[name] = visible
    local sg = lp.PlayerGui:FindFirstChild("Ingame")
    if sg then
        local gui = sg:FindFirstChild(name)
        if gui then gui.Visible = visible end
    end
    UpdateMouseLock()
    return true
end

local pseudoGodData = {
    Enabled = false,
    SavedPosition = nil,
    Seat = nil
}

local bullet = {
    TrackActive = false,
    TrailActive = false,
    TrailColor = Color3.fromRGB(0, 120, 255),
    TrailLinger = 0.5
}

local function createBulletTrail(from, to)
    local linger = bullet.TrailLinger or 0.5
    local part = Instance.new("Part")
    part.Anchored = true
    part.CanCollide = false
    part.Material = Enum.Material.Neon
    part.Color = bullet.TrailColor
    part.Size = Vector3.new(0.05, 0.05, (to   from).Magnitude)
    part.CFrame = CFrame.new(from, to) * CFrame.new(0, 0,  part.Size.Z / 2)
    part.Transparency = 0
    part.Parent = W
    task.spawn(function()
        local steps = 20
        local stepTime = linger / steps
        for i = 1, steps do
            task.wait(stepTime)
            part.Transparency = i / steps
        end
        part:Destroy()
    end)
end

local function setupBulletTrack()
    local success, ProjectileHandler = pcall(function()
        return require(game:GetService("ReplicatedStorage").GameStuff.Modules.ProjectileHandler)
    end)

    if not success or not ProjectileHandler or not ProjectileHandler.SimulateProjectile then
        WindUI:Notify({
            Title = "子弹追踪",
            Content = "无法找到ProjectileHandler模块",
            Duration = 3,
            Icon = "xmark"
        })
        return false
    end

    local originalSimulate = ProjectileHandler.SimulateProjectile
    local hookFunc = function(self, p135, p136, p137, p138, p139, p140, p141, p142, p143, p144, p145, p146)
           
        if bullet.TrackActive and p138 and p139 and type(p138) == "table" then
            local enemyPos = getNearestEnemyPos()
            if enemyPos and p139.WorldPosition then
                local firePos = p139.WorldPosition
                if bullet.TrailActive then
                    createBulletTrail(firePos, enemyPos)
                end
                local newDir = (enemyPos   firePos).Unit
                if #p138 > 0 then
                    for i = 1, #p138 do
                        p138[i] = newDir
                    end
                end
            end
        end
        return originalSimulate(self, p135, p136, p137, p138, p139, p140, p141, p142, p143, p144, p145, p146)
    end

    if type(newcclosure) == "function" then
        ProjectileHandler.SimulateProjectile = newcclosure(hookFunc)
    else
        ProjectileHandler.SimulateProjectile = hookFunc
    end
    return true
end

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
        TextSize = config.TextSize or 14,
        AlwaysOnTop = config.AlwaysOnTop ~= false,
        StudsOffset = config.StudsOffset or Vector3.new(0, 3, 0),
        BillboardSize = config.BillboardSize or UDim2.new(0, 200, 0, 40),
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
        hl.FillTransparency = 0.6
        hl.OutlineTransparency = 0.1
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
    nl.Font = Enum.Font.SourceSansBold
    nl.Parent = gui

    local dl = Instance.new("TextLabel")
    dl.Size = UDim2.new(1, 0, 0, cfg.TextSize)
    dl.Position = UDim2.new(0, 0, 0, cfg.TextSize + 2)
    dl.BackgroundTransparency = 1
    dl.Text = "0m"
    dl.TextColor3 = cfg.Color
    dl.TextStrokeTransparency = 0
    dl.TextSize = cfg.TextSize   2
    dl.Font = Enum.Font.SourceSans
    dl.Parent = gui

    local il = Instance.new("TextLabel")
    il.Size = UDim2.new(1, 0, 0, cfg.TextSize)
    il.Position = UDim2.new(0, 0, 0, cfg.TextSize * 2 + 2)
    il.BackgroundTransparency = 1
    il.Text = ""
    il.TextColor3 = Color3.new(1, 1, 1)
    il.TextStrokeTransparency = 0
    il.TextSize = cfg.TextSize   2
    il.Font = Enum.Font.SourceSans
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

function ESP:SetColor(c)
    for d in pairs(ESPList) do
        if d.Config then d.Config.Color = c end
        if d.HL then d.HL.FillColor = c; d.HL.OutlineColor = c end
        if d.NL then d.NL.TextColor3 = c end
        if d.DL then d.DL.TextColor3 = c end
        if d.Box then d.Box.Color = c end
    end
end

local espObjects = {
    Players = {},
    Chains = {},
    Buildings = {},
    Scraps = {},
    AirDrops = {},
    Artifacts = {}
}

local artifactCache = {}

local function findArtifacts()
    local artifacts = {}
    for _, obj in ipairs(W:GetDescendants()) do
        if obj:IsA("BasePart") or obj:IsA("Model") then
            local name = string.lower(obj.Name)
            if string.find(name, "神器") or string.find(name, "文物")
                or string.find(name, "artifact") or string.find(name, "relic") then
                table.insert(artifacts, obj)
                artifactCache[obj] = true
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
                            StudsOffset = Vector3.new(0, 3.5, 0),
                            BillboardSize = UDim2.new(0, 300, 0, 60),
                        })
                    end
                end
            end
        end
    end

       Scrap ESP
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
                            Name = "废料",
                            Color = State.ScrapESP_Color,
                            Highlight = true,
                            Box = true,
                            Text = true,
                            Distance = true,
                            AlwaysOnTop = true,
                            StudsOffset = Vector3.new(0, 2.5, 0),
                        }),
                        Part = anchorPart
                    }
                end
            end
        end
    end

       Player ESP
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
                                Box = true,
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

       Building ESP
    if State.BuildingESP then
        local buildings = {
            {Name = "发电站", Model = GameSections:FindFirstChild("POWERSTATION")},
            {Name = "仓库", Model = GameSections:FindFirstChild("WAREHOUSE")},
            {Name = "工作区", Model = GameSections:FindFirstChild("WORKSHOP")}
        }
        for _, building in ipairs(buildings) do
            if building.Model and not espObjects.Buildings[building.Model] then
                local pivot = building.Model:GetPivot()
                local _, bsize = building.Model:GetBoundingBox()

                local anchorPart = Instance.new("Part")
                anchorPart.Anchored = true
                anchorPart.CanCollide = false
                anchorPart.CanTouch = false
                anchorPart.CanQuery = false
                anchorPart.Transparency = 1
                anchorPart.Size = bsize
                anchorPart.CFrame = pivot
                anchorPart.Parent = W

                espObjects.Buildings[building.Model] = {
                    Obj = ESP:Add({
                        Entity = building.Model,
                        Part = anchorPart,
                        Name = building.Name,
                        Color = State.BuildingESP_Color,
                        Highlight = true,
                        Box = true,
                        Text = true,
                        Distance = true,
                        AlwaysOnTop = true,
                        StudsOffset = Vector3.new(0, 5, 0),
                        BillboardSize = UDim2.new(0, 300, 0, 50),
                    }),
                    Part = anchorPart
                }
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
                                Name = "空投",
                                Color = State.AirDropESP_Color,
                                Highlight = true,
                                Box = true,
                                Text = true,
                                Distance = true,
                                AlwaysOnTop = true,
                                StudsOffset = Vector3.new(0, 5, 0),
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
                          
                        for _, existing in ipairs(hlTarget:GetChildren()) do
                            if existing:IsA("Highlight") then
                                existing:Destroy()
                            end
                        end
                        local hl = Instance.new("Highlight")
                        hl.FillColor = c.Color
                        hl.OutlineColor = c.Color
                        hl.FillTransparency = 0.6
                        hl.OutlineTransparency = 0.1
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
                        local dist = math.floor((lhrp.Position   p.Position).Magnitude)
                        d.DL.Text = tostring(dist) .. "m"
                        d.DL.Visible = true
                    else
                        d.DL.Visible = false
                    end
                end

                if e:IsA("Model") and e:FindFirstChild("Humanoid") then
                    local attrs = e:GetAttributes()
                    local infoStr = ""
                    if attrs.Anger then infoStr = infoStr .. "怒气:" .. string.format("%.1f", attrs.Anger) .. " " end
                    if attrs.ChokeMeter then infoStr = infoStr .. "窒息:" .. string.format("%.1f", attrs.ChokeMeter) .. "% " end
                    if attrs.Burst then infoStr = infoStr .. "重击:" .. string.format("%.1f", attrs.Burst) end
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
                        cf * CFrame.new( sz.X/2,  sz.Y/2,  sz.Z/2),
                        cf * CFrame.new(sz.X/2,  sz.Y/2,  sz.Z/2),
                        cf * CFrame.new(sz.X/2, sz.Y/2,  sz.Z/2),
                        cf * CFrame.new( sz.X/2, sz.Y/2,  sz.Z/2),
                        cf * CFrame.new( sz.X/2,  sz.Y/2, sz.Z/2),
                        cf * CFrame.new(sz.X/2,  sz.Y/2, sz.Z/2),
                        cf * CFrame.new(sz.X/2, sz.Y/2, sz.Z/2),
                        cf * CFrame.new( sz.X/2, sz.Y/2, sz.Z/2),
                    }

                    local x1, y1 = math.huge, math.huge
                    local x2, y2 =  math.huge,  math.huge
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
                        d.Box.Size = Vector2.new(x2   x1, y2   y1)
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
                    Box = true,
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
    ["rbxassetid://11545349261"] = "连击1",
    ["rbxassetid://14123467583"] = "连击2",
    ["rbxassetid://14101304975"] = "连击3",
    ["rbxassetid://14101956641"] = "背后攻击",
    ["rbxassetid://15943264089"] = "蓄力斩击",
    ["rbxassetid://14401168075"] = "蓄力冲锋",
    ["rbxassetid://14875631059"] = "范围攻击",
    ["rbxassetid://11987922371"] = "闪避",
    ["rbxassetid://14255769487"] = "破门",
    ["rbxassetid://15408077041"] = "倒地处决1",
    ["rbxassetid://15409393739"] = "倒地处决2",
    ["rbxassetid://11442109170"] = "警觉",
    ["rbxassetid://123029648649398"] = "空洞警觉",
    ["rbxassetid://78440647847406"] = "蓄力",
    ["rbxassetid://88813113168837"] = "蓄力跳斩",
    ["rbxassetid://135099305543293"] = "暴怒",
    ["rbxassetid://140464711815827"] = "暴怒反击",
    ["rbxassetid://16214202640"] = "突刺",
}

local chainStateAnims = {
    ["rbxassetid://11442109170"] = true,
    ["rbxassetid://123029648649398"] = true,
    ["rbxassetid://135099305543293"] = true,
}

local chainAlertSounds = {
    ["CurbStomp1"] = "踩踏反击",
    ["CurbStomp2"] = "踩踏反击",
    ["Charging"] = "蓄力",
    ["ChainsawSwing"] = "电锯挥砍",
    ["ChainsawCharge"] = "电锯蓄力",
    ["ChainsawSpot"] = "电锯突刺",
    ["ChokeSwing"] = "突刺",
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
        local wall = Instance.new("Part")
        wall.Size = Vector3.new(2, WALL_HEIGHT, 1)
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
            center.Y   2.5,
            center.Z + math.sin(angle) * radius
        )
    end

    for i, wall in ipairs(ringData.Walls) do
        local angle = (i / RING_POINTS) * math.pi * 2 + ringRotAngle
        wall.Position = Vector3.new(
            center.X + math.cos(angle) * radius,
            center.Y + WALL_HEIGHT / 2   15,
            center.Z + math.sin(angle) * radius
        )
        wall.CFrame = CFrame.new(wall.Position, center)
    end
end

local function clearSingleChainRing(chain)
    for i = #chainRings, 1,  1 do
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
                        local dist = (myHRP.Position   hrp.Position).Magnitude
                        if dist < cAlert.RingRadius then
                            local dir = (myHRP.Position   hrp.Position).Unit
                            myHRP.CFrame = CFrame.new(hrp.Position + dir * (cAlert.RingRadius + 10))
                        end
                    end
                end
            end
        end

        for i = #toRemove, 1,  1 do
            local d = chainRings[toRemove[i]]
            for _, p in ipairs(d.Parts.Balls) do pcall(function() p:Destroy() end) end
            for _, p in ipairs(d.Parts.Walls) do pcall(function() p:Destroy() end) end
            table.remove(chainRings, toRemove[i])
        end
    end)
end

local function triggerChainAlert(chain, skillName)
    if cAlert.Notify then
        WindUI:Notify({
            Title = "Chain 预警",
            Content = chain.Name .. " 使用 " .. skillName,
            Duration = 2,
            Icon = "alert triangle"
        })
    end
    activeDodgeChains[chain] = tick()
    if cAlert.Dodge then
        local myHRP = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
        local chainHRP = chain:FindFirstChild("HumanoidRootPart")
        if myHRP and chainHRP then
            local dir = (myHRP.Position   chainHRP.Position).Unit
            myHRP.CFrame = CFrame.new(chainHRP.Position + dir * (cAlert.RingRadius + 10))
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
    for _, conn in ipairs(chainAlertConns) do pcall(function() conn:Disconnect() end) end
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

local tp3 = { Active = false, CamLock = false, CamLockConn = nil, Conn = nil, CharConn = nil, SavedMax = nil, SavedMin = nil }

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

local function updateCameraLock()
    if tp3.CamLockConn then tp3.CamLockConn:Disconnect(); tp3.CamLockConn = nil end
    if tp3.Active and tp3.CamLock then
        tp3.CamLockConn = RS.RenderStepped:Connect(function()
            local char = lp.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if hrp then
                local camCF = Cam.CFrame
                local lookDir = camCF.LookVector
                hrp.CFrame = CFrame.new(hrp.Position, hrp.Position + Vector3.new(lookDir.X, 0, lookDir.Z))
            end
        end)
    end
end
     
local nofogConns = {}
local nofogSaved = {}
local fullbrightConn = nil
local fullbrightSaved = nil

local CoreGui = game:GetService("CoreGui")
local HUDEnabled = true
local HUDLabels = {}

local function createHUD()
    for _, label in pairs(HUDLabels) do
        pcall(function() label:Destroy() end)
    end
    HUDLabels = {}

    local hudGui = Instance.new("ScreenGui")
    hudGui.Name = "ChainXK_HUD"
    hudGui.Parent = CoreGui
    hudGui.ResetOnSpawn = false
    hudGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    local container = Instance.new("Frame")
    container.Size = UDim2.new(0, 220, 0, 160)
    container.Position = UDim2.new(0, 10, 0, 10)
    container.BackgroundTransparency = 1
    container.Parent = hudGui
    HUDLabels.Container = container

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 24)
    title.Position = UDim2.new(0, 0, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "Chain XK V2.9.1"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextStrokeTransparency = 0
    title.Font = Enum.Font.GothamBold
    title.TextSize = 18
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = container
    HUDLabels.Title = title

    local fpsLabel = Instance.new("TextLabel")
    fpsLabel.Size = UDim2.new(1, 0, 0, 20)
    fpsLabel.Position = UDim2.new(0, 0, 0, 28)
    fpsLabel.BackgroundTransparency = 1
    fpsLabel.Text = "FPS:   "
    fpsLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
    fpsLabel.TextStrokeTransparency = 0
    fpsLabel.Font = Enum.Font.Gotham
    fpsLabel.TextSize = 14
    fpsLabel.TextXAlignment = Enum.TextXAlignment.Left
    fpsLabel.Parent = container
    HUDLabels.FPS = fpsLabel

    local pingLabel = Instance.new("TextLabel")
    pingLabel.Size = UDim2.new(1, 0, 0, 20)
    pingLabel.Position = UDim2.new(0, 0, 0, 48)
    pingLabel.BackgroundTransparency = 1
    pingLabel.Text = "Ping:   "
    pingLabel.TextColor3 = Color3.fromRGB(0, 200, 255)
    pingLabel.TextStrokeTransparency = 0
    pingLabel.Font = Enum.Font.Gotham
    pingLabel.TextSize = 14
    pingLabel.TextXAlignment = Enum.TextXAlignment.Left
    pingLabel.Parent = container
    HUDLabels.Ping = pingLabel

    local timeLabel = Instance.new("TextLabel")
    timeLabel.Size = UDim2.new(1, 0, 0, 20)
    timeLabel.Position = UDim2.new(0, 0, 0, 68)
    timeLabel.BackgroundTransparency = 1
    timeLabel.Text = "时间:   :  "
    timeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    timeLabel.TextStrokeTransparency = 0
    timeLabel.Font = Enum.Font.Gotham
    timeLabel.TextSize = 14
    timeLabel.TextXAlignment = Enum.TextXAlignment.Left
    timeLabel.Parent = container
    HUDLabels.Time = timeLabel

    local powerLabel = Instance.new("TextLabel")
    powerLabel.Size = UDim2.new(1, 0, 0, 20)
    powerLabel.Position = UDim2.new(0, 0, 0, 88)
    powerLabel.BackgroundTransparency = 1
    powerLabel.Text = "电力:   "
    powerLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
    powerLabel.TextStrokeTransparency = 0
    powerLabel.Font = Enum.Font.Gotham
    powerLabel.TextSize = 14
    powerLabel.TextXAlignment = Enum.TextXAlignment.Left
    powerLabel.Parent = container
    HUDLabels.Power = powerLabel

    local playersLabel = Instance.new("TextLabel")
    playersLabel.Size = UDim2.new(1, 0, 0, 20)
    playersLabel.Position = UDim2.new(0, 0, 0, 108)
    playersLabel.BackgroundTransparency = 1
    playersLabel.Text = "玩家:   /  "
    playersLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    playersLabel.TextStrokeTransparency = 0
    playersLabel.Font = Enum.Font.Gotham
    playersLabel.TextSize = 14
    playersLabel.TextXAlignment = Enum.TextXAlignment.Left
    playersLabel.Parent = container
    HUDLabels.Players = playersLabel

    local chainsLabel = Instance.new("TextLabel")
    chainsLabel.Size = UDim2.new(1, 0, 0, 20)
    chainsLabel.Position = UDim2.new(0, 0, 0, 128)
    chainsLabel.BackgroundTransparency = 1
    chainsLabel.Text = "Chain:   "
    chainsLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
    chainsLabel.TextStrokeTransparency = 0
    chainsLabel.Font = Enum.Font.Gotham
    chainsLabel.TextSize = 14
    chainsLabel.TextXAlignment = Enum.TextXAlignment.Left
    chainsLabel.Parent = container
    HUDLabels.Chains = chainsLabel
end

createHUD()

local lastFPSTime = tick()
local frameCount = 0
local fps = 0

local function UpdateHUD()
    if not HUDEnabled then
        if HUDLabels.Container and HUDLabels.Container.Parent then
            HUDLabels.Container.Parent.Enabled = false
        end
        return
    end
    if HUDLabels.Container and not HUDLabels.Container.Parent.Enabled then
        HUDLabels.Container.Parent.Enabled = true
    end

    pcall(function()
           FPS
        if HUDLabels.FPS then
            HUDLabels.FPS.Text = "FPS: " .. tostring(fps)
            if fps >= 50 then
                HUDLabels.FPS.TextColor3 = Color3.fromRGB(0, 255, 0)
            elseif fps >= 30 then
                HUDLabels.FPS.TextColor3 = Color3.fromRGB(255, 200, 0)
            else
                HUDLabels.FPS.TextColor3 = Color3.fromRGB(255, 50, 50)
            end
        end

           Ping
        if HUDLabels.Ping then
            local ping = math.floor(lp:GetNetworkPing() * 1000)
            HUDLabels.Ping.Text = "Ping: " .. tostring(ping) .. "ms"
            if ping < 80 then
                HUDLabels.Ping.TextColor3 = Color3.fromRGB(0, 255, 0)
            elseif ping < 150 then
                HUDLabels.Ping.TextColor3 = Color3.fromRGB(255, 200, 0)
            else
                HUDLabels.Ping.TextColor3 = Color3.fromRGB(255, 50, 50)
            end
        end

           时间
        if HUDLabels.Time then
            local roundTime = valuesFolder:GetAttribute("RoundTime")
            if type(roundTime) == "number" and roundTime > 0 then
                local mins = math.floor(roundTime / 60)
                local secs = math.floor(roundTime % 60)
                HUDLabels.Time.Text = string.format("时间: %02d:%02d", mins, secs)
                HUDLabels.Time.TextColor3 = Color3.fromRGB(255, 255, 255)
            else
                HUDLabels.Time.Text = "时间: 白天"
                HUDLabels.Time.TextColor3 = Color3.fromRGB(50, 255, 50)
            end
        end

           电力
        if HUDLabels.Power then
            local power = valuesFolder:GetAttribute("Power")
            if type(power) == "number" then
                HUDLabels.Power.Text = "电力: " .. tostring(math.floor(power)) .. "%"
                if power <= 10 then
                    HUDLabels.Power.TextColor3 = Color3.fromRGB(255, 50, 50)
                elseif power <= 30 then
                    HUDLabels.Power.TextColor3 = Color3.fromRGB(255, 200, 50)
                else
                    HUDLabels.Power.TextColor3 = Color3.fromRGB(50, 255, 50)
                end
            else
                HUDLabels.Power.Text = "电力:   "
                HUDLabels.Power.TextColor3 = Color3.fromRGB(150, 150, 150)
            end
        end

           玩家数
        if HUDLabels.Players then
            local count = 0
            for _, pl in ipairs(P:GetPlayers()) do count = count + 1 end
            HUDLabels.Players.Text = "玩家: " .. tostring(count) .. "/" .. tostring(P.MaxPlayers)
        end

           Chain数
        if HUDLabels.Chains then
            local count = 0
            for _, c in ipairs(aiFolder:GetChildren()) do
                if c:IsA("Model") and c:FindFirstChild("Humanoid") then
                    count = count + 1
                end
            end
            HUDLabels.Chains.Text = "Chain: " .. tostring(count)
        end
    end)
end

task.spawn(function()
    while true do
        task.wait(0.5)
        if HUDEnabled then
            UpdateHUD()
        end
    end
end)

RS.RenderStepped:Connect(function()
    frameCount = frameCount + 1
    local now = tick()
    if now   lastFPSTime >= 1 then
        fps = frameCount
        frameCount = 0
        lastFPSTime = now
    end
end)
     
Tabs.VisualTab:Toggle({
    Title = "除雾",
    Value = false,
    Callback = function(v)
        for _, conn in ipairs(nofogConns) do pcall(function() conn:Disconnect() end) end
        nofogConns = {}

        if v then
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
        else
            if nofogSaved.FogEnd then L.FogEnd = nofogSaved.FogEnd end
            for atm, density in pairs(nofogSaved.Atmospheres or {}) do
                pcall(function() atm.Density = density end)
            end
            nofogSaved = {}
        end
    end,
})

Tabs.VisualTab:Toggle({
    Title = "高亮",
    Value = false,
    Callback = function(v)
        if fullbrightConn then pcall(function() fullbrightConn:Disconnect() end) fullbrightConn = nil end

        if v then
            fullbrightSaved = {
                Brightness = L.Brightness,
                ClockTime = L.ClockTime,
                FogEnd = L.FogEnd,
                GlobalShadows = L.GlobalShadows,
                OutdoorAmbient = L.OutdoorAmbient,
            }

            local function fb()
                L.Brightness = 2
                L.ClockTime = 14
                L.FogEnd = 100000
                L.GlobalShadows = false
                L.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
            end

            fb()
            fullbrightConn = RS.RenderStepped:Connect(fb)
        else
            if fullbrightSaved then
                L.Brightness = fullbrightSaved.Brightness
                L.ClockTime = fullbrightSaved.ClockTime
                L.FogEnd = fullbrightSaved.FogEnd
                L.GlobalShadows = fullbrightSaved.GlobalShadows
                L.OutdoorAmbient = fullbrightSaved.OutdoorAmbient
                fullbrightSaved = nil
            end
        end
    end,
})

Tabs.VisualTab:Toggle({
    Title = "显示聊天框",
    Value = false,
    Callback = function(v)
        State.ForceChat = v
        if v then
            pcall(function()
                local TextChatService = game:GetService("TextChatService")
                local ok, chatWinCfg = pcall(function()
                    return TextChatService.ChatWindowConfiguration
                end)

                if ok and chatWinCfg then
                    chatWinCfg.Enabled = true
                    WindUI:Notify({
                        Title = "聊天框已启用",
                        Content = "聊天窗口已强制显示",
                        Duration = 3,
                        Icon = "check circle"
                    })
                else
                    WindUI:Notify({
                        Title = "聊天框启用失败",
                        Content = "请确保聊天类型是 TextChatService",
                        Duration = 3,
                        Icon = "alert triangle"
                    })
                end
            end)
        end
    end,
})

Tabs.VisualTab:Section({ Title = "ESP 颜色设置" })

Tabs.VisualTab:Colorpicker({
    Title = "玩家ESP颜色",
    Default = State.PlayerESP_Color,
    Callback = function(c)
        State.PlayerESP_Color = c
        for _, obj in pairs(espObjects.Players) do
            if obj.SetColor then obj:SetColor(c) end
        end
    end,
})

Tabs.VisualTab:Colorpicker({
    Title = "ChainESP颜色",
    Default = State.ChainESP_Color,
    Callback = function(c)
        State.ChainESP_Color = c
        for _, obj in pairs(espObjects.Chains) do
            if obj.SetColor then obj:SetColor(c) end
        end
    end,
})

Tabs.VisualTab:Colorpicker({
    Title = "建筑ESP颜色",
    Default = State.BuildingESP_Color,
    Callback = function(c)
        State.BuildingESP_Color = c
        for _, data in pairs(espObjects.Buildings) do
            if data.Obj and data.Obj.SetColor then data.Obj:SetColor(c) end
        end
    end,
})

Tabs.VisualTab:Colorpicker({
    Title = "废料ESP颜色",
    Default = State.ScrapESP_Color,
    Callback = function(c)
        State.ScrapESP_Color = c
        for _, data in pairs(espObjects.Scraps) do
            if data.Obj and data.Obj.SetColor then data.Obj:SetColor(c) end
        end
    end,
})

Tabs.VisualTab:Colorpicker({
    Title = "空投ESP颜色",
    Default = State.AirDropESP_Color,
    Callback = function(c)
        State.AirDropESP_Color = c
        for _, obj in pairs(espObjects.AirDrops) do
            if obj.SetColor then obj:SetColor(c) end
        end
    end,
})

Tabs.VisualTab:Colorpicker({
    Title = "神器ESP颜色",
    Default = State.ArtifactESP_Color,
    Callback = function(c)
        State.ArtifactESP_Color = c
        for _, obj in pairs(espObjects.Artifacts) do
            if obj.SetColor then obj:SetColor(c) end
        end
    end,
})

Tabs.VisualTab:Section({ Title = "ESP 透视" })

Tabs.VisualTab:Toggle({
    Title = "玩家 ESP",
    Value = false,
    Callback = function(v)
        State.PlayerESP = v
        if not v then
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
                            Box = true,
                            Text = true,
                            Distance = true,
                            AlwaysOnTop = false,
                        })
                    end
                end)
            end
        end
    end,
})

Tabs.VisualTab:Toggle({
    Title = "Chain ESP",
    Value = false,
    Callback = function(v)
        State.ChainESP = v
        if not v then
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
                        StudsOffset = Vector3.new(0, 3.5, 0),
                        BillboardSize = UDim2.new(0, 300, 0, 60),
                    })
                end
            end
        end
    end,
})

Tabs.VisualTab:Toggle({
    Title = "建筑 ESP",
    Value = false,
    Callback = function(v)
        State.BuildingESP = v
        if not v then
            for _, data in pairs(espObjects.Buildings) do
                if data.Obj then data.Obj:Remove() end
                if data.Part then data.Part:Destroy() end
            end
            espObjects.Buildings = {}
            return
        end

        local buildings = {
            {Name = "发电站", Model = GameSections:FindFirstChild("POWERSTATION")},
            {Name = "仓库", Model = GameSections:FindFirstChild("WAREHOUSE")},
            {Name = "工作区", Model = GameSections:FindFirstChild("WORKSHOP")}
        }
        for _, building in ipairs(buildings) do
            if building.Model and not espObjects.Buildings[building.Model] then
                local pivot = building.Model:GetPivot()
                local _, bsize = building.Model:GetBoundingBox()

                local anchorPart = Instance.new("Part")
                anchorPart.Anchored = true
                anchorPart.CanCollide = false
                anchorPart.CanTouch = false
                anchorPart.CanQuery = false
                anchorPart.Transparency = 1
                anchorPart.Size = bsize
                anchorPart.CFrame = pivot
                anchorPart.Parent = W

                espObjects.Buildings[building.Model] = {
                    Obj = ESP:Add({
                        Entity = building.Model,
                        Part = anchorPart,
                        Name = building.Name,
                        Color = State.BuildingESP_Color,
                        Highlight = true,
                        Box = true,
                        Text = true,
                        Distance = true,
                        AlwaysOnTop = true,
                        StudsOffset = Vector3.new(0, 5, 0),
                        BillboardSize = UDim2.new(0, 300, 0, 50),
                    }),
                    Part = anchorPart
                }
            end
        end
    end,
})

Tabs.VisualTab:Toggle({
    Title = "废料 ESP",
    Value = false,
    Callback = function(v)
        State.ScrapESP = v
        if not v then
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
                            Name = "废料",
                            Color = State.ScrapESP_Color,
                            Highlight = true,
                            Box = true,
                            Text = true,
                            Distance = true,
                            AlwaysOnTop = true,
                            StudsOffset = Vector3.new(0, 2.5, 0),
                        }),
                        Part = anchorPart
                    }
                end
            end
        end
    end,
})

Tabs.VisualTab:Toggle({
    Title = "空投 ESP",
    Value = false,
    Callback = function(v)
        State.AirDropESP = v
        if not v then
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
                                Name = "空投",
                                Color = State.AirDropESP_Color,
                                Highlight = true,
                                Box = true,
                                Text = true,
                                Distance = true,
                                AlwaysOnTop = true,
                                StudsOffset = Vector3.new(0, 5, 0),
                            })
                        end
                    end
                end
            end
        end
    end,
})

Tabs.VisualTab:Section({ Title = "神器/文物 ESP" })

Tabs.VisualTab:Toggle({
    Title = "神器 ESP",
    Value = false,
    Callback = function(v)
        State.ArtifactESP = v
        if v then
               
            for _, obj in pairs(espObjects.Artifacts) do
                if obj.Remove then obj:Remove() end
            end
            espObjects.Artifacts = {}
            artifactCache = {}

            local artifacts = findArtifacts()
            for _, artifact in ipairs(artifacts) do
                if not espObjects.Artifacts[artifact] then
                    local part = artifact
                    if artifact:IsA("Model") then
                        part = artifact:FindFirstChildWhichIsA("BasePart", true) or artifact.PrimaryPart
                           【修复7】Lua 5.1 无 continue，用 if/then 替代
                        if part then
                            espObjects.Artifacts[artifact] = ESP:Add({
                                Entity = artifact,
                                Part = part,
                                Name = "神器",
                                Color = State.ArtifactESP_Color,
                                Highlight = true,
                                Box = true,
                                Text = true,
                                Distance = true,
                                AlwaysOnTop = true,
                                StudsOffset = Vector3.new(0, 3, 0),
                                BillboardSize = UDim2.new(0, 200, 0, 50),
                            })
                        end
                    else
                        espObjects.Artifacts[artifact] = ESP:Add({
                            Entity = artifact,
                            Part = part,
                            Name = "神器",
                            Color = State.ArtifactESP_Color,
                            Highlight = true,
                            Box = true,
                            Text = true,
                            Distance = true,
                            AlwaysOnTop = true,
                            StudsOffset = Vector3.new(0, 3, 0),
                            BillboardSize = UDim2.new(0, 200, 0, 50),
                        })
                    end
                end
            end

            if not espObjects.Artifacts.Connection then
                espObjects.Artifacts.Connection = W.DescendantAdded:Connect(function(obj)
                    local name = string.lower(obj.Name)
                    if (obj:IsA("BasePart") or obj:IsA("Model"))
                        and (string.find(name, "神器") or string.find(name, "文物")
                             or string.find(name, "artifact") or string.find(name, "relic")) then
                        if not espObjects.Artifacts[obj] and not artifactCache[obj] then
                            local part = obj
                            if obj:IsA("Model") then
                                part = obj:FindFirstChildWhichIsA("BasePart", true) or obj.PrimaryPart
                                if not part then return end
                            end
                            espObjects.Artifacts[obj] = ESP:Add({
                                Entity = obj,
                                Part = part,
                                Name = "神器",
                                Color = State.ArtifactESP_Color,
                                Highlight = true,
                                Box = true,
                                Text = true,
                                Distance = true,
                                AlwaysOnTop = true,
                                StudsOffset = Vector3.new(0, 3, 0),
                                BillboardSize = UDim2.new(0, 200, 0, 50),
                            })
                            artifactCache[obj] = true
                        end
                    end
                end)
            end

            WindUI:Notify({
                Title = "神器ESP",
                Content = "神器 (" .. #artifacts .. " 个)",
                Duration = 2,
                Icon = "check circle"
            })
        else
            if espObjects.Artifacts.Connection then
                espObjects.Artifacts.Connection:Disconnect()
                espObjects.Artifacts.Connection = nil
            end
            for _, obj in pairs(espObjects.Artifacts) do
                if obj.Remove then obj:Remove() end
            end
            espObjects.Artifacts = {}
            artifactCache = {}
        end
    end,
})

local HUDEnabledSection = Tabs.VisualTab:Section({
    Title = "状态显示器",
    Opened = true
})

HUDEnabledSection:Toggle({
    Title = "显示游戏状态",
    Value = true,
    Callback = function(v)
        HUDEnabled = v
        if v then
            if not HUDLabels.Container then
                createHUD()
            end
            UpdateHUD()
            WindUI:Notify({
                Title = "状态HUD",
                Content = "已开启",
                Duration = 2,
                Icon = "check circle"
            })
        else
            if HUDLabels.Container and HUDLabels.Container.Parent then
                HUDLabels.Container.Parent.Enabled = false
            end
            WindUI:Notify({
                Title = "状态HUD",
                Content = "已关闭",
                Duration = 2,
                Icon = "xmark"
            })
        end
    end,
})

local AutoPowerSection = Tabs.FuncTab:Section({
    Title = "自动发电机",
    Opened = true
})

local function isStationElectrified(station)
    local powerStation = station:FindFirstChild("PowerStation")
    if not powerStation then return false end
    local electricZone = powerStation:FindFirstChild("ElectricZone")
    if not electricZone then return false end
    local danger = electricZone:FindFirstChild("Danger")
    if not danger then return false end
    return danger.Transparency < 0.99 and danger.Visible
end

AutoPowerSection:Toggle({
    Title = "自动发电机",
    Value = false,
    Callback = function(v)
        State.AutoPower = v
        if v then
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
                                hrp.CFrame = CFrame.new( 208.299744,  110.604126,  120.227615)
                                task.wait(0.2)

                                local startTime = tick()
                                while State.AutoPower and tick()   startTime < 60 do
                                    local curPower = valuesFolder:GetAttribute("Power")
                                    if type(curPower) == "number" and curPower > 0 then
                                        break
                                    end

                                    if isStationElectrified(station) then
                                        task.wait(0.5)
                                    else
                                        local alertUI = station:FindFirstChild("AlertUI")
                                        if alertUI then
                                            local gui = alertUI:FindFirstChild("GUI")
                                            if gui and not gui.Enabled then
                                                local prompt = station:FindFirstChildWhichIsA("ProximityPrompt", true)
                                                safeFireProximityPrompt(prompt)
                                            end
                                        end
                                        task.wait(0.1)
                                    end
                                end

                                if hrp and hrp.Parent then
                                    hrp.CFrame = savedCF
                                end
                            end
                        end
                    end)
                    task.wait(1)
                end
            end)
        end
        WindUI:Notify({
            Title = "自动发电机",
            Content = v and "已开启" or "已关闭",
            Duration = 2,
            Icon = v and "check" or "xmark"
        })
    end,
})

local AutoScrapSection = Tabs.FuncTab:Section({
    Title = "自动捡废料",
    Opened = true
})

AutoScrapSection:Toggle({
    Title = "自动捡废料",
    Value = false,
    Callback = function(v)
        State.AutoScrap = v
        if v then
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
                                            local dist = (hrp.Position   scrap:GetPivot().Position).Magnitude
                                            if dist <= State.ScrapRange then
                                                local prompt = scrap:FindFirstChildWhichIsA("ProximityPrompt", true)
                                                safeFireProximityPrompt(prompt)
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
        WindUI:Notify({
            Title = "自动捡废料",
            Content = v and "已开启" or "已关闭",
            Duration = 2,
            Icon = v and "check" or "xmark"
        })
    end,
})

AutoScrapSection:Slider({
    Title = "收集范围",
    Desc = "六秒内不要拾取太多否则会踢",
    Value = {
        Min = 10,
        Max = 200,
        Default = 50
    },
    Callback = function(v)
        State.ScrapRange = v
    end,
})

AutoScrapSection:Slider({
    Title = "收集间隔(秒)",
    Value = {
        Min = 1,
        Max = 6,
        Default = 6
    },
    Callback = function(v)
        State.ScrapInterval = v
    end,
})
 
Tabs.FuncTab:Section({ Title = "战斗功能" })

Tabs.FuncTab:Toggle({
    Title = "自动 QTE",
    Desc = "可能无效需要自行点击屏幕中间的按钮",
    Value = false,
    Callback = function(v)
        State.AutoQTE = v
        WindUI:Notify({
            Title = "自动 QTE",
            Content = v and "已开启" or "已关闭",
            Duration = 3,
            Icon = v and "alert triangle" or "xmark"
        })
    end,
})

Tabs.FuncTab:Toggle({
    Title = "拼刀必胜",
    Value = false,
    Callback = function(v)
        State.WinClash = v
    end,
})

Tabs.FuncTab:Toggle({
    Title = "X锯无限燃油",
    Value = false,
    Callback = function(v)
        State.InfGas = v
    end,
})

local toggleInfAmmo
local InfAmmoToggle

InfAmmoToggle = Tabs.FuncTab:Toggle({
    Title = "无限弹药",
    Value = false,
    Callback = function(v)
        State.InfAmmo = v
        toggleInfAmmo()
    end,
})

Tabs.FuncTab:Section({ Title = "子弹" })

Tabs.FuncTab:Toggle({
    Title = "子弹追踪",
    Value = false,
    Callback = function(v)
        State.BulletTrack = v
        bullet.TrackActive = v
        if v then
            setupBulletTrack()
            WindUI:Notify({
                Title = "子弹追踪",
                Content = "已开启",
                Duration = 2
            })
        else
            WindUI:Notify({
                Title = "子弹追踪",
                Content = "已关闭",
                Duration = 2
            })
        end
    end,
})

Tabs.FuncTab:Toggle({
    Title = "子弹轨迹",
    Value = false,
    Callback = function(v)
        State.BulletTrail = v
        bullet.TrailActive = v
        WindUI:Notify({
            Title = "子弹轨迹",
            Content = v and "已开启" or "已关闭",
            Duration = 2
        })
    end,
})

Tabs.FuncTab:Section({ Title = "枪械" })

Tabs.FuncTab:Toggle({
    Title = "无后坐力",
    Value = false,
    Callback = function(v)
        State.NoRecoil = v
        if v then
            hookRecoil()
            WindUI:Notify({
                Title = "无后坐力",
                Content = "已开启",
                Duration = 2
            })
        else
            restoreRecoil()
            WindUI:Notify({
                Title = "无后坐力",
                Content = "已关闭",
                Duration = 2
            })
        end
    end,
})
                          
Tabs.FuncTab:Section({ Title = "生存" })

Tabs.FuncTab:Toggle({
    Title = "无限体力",
    Value = false,
    Callback = function(v)
        State.InfStamina = v
    end,
})

Tabs.FuncTab:Toggle({
    Title = "无限战斗体力",
    Value = false,
    Callback = function(v)
        State.InfCombatStamina = v
    end,
})
              
local PseudoGodToggle
local function doPseudoGod(enable)
    State.PseudoGod = enable
    if enable then
        State.ChainDodge = false
        cAlert.Dodge = false

        local char = lp.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local torso = char and (char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso"))

        if hrp and torso then
            State.PseudoGodReturnPos = hrp.CFrame

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

            hrp.CFrame = CFrame.new( 25.95, 84, 3537.55)
            task.wait(0.15)

            local seat = Instance.new("Seat")
            seat.Name = ""
            seat.Anchored = false
            seat.CanCollide = false
            seat.Transparency = 1
            seat.Position = Vector3.new(95, 84, 37.55)
            seat.Parent = workspace

            local weld = Instance.new("Weld")
            weld.Part0 = seat
            weld.Part1 = torso
            weld.Parent = seat

            task.wait()
            seat.CFrame = State.PseudoGodReturnPos
            pseudoGodData.Seat = seat

            task.wait(0.5)
            blackGui:Destroy()

            WindUI:Notify({
                Title = "伪无敌",
                Content = "已开启 请确保本体在安全位置",
                Duration = 4,
                Icon = "alert triangle"
            })
        end
    else
        if pseudoGodData.Seat then
            local char = lp.Character
            if char then
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if hrp and State.PseudoGodReturnPos then
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

                    hrp.CFrame = State.PseudoGodReturnPos

                    task.wait(0.5)
                    blackGui:Destroy()
                end
            end
            pseudoGodData.Seat:Destroy()
            pseudoGodData.Seat = nil
        end
        WindUI:Notify({
            Title = "伪无敌",
            Content = "已关闭",
            Duration = 2,
            Icon = "xmark"
        })
    end
    if PseudoGodToggle then
        PseudoGodToggle:SetValue(enable)
    end
end

PseudoGodToggle = Tabs.FuncTab:Toggle({
    Title = "伪无敌",
    Desc = "开启前请将本体藏在安全的地方",
    Value = false,
    Callback = function(v)
        doPseudoGod(v)
    end,
})

Tabs.FuncTab:Toggle({
    Title = "朝向 Chain",
    Value = false,
    Callback = function(v)
        State.FaceChain = v
    end,
})

Tabs.FuncTab:Section({ Title = "速度 & 视野" })

Tabs.FuncTab:Toggle({
    Title = "速度",
    Value = false,
    Callback = function(v)
        State.SpeedBoost = v
        speedData.Active = v
        setupSpeedBoost()
        WindUI:Notify({
            Title = "速度",
            Content = v and "已开启" or "已关闭",
            Duration = 2
        })
    end,
})

Tabs.FuncTab:Slider({
    Title = "速度倍率",
    Value = {
        Min = 0.5,
        Max = 20,
        Default = 1
    },
    Callback = function(v)
        State.SpeedValue = v
        speedData.Speed = v
    end,
})

Tabs.FuncTab:Toggle({
    Title = "绕过捕兽夹放置限制",
    Value = false,
    Callback = function(state)
        pcall(function()
            _G.BypassBearTrap = state
            if state then
                task.spawn(function()
                    while _G.BypassBearTrap do
                        pcall(function()
                            task.wait()
                            local stats = game:GetService("Players").LocalPlayer:FindFirstChild("PlayerStats")
                            if stats then
                                stats:SetAttribute("BearTrapPlaced", false)
                            end
                        end)
                    end
                end)
            else
                local stats = game:GetService("Players").LocalPlayer:FindFirstChild("PlayerStats")
                if stats then
                    stats:SetAttribute("BearTrapPlaced", true)
                end
            end
        end)
    end,
})

local DisableSmoothness
pcall(function()
    DisableSmoothness = game:GetService("ReplicatedStorage"):WaitForChild("Assets"):WaitForChild("Client"):WaitForChild("Movement"):WaitForChild("DisableSmoothness")
end)

Tabs.FuncTab:Toggle({
    Title = "取消走路/跑步惯性",
    Value = false,
    Callback = function(state)
        pcall(function()
            if DisableSmoothness then
                DisableSmoothness.Value = state
            end
        end)
    end,
})

local tpwalking = false
local tpwalkSpeed = 5

Tabs.FuncTab:Toggle({
    Title = "速度",
    Value = false,
    Callback = function(state)
        pcall(function()
            tpwalking = state
            if state then
                task.spawn(function()
                    while tpwalking do
                        pcall(function()
                            local chr = lp.Character or lp.CharacterAdded:Wait()
                            local hrp = chr:FindFirstChild("HumanoidRootPart")
                            local hum = chr:FindFirstChildWhichIsA("Humanoid")
                            local delta = RS.Heartbeat:Wait()
                            if hrp and hum and hum.MoveDirection.Magnitude > 0 then
                                hrp.CFrame = hrp.CFrame + (hum.MoveDirection * tpwalkSpeed * delta)
                            end
                        end)
                    end
                end)
            end
        end)
    end,
})

Tabs.FuncTab:Slider({
    Title = "行走速度",
    Value = { Min = 0, Max = 50, Default = tpwalkSpeed },
    Callback = function(value)
        pcall(function() tpwalkSpeed = value end)
    end,
})

local AdminCheckEnabled = false
local targetUsers = {
    "AdminUser1", "HackerHunter", "ReportBot", "ModeratorX",
    "AntiCheatDev", "ChainMod", "ScriptDetector", "BanHammer",
    "WatchDog", "Cleaner01", "Cleaner02", "ServerGuard",
    "RobloxCorp", "TrustAndSafety", "ReportKing", "AdminAlice",
    "AdminBob", "SuspiciousUser", "CheatFinder", "BanAppeal",
    "GameWatcher", "AutoMod", "SecOps01", "SecOps02",
    "FraudSquad", "ComplianceBot", "RuleEnforcer", "JusticeLeague",
    "NightWatch", "DayShift", "TheObserver", "SilentGuard",
    "ProxyHunter", "VPNBlocker", "AccountChecker", "NewAccWatch",
    "OldPlayerHater", "ChainDev", "XKDetector", "ScriptUser01",
    "ScriptUser02", "ExploitFinder", "BackdoorScan", "RemoteLogger",
    "PacketSniffer", "MemoryWatcher", "DecompilerBot", "Disassembler"
}

local function checkAdminAndReporters()
    pcall(function()
        for _, player in ipairs(P:GetPlayers()) do
            if player ~= lp then
                local name = player.Name:lower()
                for _, target in ipairs(targetUsers) do
                    if name == target:lower() then
                        WindUI:Notify({
                            Title = "⚠️ 警告",
                            Content = player.Name .. " 已加入游戏（疑似管理员/举报者）",
                            Duration = 8,
                            Icon = "alert triangle"
                        })
                        break
                    end
                end
            end
        end
    end)
end

Tabs.FuncTab:Toggle({
    Title = "检测管理员/举报者",
    Value = false,
    Callback = function(state)
        pcall(function()
            AdminCheckEnabled = state
            _G.AdminCheckEnabled = state
            if state then
                checkAdminAndReporters()
                   持续监控
                task.spawn(function()
                    while AdminCheckEnabled do
                        task.wait(10)
                        checkAdminAndReporters()
                    end
                end)
            end
        end)
    end,
})

P.PlayerAdded:Connect(function(player)
    pcall(function()
        if not AdminCheckEnabled then return end
        task.wait(2)
        local name = player.Name:lower()
        for _, target in ipairs(targetUsers) do
            if name == target:lower() then
                WindUI:Notify({
                    Title = "⚠️ 警告",
                    Content = player.Name .. " 加入游戏（疑似管理员/特殊人员）",
                    Duration = 8,
                    Icon = "alert triangle"
                })
                break
            end
        end
    end)
end)

local CTS
local capturingCTS = false
local LastCTSArgs
local ctsLoop

local function refreshCTS()
    pcall(function()
        local char = lp.Character
        if not char then return end
        local mob = char:FindFirstChild("CharacterMobility")
        if mob then
            local cts = mob:FindFirstChild("CTS")
            if cts then CTS = cts end
        end
    end)
end

lp.CharacterAdded:Connect(function()
    pcall(function()
        task.wait(1)
        refreshCTS()
        LastCTSArgs = nil
        local wasCapturing = capturingCTS
        if wasCapturing then
            capturingCTS = true
        end
    end)
end)

refreshCTS()

pcall(function()
    local mt = getrawmetatable(game)
    if mt then
        local old = mt.__namecall
        setreadonly(mt, false)
        mt.__namecall = function(self, ...)
            local method = getnamecallmethod()
            if method == "FireServer" and self == CTS then
                local args = {...}
                if capturingCTS and not LastCTSArgs then
                    LastCTSArgs = args
                end
            end
            return old(self, ...)
        end
        setreadonly(mt, true)
    end
end)

Tabs.FuncTab:Toggle({
    Title = "自动无限闪避",
    Desc = "开启功能之后需要你手动点一下闪避键(注意:多次闪避会被踢)",
    Value = false,
    Callback = function(state)
        pcall(function()
            if state then
                capturingCTS = true
                LastCTSArgs = nil
                if ctsLoop then
                    ctsLoop:Disconnect()
                    ctsLoop = nil
                end
                ctsLoop = RS.Heartbeat:Connect(function(dt)
                    pcall(function()
                        if not CTS or not CTS.Parent then
                            refreshCTS()
                        end
                        if CTS and LastCTSArgs then
                            if tick() % 0.7 < dt then
                                CTS:FireServer(unpack(LastCTSArgs))
                            end
                        end
                    end)
                end)
            else
                capturingCTS = false
                if ctsLoop then
                    ctsLoop:Disconnect()
                    ctsLoop = nil
                end
            end
        end)
    end,
})

local Interact2
local capturingInteract = false
local LastInteractArgs
local swingLoop
local swingDelay = 0.7

local function refreshInteract()
    pcall(function()
        local char = lp.Character
        if not char then return end
        local ch = char:FindFirstChild("CharacterHandler")
        if ch then
            local contents = ch:FindFirstChild("Contents")
            if contents then
                local remotes = contents:FindFirstChild("Remotes")
                if remotes then
                    Interact2 = remotes:FindFirstChild("Interact")
                end
            end
        end
    end)
end

lp.CharacterAdded:Connect(function()
    pcall(function()
        task.wait(1)
        refreshInteract()
        LastInteractArgs = nil
        if capturingInteract then
            capturingInteract = true
        end
    end)
end)

refreshInteract()

pcall(function()
    local mt = getrawmetatable(game)
    if mt then
        local old = mt.__namecall
        setreadonly(mt, false)
        mt.__namecall = function(self, ...)
            local method = getnamecallmethod()
            if method == "FireServer" and self == Interact2 then
                local args = {...}
                if capturingInteract and not LastInteractArgs then
                    LastInteractArgs = args
                end
            end
            return old(self, ...)
        end
        setreadonly(mt, true)
    end
end)

Tabs.FuncTab:Input({
    Title = "自动挥刀间隔(最高1最低0.7)",
    Value = "0.7",
    Placeholder = "0.7 1",
    Callback = function(input)
        pcall(function()
            local num = tonumber(input)
            if num then
                if num > 1 then
                    num = 1
                elseif num < 0.01 then
                    num = 0.01
                end
                swingDelay = num
            end
        end)
    end,
})

Tabs.FuncTab:Toggle({
    Title = "自动挥刀滥用",
    Desc = "速度调低了也会被踢",
    Value = false,
    Callback = function(state)
        pcall(function()
            if state then
                capturingInteract = true
                LastInteractArgs = nil
                if swingLoop then
                    swingLoop:Disconnect()
                    swingLoop = nil
                end
                swingLoop = RS.Heartbeat:Connect(function(dt)
                    pcall(function()
                        if not Interact2 or not Interact2.Parent then
                            refreshInteract()
                        end
                        if Interact2 and LastInteractArgs then
                            if tick() % swingDelay < dt then
                                Interact2:FireServer(unpack(LastInteractArgs))
                            end
                        end
                    end)
                end)
            else
                capturingInteract = false
                if swingLoop then
                    swingLoop:Disconnect()
                    swingLoop = nil
                end
            end
        end)
    end,
})

local G_Choke = {}
G_Choke.Players = P
G_Choke.RunService = RS
G_Choke.Workspace = W
G_Choke.LocalPlayer = lp
G_Choke.CTS = nil
G_Choke.StoredCTSArgs = nil
G_Choke.CapturedThisLife = false
G_Choke.ChokeEnabled = false
G_Choke.ScreamEnabled = false
G_Choke.DetectRange = 14
G_Choke.LastDodgeTime = 0
G_Choke.ChokeAnimId = "16214202640"
G_Choke.ScreamAnimIds = { "14401168075", "15943264089" }
G_Choke.LastKnownTracks = {}
G_Choke.boundChain = nil

function G_Choke.refreshCTS()
    pcall(function()
        local char = G_Choke.LocalPlayer.Character
        if not char then return end
        local mob = char:FindFirstChild("CharacterMobility")
        if mob then
            local cts = mob:FindFirstChild("CTS")
            if cts then G_Choke.CTS = cts end
        end
    end)
end

function G_Choke.resetLifeState()
    pcall(function()
        G_Choke.CTS = nil
        G_Choke.StoredCTSArgs = nil
        G_Choke.CapturedThisLife = false
        G_Choke.LastKnownTracks = {}
        task.wait(1)
        G_Choke.refreshCTS()
    end)
end

G_Choke.LocalPlayer.CharacterAdded:Connect(G_Choke.resetLifeState)
G_Choke.refreshCTS()

pcall(function()
    local mt = getrawmetatable(game)
    if mt then
        local old = mt.__namecall
        setreadonly(mt, false)
        mt.__namecall = function(self, ...)
            local method = getnamecallmethod()
            local args = {...}
            if method == "FireServer" and self == G_Choke.CTS and not G_Choke.CapturedThisLife then
                if args[1] == "Dodge1" then
                    G_Choke.StoredCTSArgs = args
                    G_Choke.CapturedThisLife = true
                end
            end
            return old(self, ...)
        end
        setreadonly(mt, true)
    end
end)

function G_Choke.AttemptDodge()
    pcall(function()
        if G_Choke.CTS and G_Choke.StoredCTSArgs and G_Choke.CapturedThisLife then
            local now = os.clock()
            if now   G_Choke.LastDodgeTime >= 0.05 then
                G_Choke.LastDodgeTime = now
                G_Choke.CTS:FireServer(unpack(G_Choke.StoredCTSArgs))
            end
        end
    end)
end

function G_Choke.getChain()
    local misc = G_Choke.Workspace:FindFirstChild("Misc")
    if not misc then return nil end
    local ai = misc:FindFirstChild("AI")
    if not ai then return nil end
    return ai:FindFirstChild("CHAIN")
end

function G_Choke.checkAnimId(id)
    if G_Choke.ChokeEnabled and id:find(G_Choke.ChokeAnimId) then
        return true
    end
    if G_Choke.ScreamEnabled then
        for _, sid in ipairs(G_Choke.ScreamAnimIds) do
            if id:find(sid) then return true end
        end
    end
    return false
end

function G_Choke.bindChainAnimEvents(chain)
    pcall(function()
        local humanoid = chain:FindFirstChild("Humanoid")
        if not humanoid then return end
        humanoid.AnimationPlayed:Connect(function(track)
            pcall(function()
                if not G_Choke.CapturedThisLife then return end
                local char = G_Choke.LocalPlayer.Character
                if not char then return end
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if not hrp then return end
                local chainHrp = chain:FindFirstChild("HumanoidRootPart")
                if not chainHrp then return end
                local dist = (hrp.Position   chainHrp.Position).Magnitude
                if dist > G_Choke.DetectRange then return end
                local anim = track.Animation
                if not anim then return end
                local id = tostring(anim.AnimationId)
                if G_Choke.checkAnimId(id) then
                    G_Choke.AttemptDodge()
                end
            end)
        end)
    end)
end

G_Choke.RunService.Heartbeat:Connect(function()
    pcall(function()
        local chain = G_Choke.getChain()
        if chain and chain ~= G_Choke.boundChain then
            G_Choke.boundChain = chain
            G_Choke.bindChainAnimEvents(chain)
        end
        if not G_Choke.ChokeEnabled and not G_Choke.ScreamEnabled then return end
        if not G_Choke.CapturedThisLife then return end
        local char = G_Choke.LocalPlayer.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        if not chain then return end
        local chainHrp = chain:FindFirstChild("HumanoidRootPart")
        local humanoid = chain:FindFirstChild("Humanoid")
        if not chainHrp or not humanoid then return end
        local dist = (hrp.Position   chainHrp.Position).Magnitude
        if dist > G_Choke.DetectRange then return end
        local currentTracks = humanoid:GetPlayingAnimationTracks()
        local currentSet = {}
        for i = 1, #currentTracks do
            local track = currentTracks[i]
            local anim = track.Animation
            if anim then
                local id = tostring(anim.AnimationId)
                currentSet[id] = true
                if not G_Choke.LastKnownTracks[id] then
                    if G_Choke.checkAnimId(id) then
                        G_Choke.AttemptDodge()
                    end
                end
            end
        end
        G_Choke.LastKnownTracks = currentSet
    end)
end)

Tabs.FuncTab:Toggle({
    Title = "自动躲掐脖",
    Desc = "开启后点一次闪避键",
    Value = false,
    Callback = function(state)
        pcall(function()
            G_Choke.ChokeEnabled = state
            if state and not G_Choke.CTS then G_Choke.refreshCTS() end
        end)
    end,
})

Tabs.FuncTab:Toggle({
    Title = "自动躲尖叫斩",
    Desc = "开启后点一次闪避键",
    Value = false,
    Callback = function(state)
        pcall(function()
            G_Choke.ScreamEnabled = state
            if state and not G_Choke.CTS then G_Choke.refreshCTS() end
        end)
    end,
})

                                                                      
   新功能：无敌QTE（Interact自动重发）
                                                                      
local InvincibleInteract
local invincibleCapturing = false
local invincibleLastArgs
local invincibleLoop
local invincibleLastFire = 0

local function refreshInvincibleInteract()
    pcall(function()
        local char = lp.Character
        if not char then return end
        local ch = char:FindFirstChild("CharacterHandler")
        if ch then
            local contents = ch:FindFirstChild("Contents")
            if contents then
                local remotes = contents:FindFirstChild("Remotes")
                if remotes then
                    InvincibleInteract = remotes:FindFirstChild("Interact")
                end
            end
        end
    end)
end

lp.CharacterAdded:Connect(function()
    pcall(function()
        task.wait(1)
        refreshInvincibleInteract()
        invincibleLastArgs = nil
    end)
end)

refreshInvincibleInteract()

pcall(function()
    local mt = getrawmetatable(game)
    if mt then
        local old = mt.__namecall
        setreadonly(mt, false)
        mt.__namecall = function(self, ...)
            local method = getnamecallmethod()
            if method == "FireServer" and self == InvincibleInteract then
                local args = {...}
                if invincibleCapturing and not invincibleLastArgs then
                    invincibleLastArgs = args
                end
            end
            return old(self, ...)
        end
        setreadonly(mt, true)
    end
end)

Tabs.FuncTab:Toggle({
    Title = "无敌QTE",
    Desc = "开启功能后需要点一下qte键，比如斧头、电锯的qte按键",
    Value = false,
    Callback = function(state)
        pcall(function()
            if state then
                invincibleCapturing = true
                invincibleLastArgs = nil
                if invincibleLoop then
                    invincibleLoop:Disconnect()
                    invincibleLoop = nil
                end
                invincibleLoop = RS.Heartbeat:Connect(function(dt)
                    pcall(function()
                        if not InvincibleInteract or not InvincibleInteract.Parent then
                            refreshInvincibleInteract()
                        end
                        if InvincibleInteract and invincibleLastArgs and (tick()   invincibleLastFire >= 1) then
                            invincibleLastFire = tick()
                            InvincibleInteract:FireServer(unpack(invincibleLastArgs))
                        end
                    end)
                end)
            else
                invincibleCapturing = false
                if invincibleLoop then
                    invincibleLoop:Disconnect()
                    invincibleLoop = nil
                end
            end
        end)
    end,
})

                                                                      
   新功能：让Chain一直减速（十字架持续释放）
                                                                      
local SlowChain = {}
SlowChain.Players = P
SlowChain.RunService = RS
SlowChain.LocalPlayer = lp
SlowChain.Interact = nil
SlowChain.capturingInteract = false
SlowChain.LastInteractArgs = nil
SlowChain.loop = nil
SlowChain.lastFire = 0

function SlowChain.refreshInteract()
    pcall(function()
        local char = SlowChain.LocalPlayer.Character
        if not char then return end
        local ch = char:FindFirstChild("CharacterHandler")
        if ch then
            local contents = ch:FindFirstChild("Contents")
            if contents then
                local remotes = contents:FindFirstChild("Remotes")
                if remotes then
                    SlowChain.Interact = remotes:FindFirstChild("Interact")
                end
            end
        end
    end)
end

SlowChain.LocalPlayer.CharacterAdded:Connect(function()
    pcall(function()
        task.wait(1)
        SlowChain.refreshInteract()
        SlowChain.LastInteractArgs = nil
    end)
end)

SlowChain.refreshInteract()

pcall(function()
    local mt = getrawmetatable(game)
    if mt then
        local old = mt.__namecall
        setreadonly(mt, false)
        mt.__namecall = function(self, ...)
            local method = getnamecallmethod()
            if method == "FireServer" and self == SlowChain.Interact then
                local args = {...}
                if SlowChain.capturingInteract and not SlowChain.LastInteractArgs then
                    SlowChain.LastInteractArgs = args
                end
            end
            return old(self, ...)
        end
        setreadonly(mt, true)
    end
end)

Tabs.FuncTab:Toggle({
    Title = "让Chain一直减速",
    Desc = "开启功能后需要用一次十字架(开启这个功能就不要开自动挥刀滥用)",
    Value = false,
    Callback = function(state)
        pcall(function()
            if state then
                SlowChain.capturingInteract = true
                SlowChain.LastInteractArgs = nil
                if SlowChain.loop then
                    SlowChain.loop:Disconnect()
                    SlowChain.loop = nil
                end
                SlowChain.loop = SlowChain.RunService.Heartbeat:Connect(function()
                    pcall(function()
                        if not SlowChain.Interact or not SlowChain.Interact.Parent then
                            SlowChain.refreshInteract()
                        end
                        if SlowChain.Interact and SlowChain.LastInteractArgs and (tick()   SlowChain.lastFire >= 1) then
                            SlowChain.lastFire = tick()
                            SlowChain.Interact:FireServer(unpack(SlowChain.LastInteractArgs))
                        end
                    end)
                end)
            else
                SlowChain.capturingInteract = false
                if SlowChain.loop then
                    SlowChain.loop:Disconnect()
                    SlowChain.loop = nil
                end
            end
        end)
    end,
})

                                                                      
   新功能：秒封印（SpellBook自动完成）
                                                                      
local autoSealEnabled = false
local sealInteractRemote
pcall(function()
    local char = lp.Character or lp.CharacterAdded:Wait()
    sealInteractRemote = char:WaitForChild("CharacterHandler"):WaitForChild("Contents"):WaitForChild("Remotes"):WaitForChild("Interact")
end)

lp.CharacterAdded:Connect(function()
    pcall(function()
        task.wait(1)
        pcall(function()
            sealInteractRemote = lp.Character:WaitForChild("CharacterHandler"):WaitForChild("Contents"):WaitForChild("Remotes"):WaitForChild("Interact")
        end)
    end)
end)

pcall(function()
    local mt = getrawmetatable(game)
    if mt then
        local oldNamecall = mt.__namecall
        setreadonly(mt, false)
        mt.__namecall = newcclosure(function(self, ...)
            local method = getnamecallmethod()
            local args = {...}
            if autoSealEnabled and self == sealInteractRemote and (method == "FireServer" or method == "fireServer") then
                if args[1] == "SpellBookBegin" then
                    local currentId = args[3]
                    task.spawn(function()
                        pcall(function()
                            sealInteractRemote:FireServer("SpellBookSuccess", nil, currentId)
                        end)
                    end)
                end
            end
            return oldNamecall(self, ...)
        end)
        setreadonly(mt, true)
    end
end)

Tabs.FuncTab:Toggle({
    Title = "秒封印",
    Value = false,
    Callback = function(state)
        pcall(function()
            autoSealEnabled = state
        end)
    end,
})

                                                                      
   新功能：枪械光环（InflictTarget循环）
                                                                      
local InflictConfig = {
    Players = P,
    InflictTarget = nil,
    capturing = false,
    capturedArgs = nil,
    isLooping = false,
    WEAPONS = {"AK47", "DesertEagle", "DoubleBarrel"},
    mt = nil,
    old = nil
}
InflictConfig.LocalPlayer = lp

local InflictFuncs = {}
InflictFuncs.getWeaponFolder = function()
    local char = W:FindFirstChild(InflictConfig.LocalPlayer.Name)
    if not char then return nil end
    for _, name in ipairs({"STRG_", "STRG"}) do
        local f = char:FindFirstChild(name)
        if f then return f end
    end
    return nil
end

InflictFuncs.hasWeaponEquipped = function()
    local folder = InflictFuncs.getWeaponFolder()
    if not folder then return false end
    for _, weaponName in ipairs(InflictConfig.WEAPONS) do
        if folder:FindFirstChild(weaponName) then
            return true
        end
    end
    return false
end

InflictFuncs.refreshRemote = function()
    pcall(function()
        local remote = game:GetService("ReplicatedStorage"):WaitForChild("GameStuff"):WaitForChild("Remotes"):WaitForChild("InflictTarget")
        InflictConfig.InflictTarget = remote
    end)
end

lp.CharacterAdded:Connect(function()
    pcall(function()
        task.wait(1)
        InflictFuncs.refreshRemote()
        InflictConfig.capturedArgs = nil
    end)
end)

InflictFuncs.refreshRemote()

pcall(function()
    local mt = getrawmetatable(game)
    if mt then
        InflictConfig.old = mt.__namecall
        setreadonly(mt, false)
        mt.__namecall = function(self, ...)
            local args = {...}
            local method = getnamecallmethod()
            if method == "InvokeServer" and self == InflictConfig.InflictTarget then
                if InflictConfig.capturing then
                    InflictConfig.capturedArgs = args
                end
            end
            return InflictConfig.old(self, unpack(args))
        end
        setreadonly(mt, true)
    end
end)

Tabs.FuncTab:Toggle({
    Title = "枪械光环",
    Value = false,
    Callback = function(state)
        pcall(function()
            InflictConfig.capturing = state
            if state then
                InflictConfig.capturedArgs = nil
                InflictConfig.isLooping = true
                task.spawn(function()
                    local wasSending = false
                    while InflictConfig.isLooping do
                        pcall(function()
                            if not InflictConfig.InflictTarget or not InflictConfig.InflictTarget.Parent then
                                InflictFuncs.refreshRemote()
                            end
                            local equipped = InflictFuncs.hasWeaponEquipped()
                            if InflictConfig.InflictTarget and InflictConfig.capturedArgs and equipped then
                                wasSending = true
                                task.spawn(function()
                                    pcall(function()
                                        InflictConfig.InflictTarget:InvokeServer(unpack(InflictConfig.capturedArgs))
                                    end)
                                end)
                                task.wait(0.1)
                            else
                                if wasSending and not equipped then
                                    wasSending = false
                                    InflictConfig.capturedArgs = nil
                                end
                                task.wait()
                            end
                        end)
                    end
                end)
            else
                InflictConfig.isLooping = false
                InflictConfig.capturedArgs = nil
            end
        end)
    end,
})

                                                                      
   新功能：给予物品系统
                                                                      
local GiveItem = {}
GiveItem.Players = P
GiveItem.VirtualInputManager = game:GetService("VirtualInputManager")
GiveItem.LocalPlayer = lp
GiveItem.autoCrucifixEnabled = false
GiveItem.slotIds = { "1","2","3","4","5","6","7","8","9","0" }
GiveItem.keyMap = {
    ["1"] = Enum.KeyCode.One, ["2"] = Enum.KeyCode.Two, ["3"] = Enum.KeyCode.Three,
    ["4"] = Enum.KeyCode.Four, ["5"] = Enum.KeyCode.Five, ["6"] = Enum.KeyCode.Six,
    ["7"] = Enum.KeyCode.Seven, ["8"] = Enum.KeyCode.Eight, ["9"] = Enum.KeyCode.Nine,
    ["0"] = Enum.KeyCode.Zero
}

function GiveItem.getInventory()
    local pg = GiveItem.LocalPlayer:FindFirstChild("PlayerGui")
    if not pg then return nil end
    local ig = pg:FindFirstChild("Ingame")
    if not ig then return nil end
    return ig:FindFirstChild("Inventory")
end

function GiveItem.equipSlot(slotName)
    pcall(function()
        local key = GiveItem.keyMap[slotName]
        if key then
            GiveItem.VirtualInputManager:SendKeyEvent(true, key, false, game)
            task.wait(0.05)
            GiveItem.VirtualInputManager:SendKeyEvent(false, key, false, game)
        end
    end)
end

function GiveItem.isSlotValid(slot)
    if not slot then return false end
    local v = slot:FindFirstChild("Values")
    if not v then return false end
    local n = v:FindFirstChild("ItemName")
    if not n or n.Value == "" then return false end
    local count = v:FindFirstChild("Count")
    if count and count.Value <= 0 then return false end
    return true
end

function GiveItem.findItemSlot(inventory, itemName)
    for _, slotName in ipairs(GiveItem.slotIds) do
        local slot = inventory:FindFirstChild(slotName)
        if slot and GiveItem.isSlotValid(slot) then
            local v = slot:FindFirstChild("Values")
            local n = v and v:FindFirstChild("ItemName")
            if n and n.Value == itemName then
                return slotName
            end
        end
    end
    return nil
end

function GiveItem.findEmptySlot(inventory)
    for _, slotName in ipairs(GiveItem.slotIds) do
        local slot = inventory:FindFirstChild(slotName)
        if not slot or not GiveItem.isSlotValid(slot) then
            return slotName
        end
    end
    return nil
end

function GiveItem.giveItem(itemName, itemImage)
    pcall(function()
        local inventory = GiveItem.getInventory()
        if not inventory then return end
        local existing = GiveItem.findItemSlot(inventory, itemName)
        if existing then
            GiveItem.equipSlot(existing)
            WindUI:Notify({
                Title = "物品提示",
                Content = itemName .. " 已在背包中!",
                Duration = 3,
                Icon = "info"
            })
            return
        end
        local emptySlot = GiveItem.findEmptySlot(inventory)
        if not emptySlot then
            WindUI:Notify({
                Title = "物品提示",
                Content = "背包已满，无空余槽位!",
                Duration = 3,
                Icon = "xmark"
            })
            return
        end
        local template = nil
        for _, slotName in ipairs(GiveItem.slotIds) do
            local slot = inventory:FindFirstChild(slotName)
            if slot and GiveItem.isSlotValid(slot) then
                template = slot:Clone()
                break
            end
        end
        if not template then
            WindUI:Notify({
                Title = "物品提示",
                Content = "物品给予失败! 请先获得至少一个物品",
                Duration = 3,
                Icon = "xmark"
            })
            return
        end
        local existing_slot = inventory:FindFirstChild(emptySlot)
        if existing_slot then
            existing_slot:Destroy()
        end
        template.Parent = inventory
        template.Name = emptySlot
        template.Values.ItemName.Value = itemName
        template.Icon.Image = itemImage
        template.Number.Text = emptySlot
        task.wait(0.1)
        GiveItem.equipSlot(emptySlot)
        WindUI:Notify({
            Title = "物品提示",
            Content = itemName .. " 已添加到背包!",
            Duration = 3,
            Icon = "check circle"
        })
    end)
end

   给予物品 Section
Tabs.FuncTab:Section({Title = "给予物品", TextXAlignment = "Left", TextSize = 18})
Tabs.FuncTab:Paragraph({
    Title = "注意事项",
    Desc = "你需要拥有一个物品才能给你物品(任何物品都可以) ‖ 由于chain自身的问题，手机端用给予物品时会不能移动，要过个5秒才能正常移动，电脑端一切正常，所以用给予物品时要离chain远一点，不然几秒钟给你骨灰扬了(如果不介意的话你也可以用键盘脚本来控制移动)",
    Image = "triangle alert",
    Color = "White",
    ImageSize = 40,
    ThumbnailSize = 120
})

Tabs.FuncTab:Button({
    Title = "给十字架",
    Callback = function()
        pcall(function() GiveItem.giveItem("Crucifix", "rbxassetid://15903361925") end)
    end,
})

Tabs.FuncTab:Button({
    Title = "给双喷",
    Callback = function()
        pcall(function() GiveItem.giveItem("DoubleBarrel", "rbxassetid://16190395023") end)
    end,
})

Tabs.FuncTab:Button({
    Title = "给魔法书",
    Callback = function()
        pcall(function() GiveItem.giveItem("SpellBook", "rbxassetid://15410543290") end)
    end,
})

Tabs.FuncTab:Button({
    Title = "给AK47",
    Callback = function()
        pcall(function() GiveItem.giveItem("AK47", "rbxassetid://17812936812") end)
    end,
})

Tabs.FuncTab:Toggle({
    Title = "自动给与十字架",
    Default = false,
    Callback = function(Value)
        pcall(function()
            GiveItem.autoCrucifixEnabled = Value
        end)
    end,
})

task.spawn(function()
    while true do
        pcall(function()
            task.wait(0.5)
            if GiveItem.autoCrucifixEnabled then
                local inventory = GiveItem.getInventory()
                if inventory then
                    local found = GiveItem.findItemSlot(inventory, "Crucifix")
                    if not found then
                        GiveItem.giveItem("Crucifix", "rbxassetid://15903361925")
                    end
                end
            end
        end)
    end
end)

local GiveDeagle = {}
GiveDeagle.Players = P
GiveDeagle.VirtualInputManager = game:GetService("VirtualInputManager")
GiveDeagle.LocalPlayer = lp
GiveDeagle.targetItem = "Deagle"
GiveDeagle.targetID = "rbxassetid://15410404828"
GiveDeagle.slotIds = { "1","2","3","4","5","6","7","8","9","0" }
GiveDeagle.keyMap = { ["1"]=Enum.KeyCode.One, ["2"]=Enum.KeyCode.Two, ["3"]=Enum.KeyCode.Three, ["4"]=Enum.KeyCode.Four, ["5"]=Enum.KeyCode.Five, ["6"]=Enum.KeyCode.Six, ["7"]=Enum.KeyCode.Seven, ["8"]=Enum.KeyCode.Eight, ["9"]=Enum.KeyCode.Nine, ["0"]=Enum.KeyCode.Zero }

function GiveDeagle.getInventory()
    local pg = GiveDeagle.LocalPlayer:FindFirstChild("PlayerGui")
    if not pg then return nil end
    local ig = pg:FindFirstChild("Ingame")
    if not ig then return nil end
    return ig:FindFirstChild("Inventory")
end

function GiveDeagle.equipSlot(slotName)
    pcall(function()
        local key = GiveDeagle.keyMap[slotName]
        if key then
            GiveDeagle.VirtualInputManager:SendKeyEvent(true, key, false, game)
            task.wait(0.05)
            GiveDeagle.VirtualInputManager:SendKeyEvent(false, key, false, game)
        end
    end)
end

function GiveDeagle.isSlotValid(slot)
    if not slot or not slot:FindFirstChild("Values") or not slot.Values:FindFirstChild("ItemName") then return false end
    if slot.Values.ItemName.Value == "" then return false end
    return true
end

function GiveDeagle.findItemSlot(inventory, itemName)
    for _, slotName in ipairs(GiveDeagle.slotIds) do
        local slot = inventory:FindFirstChild(slotName)
        if slot and GiveDeagle.isSlotValid(slot) and slot.Values.ItemName.Value == itemName then
            return slotName
        end
    end
    return nil
end

function GiveDeagle.findEmptySlot(inventory)
    for _, slotName in ipairs(GiveDeagle.slotIds) do
        local slot = inventory:FindFirstChild(slotName)
        if not slot or not GiveDeagle.isSlotValid(slot) then return slotName end
    end
    return nil
end

function GiveDeagle.giveItem()
    pcall(function()
        local inventory = GiveDeagle.getInventory()
        if not inventory then return end
        if GiveDeagle.findItemSlot(inventory, GiveDeagle.targetItem) then return end
        local emptySlot = GiveDeagle.findEmptySlot(inventory)
        local template = nil
        for _, slotName in ipairs(GiveDeagle.slotIds) do
            local s = inventory:FindFirstChild(slotName)
            if s and GiveDeagle.isSlotValid(s) then template = s:Clone(); break end
        end
        if template and emptySlot then
            local old = inventory:FindFirstChild(emptySlot)
            if old then old:Destroy() end
            template.Parent = inventory
            template.Name = emptySlot
            template.Values.ItemName.Value = GiveDeagle.targetItem
            template.Icon.Image = GiveDeagle.targetID
            template.Number.Text = emptySlot
            GiveDeagle.equipSlot(emptySlot)
        end
    end)
end

Tabs.FuncTab:Button({
    Title = "给与沙鹰",
    Callback = function()
        pcall(function() GiveDeagle.giveItem() end)
    end,
})

Tabs.FuncTab:Toggle({
    Title = "第三人称",
    Value = false,
    Callback = function(v)
        State.ThirdPerson = v
        tp3.Active = v
        if v then
            enforceThirdPerson()
        else
            pcall(function()
                lp.CameraMode = Enum.CameraMode.LockFirstPerson
            end)
            if tp3.Conn then tp3.Conn:Disconnect(); tp3.Conn = nil end
        end
    end,
})

Tabs.FuncTab:Toggle({
    Title = "穿墙",
    Desc = "已失效后续修复",
    Value = false,
    Callback = function(v)
        State.Noclip = v
        Noclip()
        WindUI:Notify({
            Title = "穿墙",
            Content = v and "已开启" or "已关闭",
            Duration = 3,
            Icon = v and "check circle" or "xmark"
        })
    end,
})

Tabs.FuncTab:Section({ Title = "Chain 预警" })

Tabs.FuncTab:Toggle({
    Title = "启用 Chain 预警",
    Value = false,
    Callback = function(v)
        State.ChainAlert = v
        cAlert.Active = v
        setupChainAlert()
    end,
})

Tabs.FuncTab:Toggle({
    Title = "自动躲避",
    Desc = "有致命bug，无论多远都会传送，请勿常开",
    Value = false,
    Callback = function(v)
        if State.PseudoGod and v then
            WindUI:Notify({
                Title = "无法开启",
                Content = "伪无敌期间无法使用自动躲避",
                Duration = 3,
                Icon = "alert triangle"
            })
            return
        end
        State.ChainDodge = v
        cAlert.Dodge = v
        WindUI:Notify({
            Title = "自动躲避",
            Content = v and "已开启" or "已关闭",
            Duration = 4,
            Icon = v and "alert triangle" or "xmark"
        })
    end,
})

Tabs.FuncTab:Toggle({
    Title = "显示光环",
    Value = true,
    Callback = function(v)
        State.ChainRing = v
        cAlert.ShowRing = v
        setupChainAlert()
    end,
})

Tabs.FuncTab:Toggle({
    Title = "旋转光环",
    Value = true,
    Callback = function(v)
        State.ChainRotate = v
        cAlert.RingRotating = v
    end,
})

Tabs.FuncTab:Slider({
    Title = "预警范围大小",
    Value = {
        Min = 30,
        Max = 100,
        Default = 55
    },
    Callback = function(v)
        State.ChainRingRadius = v
        cAlert.RingRadius = v
        setupChainAlert()
    end,
})

local RemoteSection = Tabs.RemoteTab:Section({
    Title = "远程UI & 快捷键",
    Opened = true
})

RemoteSection:Toggle({
    Title = "商店界面",
    Value = false,
    Callback = function(v)
        if v and not isDaytime() then
            WindUI:Notify({
                Title = "无法开启",
                Content = "商店只能在白天打开",
                Duration = 2,
                Icon = "xmark"
            })
            return
        end
        SetRemoteGui("Shop", v)
    end,
})

RemoteSection:Paragraph({
    Title = "警告",
    Desc = "黑夜不能买商店物品，否则会被踢出游戏",
    Color = "Red"
})

RemoteSection:Keybind({
    Title = "商店快捷键",
    Value = Enum.KeyCode.V,
    Callback = function(v)
        if v and not isDaytime() then
            WindUI:Notify({
                Title = "无法开启",
                Content = "商店只能在白天打开",
                Duration = 2,
                Icon = "xmark"
            })
            return
        end
        SetRemoteGui("Shop", v)
    end,
})

RemoteSection:Toggle({
    Title = "分解机界面",
    Value = false,
    Callback = function(v)
        SetRemoteGui("Deconstructor", v)
    end,
})

RemoteSection:Paragraph({
    Title = "警告",
    Desc = "会吃材料请前往工作间",
    Color = "Red"
})

RemoteSection:Keybind({
    Title = "分解机快捷键",
    Value = Enum.KeyCode.B,
    Callback = function(v)
        SetRemoteGui("Deconstructor", v)
    end,
})

RemoteSection:Toggle({
    Title = "工作台界面",
    Value = false,
    Callback = function(v)
        SetRemoteGui("Workbench", v)
    end,
})

RemoteSection:Paragraph({
    Title = "警告",
    Desc = "会吃材料请前往工作间",
    Color = "Red"
})

RemoteSection:Keybind({
    Title = "工作台快捷键",
    Value = Enum.KeyCode.N,
    Callback = function(v)
        SetRemoteGui("Workbench", v)
    end,
})

RemoteSection:Section({ Title = "伪无敌快捷键" })

RemoteSection:Keybind({
    Title = "伪无敌快捷键",
    Value = Enum.KeyCode.F4,
    Callback = function(v)
        doPseudoGod(not State.PseudoGod)
    end,
})

RemoteSection:Section({ Title = "无限子弹快捷键" })

RemoteSection:Keybind({
    Title = "无限子弹快捷键",
    Value = Enum.KeyCode.F5,
    Callback = function(v)
        State.InfAmmo = not State.InfAmmo
        toggleInfAmmo()
        WindUI:Notify({
            Title = "无限弹药",
            Content = State.InfAmmo and "已开启" or "已关闭",
            Duration = 2,
            Icon = State.InfAmmo and "check" or "xmark"
        })
        if InfAmmoToggle then
            InfAmmoToggle:SetValue(State.InfAmmo)
        end
    end,
})

RemoteSection:Section({ Title = "特殊功能" })

local bypassAK_original = nil
RemoteSection:Toggle({
    Title = "绕过AK购买徽章",
    Value = false,
    Callback = function(v)
        if v then
            task.spawn(function()
                local BadgeService = game:GetService("BadgeService")
                   【修复10】安全检测 hookfunction
                if type(hookfunction) == "function" then
                    bypassAK_original = BadgeService.UserHasBadgeAsync
                    hookfunction(BadgeService.UserHasBadgeAsync, function(self, userId, badgeId)
                        if badgeId == 1224768178420330 then
                            return true
                        end
                        return bypassAK_original(self, userId, badgeId)
                    end)
                    WindUI:Notify({
                        Title = "绕过成功",
                        Content = "AK47购买徽章已绕过",
                        Duration = 10,
                        Icon = "check circle"
                    })
                else
                    WindUI:Notify({
                        Title = "绕过失败",
                        Content = "当前环境不支持 hookfunction",
                        Duration = 3,
                        Icon = "xmark"
                    })
                end
            end)
        else
            if bypassAK_original and type(hookfunction) == "function" then
                hookfunction(game:GetService("BadgeService").UserHasBadgeAsync, bypassAK_original)
                bypassAK_original = nil
                WindUI:Notify({
                    Title = "绕过关闭",
                    Content = "AK购买徽章绕过已关闭",
                    Duration = 3,
                    Icon = "xmark"
                })
            end
        end
    end,
})
         
local themes = WindUI:GetThemes()
local themeValues = {}
for name in pairs(themes) do table.insert(themeValues, name) end

Tabs.SettingsTab:Dropdown({
    Title = "选择主题",
    Multi = false,
    AllowNone = false,
    Value = WindUI:GetCurrentTheme(),
    Values = themeValues,
    Callback = function(theme)
        WindUI:SetTheme(theme)
    end,
})

Tabs.SettingsTab:Toggle({
    Title = "窗口透明",
    Value = WindUI:GetTransparency(),
    Callback = function(v)
        Window:ToggleTransparency(v)
    end,
})
      
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

    if type(getconnections) == "function" then
        local conns = getconnections(interact.OnClientEvent)
        if conns and #conns > 0 then
            local origConn = conns[1]
            origSyncFunc = origConn.Function
            origConn:Disable()

            local newConn = interact.OnClientEvent:Connect(function(action, gunName, ammoData)
                if infAmmoActive and action == "Sync" and gunMax[gunName] then
                    ammoData = {gunMax[gunName], 999}
                end
                if origSyncFunc then
                    pcall(origSyncFunc, action, gunName, ammoData)
                end
            end)
            table.insert(ammoConns, newConn)
        end
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
                    for gName, maxAmmo in pairs(gunMax) do
                        local g = items:FindFirstChild(gName)
                        if g and g:GetAttribute("Equipped") then
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

toggleInfAmmo = function()
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

lp.CharacterAdded:Connect(function()
      
    for _, c in ipairs(ammoConns) do pcall(function() c:Disconnect() end) end
    ammoConns = {}

    if infAmmoActive then
        task.wait(1)
        setupAmmoHooks()
    end
    if State.NoRecoil then
        task.wait(1)
        hookRecoil()
    end
    if speedData.Active then
        task.wait(0.5)
        startSpeedBoost()
    end
end)

task.spawn(function()
    while true do
        task.wait(0.1)
        if State.InfStamina and lp.Character then
            pcall(function()
                local stats = lp.Character:FindFirstChild("Stats")
                if stats then stats.Stamina.Value = 100 end
            end)
        end
    end
end)

task.spawn(function()
    while true do
        task.wait(0.1)
        if State.InfCombatStamina and lp.Character then
            pcall(function()
                local stats = lp.Character:FindFirstChild("Stats")
                if stats then stats.CombatStamina.Value = 100 end
            end)
        end
    end
end)

task.spawn(function()
    while true do
        task.wait(0.1)
        if State.InfGas and lp.Character then
            pcall(function()
                local XSaw = lp.Character:FindFirstChild("Items") and lp.Character.Items:FindFirstChild("XSaw")
                if XSaw then
                    XSaw:SetAttribute("Gas", 100)
                end
            end)
        end
    end
end)

task.spawn(function()
    while true do
        task.wait(0.005)
        if State.WinClash and lp.Character then
            pcall(function()
                local stats = lp.Character:FindFirstChild("Stats")
                if stats then stats.ClashStrength.Value = 100 end
            end)
        end
    end
end)

task.spawn(function()
    while true do
        task.wait(0.03)
        if State.FaceChain then
            pcall(function()
                local nearest, nearDist = nil, math.huge
                for _, chain in ipairs(aiFolder:GetChildren()) do
                    if chain:IsA("Model") then
                        local cHRP = chain:FindFirstChild("HumanoidRootPart")
                        local cHum = chain:FindFirstChild("Humanoid")
                        if cHRP and cHum and cHum.Health > 0 then
                            local dist = (Cam.CFrame.Position   cHRP.Position).Magnitude
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
  
WindUI:Notify({
    Title = "ChainXK已加载",
    Content = "欢迎使用XK Chain V3.0",
    Duration = 5,
    Icon = "check circle",
})

print ("欢迎使用")