local DripESP = {}
local connections = {}
local all_settings = {}
local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local rootPart = char:WaitForChild("HumanoidRootPart")

local ESPFolder = workspace:FindFirstChild("ESP_Objects")
if not ESPFolder then
    ESPFolder = Instance.new("Folder")
    ESPFolder.Name = "ESP_Objects"
    ESPFolder.Parent = workspace
end

function DripESP.SetOptions(ESP_ID, opts)
    all_settings[ESP_ID] = {
        TargetName = opts.TargetName or opts.ModelName or "Model",
        CustomText = opts.CustomText or "Target",
        TextColor = opts.TextColor or Color3.fromRGB(255, 255, 255),
        OutlineColor = opts.OutlineColor or Color3.fromRGB(0, 0, 0),
        FillColor = opts.FillColor or Color3.fromRGB(0, 0, 0),
        FillTransparency = opts.FillTransparency or 0.5,
        OutlineTransparency = opts.OutlineTransparency or 0,
        TextSize = opts.TextSize or 15,
        CheckForHumanoid = opts.CheckForHumanoid or false,
        TargetType = opts.TargetType or "Both",
        ParentFolder = opts.ParentFolder or workspace, 
        HighlightName = "ESP_Highlight_" .. ESP_ID,
        BillboardName = "ESP_Billboard_" .. ESP_ID,
    }
end

local function applyESP(target, ESP_ID, settings)
    local isValidType = (settings.TargetType == "Both") or
                      (settings.TargetType == "Model" and target:IsA("Model")) or
                      (settings.TargetType == "Part" and target:IsA("BasePart"))
    if not isValidType then return end
    if target.Name ~= settings.TargetName then return end
    if target:IsA("Model") and settings.CheckForHumanoid and not target:FindFirstChild("Humanoid") then return end

    local targetPart
    if target:IsA("Model") then
        targetPart = target:FindFirstChild("HumanoidRootPart") or
                     target:FindFirstChild("Torso") or
                     target:FindFirstChild("Head") or
                     target:FindFirstChildWhichIsA("BasePart")
    else
        targetPart = target
    end
    if not targetPart then return end

    local bbName = settings.BillboardName .. "_" .. target:GetDebugId()
    if not ESPFolder:FindFirstChild(bbName) then
        local billboard = Instance.new("BillboardGui")
        billboard.Name = bbName
        billboard.Parent = ESPFolder
        billboard.Adornee = targetPart
        billboard.Size = UDim2.new(0, 100, 0, 60) 
        billboard.StudsOffset = Vector3.new(0, 0, 0)
        billboard.AlwaysOnTop = true

        local container = Instance.new("Frame")
        container.Parent = billboard
        container.Size = UDim2.new(1, 0, 1, 0)
        container.BackgroundTransparency = 1
        
        local layout = Instance.new("UIListLayout")
        layout.Parent = container
        layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        layout.VerticalAlignment = Enum.VerticalAlignment.Center
        layout.SortOrder = Enum.SortOrder.LayoutOrder

        local label = Instance.new("TextLabel")
        label.Name = "ESP_Text"
        label.Parent = container
        label.Size = UDim2.new(1, 0, 0.5, 0)
        label.BackgroundTransparency = 1
        label.TextColor3 = settings.TextColor
        label.TextSize = settings.TextSize
        label.Font = Enum.Font.RobotoCondensed 
        label.Text = settings.CustomText
        label.TextYAlignment = Enum.TextYAlignment.Bottom
  
        local stroke = Instance.new("UIStroke")
        stroke.Parent = label
        stroke.Thickness = 1.3
        stroke.Color = Color3.new(0, 0, 0)

        local distanceLabel = Instance.new("TextLabel")
        distanceLabel.Name = "ESP_Distance"
        distanceLabel.Parent = container
        distanceLabel.Size = UDim2.new(1, 0, 0.5, 0)
        distanceLabel.BackgroundTransparency = 1
        distanceLabel.TextColor3 = settings.TextColor
        distanceLabel.TextSize = settings.TextSize - 2
        distanceLabel.Font = Enum.Font.RobotoCondensed 
        distanceLabel.TextYAlignment = Enum.TextYAlignment.Top
        distanceLabel.Text = "[0]"

        local distanceStroke = Instance.new("UIStroke")
        distanceStroke.Parent = distanceLabel
        distanceStroke.Thickness = 1.3
        distanceStroke.Color = Color3.new(0, 0, 0)

        coroutine.wrap(function()
            while billboard.Parent and targetPart.Parent do
                local playerRoot = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                if playerRoot then
                    local distance = (targetPart.Position - playerRoot.Position).Magnitude
                    distanceLabel.Text = string.format("[%d]", math.floor(distance))
                else
                    distanceLabel.Text = "[N/A]"
                end
                task.wait(0.2) 
            end
            billboard:Destroy()  
        end)()
    end

    local hlName = settings.HighlightName .. "_" .. target:GetDebugId()
    if not ESPFolder:FindFirstChild(hlName) then
        local highlight = Instance.new("Highlight")
        highlight.Name = hlName
        highlight.Parent = ESPFolder
        highlight.Adornee = target
        highlight.FillColor = settings.FillColor
        highlight.FillTransparency = settings.FillTransparency
        highlight.OutlineColor = settings.OutlineColor
        highlight.OutlineTransparency = settings.OutlineTransparency
    end
end

function DripESP.Enable(ESP_ID)
    local settings = all_settings[ESP_ID]
    if not settings then return end

    local function scanFolder(folder)
        for _, item in ipairs(folder:GetDescendants()) do
            if (item:IsA("Model") or item:IsA("BasePart")) and item.Name == settings.TargetName then
                applyESP(item, ESP_ID, settings)
            end
        end
    end

    if type(settings.ParentFolder) == "string" then
        settings.ParentFolder = workspace:FindFirstChild(settings.ParentFolder) or workspace
    end

    if type(settings.ParentFolder) == "table" then
        for _, folder in ipairs(settings.ParentFolder) do
            if typeof(folder) == "Instance" then
                scanFolder(folder)
            end
        end
    else
        scanFolder(settings.ParentFolder)
    end
    
    connections[ESP_ID] = {
        Added = settings.ParentFolder.DescendantAdded:Connect(function(v)
            if (v:IsA("Model") or v:IsA("BasePart")) and v.Name == settings.TargetName then
                task.wait(0.5)
                applyESP(v, ESP_ID, settings)
            end
        end),
        Removed = settings.ParentFolder.DescendantRemoving:Connect(function(v)
            if (v:IsA("Model") or v:IsA("BasePart")) and v.Name == settings.TargetName then
                local bbName = settings.BillboardName .. "_" .. v:GetDebugId()
                local hlName = settings.HighlightName .. "_" .. v:GetDebugId()
                if ESPFolder:FindFirstChild(bbName) then ESPFolder[bbName]:Destroy() end
                if ESPFolder:FindFirstChild(hlName) then ESPFolder[hlName]:Destroy() end
            end
        end)
    }
end

function DripESP.Disable(ESP_ID)
    local settings = all_settings[ESP_ID]
    if not settings then return end

    if connections[ESP_ID] then
        if connections[ESP_ID].Added then connections[ESP_ID].Added:Disconnect() end
        if connections[ESP_ID].Removed then connections[ESP_ID].Removed:Disconnect() end
        connections[ESP_ID] = nil
    end

    for _, item in ipairs(ESPFolder:GetChildren()) do
        if item.Name:match(settings.BillboardName) or item.Name:match(settings.HighlightName) then
            item:Destroy()
        end
    end

    all_settings[ESP_ID] = nil
end

return DripESP