local VexUI = {}

VexUI.Fonts = {
    Inter = Font.new("rbxassetid://12187348397", Enum.FontStyle.Normal),
    Poppins = Font.new("rbxassetid://11714050028", Enum.FontStyle.Normal),
    Satoshi = Font.new("rbxassetid://11702720882", Enum.FontStyle.Normal),
    Rajdhani = Font.new("rbxassetid://11747315117", Enum.FontStyle.Normal)
}

VexUI.DefaultTheme = {
    Background = Color3.fromRGB(20, 20, 25),
    Surface = Color3.fromRGB(30, 30, 38),
    SurfaceHover = Color3.fromRGB(40, 40, 50),
    Primary = Color3.fromRGB(88, 166, 255),
    PrimaryHover = Color3.fromRGB(108, 186, 255),
    Secondary = Color3.fromRGB(168, 85, 247),
    Accent = Color3.fromRGB(236, 72, 153),
    Success = Color3.fromRGB(52, 211, 153),
    Warning = Color3.fromRGB(251, 191, 36),
    Error = Color3.fromRGB(248, 113, 113),
    Text = Color3.fromRGB(255, 255, 255),
    TextSecondary = Color3.fromRGB(160, 160, 170),
    Border = Color3.fromRGB(50, 50, 60),
    CornerRadius = 8
}

VexUI.CurrentTheme = nil
VexUI.Animations = {}

function VexUI:SetTheme(theme)
    VexUI.CurrentTheme = {}
    for i, v in pairs(VexUI.DefaultTheme) do
        VexUI.CurrentTheme[i] = theme[i] or v
    end
end

function VexUI:Initialize()
    VexUI:SetTheme(VexUI.DefaultTheme)
end

local function Tween(instance, properties, duration, easing)
    local tweenInfo = TweenInfo.new(duration or 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween = game:GetService("TweenService"):Create(instance, tweenInfo, properties)
    tween:Play()
    return tween
end

local function RippleEffect(button, mouse)
    local ripple = Instance.new("Frame")
    ripple.Size = UDim2.new(0, 0, 0, 0)
    ripple.Position = UDim2.new(0, mouse.X - button.AbsolutePosition.X, 0, mouse.Y - button.AbsolutePosition.Y)
    ripple.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ripple.BorderSizePixel = 0
    ripple.ZIndex = 100
    ripple.BackgroundTransparency = 0.5
    ripple.Parent = button

    local targetSize = math.max(button.AbsoluteSize.X, button.AbsoluteSize.Y) * 2
    Tween(ripple, {Size = UDim2.new(0, targetSize, 0, targetSize), BackgroundTransparency = 1}, 0.5)

    task.delay(0.5, function()
        ripple:Destroy()
    end)
end

function VexUI:CreateButton(config)
    local button = Instance.new("TextButton")
    button.Size = config.Size or UDim2.new(0, 200, 0, 40)
    button.Position = config.Position or UDim2.new(0, 0, 0, 0)
    button.BackgroundColor3 = self.CurrentTheme.Primary
    button.Text = config.Text or "Button"
    button.TextColor3 = Color3.new(1, 1, 1)
    button.Font = getFont("Poppins")
    button.TextSize = 14
    button.AutoButtonColor = false
    button.BorderSizePixel = 0
    button.ZIndex = 1
    button.Parent = config.Parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, self.CurrentTheme.CornerRadius)
    corner.Parent = button

    local shadow = Instance.new("Frame")
    shadow.Size = UDim2.new(1, 0, 1, 0)
    shadow.Position = UDim2.new(0, 0, 0, 4)
    shadow.BackgroundColor3 = Color3.new(0, 0, 0)
    shadow.BackgroundTransparency = 0.5
    shadow.BorderSizePixel = 0
    shadow.ZIndex = 0
    shadow.Parent = button
    local shadowCorner = Instance.new("UICorner")
    shadowCorner.CornerRadius = UDim.new(0, self.CurrentTheme.CornerRadius)
    shadowCorner.Parent = shadow

    button.MouseEnter:Connect(function()
        Tween(button, {BackgroundColor3 = self.CurrentTheme.PrimaryHover}, 0.15)
    end)

    button.MouseLeave:Connect(function()
        Tween(button, {BackgroundColor3 = self.CurrentTheme.Primary}, 0.15)
    end)

    button.MouseButton1Down:Connect(function(_, mouse)
        RippleEffect(button, mouse)
        Tween(button, {Size = UDim2.new(0, button.AbsoluteSize.X - 4, 0, button.AbsoluteSize.Y - 4)}, 0.05)
    end)

    button.MouseButton1Up:Connect(function()
        Tween(button, {Size = UDim2.new(0, tonumber(button.Size.X.Scale) > 0 and button.Size.X.Scale * button.Parent.AbsoluteSize.X or button.Size.X.Offset, 0, tonumber(button.Size.Y.Scale) > 0 and button.Size.Y.Scale * button.Parent.AbsoluteSize.Y or button.Size.Y.Offset)}, 0.05)
    end)

    return button
