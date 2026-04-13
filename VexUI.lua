-- VexUI v1.1 - Minimal UI Library for Roblox
local VexUI = {}

VexUI.Fonts = {
    Poppins = Font.new("rbxassetid://11714050028", Enum.FontStyle.Normal),
    Inter = Font.new("rbxassetid://12187348397", Enum.FontStyle.Normal)
}

VexUI.DefaultTheme = {
    Background = Color3.fromRGB(20, 20, 25),
    Surface = Color3.fromRGB(30, 30, 38),
    SurfaceHover = Color3.fromRGB(40, 40, 50),
    Primary = Color3.fromRGB(88, 166, 255),
    PrimaryHover = Color3.fromRGB(108, 186, 255),
    Text = Color3.fromRGB(255, 255, 255),
    TextSecondary = Color3.fromRGB(160, 160, 170),
    Border = Color3.fromRGB(50, 50, 60),
    CornerRadius = 8
}

VexUI.CurrentTheme = VexUI.DefaultTheme

function VexUI:SetTheme(theme)
    VexUI.CurrentTheme = {}
    for i, v in pairs(VexUI.DefaultTheme) do
        VexUI.CurrentTheme[i] = theme[i] or v
    end
end

local function getFont()
    return VexUI.Fonts.Poppins
end

local function tween(instance, props, duration)
    local ti = TweenInfo.new(duration or 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    game:GetService("TweenService"):Create(instance, ti, props):Play()
end

function VexUI:CreateButton(config)
    local btn = Instance.new("TextButton")
    btn.Size = config.Size or UDim2.new(0, 200, 0, 40)
    btn.Position = config.Position or UDim2.new(0, 0, 0, 0)
    btn.BackgroundColor3 = self.CurrentTheme.Primary
    btn.Text = config.Text or "Button"
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = getFont()
    btn.TextSize = 14
    btn.AutoButtonColor = false
    btn.BorderSizePixel = 0
    btn.ZIndex = 1
    btn.Parent = config.Parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, self.CurrentTheme.CornerRadius)
    corner.Parent = btn
    
    local shadow = Instance.new("Frame")
    shadow.Size = UDim2.new(1, 0, 1, 0)
    shadow.Position = UDim2.new(0, 0, 0, 4)
    shadow.BackgroundColor3 = Color3.new(0, 0, 0)
    shadow.BackgroundTransparency = 0.5
    shadow.BorderSizePixel = 0
    shadow.ZIndex = 0
    shadow.Parent = btn
    Instance.new("UICorner", shadow).CornerRadius = UDim.new(0, self.CurrentTheme.CornerRadius)
    
    btn.MouseEnter:Connect(function()
        tween(btn, {BackgroundColor3 = self.CurrentTheme.PrimaryHover}, 0.15)
    end)
    btn.MouseLeave:Connect(function()
        tween(btn, {BackgroundColor3 = self.CurrentTheme.Primary}, 0.15)
    end)
    btn.MouseButton1Down:Connect(function()
        tween(btn, {Size = UDim2.new(0, btn.AbsoluteSize.X - 4, 0, btn.AbsoluteSize.Y - 4)}, 0.05)
    end)
    btn.MouseButton1Up:Connect(function()
        tween(btn, {Size = UDim2.new(0, 200, 0, 40)}, 0.05)
    end)
    
    return btn
end

