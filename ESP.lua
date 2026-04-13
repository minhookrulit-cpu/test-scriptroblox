local RunService = game:GetService("RunService")

local PlayerService = game:GetService("Players")
local LocalPlayer = PlayerService.LocalPlayer

local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid") 
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

local Camera = workspace.CurrentCamera

local function ESP(player)
    local ESPConnection;

    local Drawings = {
        Box = Drawing.new("Square"),
        BoxOutline = Drawing.new("Square"),
    }

    local UpdateESP = function()
        ESPConnection = RunService.RenderStepped:Connect(function()
            local Character = player.Character

            if Character then
                local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
                if HumanoidRootPart then
                    local Position, OnScreen = Camera:WorldToViewportPoint(HumanoidRootPart.Position)
                    if OnScreen then
                        local Scale = 1 / (Position.Z * math.tan(math.rad(Camera.FieldOfView * 0.5)) * 2) * 1000
                        local Width, Height = math.floor(4.5 * Scale), math.floor(6 * Scale)
                        local x, y = math.floor(Position.X), math.floor(Position.Y)
                        local XPosition, YPosition = math.floor(x - Width * 0.5), math.floor((y - Height * 0.5) + (0.5 * Scale))

                        Drawings.Box.Size = Vector2.new(Width, Height)
                        Drawings.Box.Position = Vector2.new(XPosition, YPosition)
                        Drawings.Box.Visible = true
                        Drawings.Box.Color = Color3.new(1, 0, 0)
                        Drawings.Box.Thickness = 1

                        Drawings.BoxOutline.Size = Vector2.new(Width, Height)
                        Drawings.BoxOutline.Position = Vector2.new(XPosition, YPosition)
                        Drawings.BoxOutline.Visible = true
                        Drawings.BoxOutline.Color = Color3.new(0, 0, 0)
                        Drawings.BoxOutline.Thickness = 1

                        Drawings.BoxOutline.ZIndex = 1
                        Drawings.Box.ZIndex = 2
                    else
                        Drawings.Box.Visible = false
                        Drawings.BoxOutline.Visible = false
                    end
                else
                    Drawings.Box.Visible = false
                    Drawings.BoxOutline.Visible = false
                end
            else
                Drawings.Box.Visible = false
                Drawings.BoxOutline.Visible = false
            end

        end)
    end

    coroutine.wrap(UpdateESP)()
end

for _, player in pairs(PlayerService:GetPlayers()) do
    if player.Name ~= LocalPlayer.Name then
        coroutine.wrap(ESP)(player)
    end
end

PlayerService.PlayerAdded:Connect(function(player)
    if player.Name ~= LocalPlayer.Name then
        coroutine.wrap(ESP)(player)
    end
end)