end

function VexUI:CreateToggle(config)
    local toggle = Instance.new("TextButton")
    toggle.Size = config.Size or UDim2.new(0, 50, 0, 26)
    toggle.BackgroundColor3 = self.CurrentTheme.Surface
    toggle.Text = ""
    toggle.BorderSizePixel = 0
    toggle.AutoButtonColor = false
    toggle.ZIndex = 1
    toggle.Parent = config.Parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 13)
    corner.Parent = toggle

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 20, 0, 20)
    knob.Position = UDim2.new(0, 3, 0, 3)
    knob.BackgroundColor3 = self.CurrentTheme.TextSecondary
    knob.BorderSizePixel = 0
    knob.ZIndex = 2
    knob.Parent = toggle
    local knobCorner = Instance.new("UICorner")
    knobCorner.CornerRadius = UDim.new(0, 10)
    knobCorner.Parent = knob

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -60, 1, 0)
    label.Position = UDim2.new(0, 55, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = config.Text or "Toggle"
    label.TextColor3 = self.CurrentTheme.Text
    label.Font = getFont("Poppins")
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 1
    label.Parent = toggle

    local enabled = false
    local function setToggle(state)
        enabled = state
        if enabled then
            Tween(toggle, {BackgroundColor3 = self.CurrentTheme.Primary}, 0.2)
            Tween(knob, {Position = UDim2.new(0, 27, 0, 3), BackgroundColor3 = Color3.new(1, 1, 1)}, 0.2)
        else
            Tween(toggle, {BackgroundColor3 = self.CurrentTheme.Surface}, 0.2)
            Tween(knob, {Position = UDim2.new(0, 3, 0, 3), BackgroundColor3 = self.CurrentTheme.TextSecondary}, 0.2)
        end
    end

    toggle.MouseButton1Click:Connect(function()
        setToggle(not enabled)
        if config.Callback then
            config.Callback(enabled)
        end
    end)

    if config.Default then
        setToggle(true)
    end

    return {
        Toggle = toggle,
        SetValue = setToggle,
        GetValue = function() return enabled end
    }
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
    local trackCorner = Instance.new("UICorner")
    trackCorner.CornerRadius = UDim.new(0, 3)
    trackCorner.Parent = track

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new(0, 0, 1, 0)
    fill.BackgroundColor3 = self.CurrentTheme.Primary
    fill.BorderSizePixel = 0
    fill.ZIndex = 2
    fill.Parent = track
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(0, 3)
    fillCorner.Parent = fill

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 16, 0, 16)
    knob.Position = UDim2.new(0, 0, 0.5, 0)
    knob.BackgroundColor3 = Color3.new(1, 1, 1)
    knob.BorderSizePixel = 0
    knob.ZIndex = 3
    knob.Parent = track
    local knobCorner = Instance.new("UICorner")
    knobCorner.CornerRadius = UDim.new(0, 8)
    knobCorner.Parent = knob

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 20)
    label.Position = UDim2.new(0, 0, 0, -22)
    label.BackgroundTransparency = 1
    label.Text = config.Text or "Slider"
    label.TextColor3 = self.CurrentTheme.Text
    label.Font = getFont("Poppins")
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
    valueLabel.Font = getFont("Poppins")
    valueLabel.TextSize = 12
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.ZIndex = 1
    valueLabel.Parent = slider

    local minVal = config.Min or 0
    local maxVal = config.Max or 100
    local currentVal = config.Default or minVal

    local function updateSlider(value)
        local percent = (value - minVal) / (maxVal - minVal)
        local width = track.AbsoluteSize.X
        local newX = width * percent
        
        fill.Size = UDim2.new(0, newX, 1, 0)
        knob.Position = UDim2.new(0, newX - 8, 0.5, 0)
        valueLabel.Text = string.format("%.0f", value)
        
        if config.Callback then
            config.Callback(value)
        end
    end

    local dragging = false
    local function calculateValue()
        local mouseX = game:GetService("UserInputService"):GetMouseLocation().X
        local sliderX = track.AbsolutePosition.X
        local relativeX = mouseX - sliderX
        local percent = math.clamp(relativeX / track.AbsoluteSize.X, 0, 1)
        local value = minVal + (maxVal - minVal) * percent
        updateSlider(math.round(value))
    end

    track.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            calculateValue()
        end
    end)

    track.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            calculateValue()
        end
    end)

    updateSlider(currentVal)

    return {
        Slider = slider,
        SetValue = updateSlider,
        GetValue = function() return currentVal end
    }
