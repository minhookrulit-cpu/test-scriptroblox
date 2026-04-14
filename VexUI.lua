-- FatalityUI v2 (extended framework)
local UI = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")

--// CONFIG SYSTEM
local Config = {
    FileName = "FatalityConfig.json",
    Data = {}
}

function Config:Save()
    if writefile then
        writefile(self.FileName, HttpService:JSONEncode(self.Data))
    end
end

function Config:Load()
    if readfile and isfile and isfile(self.FileName) then
        self.Data = HttpService:JSONDecode(readfile(self.FileName))
    end
end

--// THEME SYSTEM
local Themes = {
    Dark = {
        Main = Color3.fromRGB(15,15,20),
        Accent = Color3.fromRGB(170,0,255)
    },
    Neon = {
        Main = Color3.fromRGB(10,10,10),
        Accent = Color3.fromRGB(0,255,200)
    }
}

local CurrentTheme = Themes.Dark

local function tween(obj, info, props)
    TweenService:Create(obj, info, props):Play()
end

--// DRAG SYSTEM
local function makeDraggable(frame)
    local dragging, dragInput, startPos, startInput

    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            startInput = input.Position
            startPos = frame.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - startInput
            frame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
end

--// KEYBINDS
local Keybinds = {}

UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    for key, func in pairs(Keybinds) do
        if input.KeyCode == key then
            func()
        end
    end
end)

function UI:CreateWindow(title)
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Parent = game.CoreGui

    local Main = Instance.new("Frame")
    Main.Size = UDim2.new(0, 600,0,400)
    Main.Position = UDim2.new(0.5,-300,0.5,-200)
    Main.BackgroundColor3 = CurrentTheme.Main
    Main.Parent = ScreenGui

    Instance.new("UICorner", Main).CornerRadius = UDim.new(0,10)

    local Stroke = Instance.new("UIStroke", Main)
    Stroke.Color = CurrentTheme.Accent

    local TopBar = Instance.new("Frame", Main)
    TopBar.Size = UDim2.new(1,0,0,40)

    local Title = Instance.new("TextLabel", TopBar)
    Title.Size = UDim2.new(1,0,1,0)
    Title.Text = title or "Fatality UI"

    makeDraggable(Main)

    local Tabs = Instance.new("Frame", Main)
    Tabs.Size = UDim2.new(0,150,1,-40)
    Tabs.Position = UDim2.new(0,0,0,40)

    local Content = Instance.new("Frame", Main)
    Content.Size = UDim2.new(1,-150,1,-40)
    Content.Position = UDim2.new(0,150,0,40)

    local self = {
        ScreenGui = ScreenGui,
        Main = Main,
        Tabs = Tabs,
        Content = Content,
        CurrentTab = nil,
        SearchQuery = ""
    }

    --// SEARCH FILTER
    function self:SetSearch(text)
        self.SearchQuery = text:lower()
    end

    function self:CreateTab(name)

        local TabButton = Instance.new("TextButton", Tabs)
        TabButton.Size = UDim2.new(1,0,0,35)
        TabButton.Text = name

        local TabFrame = Instance.new("Frame", Content)
        TabFrame.Size = UDim2.new(1,0,1,0)
        TabFrame.Visible = false

        TabButton.MouseButton1Click:Connect(function()
            if self.CurrentTab then
                self.CurrentTab.Visible = false
            end
            TabFrame.Visible = true
            self.CurrentTab = TabFrame
        end)

        local tab = {}

        -- BUTTON
        function tab:AddButton(text, callback)
            local Button = Instance.new("TextButton", TabFrame)
            Button.Text = text

            Button.MouseButton1Click:Connect(function()
                tween(Button, TweenInfo.new(0.2), {BackgroundTransparency = 0.5})
                if callback then callback() end
            end)
        end

        -- TOGGLE
        function tab:AddToggle(text, callback)
            local state = false
            local Toggle = Instance.new("TextButton", TabFrame)
            Toggle.Text = text .. ": OFF"

            Toggle.MouseButton1Click:Connect(function()
                state = not state
                Toggle.Text = text .. (state and ": ON" or ": OFF")
                if callback then callback(state) end
            end)
        end

        -- SLIDER
        function tab:AddSlider(text, min, max, callback)
            local value = min

            local Slider = Instance.new("TextButton", TabFrame)
            Slider.Text = text .. ": " .. value

            Slider.MouseButton1Down:Connect(function()
                local move
                move = UserInputService.InputChanged:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseMovement then
                        value = math.clamp(value + 1, min, max)
                        Slider.Text = text .. ": " .. value
                        if callback then callback(value) end
                    end
                end)

                UserInputService.InputEnded:Connect(function()
                    move:Disconnect()
                end)
            end)
        end

        -- DROPDOWN
        function tab:AddDropdown(text, options, callback)
            local open = false

            local Drop = Instance.new("TextButton", TabFrame)
            Drop.Text = text

            local Frame = Instance.new("Frame", TabFrame)
            Frame.Visible = false

            Drop.MouseButton1Click:Connect(function()
                open = not open
                Frame.Visible = open
            end)

            for _, opt in ipairs(options) do
                local b = Instance.new("TextButton", Frame)
                b.Text = opt

                b.MouseButton1Click:Connect(function()
                    if callback then callback(opt) end
                end)
            end
        end

        -- LABEL
        function tab:AddLabel(text)
            local Label = Instance.new("TextLabel", TabFrame)
            Label.Text = text
        end

        -- KEYBIND
        function tab:AddKeybind(key, callback)
            Keybinds[key] = callback
        end

        return tab
    end

    -- APPLY THEME
    function self:SetTheme(themeName)
        CurrentTheme = Themes[themeName] or Themes.Dark
        Main.BackgroundColor3 = CurrentTheme.Main
    end

    return self
end

return UI