function VexUI:CreateToggle(config)
    local toggle = Instance.new("TextButton")
    toggle.Size = UDim2.new(0, 50, 0, 26)
    toggle.BackgroundColor3 = self.CurrentTheme.Surface
    toggle.Text = ""
    toggle.BorderSizePixel = 0
    toggle.AutoButtonColor = false
    toggle.ZIndex = 1
    toggle.Parent = config.Parent
    
    Instance.new("UICorner", toggle).CornerRadius = UDim.new(0, 13)
    
    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 20, 0, 20)
    knob.Position = UDim2.new(0, 3, 0, 3)
    knob.BackgroundColor3 = self.CurrentTheme.TextSecondary
    knob.BorderSizePixel = 0
    knob.ZIndex = 2
    knob.Parent = toggle
    Instance.new("UICorner", knob).CornerRadius = UDim.new(0, 10)
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -60, 1, 0)
    label.Position = UDim2.new(0, 55, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = config.Text or "Toggle"
    label.TextColor3 = self.CurrentTheme.Text
    label.Font = getFont()
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 1
    label.Parent = toggle
    
    local enabled = false
    local function setState(state)
        enabled = state
        if enabled then
            tween(toggle, {BackgroundColor3 = self.CurrentTheme.Primary}, 0.2)
            tween(knob, {Position = UDim2.new(0, 27, 0, 3)}, 0.2)
        else
            tween(toggle, {BackgroundColor3 = self.CurrentTheme.Surface}, 0.2)
            tween(knob, {Position = UDim2.new(0, 3, 0, 3)}, 0.2)
        end
    end
    
    toggle.MouseButton1Click:Connect(function()
        setState(not enabled)
        if config.Callback then config.Callback(enabled) end
    end)
    
    if config.Default then setState(true) end
    
    return {Toggle = toggle, SetValue = setState, GetValue = function() return enabled end}
end

function VexUI:CreateSlider(config)
    local slider = Instance.new("Frame")
    slider.Size = config.Size or UDim2.new(0, 200, 0, 20)
    slider.BackgroundTransparency = 1
    slider.ZIndex = 1
    slider.Parent = config.Parent
    
    local track = Instance.new("Frame")
    track.Size = UDim2.new(1, 0, 0, 6)
    track.Position = UDim2.new(0, 0, 0, 7)
    track.BackgroundColor3 = self.CurrentTheme.Surface
    track.BorderSizePixel = 0
    track.ZIndex = 1
    track.Parent = slider
    Instance.new("UICorner", track).CornerRadius = UDim.new(0, 3)
    
    local fill = Instance.new("Frame")
    fill.Size = UDim2.new(0, 0, 1, 0)
    fill.BackgroundColor3 = self.CurrentTheme.Primary
    fill.BorderSizePixel = 0
    fill.ZIndex = 2
    fill.Parent = track
    Instance.new("UICorner", fill).CornerRadius = UDim.new(0, 3)
    
    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 16, 0, 16)
    knob.Position = UDim2.new(0, 0, 0.5, 0)
    knob.BackgroundColor3 = Color3.new(1, 1, 1)
    knob.BorderSizePixel = 0
    knob.ZIndex = 3
    knob.Parent = track
    Instance.new("UICorner", knob).CornerRadius = UDim.new(0, 8)
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 20)
    label.Position = UDim2.new(0, 0, 0, -22)
    label.BackgroundTransparency = 1
    label.Text = config.Text or "Slider"
    label.TextColor3 = self.CurrentTheme.Text
    label.Font = getFont()
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 1
    label.Parent = slider
    
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Size = UDim2.new(0, 50, 0, 20)
    valueLabel.Position = UDim2.new(1, 0, 0, -22)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = tostring(config.Min or 0)
    valueLabel.TextColor3 = self.CurrentTheme.TextSecondary
    valueLabel.Font = getFont()
    valueLabel.TextSize = 12
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.ZIndex = 1
    valueLabel.Parent = slider
    
    local minVal, maxVal = config.Min or 0, config.Max or 100
    local currentVal = config.Default or minVal
    
    local function update(value)
        local percent = (value - minVal) / (maxVal - minVal)
        local newX = track.AbsoluteSize.X * percent
        fill.Size = UDim2.new(0, newX, 1, 0)
        knob.Position = UDim2.new(0, newX - 8, 0.5, 0)
        valueLabel.Text = string.format("%.0f", value)
        if config.Callback then config.Callback(value) end
    end
    
    local dragging = false
    track.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            local relativeX = input.Position.X - track.AbsolutePosition.X
            local percent = math.clamp(relativeX / track.AbsoluteSize.X, 0, 1)
            update(minVal + (maxVal - minVal) * percent)
        end
    end)
    track.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local relativeX = input.Position.X - track.AbsolutePosition.X
            local percent = math.clamp(relativeX / track.AbsoluteSize.X, 0, 1)
            update(minVal + (maxVal - minVal) * percent)
        end
    end)
    
    update(currentVal)
    return {Slider = slider, SetValue = update, GetValue = function() return currentVal end}
end