end

function VexUI:CreateColorPicker(config)
    local picker = Instance.new("Frame")
    picker.Size = config.Size or UDim2.new(0, 200, 0, 40)
    picker.BackgroundTransparency = 1
    picker.ZIndex = 1
    picker.Parent = config.Parent

    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 32, 0, 32)
    button.Position = UDim2.new(0, 0, 0, 4)
    button.BackgroundColor3 = config.Default or Color3.new(1, 0, 0)
    button.BorderSizePixel = 0
    button.Text = ""
    button.AutoButtonColor = false
    button.ZIndex = 2
    button.Parent = picker
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 8)
    buttonCorner.Parent = button

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -45, 1, 0)
    label.Position = UDim2.new(0, 40, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = config.Text or "Color"
    label.TextColor3 = self.CurrentTheme.Text
    label.Font = getFont("Poppins")
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 1
    label.Parent = picker

    local hexLabel = Instance.new("TextLabel")
    hexLabel.Size = UDim2.new(0, 80, 0, 20)
    hexLabel.Position = UDim2.new(1, -80, 0.5, 0)
    hexLabel.BackgroundTransparency = 1
    hexLabel.Text = "#FF0000"
    hexLabel.TextColor3 = self.CurrentTheme.TextSecondary
    hexLabel.Font = getFont("Poppins")
    hexLabel.TextSize = 12
    hexLabel.TextXAlignment = Enum.TextXAlignment.Right
    hexLabel.ZIndex = 1
    hexLabel.Parent = picker

    local popup = nil
    local currentColor = config.Default or Color3.new(1, 0, 0)

    local function rgbToHex(color)
        return string.format("#%02X%02X%02X", 
            math.round(color.R * 255), 
            math.round(color.G * 255), 
            math.round(color.B * 255))
    end

    local function createPopup()
        if popup then popup:Destroy() end

        popup = Instance.new("Frame")
        popup.Size = UDim2.new(0, 250, 0, 180)
        popup.Position = UDim2.new(0, 0, 0, 44)
        popup.BackgroundColor3 = self.CurrentTheme.Surface
        popup.BorderSizePixel = 0
        popup.ZIndex = 100
        popup.Parent = picker

        local popupCorner = Instance.new("UICorner")
        popupCorner.CornerRadius = UDim.new(0, 12)
        popupCorner.Parent = popup

        local hueSlider = Instance.new("Frame")
        hueSlider.Size = UDim2.new(1, -20, 0, 20)
        hueSlider.Position = UDim2.new(0, 10, 0, 10)
        hueSlider.BackgroundColor3 = Color3.new(1, 0, 0)
        hueSlider.BorderSizePixel = 0
        hueSlider.ZIndex = 101
        hueSlider.Parent = popup

        local satValueBox = Instance.new("Frame")
        satValueBox.Size = UDim2.new(1, -20, 0, 100)
        satValueBox.Position = UDim2.new(0, 10, 0, 40)
        satValueBox.BorderSizePixel = 0
        satValueBox.ZIndex = 101
        satValueBox.Parent = popup

        local gradient = Instance.new("UIGradient")
        gradient.Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
            ColorSequenceKeypoint.new(1, currentColor)
        }
        gradient.Parent = satValueBox

        local gradient2 = Instance.new("UIGradient")
        gradient2.Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.new(0, 0, 0)),
            ColorSequenceKeypoint.new(1, Color3.new(0, 0, 0))
        }
        gradient2.Rotation = 90
        gradient2.Parent = satValueBox
    end

    button.MouseButton1Click:Connect(function()
        createPopup()
    end)

    return {
        Picker = picker,
        GetValue = function() return currentColor end,
        SetValue = function(color)
            currentColor = color
            button.BackgroundColor3 = color
            hexLabel.Text = rgbToHex(color)
        end
    }
