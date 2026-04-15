local Fatality = loadstring(game:HttpGet("https://raw.githubusercontent.com/4lpaca-pin/Fatality/refs/heads/main/src/source.luau"))();

Fatality:Loader({Name = "NASVAI", Duration = 2});

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")

local Settings = {
    ESP = {Enabled = true, Box = true, Health = true, Name = true, Distance = false, MaxDistance = 1000, TeamCheck = true},
    Aim = {Enabled = true, TeamCheck = true, VisibleCheck = true, AliveCheck = true, LockPart = "Head", FOV = 90, ShowFOV = true, AutoFire = true}
}

local Highlights = {}

local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1
FOVCircle.NumSides = 60
FOVCircle.Transparency = 0.5
FOVCircle.Filled = false

local function IsSameTeam(p)
    return p.Team == LocalPlayer.Team
end

local function IsVisible(p)
    if not p.Character then return false end
    local localChar = LocalPlayer.Character
    if not localChar then return false end
    
    local myRoot = localChar:FindFirstChild("HumanoidRootPart")
    local theirRoot = p.Character:FindFirstChild("HumanoidRootPart")
    if not myRoot or not theirRoot then return false end
    
    local direction = (theirRoot.Position - myRoot.Position).Unit
    local ray = workspace:Raycast(myRoot.Position, direction * 1000)
    if ray and ray.Instance then
        local hitPart = ray.Instance
        local ancestor = hitPart:FindFirstAncestorOfClass("Model")
        if ancestor and ancestor == p.Character then
            return true
        end
    end
    return false
end

local function GetClosest()
    local closest = nil
    local closestDist = Settings.Aim.FOV
    local mousePos = UserInputService:GetMouseLocation()
    
    local playersList = Players:GetPlayers()
    for i = 1, #playersList do
        local p = playersList[i]
        if p ~= LocalPlayer and p.Character then
            local sameTeam = IsSameTeam(p)
            if Settings.Aim.TeamCheck == false or sameTeam == false then
                local part = p.Character:FindFirstChild(Settings.Aim.LockPart)
                if part then
                    if Settings.Aim.VisibleCheck and not IsVisible(p) then
                    else
                        local screenPos = Camera:WorldToViewportPoint(part.Position)
                        if screenPos.Z > 0 then
                            local dist = math.sqrt((screenPos.X - mousePos.X)^2 + (screenPos.Y - mousePos.Y)^2)
                            if dist < closestDist then
                                closestDist = dist
                                closest = p
                            end
                        end
                    end
                end
            end
        end
    end
    return closest
end

local function CreateESP(p)
    if Highlights[p] then return end
    
    local highlight = Instance.new("Highlight")
    highlight.Name = p.Name .. "_ESP"
    highlight.Adornee = nil
    highlight.FillColor = Color3.fromRGB(255, 0, 0)
    highlight.OutlineColor = Color3.new(0, 0, 0)
    highlight.FillTransparency = 0.6
    highlight.OutlineTransparency = 0
    highlight.Parent = game.CoreGui
    
    local box = Drawing.new("Square")
    box.Thickness = 1
    box.Color = Color3.fromRGB(255, 0, 0)
    box.Filled = false
    box.Visible = false
    
    local outline = Drawing.new("Square")
    outline.Thickness = 3
    outline.Color = Color3.new(0, 0, 0)
    outline.Filled = false
    outline.Visible = false
    
    local nameTag = Drawing.new("Text")
    nameTag.Size = 18
    nameTag.Color = Color3.new(1, 1, 1)
    nameTag.Outline = true
    nameTag.Center = true
    nameTag.Visible = false
    
    local healthBg = Drawing.new("Square")
    healthBg.Thickness = 1
    healthBg.Color = Color3.new(0.2, 0.2, 0.2)
    healthBg.Filled = true
    healthBg.Visible = false
    
    local healthBar = Drawing.new("Square")
    healthBar.Thickness = 1
    healthBar.Color = Color3.new(0, 1, 0)
    healthBar.Filled = true
    healthBar.Visible = false
    
    local distanceText = Drawing.new("Text")
    distanceText.Size = 12
    distanceText.Color = Color3.new(0.7, 0.7, 0.7)
    distanceText.Outline = true
    distanceText.Center = true
    distanceText.Visible = false
    
    Highlights[p] = {
        Highlight = highlight,
        Box = box,
        Outline = outline,
        Name = nameTag,
        HealthBg = healthBg,
        Health = healthBar,
        Distance = distanceText
    }
end

local function RemoveESP(p)
    if Highlights[p] then
        local d = Highlights[p]
        pcall(function() d.Highlight:Destroy() end)
        pcall(function() d.Box:Remove() end)
        pcall(function() d.Outline:Remove() end)
        pcall(function() d.Name:Remove() end)
        pcall(function() d.HealthBg:Remove() end)
        pcall(function() d.Health:Remove() end)
        pcall(function() d.Distance:Remove() end)
        Highlights[p] = nil
    end
