--[[
    Skeet UI Library for Roblox
    Inspired by Skeet/Gamesense CS2 cheat interface
    Created for open-source distribution
]]

local SkeetUI = {}
SkeetUI.__index = SkeetUI

-- Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Color Scheme (Skeet-inspired)
local Colors = {
    Background = Color3.fromRGB(17, 17, 17),
    TopBar = Color3.fromRGB(25, 25, 25),
    Section = Color3.fromRGB(22, 22, 22),
    Accent = Color3.fromRGB(165, 220, 134),
    AccentDark = Color3.fromRGB(140, 195, 109),
    Text = Color3.fromRGB(200, 200, 200),
    TextDark = Color3.fromRGB(150, 150, 150),
    Border = Color3.fromRGB(45, 45, 45),
    ElementBg = Color3.fromRGB(30, 30, 30),
    Hover = Color3.fromRGB(35, 35, 35)
}

-- Utility Functions
local function CreateInstance(className, properties)
    local instance = Instance.new(className)
    for property, value in pairs(properties) do
        instance[property] = value
    end
    return instance
end

local function Tween(object, properties, duration)
    local tweenInfo = TweenInfo.new(duration or 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween = TweenService:Create(object, tweenInfo, properties)
    tween:Play()
    return tween
end

-- Main Library Constructor
function SkeetUI:New(title)
    local library = setmetatable({}, SkeetUI)
    
    library.Title = title or "Skeet UI"
    library.Windows = {}
    library.Flags = {}
    
    -- Create ScreenGui
    library.ScreenGui = CreateInstance("ScreenGui", {
        Name = "SkeetUI",
        Parent = game:GetService("CoreGui"),
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        ResetOnSpawn = false
    })
    
    -- Create Watermark
    library:CreateWatermark()
    
    return library
end

-- Watermark Constructor
function SkeetUI:CreateWatermark()
    local watermark = {}
    
    -- Watermark Frame
    watermark.Frame = CreateInstance("Frame", {
        Name = "Watermark",
        Parent = self.ScreenGui,
        BackgroundColor3 = Colors.Background,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 10, 0, 10),
        Size = UDim2.new(0, 0, 0, 25),
        AutomaticSize = Enum.AutomaticSize.X,
        ZIndex = 100
    })
    
    CreateInstance("UIStroke", {
        Parent = watermark.Frame,
        Color = Colors.Border,
        Thickness = 1
    })
    
    CreateInstance("UICorner", {
        Parent = watermark.Frame,
        CornerRadius = UDim.new(0, 3)
    })
    
    -- Watermark Text Container
    local textContainer = CreateInstance("Frame", {
        Name = "TextContainer",
        Parent = watermark.Frame,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        AutomaticSize = Enum.AutomaticSize.X
    })
    
    CreateInstance("UIPadding", {
        Parent = textContainer,
        PaddingLeft = UDim.new(0, 10),
        PaddingRight = UDim.new(0, 10),
        PaddingTop = UDim.new(0, 3),
        PaddingBottom = UDim.new(0, 3)
    })
    
    CreateInstance("UIListLayout", {
        Parent = textContainer,
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Left,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        Padding = UDim.new(0, 5)
    })
    
    -- Script Name
    watermark.ScriptName = CreateInstance("TextLabel", {
        Name = "ScriptName",
        Parent = textContainer,
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 0, 1, 0),
        AutomaticSize = Enum.AutomaticSize.X,
        Font = Enum.Font.GothamBold,
        Text = self.Title,
        TextColor3 = Colors.Accent,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    
    -- Separator
    CreateInstance("TextLabel", {
        Name = "Separator",
        Parent = textContainer,
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 0, 1, 0),
        AutomaticSize = Enum.AutomaticSize.X,
        Font = Enum.Font.Gotham,
        Text = "|",
        TextColor3 = Colors.Border,
        TextSize = 12
    })
    
    -- Username
    watermark.Username = CreateInstance("TextLabel", {
        Name = "Username",
        Parent = textContainer,
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 0, 1, 0),
        AutomaticSize = Enum.AutomaticSize.X,
        Font = Enum.Font.Gotham,
        Text = game.Players.LocalPlayer.Name,
        TextColor3 = Colors.Text,
        TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    
    -- Separator 2
    CreateInstance("TextLabel", {
        Name = "Separator2",
        Parent = textContainer,
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 0, 1, 0),
        AutomaticSize = Enum.AutomaticSize.X,
        Font = Enum.Font.Gotham,
        Text = "|",
        TextColor3 = Colors.Border,
        TextSize = 12
    })
    
    -- FPS Counter
    watermark.FPS = CreateInstance("TextLabel", {
        Name = "FPS",
        Parent = textContainer,
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 0, 1, 0),
        AutomaticSize = Enum.AutomaticSize.X,
        Font = Enum.Font.Gotham,
        Text = "0 fps",
        TextColor3 = Colors.Text,
        TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    
    -- Separator 3
    CreateInstance("TextLabel", {
        Name = "Separator3",
        Parent = textContainer,
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 0, 1, 0),
        AutomaticSize = Enum.AutomaticSize.X,
        Font = Enum.Font.Gotham,
        Text = "|",
        TextColor3 = Colors.Border,
        TextSize = 12
    })
    
    -- Ping Counter
    watermark.Ping = CreateInstance("TextLabel", {
        Name = "Ping",
        Parent = textContainer,
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 0, 1, 0),
        AutomaticSize = Enum.AutomaticSize.X,
        Font = Enum.Font.Gotham,
        Text = "0ms",
        TextColor3 = Colors.Text,
        TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    
    -- Update FPS
    local lastUpdate = tick()
    local frameCount = 0
    RunService.RenderStepped:Connect(function()
        frameCount = frameCount + 1
        if tick() - lastUpdate >= 1 then
            watermark.FPS.Text = frameCount .. " fps"
            frameCount = 0
            lastUpdate = tick()
        end
    end)
    
    -- Update Ping
    spawn(function()
        while wait(2) do
            local ping = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValueString()
            watermark.Ping.Text = ping
        end
    end)
    
    self.Watermark = watermark
    return watermark
end

-- Window Constructor
function SkeetUI:CreateWindow(title, size)
    local window = {}
    window.Title = title or "Window"
    window.Tabs = {}
    window.CurrentTab = nil
    
    size = size or UDim2.new(0, 600, 0, 500)
    
    -- Main Window Frame
    window.Frame = CreateInstance("Frame", {
        Name = "Window",
        Parent = self.ScreenGui,
        BackgroundColor3 = Colors.Background,
        BorderSizePixel = 0,
        Position = UDim2.new(0.5, -size.X.Offset/2, 0.5, -size.Y.Offset/2),
        Size = size
    })
    
    -- Border
    CreateInstance("UIStroke", {
        Parent = window.Frame,
        Color = Colors.Border,
        Thickness = 1
    })
    
    -- Top Bar
    window.TopBar = CreateInstance("Frame", {
        Name = "TopBar",
        Parent = window.Frame,
        BackgroundColor3 = Colors.TopBar,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 30)
    })
    
    -- Title Label
    CreateInstance("TextLabel", {
        Name = "Title",
        Parent = window.TopBar,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 10, 0, 0),
        Size = UDim2.new(0.5, -10, 1, 0),
        Font = Enum.Font.GothamBold,
        Text = window.Title,
        TextColor3 = Colors.Accent,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    
    -- Tab Container
    window.TabContainer = CreateInstance("Frame", {
        Name = "TabContainer",
        Parent = window.Frame,
        BackgroundColor3 = Colors.Section,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 0, 30),
        Size = UDim2.new(0, 120, 1, -30)
    })
    
    CreateInstance("UIStroke", {
        Parent = window.TabContainer,
        Color = Colors.Border,
        Thickness = 1
    })
    
    -- Content Container
    window.ContentContainer = CreateInstance("Frame", {
        Name = "ContentContainer",
        Parent = window.Frame,
        BackgroundColor3 = Colors.Background,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 120, 0, 30),
        Size = UDim2.new(1, -120, 1, -30)
    })
    
    -- Tab List Layout
    CreateInstance("UIListLayout", {
        Parent = window.TabContainer,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 2)
    })
    
    -- Make window draggable
    self:MakeDraggable(window.Frame, window.TopBar)
    
    table.insert(self.Windows, window)
    return window