end

function VexUI:CreateInput(config)
    local inputFrame = Instance.new("Frame")
    inputFrame.Size = config.Size or UDim2.new(0, 200, 0, 40)
    inputFrame.BackgroundColor3 = self.CurrentTheme.Surface
    inputFrame.BorderSizePixel = 0
    inputFrame.ZIndex = 1
    inputFrame.Parent = config.Parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, self.CurrentTheme.CornerRadius)
    corner.Parent = inputFrame

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -20, 0, 20)
    label.Position = UDim2.new(0, 10, 0, 5)
    label.BackgroundTransparency = 1
    label.Text = config.Text or "Input"
    label.TextColor3 = self.CurrentTheme.TextSecondary
    label.Font = getFont("Poppins")
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 1
    label.Parent = inputFrame

    local textBox = Instance.new("TextBox")
    textBox.Size = UDim2.new(1, -20, 0, 20)
    textBox.Position = UDim2.new(0, 10, 0, 20)
    textBox.BackgroundTransparency = 1
    textBox.Text = ""
    textBox.PlaceholderText = config.Placeholder or "Enter text..."
    textBox.PlaceholderColor3 = self.CurrentTheme.TextSecondary
    textBox.TextColor3 = self.CurrentTheme.Text
    textBox.Font = getFont("Poppins")
    textBox.TextSize = 14
    textBox.TextXAlignment = Enum.TextXAlignment.Left
    textBox.ZIndex = 1
    textBox.Parent = inputFrame

    return {
        Input = inputFrame,
        TextBox = textBox,
        GetValue = function() return textBox.Text end,
        SetValue = function(value) textBox.Text = value end
    }
end

