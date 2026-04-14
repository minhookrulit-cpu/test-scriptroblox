-- FatalityUI (basic UI framework)
local UI = {}

function UI:CreateWindow(title)
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "FatalityUI"
    ScreenGui.Parent = game.CoreGui

    local Main = Instance.new("Frame")
    Main.Size = UDim2.new(0, 600, 0, 400)
    Main.Position = UDim2.new(0.5, -300, 0.5, -200)
    Main.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    Main.BorderSizePixel = 0
    Main.Parent = ScreenGui

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 10)
    Corner.Parent = Main

    local Stroke = Instance.new("UIStroke")
    Stroke.Thickness = 2
    Stroke.Color = Color3.fromRGB(170, 0, 255)
    Stroke.Parent = Main

    local TopBar = Instance.new("Frame")
    TopBar.Size = UDim2.new(1, 0, 0, 40)
    TopBar.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    TopBar.BorderSizePixel = 0
    TopBar.Parent = Main

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 1, 0)
    Title.BackgroundTransparency = 1
    Title.Text = title or "FATALITY UI"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 18
    Title.Parent = TopBar

    local Tabs = Instance.new("Frame")
    Tabs.Size = UDim2.new(0, 150, 1, -40)
    Tabs.Position = UDim2.new(0, 0, 0, 40)
    Tabs.BackgroundColor3 = Color3.fromRGB(18, 18, 25)
    Tabs.BorderSizePixel = 0
    Tabs.Parent = Main

    local Content = Instance.new("Frame")
    Content.Size = UDim2.new(1, -150, 1, -40)
    Content.Position = UDim2.new(0, 150, 0, 40)
    Content.BackgroundTransparency = 1
    Content.Parent = Main

    local self = {}

    self.ScreenGui = ScreenGui
    self.Main = Main
    self.Tabs = Tabs
    self.Content = Content
    self.CurrentTab = nil

    function self:CreateTab(name)
        local TabButton = Instance.new("TextButton")
        TabButton.Size = UDim2.new(1, 0, 0, 35)
        TabButton.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
        TabButton.Text = name
        TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        TabButton.Font = Enum.Font.Gotham
        TabButton.TextSize = 14
        TabButton.Parent = Tabs

        local TabFrame = Instance.new("Frame")
        TabFrame.Size = UDim2.new(1, 0, 1, 0)
        TabFrame.BackgroundTransparency = 1
        TabFrame.Visible = false
        TabFrame.Parent = Content

        TabButton.MouseButton1Click:Connect(function()
            if self.CurrentTab then
                self.CurrentTab.Visible = false
            end
            TabFrame.Visible = true
            self.CurrentTab = TabFrame
        end)

        local tab = {}

        function tab:AddButton(text, callback)
            local Button = Instance.new("TextButton")
            Button.Size = UDim2.new(0, 200, 0, 35)
            Button.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
            Button.Text = text
            Button.TextColor3 = Color3.fromRGB(255, 255, 255)
            Button.Font = Enum.Font.Gotham
            Button.TextSize = 14
            Button.Parent = TabFrame

            local c = Instance.new("UICorner", Button)
            c.CornerRadius = UDim.new(0, 6)

            Button.MouseButton1Click:Connect(function()
                if callback then callback() end
            end)
        end

        function tab:AddToggle(text, callback)
            local Toggle = Instance.new("TextButton")
            Toggle.Size = UDim2.new(0, 200, 0, 35)
            Toggle.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
            Toggle.Text = text .. " : OFF"
            Toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
            Toggle.Font = Enum.Font.Gotham
            Toggle.TextSize = 14
            Toggle.Parent = TabFrame

            local state = false

            Toggle.MouseButton1Click:Connect(function()
                state = not state
                Toggle.Text = text .. (state and " : ON" or " : OFF")
                if callback then callback(state) end
            end)
        end

        function tab:AddLabel(text)
            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(0, 200, 0, 25)
            Label.BackgroundTransparency = 1
            Label.Text = text
            Label.TextColor3 = Color3.fromRGB(180, 180, 180)
            Label.Font = Enum.Font.Gotham
            Label.TextSize = 13
            Label.Parent = TabFrame
        end

        return tab
    end

    return self
end

return UI