end

-- Tab Constructor
function SkeetUI:CreateTab(window, name)
    local tab = {}
    tab.Name = name
    tab.Sections = {}
    tab.Elements = {}
    
    -- Tab Button
    tab.Button = CreateInstance("TextButton", {
        Name = name,
        Parent = window.TabContainer,
        BackgroundColor3 = Colors.ElementBg,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 35),
        Font = Enum.Font.Gotham,
        Text = name,
        TextColor3 = Colors.TextDark,
        TextSize = 12,
        AutoButtonColor = false
    })
    
    CreateInstance("UIPadding", {
        Parent = tab.Button,
        PaddingLeft = UDim.new(0, 10)
    })
    
    -- Tab Content Frame
    tab.Content = CreateInstance("ScrollingFrame", {
        Name = name .. "Content",
        Parent = window.ContentContainer,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 1, 0),
        ScrollBarThickness = 4,
        ScrollBarImageColor3 = Colors.Accent,
        Visible = false,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y
    })
    
    CreateInstance("UIListLayout", {
        Parent = tab.Content,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 10)
    })
    
    CreateInstance("UIPadding", {
        Parent = tab.Content,
        PaddingTop = UDim.new(0, 10),
        PaddingLeft = UDim.new(0, 10),
        PaddingRight = UDim.new(0, 10),
        PaddingBottom = UDim.new(0, 10)
    })
    
    -- Tab Button Click
    tab.Button.MouseButton1Click:Connect(function()
        for _, otherTab in pairs(window.Tabs) do
            otherTab.Content.Visible = false
            otherTab.Button.BackgroundColor3 = Colors.ElementBg
            otherTab.Button.TextColor3 = Colors.TextDark
        end
        
        tab.Content.Visible = true
        tab.Button.BackgroundColor3 = Colors.Hover
        tab.Button.TextColor3 = Colors.Text
        window.CurrentTab = tab
    end)
    
    -- Hover effects
    tab.Button.MouseEnter:Connect(function()
        if window.CurrentTab ~= tab then
            Tween(tab.Button, {BackgroundColor3 = Colors.Hover}, 0.15)
        end
    end)
    
    tab.Button.MouseLeave:Connect(function()
        if window.CurrentTab ~= tab then
            Tween(tab.Button, {BackgroundColor3 = Colors.ElementBg}, 0.15)
        end
    end)
    
    table.insert(window.Tabs, tab)
    
    -- Auto-select first tab
    if #window.Tabs == 1 then
        tab.Button.BackgroundColor3 = Colors.Hover
        tab.Button.TextColor3 = Colors.Text
        tab.Content.Visible = true
        window.CurrentTab = tab
    end
    
    return tab