function VexUI:CreateDropdown(config)
    local dropdown = Instance.new("Frame")
    dropdown.Size = config.Size or UDim2.new(0, 200, 0, 40)
    dropdown.BackgroundColor3 = self.CurrentTheme.Surface
    dropdown.BorderSizePixel = 0
    dropdown.ZIndex = 1
    dropdown.Parent = config.Parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, self.CurrentTheme.CornerRadius)
    corner.Parent = dropdown

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -40, 0, 20)
    label.Position = UDim2.new(0, 10, 0, 5)
    label.BackgroundTransparency = 1
    label.Text = config.Text or "Dropdown"
    label.TextColor3 = self.CurrentTheme.TextSecondary
    label.Font = getFont("Poppins")
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 1
    label.Parent = dropdown

    local selectedLabel = Instance.new("TextLabel")
    selectedLabel.Size = UDim2.new(1, -40, 0, 20)
    selectedLabel.Position = UDim2.new(0, 10, 0, 20)
    selectedLabel.BackgroundTransparency = 1
    selectedLabel.Text = config.Options[1] or "Select..."
    selectedLabel.TextColor3 = self.CurrentTheme.Text
    selectedLabel.Font = getFont("Poppins")
    selectedLabel.TextSize = 14
    selectedLabel.TextXAlignment = Enum.TextXAlignment.Left
    selectedLabel.ZIndex = 1
    selectedLabel.Parent = dropdown

    local arrow = Instance.new("TextLabel")
    arrow.Size = UDim2.new(0, 20, 0, 20)
    arrow.Position = UDim2.new(1, -25, 0, 10)
    arrow.BackgroundTransparency = 1
    arrow.Text = "▼"
    arrow.TextColor3 = self.CurrentTheme.TextSecondary
    arrow.Font = getFont("Poppins")
    arrow.TextSize = 10
    arrow.ZIndex = 1
    arrow.Parent = dropdown

    local list = nil
    local isOpen = false

    local function toggleList()
        isOpen = not isOpen
        if isOpen then
            Tween(arrow, {Rotation = 180}, 0.2)
            if not list then
                list = Instance.new("Frame")
                list.Size = UDim2.new(1, 0, 0, #config.Options * 30 + 10)
                list.Position = UDim2.new(0, 0, 0, 40)
                list.BackgroundColor3 = self.CurrentTheme.Surface
                list.BorderSizePixel = 0
                list.ZIndex = 100
                list.Parent = dropdown
                local listCorner = Instance.new("UICorner")
                listCorner.CornerRadius = UDim.new(0, self.CurrentTheme.CornerRadius)
                listCorner.Parent = list

                for i, option in ipairs(config.Options) do
                    local optionBtn = Instance.new("TextButton")
                    optionBtn.Size = UDim2.new(1, -10, 0, 30)
                    optionBtn.Position = UDim2.new(0, 5, 0, (i - 1) * 30)
                    optionBtn.BackgroundTransparency = 1
                    optionBtn.Text = option
                    optionBtn.TextColor3 = self.CurrentTheme.Text
                    optionBtn.Font = getFont("Poppins")
                    optionBtn.TextSize = 14
                    optionBtn.TextXAlignment = Enum.TextXAlignment.Left
                    optionBtn.ZIndex = 101
                    optionBtn.Parent = list

                    optionBtn.MouseEnter:Connect(function()
                        optionBtn.TextColor3 = self.CurrentTheme.Primary
                    end)

                    optionBtn.MouseLeave:Connect(function()
                        optionBtn.TextColor3 = self.CurrentTheme.Text
                    end)

                    optionBtn.MouseButton1Click:Connect(function()
                        selectedLabel.Text = option
                        isOpen = false
                        Tween(arrow, {Rotation = 0}, 0.2)
                        list:Destroy()
                        list = nil
                        if config.Callback then
                            config.Callback(option)
                        end
                    end)
                end
            end
        else
            Tween(arrow, {Rotation = 0}, 0.2)
            if list then
                list:Destroy()
                list = nil
            end
        end
    end

    dropdown.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            toggleList()
        end
    end)

    return {
        Dropdown = dropdown,
        GetValue = function() return selectedLabel.Text end,
        SetValue = function(value) selectedLabel.Text = value end
    }
end

function VexUI:CreateWindow(config)
    local window = Instance.new("Frame")
    window.Size = config.Size or UDim2.new(0, 500, 0, 400)
    window.Position = UDim2.new(0.5, -250, 0.5, -200)
    window.BackgroundColor3 = self.CurrentTheme.Background
    window.BorderSizePixel = 0
    window.ZIndex = 1
    window.Active = true
    window.Draggable = true

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 16)
    corner.Parent = window

    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1, 0, 0, 40)
    titleBar.BackgroundTransparency = 1
    titleBar.ZIndex = 1
    titleBar.Parent = window

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -60, 1, 0)
    title.BackgroundTransparency = 1
    title.Text = config.Title or "VexUI"
    title.TextColor3 = self.CurrentTheme.Text
    title.Font = getFont("Poppins")
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
    closeBtn.Font = getFont("Poppins")
    closeBtn.TextSize = 16
    closeBtn.ZIndex = 1
    closeBtn.Parent = titleBar

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

    closeBtn.MouseButton1Click:Connect(function()
        window:Destroy()
    end)

    return {
        Window = window,
        Content = content
    }
end

function VexUI:CreateSection(parent, title)
    local section = Instance.new("Frame")
    section.Size = UDim2.new(1, 0, 0, 40)
    section.BackgroundTransparency = 1
    section.ZIndex = 1
    section.Parent = parent

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, 0, 0, 20)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title or "Section"
    titleLabel.TextColor3 = self.CurrentTheme.Primary
    titleLabel.Font = getFont("Poppins")
    titleLabel.TextSize = 12
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.ZIndex = 1
    titleLabel.Parent = section

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
    label.Font = getFont("Poppins")
    label.TextSize = config.TextSize or 14
    label.TextXAlignment = config.Alignment or Enum.TextXAlignment.Left
    label.ZIndex = 1
    label.Parent = config.Parent

    return label
end

local function getFont(name)
    return Font.new(VexUI.Fonts[name], Enum.FontStyle.Normal)
end

VexUI:GetFont = getFont

VexUI:Initialize()

return VexUI