end

local function Update()
    local target = nil
    
    if Settings.Aim.Enabled then
        target = GetClosest()
        if target and target.Character then
            local part = target.Character:FindFirstChild(Settings.Aim.LockPart)
            if part then
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, part.Position)
                
                if Settings.Aim.AutoFire then
                    local vm = LocalPlayer:FindFirstChild("PlayerScripts")
                    if vm then vm = vm:FindFirstChild("States") end
                    if vm then vm = vm:FindFirstChild("Attack") end
                    if vm and vm.Fire then vm:Fire() end
                end
            end
        end
        if target then
            FOVCircle.Color = Color3.fromRGB(255, 70, 70)
        else
            FOVCircle.Color = Color3.fromRGB(255, 255, 255)
        end
    else
        FOVCircle.Color = Color3.fromRGB(255, 255, 255)
    end
    
    FOVCircle.Visible = Settings.Aim.ShowFOV
    FOVCircle.Radius = Settings.Aim.FOV
    FOVCircle.Position = UserInputService:GetMouseLocation()
    
    local playersList = Players:GetPlayers()
    for i = 1, #playersList do
        local player = playersList[i]
        local data = Highlights[player]
        
        if data then
            if player == LocalPlayer then
                data.Highlight.Adornee = nil
                data.Box.Visible = false
                data.Outline.Visible = false
                data.Name.Visible = false
                data.HealthBg.Visible = false
                data.Health.Visible = false
                data.Distance.Visible = false
            else
                local sameTeam = IsSameTeam(player)
                if Settings.ESP.TeamCheck and sameTeam then
                    data.Highlight.Adornee = nil
                    data.Box.Visible = false
                    data.Outline.Visible = false
                    data.Name.Visible = false
                    data.HealthBg.Visible = false
                    data.Health.Visible = false
                    data.Distance.Visible = false
                else
                    local char = player.Character
                    if char then
                        local hrp = char:FindFirstChild("HumanoidRootPart")
                        local head = char:FindFirstChild("Head")
                        local humanoid = char:FindFirstChild("Humanoid")
                        
                        if hrp and head then
                            local localChar = LocalPlayer.Character
                            if localChar and localChar:FindFirstChild("HumanoidRootPart") then
                                local dist = (hrp.Position - localChar.HumanoidRootPart.Position).Magnitude
                                
                                if Settings.ESP.Enabled and dist <= Settings.ESP.MaxDistance then
                                    local rootPos = Camera:WorldToViewportPoint(hrp.Position)
                                    local headPos = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0))
                                    local legPos = Camera:WorldToViewportPoint(hrp.Position - Vector3.new(0, 3.5, 0))
                                    
                                    if rootPos.Z > 0 then
                                        local height = math.abs(headPos.Y - legPos.Y)
                                        local width = height / 2
                                        
                                        if width < 10 then width = 10 end
                                        if height < 20 then height = 20 end
                                        
                                        local x = rootPos.X - width / 2
                                        local y = rootPos.Y - height / 2
                                        
                                        data.Highlight.Adornee = char
                                        
                                        if Settings.ESP.Box then
                                            data.Box.Size = Vector2.new(width, height)
                                            data.Box.Position = Vector2.new(x, y)
                                            data.Box.Color = target == player and Color3.new(1, 1, 0) or Color3.fromRGB(255, 0, 0)
                                            data.Box.Visible = true
                                            data.Outline.Size = Vector2.new(width, height)
                                            data.Outline.Position = Vector2.new(x, y)
                                            data.Outline.Visible = true
                                        else
                                            data.Box.Visible = false
                                            data.Outline.Visible = false
                                        end
                                        
                                        if Settings.ESP.Name then
                                            data.Name.Text = player.Name
                                            data.Name.Position = Vector2.new(rootPos.X, y - 20)
                                            data.Name.Visible = true
                                        else
                                            data.Name.Visible = false
                                        end
                                        
                                        if Settings.ESP.Health and humanoid then
                                            local maxHp = humanoid.MaxHealth
                                            local hp = humanoid.Health
                                            if maxHp <= 0 or maxHp > 10000 then maxHp = 100 end
                                            local pct = math.clamp(hp / maxHp, 0, 1)
                                            
                                            data.HealthBg.Size = Vector2.new(5, height)
                                            data.HealthBg.Position = Vector2.new(x - 9, y)
                                            data.HealthBg.Visible = true
                                            data.Health.Size = Vector2.new(5, height * pct)
                                            data.Health.Position = Vector2.new(x - 9, y + height - height * pct)
                                            data.Health.Visible = true
                                            
                                            data.Health.Color = pct > 0.5 and Color3.new(0, 1, 0) or pct > 0.25 and Color3.new(1, 1, 0) or Color3.new(1, 0, 0)
                                        else
                                            data.Health.Visible = false
                                            data.HealthBg.Visible = false
                                        end
                                        
                                        if Settings.ESP.Distance then
                                            data.Distance.Text = math.floor(dist) .. "m"
                                            data.Distance.Position = Vector2.new(rootPos.X, y + height + 5)
                                            data.Distance.Visible = true
                                        else
                                            data.Distance.Visible = false
                                        end
                                    else
                                        data.Highlight.Adornee = nil
                                        data.Box.Visible = false
                                        data.Outline.Visible = false
                                        data.Name.Visible = false
                                        data.HealthBg.Visible = false
                                        data.Health.Visible = false
                                        data.Distance.Visible = false
                                    end
                                else
                                    data.Highlight.Adornee = nil
                                    data.Box.Visible = false
                                    data.Outline.Visible = false
                                    data.Name.Visible = false
                                    data.HealthBg.Visible = false
                                    data.Health.Visible = false
                                    data.Distance.Visible = false
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end