function VexUI:CreateInput(config)
    local frame = Instance.new("Frame")
    frame.Size = config.Size or UDim2.new(0, 200, 0, 40)
    frame.BackgroundColor3 = self.CurrentTheme.Surface
    frame.BorderSizePixel = 0
    frame.ZIndex = 1
    frame.Parent = config.Parent
    
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, self.CurrentTheme.CornerRadius)
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -20, 0, 20)
    label.Position = UDim2.new(0, 10, 0, 5)
    label.BackgroundTransparency = 1
    label.Text = config.Text or "Input"
    label.TextColor3 = self.CurrentTheme.TextSecondary
    label.Font = getFont()
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 1
    label.Parent = frame
    
    local textBox = Instance.new("TextBox")
    textBox.Size = UDim2.new(1, -20, 0, 20)
    textBox.Position = UDim2.new(0, 10, 0, 20)
    textBox.BackgroundTransparency = 1
    textBox.Text = ""
    textBox.PlaceholderText = config.Placeholder or ""
    textBox.PlaceholderColor3 = self.CurrentTheme.TextSecondary
    textBox.TextColor3 = self.CurrentTheme.Text
    textBox.Font = getFont()
    textBox.TextSize = 14
    textBox.TextXAlignment = Enum.TextXAlignment.Left
    textBox.ZIndex = 1
    textBox.Parent = frame
    
    return {Input = frame, TextBox = textBox, GetValue = function() return textBox.Text end}
end

function VexUI:CreateDropdown(config)
    local frame = Instance.new("Frame")
    frame.Size = config.Size or UDim2.new(0, 200, 0, 40)
    frame.BackgroundColor3 = self.CurrentTheme.Surface
    frame.BorderSizePixel = 0
    frame.ZIndex = 1
    frame.Parent = config.Parent
    
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, self.CurrentTheme.CornerRadius)
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -40, 0, 20)
    label.Position = UDim2.new(0, 10, 0, 5)
    label.BackgroundTransparency = 1
    label.Text = config.Text or "Dropdown"
    label.TextColor3 = self.CurrentTheme.TextSecondary
    label.Font = getFont()
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 1
    label.Parent = frame
    
    local selected = Instance.new("TextLabel")
    selected.Size = UDim2.new(1, -40, 0, 20)
    selected.Position = UDim2.new(0, 10, 0, 20)
    selected.BackgroundTransparency = 1
    selected.Text = config.Options[1] or "Select..."
    selected.TextColor3 = self.CurrentTheme.Text
    selected.Font = getFont()
    selected.TextSize = 14
    selected.TextXAlignment = Enum.TextXAlignment.Left
    selected.ZIndex = 1
    selected.Parent = frame
    
    local arrow = Instance.new("TextLabel")
    arrow.Size = UDim2.new(0, 20, 0, 20)
    arrow.Position = UDim2.new(1, -25, 0, 10)
    arrow.BackgroundTransparency = 1
    arrow.Text = "▼"
    arrow.TextColor3 = self.CurrentTheme.TextSecondary
    arrow.Font = getFont()
    arrow.TextSize = 10
    arrow.ZIndex = 1
    arrow.Parent = frame
    
    local list, isOpen = nil, false
    local function toggle()
        isOpen = not isOpen
        tween(arrow, {Rotation = isOpen and 180 or 0}, 0.2)
        if isOpen then
            list = Instance.new("Frame")
            list.Size = UDim2.new(1, 0, 0, #config.Options * 30 + 10)
            list.Position = UDim2.new(0, 0, 0, 40)
            list.BackgroundColor3 = self.CurrentTheme.Surface
            list.BorderSizePixel = 0
            list.ZIndex = 100
            list.Parent = frame
            Instance.new("UICorner", list).CornerRadius = UDim.new(0, self.CurrentTheme.CornerRadius)
            
            for i, opt in ipairs(config.Options) do
                local btn = Instance.new("TextButton")
                btn.Size = UDim2.new(1, -10, 0, 30)
                btn.Position = UDim2.new(0, 5, 0, (i-1) * 30)
                btn.BackgroundTransparency = 1
                btn.Text = opt
                btn.TextColor3 = self.CurrentTheme.Text
                btn.Font = getFont()
                btn.TextSize = 14
                btn.TextXAlignment = Enum.TextXAlignment.Left
                btn.ZIndex = 101
                btn.Parent = list
                btn.MouseButton1Click:Connect(function()
                    selected.Text = opt
                    isOpen = false
                    tween(arrow, {Rotation = 0}, 0.2)
                    list:Destroy()
                    list = nil
                    if config.Callback then config.Callback(opt) end
                end)
            end
        else
            if list then list:Destroy(); list = nil end
        end
    end
    
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then toggle() end
    end)
    
    return {Dropdown = frame, GetValue = function() return selected.Text end}