end

-- Section Constructor
function SkeetUI:CreateSection(tab, name)
    local section = {}
    section.Name = name
    
    section.Frame = CreateInstance("Frame", {
        Name = name,
        Parent = tab.Content,
        BackgroundColor3 = Colors.Section,
        BorderSizePixel = 0,
        Size = UDim2.new(1, -10, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y
    })
    
    CreateInstance("UIStroke", {
        Parent = section.Frame,
        Color = Colors.Border,
        Thickness = 1
    })
    
    CreateInstance("UICorner", {
        Parent = section.Frame,
        CornerRadius = UDim.new(0, 3)
    })
    
    -- Section Title
    CreateInstance("TextLabel", {
        Name = "SectionTitle",
        Parent = section.Frame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 10, 0, 5),
        Size = UDim2.new(1, -20, 0, 20),
        Font = Enum.Font.GothamBold,
        Text = name,
        TextColor3 = Colors.Accent,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    
    -- Elements Container
    section.Container = CreateInstance("Frame", {
        Name = "Container",
        Parent = section.Frame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 30),
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y
    })
    
    CreateInstance("UIListLayout", {
        Parent = section.Container,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 5)
    })
    
    CreateInstance("UIPadding", {
        Parent = section.Container,
        PaddingLeft = UDim.new(0, 10),
        PaddingRight = UDim.new(0, 10),
        PaddingBottom = UDim.new(0, 10)
    })
    
    table.insert(tab.Sections, section)
    return section