local Window = Fatality.new({Name = "NASVAI", Expire = "never"})

local Visuals = Window:AddMenu({Name = "Visuals", Icon = "eye"})
local AimMenu = Window:AddMenu({Name = "Aim", Icon = "target"})

Visuals:AddSection({Position = "left", Name = "ESP"}):AddToggle({Name = "Enabled", Default = true, Callback = function(v) Settings.ESP.Enabled = v end})
Visuals:AddSection({Position = "left", Name = "ESP"}):AddToggle({Name = "Box", Default = true, Callback = function(v) Settings.ESP.Box = v end})
Visuals:AddSection({Position = "left", Name = "ESP"}):AddToggle({Name = "Health", Default = true, Callback = function(v) Settings.ESP.Health = v end})
Visuals:AddSection({Position = "left", Name = "ESP"}):AddToggle({Name = "Name", Default = true, Callback = function(v) Settings.ESP.Name = v end})
Visuals:AddSection({Position = "left", Name = "ESP"}):AddToggle({Name = "Distance", Default = false, Callback = function(v) Settings.ESP.Distance = v end})
Visuals:AddSection({Position = "right", Name = "Set"}):AddToggle({Name = "Team Check", Default = true, Callback = function(v) Settings.ESP.TeamCheck = v end})
Visuals:AddSection({Position = "right", Name = "Set"}):AddSlider({Name = "Max Distance", Default = 1000, Min = 50, Max = 2000, Callback = function(v) Settings.ESP.MaxDistance = v end})

AimMenu:AddSection({Position = "left", Name = "Aim"}):AddToggle({Name = "Enabled", Default = true, Callback = function(v) Settings.Aim.Enabled = v end})
AimMenu:AddSection({Position = "left", Name = "Aim"}):AddToggle({Name = "Team Check", Default = true, Callback = function(v) Settings.Aim.TeamCheck = v end})
AimMenu:AddSection({Position = "left", Name = "Aim"}):AddToggle({Name = "Visible Check", Default = true, Callback = function(v) Settings.Aim.VisibleCheck = v end})
AimMenu:AddSection({Position = "left", Name = "Aim"}):AddToggle({Name = "Alive Check", Default = true, Callback = function(v) Settings.Aim.AliveCheck = v end})
AimMenu:AddSection({Position = "left", Name = "Aim"}):AddDropdown({Name = "Lock Part", Default = "Head", Values = {"Head", "HumanoidRootPart", "Torso"}, Callback = function(v) Settings.Aim.LockPart = v end})
AimMenu:AddSection({Position = "right", Name = "FOV"}):AddToggle({Name = "Show", Default = true, Callback = function(v) Settings.Aim.ShowFOV = v end})
AimMenu:AddSection({Position = "right", Name = "FOV"}):AddSlider({Name = "Radius", Default = 90, Min = 20, Max = 300, Callback = function(v) Settings.Aim.FOV = v end})
AimMenu:AddSection({Position = "right", Name = "Action"}):AddToggle({Name = "Auto Fire", Default = true, Callback = function(v) Settings.Aim.AutoFire = v end})

local playersList = Players:GetPlayers()
for i = 1, #playersList do
    local p = playersList[i]
    if p ~= LocalPlayer then CreateESP(p) end
end

Players.PlayerAdded:Connect(function(p)
    if p ~= LocalPlayer then task.wait(1) CreateESP(p) end
end)
Players.PlayerRemoving:Connect(RemoveESP)

RunService.RenderStepped:Connect(Update)

warn("[NASVAI] Loaded!")