end

function VexUI:CreateWindow(config)
    local window = Instance.new("Frame")
    window.Size = config.Size or UDim2.new(0, 500, 0, 400)
    window.Position = config.Position or UDim2.new(0.5, -250, 0.5, -200)
    window.BackgroundColor3 = self.CurrentTheme.Background
    window.BorderSizePixel = 0
    window.ZIndex = 1
    window.Parent = config.Parent
    
    Instance.new("UICorner", window).CornerRadius = UDim.new(0, 16)
    
    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1, 0, 0, 40)
    titleBar.BackgroundTransparency = 1
    titleBar.ZIndex = 1
    titleBar.Parent = window
    
    local dragging, dragStart, startPos = false, nil, nil
    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = window.Position
        end
    end)
    titleBar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if dragging and input == dragStart then
            local delta = input.Position - dragStart
            window.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -60, 1, 0)
    title.BackgroundTransparency = 1
    title.Text = config.Title or "VexUI"
    title.TextColor3 = self.CurrentTheme.Text
    title.Font = getFont()
    title.TextSize = 18
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.ZIndex = 1
    title.Position = UDim2.new(0, 20, 0, 0)
    title.Parent = titleBar
    
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 30, 0, 30)
    closeBtn.Position = UDim2.new(1, -40, 0, 5)
    closeBtn.BackgroundTransparency = 1
    closeBtn.Text = "✕"
    closeBtn.TextColor3 = self.CurrentTheme.TextSecondary
    closeBtn.Font = getFont()
    closeBtn.TextSize = 16
    closeBtn.ZIndex = 1
    closeBtn.Parent = titleBar
    closeBtn.MouseButton1Click:Connect(function() window:Destroy() end)
    
    local content = Instance.new("ScrollingFrame")
    content.Size = UDim2.new(1, -30, 1, -50)
    content.Position = UDim2.new(0, 15, 0, 45)
    content.BackgroundTransparency = 1
    content.BorderSizePixel = 0
    content.ScrollBarThickness = 4
    content.ScrollBarImageColor3 = self.CurrentTheme.Primary
    content.ZIndex = 1
    content.Parent = window
    
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 10)
    layout.Parent = content
    
    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, 10)
    padding.PaddingLeft = UDim.new(0, 10)
    padding.Parent = content
    
    return {Window = window, Content = content}
end

function VexUI:CreateSection(parent, title)
    local section = Instance.new("Frame")
    section.Size = UDim2.new(1, 0, 0, 40)
    section.BackgroundTransparency = 1
    section.ZIndex = 1
    section.Parent = parent
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 20)
    label.BackgroundTransparency = 1
    label.Text = title or "Section"
    label.TextColor3 = self.CurrentTheme.Primary
    label.Font = getFont()
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 1
    label.Parent = section
    
    local divider = Instance.new("Frame")
    divider.Size = UDim2.new(1, 0, 0, 1)
    divider.Position = UDim2.new(0, 0, 0, 25)
    divider.BackgroundColor3 = self.CurrentTheme.Border
    divider.BorderSizePixel = 0
    divider.ZIndex = 1
    divider.Parent = section
    
    return section
end

function VexUI:CreateLabel(config)
    local label = Instance.new("TextLabel")
    label.Size = config.Size or UDim2.new(1, 0, 0, 20)
    label.BackgroundTransparency = 1
    label.Text = config.Text or "Label"
    label.TextColor3 = self.CurrentTheme.Text
    label.Font = getFont()
    label.TextSize = config.TextSize or 14
    label.TextXAlignment = config.Alignment or Enum.TextXAlignment.Left
    label.ZIndex = 1
    label.Parent = config.Parent
    return label
end

return VexUI