end

-- Toggle Element
function SkeetUI:CreateToggle(section, name, default, callback)
    local toggle = {}
    toggle.Name = name
    toggle.Value = default or false
    toggle.Callback = callback or function() end
    
    toggle.Frame = CreateInstance("Frame", {
        Name = name,
        Parent = section.Container,
        BackgroundColor3 = Colors.ElementBg,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 30)
    })
    
    CreateInstance("UICorner", {
        Parent = toggle.Frame,
        CornerRadius = UDim.new(0, 3)
    })
    
    -- Label
    toggle.Label = CreateInstance("TextLabel", {
        Name = "Label",
        Parent = toggle.Frame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 10, 0, 0),
        Size = UDim2.new(1, -50, 1, 0),
        Font = Enum.Font.Gotham,
        Text = name,
        TextColor3 = Colors.Text,
        TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    
    -- Toggle Button
    toggle.Button = CreateInstance("TextButton", {
        Name = "Button",
        Parent = toggle.Frame,
        BackgroundColor3 = toggle.Value and Colors.Accent or Colors.Border,
        Position = UDim2.new(1, -35, 0.5, -8),
        Size = UDim2.new(0, 30, 0, 16),
        Text = "",
        AutoButtonColor = false
    })
    
    CreateInstance("UICorner", {
        Parent = toggle.Button,
        CornerRadius = UDim.new(1, 0)
    })
    
    -- Toggle Circle
    toggle.Circle = CreateInstance("Frame", {
        Name = "Circle",
        Parent = toggle.Button,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        Position = toggle.Value and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6),
        Size = UDim2.new(0, 12, 0, 12)
    })
    
    CreateInstance("UICorner", {
        Parent = toggle.Circle,
        CornerRadius = UDim.new(1, 0)
    })
    
    -- Click Handler
    toggle.Button.MouseButton1Click:Connect(function()
        toggle.Value = not toggle.Value
        
        Tween(toggle.Button, {
            BackgroundColor3 = toggle.Value and Colors.Accent or Colors.Border
        }, 0.2)
        
        Tween(toggle.Circle, {
            Position = toggle.Value and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)
        }, 0.2)
        
        toggle.Callback(toggle.Value)
    end)
    
    -- Hover Effect
    toggle.Frame.MouseEnter:Connect(function()
        Tween(toggle.Frame, {BackgroundColor3 = Colors.Hover}, 0.15)
    end)
    
    toggle.Frame.MouseLeave:Connect(function()
        Tween(toggle.Frame, {BackgroundColor3 = Colors.ElementBg}, 0.15)
    end)
    
    return toggle
end

-- Slider Element
function SkeetUI:CreateSlider(section, name, min, max, default, callback)
    local slider = {}
    slider.Name = name
    slider.Min = min or 0
    slider.Max = max or 100
    slider.Value = default or min or 0
    slider.Callback = callback or function() end
    
    slider.Frame = CreateInstance("Frame", {
        Name = name,
        Parent = section.Container,
        BackgroundColor3 = Colors.ElementBg,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 45)
    })
    
    CreateInstance("UICorner", {
        Parent = slider.Frame,
        CornerRadius = UDim.new(0, 3)
    })
    
    -- Label
    slider.Label = CreateInstance("TextLabel", {
        Name = "Label",
        Parent = slider.Frame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 10, 0, 5),
        Size = UDim2.new(0.6, 0, 0, 15),
        Font = Enum.Font.Gotham,
        Text = name,
        TextColor3 = Colors.Text,
        TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    
    -- Value Label
    slider.ValueLabel = CreateInstance("TextLabel", {
        Name = "ValueLabel",
        Parent = slider.Frame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0.6, 0, 0, 5),
        Size = UDim2.new(0.4, -10, 0, 15),
        Font = Enum.Font.GothamBold,
        Text = tostring(slider.Value),
        TextColor3 = Colors.Accent,
        TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Right
    })
    
    -- Slider Track
    slider.Track = CreateInstance("Frame", {
        Name = "Track",
        Parent = slider.Frame,
        BackgroundColor3 = Colors.Border,
        Position = UDim2.new(0, 10, 0, 28),
        Size = UDim2.new(1, -20, 0, 4)
    })
    
    CreateInstance("UICorner", {
        Parent = slider.Track,
        CornerRadius = UDim.new(1, 0)
    })
    
    -- Slider Fill
    slider.Fill = CreateInstance("Frame", {
        Name = "Fill",
        Parent = slider.Track,
        BackgroundColor3 = Colors.Accent,
        Size = UDim2.new((slider.Value - slider.Min) / (slider.Max - slider.Min), 0, 1, 0)
    })
    
    CreateInstance("UICorner", {
        Parent = slider.Fill,
        CornerRadius = UDim.new(1, 0)
    })
    
    -- Slider Thumb
    slider.Thumb = CreateInstance("Frame", {
        Name = "Thumb",
        Parent = slider.Track,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        Position = UDim2.new((slider.Value - slider.Min) / (slider.Max - slider.Min), -6, 0.5, -6),
        Size = UDim2.new(0, 12, 0, 12)
    })
    
    CreateInstance("UICorner", {
        Parent = slider.Thumb,
        CornerRadius = UDim.new(1, 0)
    })
    
    -- Dragging Logic
    local dragging = false
    
    slider.Track.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local mousePos = input.Position.X
            local trackPos = slider.Track.AbsolutePosition.X
            local trackSize = slider.Track.AbsoluteSize.X
            
            local percent = math.clamp((mousePos - trackPos) / trackSize, 0, 1)
            slider.Value = math.floor(slider.Min + (slider.Max - slider.Min) * percent)
            
            slider.ValueLabel.Text = tostring(slider.Value)
            slider.Fill.Size = UDim2.new(percent, 0, 1, 0)
            slider.Thumb.Position = UDim2.new(percent, -6, 0.5, -6)
            
            slider.Callback(slider.Value)
        end
    end)
    
    return slider
end

-- Button Element
function SkeetUI:CreateButton(section, name, callback)
    local button = {}
    button.Name = name
    button.Callback = callback or function() end
    
    button.Frame = CreateInstance("TextButton", {
        Name = name,
        Parent = section.Container,
        BackgroundColor3 = Colors.Accent,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 30),
        Font = Enum.Font.GothamBold,
        Text = name,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 11,
        AutoButtonColor = false
    })
    
    CreateInstance("UICorner", {
        Parent = button.Frame,
        CornerRadius = UDim.new(0, 3)
    })
    
    -- Click Handler
    button.Frame.MouseButton1Click:Connect(function()
        Tween(button.Frame, {BackgroundColor3 = Colors.AccentDark}, 0.1)
        wait(0.1)
        Tween(button.Frame, {BackgroundColor3 = Colors.Accent}, 0.1)
        button.Callback()
    end)
    
    -- Hover Effect
    button.Frame.MouseEnter:Connect(function()
        Tween(button.Frame, {BackgroundColor3 = Colors.AccentDark}, 0.15)
    end)
    
    button.Frame.MouseLeave:Connect(function()
        Tween(button.Frame, {BackgroundColor3 = Colors.Accent}, 0.15)
    end)
    
    return button
end

-- Dropdown Element
function SkeetUI:CreateDropdown(section, name, options, default, callback)
    local dropdown = {}
    dropdown.Name = name
    dropdown.Options = options or {}
    dropdown.Value = default or (options and options[1]) or ""
    dropdown.Callback = callback or function() end
    dropdown.Open = false
    
    dropdown.Frame = CreateInstance("Frame", {
        Name = name,
        Parent = section.Container,
        BackgroundColor3 = Colors.ElementBg,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 30),
        ClipsDescendants = false
    })
    
    CreateInstance("UICorner", {
        Parent = dropdown.Frame,
        CornerRadius = UDim.new(0, 3)
    })
    
    -- Label
    dropdown.Label = CreateInstance("TextLabel", {
        Name = "Label",
        Parent = dropdown.Frame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 10, 0, 0),
        Size = UDim2.new(0.5, -10, 1, 0),
        Font = Enum.Font.Gotham,
        Text = name,
        TextColor3 = Colors.Text,
        TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    
    -- Selected Value Button
    dropdown.Button = CreateInstance("TextButton", {
        Name = "Button",
        Parent = dropdown.Frame,
        BackgroundColor3 = Colors.Border,
        Position = UDim2.new(0.5, 0, 0.5, -10),
        Size = UDim2.new(0.5, -10, 0, 20),
        Font = Enum.Font.Gotham,
        Text = dropdown.Value,
        TextColor3 = Colors.Text,
        TextSize = 10,
        AutoButtonColor = false
    })
    
    CreateInstance("UICorner", {
        Parent = dropdown.Button,
        CornerRadius = UDim.new(0, 3)
    })
    
    -- Dropdown List
    dropdown.List = CreateInstance("Frame", {
        Name = "List",
        Parent = dropdown.Frame,
        BackgroundColor3 = Colors.Section,
        Position = UDim2.new(0.5, 0, 1, 5),
        Size = UDim2.new(0.5, -10, 0, 0),
        Visible = false,
        ClipsDescendants = true,
        ZIndex = 10
    })
    
    CreateInstance("UICorner", {
        Parent = dropdown.List,
        CornerRadius = UDim.new(0, 3)
    })
    
    CreateInstance("UIStroke", {
        Parent = dropdown.List,
        Color = Colors.Border,
        Thickness = 1
    })
    
    CreateInstance("UIListLayout", {
        Parent = dropdown.List,
        SortOrder = Enum.SortOrder.LayoutOrder
    })
    
    -- Create option buttons
    for _, option in ipairs(dropdown.Options) do
        local optionButton = CreateInstance("TextButton", {
            Name = option,
            Parent = dropdown.List,
            BackgroundColor3 = Colors.ElementBg,
            BorderSizePixel = 0,
            Size = UDim2.new(1, 0, 0, 25),
            Font = Enum.Font.Gotham,
            Text = option,
            TextColor3 = Colors.Text,
            TextSize = 10,
            AutoButtonColor = false,
            ZIndex = 11
        })
        
        optionButton.MouseButton1Click:Connect(function()
            dropdown.Value = option
            dropdown.Button.Text = option
            dropdown.Open = false
            Tween(dropdown.List, {Size = UDim2.new(0.5, -10, 0, 0)}, 0.2)
            wait(0.2)
            dropdown.List.Visible = false
            dropdown.Callback(option)
        end)
        
        optionButton.MouseEnter:Connect(function()
            Tween(optionButton, {BackgroundColor3 = Colors.Hover}, 0.15)
        end)
        
        optionButton.MouseLeave:Connect(function()
            Tween(optionButton, {BackgroundColor3 = Colors.ElementBg}, 0.15)
        end)
    end
    
    -- Toggle dropdown
    dropdown.Button.MouseButton1Click:Connect(function()
        dropdown.Open = not dropdown.Open
        dropdown.List.Visible = true
        
        if dropdown.Open then
            Tween(dropdown.List, {Size = UDim2.new(0.5, -10, 0, #dropdown.Options * 25)}, 0.2)
        else
            Tween(dropdown.List, {Size = UDim2.new(0.5, -10, 0, 0)}, 0.2)
            wait(0.2)
            dropdown.List.Visible = false
        end
    end)
    
    return dropdown
end

-- Label Element
function SkeetUI:CreateLabel(section, text)
    local label = {}
    
    label.Frame = CreateInstance("Frame", {
        Name = "Label",
        Parent = section.Container,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 20)
    })
    
    label.Label = CreateInstance("TextLabel", {
        Name = "Text",
        Parent = label.Frame,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        Font = Enum.Font.Gotham,
        Text = text,
        TextColor3 = Colors.TextDark,
        TextSize = 10,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    
    function label:SetText(newText)
        label.Label.Text = newText
    end
    
    return label
end

-- Make window draggable
function SkeetUI:MakeDraggable(frame, dragHandle)
    local dragging = false
    local dragInput, mousePos, framePos
    
    dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            mousePos = input.Position
            framePos = frame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    dragHandle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - mousePos
            Tween(frame, {
                Position = UDim2.new(
                    framePos.X.Scale,
                    framePos.X.Offset + delta.X,
                    framePos.Y.Scale,
                    framePos.Y.Offset + delta.Y
                )
            }, 0.1)
        end
    end)
end

return SkeetUI
