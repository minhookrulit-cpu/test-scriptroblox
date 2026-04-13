-- VoidUI | Premium Roblox Lua UI Library
-- Dark Purple Theme (Fatality Style)
-- Version 1.0.0

local VoidUI = {}
VoidUI.__index = VoidUI

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local Theme = {
    Background = Color3.fromRGB(13, 13, 13),
    Panel = Color3.fromRGB(26, 26, 26),
    PanelLight = Color3.fromRGB(37, 37, 37),
    Accent = Color3.fromRGB(139, 92, 246),
    AccentLight = Color3.fromRGB(167, 139, 250),
    Text = Color3.fromRGB(255, 255, 255),
    TextSecondary = Color3.fromRGB(160, 160, 160),
    Border = Color3.fromRGB(51, 51, 51),
    Success = Color3.fromRGB(34, 197, 94),
    Error = Color3.fromRGB(239, 68, 68),
    Warning = Color3.fromRGB(234, 179, 8),
}

local Padding = 12
local CornerRadius = 8
local Font = Enum.Font.Gotham
local TitleFont = Enum.Font.GothamBold

local function Create(instanceClass)
    local instance = Instance.new(instanceClass)
    return instance
end

local function Tween(obj, info, props)
    local tween = TweenService:Create(obj, info, props)
    tween:Play()
    return tween
end

local function MakeDraggable(frame, main)
    local dragging = false
    local dragInput = nil
    local dragStart = nil
    local startPos = nil

    local function Update(input)
        local delta = input.Position - dragStart
        local position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        main.Position = position
    end

    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.TouchInput then
            dragging = true
            dragStart = input.Position
            startPos = main.Position
            dragInput = input

            local hoverTween = Tween(main, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                AnchorPoint = Vector2.new(0.5, 0.5)
            })
        end
    end)

    frame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.TouchInput then
            dragging = false
        end
    end)

    frame.InputChanged:Connect(function(input)
        if dragging and input == dragInput then
            Update(input)
        end
    end)
end

local function CreateLabel(text, size, color, parent)
    local label = Create("TextLabel")
    label.Size = size or UDim2.new(1, 0, 0, 20)
    label.Position = UDim2.new(0, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text or ""
    label.TextColor3 = color or Theme.Text
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = TitleFont
    label.TextSize = 14
    label.Parent = parent
    return label
end

local function CreateButtonBg(parent, size)
    local button = Create("TextButton")
    button.Size = size or UDim2.new(1, 0, 0, 36)
    button.BackgroundColor3 = Theme.Panel
    button.BorderSizePixel = 0
    button.Text = ""
    button.AutoButtonColor = false
    button.Font = TitleFont
    button.TextSize = 14
    button.TextColor3 = Theme.Text
    button.Parent = parent

    local corner = Create("UICorner")
    corner.CornerRadius = UDim.new(0, CornerRadius)
    corner.Parent = button

    local stroke = Create("UIStroke")
    stroke.Thickness = 1
    stroke.Color = Theme.Border
    stroke.Parent = button

    return button
end

local function CreateInputBg(parent, size)
    local input = Create("TextBox")
    input.Size = size or UDim2.new(1, 0, 0, 36)
    input.BackgroundColor3 = Theme.Panel
    input.BorderSizePixel = 0
    input.Text = ""
    input.PlaceholderColor3 = Theme.TextSecondary
    input.PlaceholderText = ""
    input.Font = Font
    input.TextSize = 14
    input.TextColor3 = Theme.Text
    input.TextXAlignment = Enum.TextXAlignment.Left
    input.ClearTextOnFocus = false
    input.Parent = parent

    local corner = Create("UICorner")
    corner.CornerRadius = UDim.new(0, CornerRadius)
    corner.Parent = input

    local stroke = Create("UIStroke")
    stroke.Thickness = 1
    stroke.Color = Theme.Border
    stroke.Parent = input

    local padding = Create("UIPadding")
    padding.PaddingLeft = UDim.new(0, 12)
    padding.Parent = input

    return input
end

local function CreateToggleBg(parent, size)
    local toggle = Create("TextButton")
    toggle.Size = size or UDim2.new(0, 44, 0, 24)
    toggle.BackgroundColor3 = Theme.Panel
    toggle.BorderSizePixel = 0
    toggle.Text = ""
    toggle.AutoButtonColor = false
    toggle.Parent = parent

    local corner = Create("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = toggle

    local stroke = Create("UIStroke")
    stroke.Thickness = 1
    stroke.Color = Theme.Border
    stroke.Parent = toggle

    local circle = Create("Frame")
    circle.Size = UDim2.new(0, 18, 0, 18)
    circle.Position = UDim2.new(0, 3, 0.5, 0)
    circle.AnchorPoint = Vector2.new(0, 0.5)
    circle.BackgroundColor3 = Theme.TextSecondary
    circle.BorderSizePixel = 0
    circle.Parent = toggle

    local circleCorner = Create("UICorner")
    circleCorner.CornerRadius = UDim.new(0, 9)
    circleCorner.Parent = circle

    return toggle, circle
end

local function CreateCheckboxBg(parent, size)
    local checkbox = Create("TextButton")
    checkbox.Size = size or UDim2.new(0, 24, 0, 24)
    checkbox.BackgroundColor3 = Theme.Panel
    checkbox.BorderSizePixel = 0
    checkbox.Text = ""
    checkbox.AutoButtonColor = false
    checkbox.Parent = parent

    local corner = Create("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = checkbox

    local stroke = Create("UIStroke")
    stroke.Thickness = 1
    stroke.Color = Theme.Border
    stroke.Parent = checkbox

    local check = Create("ImageLabel")
    check.Size = UDim2.new(0, 14, 0, 14)
    check.Position = UDim2.new(0.5, 0, 0.5, 0)
    check.AnchorPoint = Vector2.new(0.5, 0.5)
    check.BackgroundTransparency = 1
    check.Image = "http://www.roblox.com/asset/?id=7752724514"
    check.ImageColor3 = Theme.Text
    check.Visible = false
    check.Parent = checkbox

    return checkbox, check
end

local function CreateColorPickerUI(parent)
    local picker = Create("Frame")
    picker.Size = UDim2.new(0, 200, 0, 180)
    picker.BackgroundColor3 = Theme.PanelLight
    picker.BorderSizePixel = 0
    picker.Visible = false
    picker.ZIndex = 100
    picker.Parent = parent

    local corner = Create("UICorner")
    corner.CornerRadius = UDim.new(0, CornerRadius)
    corner.Parent = picker

    local padding = Create("UIPadding")
    padding.PaddingAll = UDim.new(0, Padding)
    padding.Parent = picker

    local title = CreateLabel("Pick Color", UDim2.new(1, 0, 0, 20), Theme.Text, picker)
    title.TextSize = 12

    local hueFrame = Create("Frame")
    hueFrame.Size = UDim2.new(1, 0, 0, 20)
    hueFrame.Position = UDim2.new(0, 0, 0, 25)
    hueFrame.BackgroundColor3 = Color3.new(1, 0, 0)
    hueFrame.BorderSizePixel = 0
    hueFrame.Parent = picker

    local hueCorner = Create("UICorner")
    hueCorner.CornerRadius = UDim.new(0, 4)
    hueCorner.Parent = hueFrame

    local hueSlider = Create("Frame")
    hueSlider.Size = UDim2.new(1, 0, 0, 4)
    hueSlider.Position = UDim2.new(0, 0, 0.5, 0)
    hueSlider.AnchorPoint = Vector2.new(0, 0.5)
    hueSlider.BackgroundColor3 = Color3.new(1, 1, 1)
    hueSlider.BorderSizePixel = 0
    hueSlider.Parent = hueFrame
    local hueSliderCorner = Create("UICorner")
    hueSliderCorner.CornerRadius = UDim.new(0, 2)
    hueSliderCorner.Parent = hueSlider

    local satFrame = Create("Frame")
    satFrame.Size = UDim2.new(1, 0, 0, 20)
    satFrame.Position = UDim2.new(0, 0, 0, 55)
    satFrame.BackgroundColor3 = Color3.new(1, 0, 0)
    satFrame.BorderSizePixel = 0
    satFrame.Parent = picker
    
    local satCorner = Create("UICorner")
    satCorner.CornerRadius = UDim.new(0, 4)
    satCorner.Parent = satFrame

    local satSlider = Create("Frame")
    satSlider.Size = UDim2.new(0.5, 0, 0, 4)
    satSlider.Position = UDim2.new(0, 0, 0.5, 0)
    satSlider.AnchorPoint = Vector2.new(0, 0.5)
    satSlider.BackgroundColor3 = Color3.new(1, 1, 1)
    satSlider.BorderSizePixel = 0
    satSlider.Parent = satFrame
    local satSliderCorner = Create("UICorner")
    satSliderCorner.CornerRadius = UDim.new(0, 2)
    satSliderCorner.Parent = satSlider

    local preview = Create("Frame")
    preview.Size = UDim2.new(0, 40, 0, 40)
    preview.Position = UDim2.new(0, 0, 0, 85)
    preview.BackgroundColor3 = Color3.new(1, 0, 0)
    preview.BorderSizePixel = 0
    preview.Parent = picker

    local previewCorner = Create("UICorner")
    previewCorner.CornerRadius = UDim.new(0, CornerRadius)
    previewCorner.Parent = preview

    local saveBtn = CreateButtonBg(picker, UDim2.new(0.5, -6, 0, 30))
    saveBtn.Size = UDim2.new(0.5, -6, 0, 30)
    saveBtn.Position = UDim2.new(0.5, 3, 0, 85)
    saveBtn.Text = "Save"

    return picker, hueFrame, satFrame, preview, saveBtn
end

function VoidUI:CreateWindow(config)
    config = config or {}
    local Title = config.Title or "VoidUI"
    local Size = config.Size or UDim2.new(0, 500, 0, 400)
    local Position = config.Position or UDim2.new(0.5, 0, 0.5, 0)
    local Draggable = config.Draggable ~= false

    local main = Create("ScreenGui")
    main.Name = "VoidUI_" .. Title
    main.DisplayOrder = 999
    main.IgnoreGuiInset = true
    main.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")

    local window = Create("Frame")
    window.Size = Size
    window.Position = UDim2.new(Position.X.Scale, Position.X.Offset - Size.X.Offset/2, Position.Y.Scale, Position.Y.Offset - Size.Y.Offset/2)
    window.BackgroundColor3 = Theme.Background
    window.BorderSizePixel = 0
    window.ClipsDescendants = true
    window.Parent = main

    local corner = Create("UICorner")
    corner.CornerRadius = UDim.new(0, CornerRadius + 2)
    corner.Parent = window

    local titleFrame = Create("Frame")
    titleFrame.Size = UDim2.new(1, 0, 0, 50)
    titleFrame.BackgroundColor3 = Theme.PanelLight
    titleFrame.BorderSizePixel = 0
    titleFrame.Parent = window

    local titleCorner = Create("UICorner")
    titleCorner.CornerRadius = UDim.new(0, CornerRadius + 2)
    titleCorner.Parent = titleFrame

    local stroke = Create("UIStroke")
    stroke.Thickness = 1
    stroke.Color = Theme.Border
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = window

    local titleLabel = CreateLabel(Title, UDim2.new(1, -80, 0, 50), Theme.Text, titleFrame)
    titleLabel.Position = UDim2.new(0, Padding, 0, 0)
    titleLabel.TextSize = 16

    local closeBtn = Create("TextButton")
    closeBtn.Size = UDim2.new(0, 32, 0, 32)
    closeBtn.Position = UDim2.new(1, -42, 0.5, 0)
    closeBtn.AnchorPoint = Vector2.new(0.5, 0.5)
    closeBtn.BackgroundColor3 = Theme.Panel
    closeBtn.BorderSizePixel = 0
    closeBtn.Text = "✕"
    closeBtn.TextColor3 = Theme.TextSecondary
    closeBtn.AutoButtonColor = false
    closeBtn.Font = TitleFont
    closeBtn.TextSize = 14
    closeBtn.Parent = titleFrame

    local closeCorner = Create("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 8)
    closeCorner.Parent = closeBtn

    local miniBtn = Create("TextButton")
    miniBtn.Size = UDim2.new(0, 32, 0, 32)
    miniBtn.Position = UDim2.new(1, -78, 0.5, 0)
    miniBtn.AnchorPoint = Vector2.new(0.5, 0.5)
    miniBtn.BackgroundColor3 = Theme.Panel
    miniBtn.BorderSizePixel = 0
    miniBtn.Text = "─"
    miniBtn.TextColor3 = Theme.TextSecondary
    miniBtn.AutoButtonColor = false
    miniBtn.Font = TitleFont
    miniBtn.TextSize = 14
    miniBtn.Parent = titleFrame

    local miniCorner = Create("UICorner")
    miniCorner.CornerRadius = UDim.new(0, 8)
    miniCorner.Parent = miniBtn

    local tabFrame = Create("Frame")
    tabFrame.Size = UDim2.new(1, 0, 0, 44)
    tabFrame.Position = UDim2.new(0, 0, 0, 50)
    tabFrame.BackgroundColor3 = Theme.Background
    tabFrame.BorderSizePixel = 0
    tabFrame.Parent = window

    local tabStroke = Create("UIStroke")
    tabStroke.Thickness = 1
    tabStroke.Color = Theme.Border
    tabStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    tabStroke.Parent = tabFrame

    local tabList = Create("UIListLayout")
    tabList.FillDirection = Enum.FillDirection.Horizontal
    tabList.Padding = UDim.new(0, 4)
    tabList.HorizontalAlignment = Enum.HorizontalAlignment.Left
    tabList.VerticalAlignment = Enum.VerticalAlignment.Center
    tabList.Parent = tabFrame

    local tabPadding = Create("UIPadding")
    tabPadding.PaddingLeft = UDim.new(0, Padding)
    tabPadding.PaddingTop = UDim.new(0, 8)
    tabPadding.Parent = tabFrame

    local contentFrame = Create("Frame")
    contentFrame.Size = UDim2.new(1, -Padding*2, 1, -130)
    contentFrame.Position = UDim2.new(0, Padding, 0, 94)
    contentFrame.BackgroundTransparency = 1
    contentFrame.BorderSizePixel = 0
    contentFrame.Parent = window

    local scroll = Create("ScrollingFrame")
    scroll.Size = UDim2.new(1, 0, 1, 0)
    scroll.BackgroundTransparency = 1
    scroll.BorderSizePixel = 0
    scroll.ScrollBarThickness = 0
    scroll.ScrollBarImageTransparency = 1
    scroll.Parent = contentFrame

    local scrollList = Create("UIListLayout")
    scrollList.Padding = UDim.new(0, Padding)
    scrollList.Parrent = scroll

    local padding2 = Create("UIPadding")
    padding2.PaddingBottom = UDim.new(0, Padding)
    padding2.Parent = scroll

    local scrollPadding = Create("UIPadding")
    scrollPadding.PaddingRight = UDim.new(0, 8)
    scrollPadding.Parent = scroll

    if Draggable then
        MakeDraggable(titleFrame, window)
    end

    closeBtn.MouseButton1Click:Connect(function()
        Tween(window, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0),
            AnchorPoint = Vector2.new(0.5, 0.5)
        })
        wait(0.2)
        main:Destroy()
    end)

    local minimized = false
    miniBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            Tween(window, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, Size.X.Offset, 0, 50)
            })
        else
            Tween(window, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Size = Size
            })
        end
    end)

    local windowObj = setmetatable({
        Main = main,
        Window = window,
        Scroll = scroll,
        TabFrame = tabFrame,
        Tabs = {},
        CurrentTab = nil
    }, VoidUI)

    windowObj:OpenTab(Title)
    return windowObj
end

function VoidUI:Tab(name)
    local tabBtn = Create("TextButton")
    tabBtn.Size = UDim2.new(0, 0, 0, 28)
    tabBtn.AutomaticSize = Enum.AutomaticSize.X
    tabBtn.BackgroundColor3 = Theme.Panel
    tabBtn.BorderSizePixel = 0
    tabBtn.Text = "  " .. name .. "  "
    tabBtn.TextColor3 = Theme.TextSecondary
    tabBtn.AutoButtonColor = false
    tabBtn.Font = TitleFont
    tabBtn.TextSize = 12
    tabBtn.Parent = self.TabFrame

    local corner = Create("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = tabBtn

    local tabContent = Create("Frame")
    tabContent.Size = UDim2.new(1, 0, 1, 0)
    tabContent.BackgroundTransparency = 1
    tabContent.BorderSizePixel = 0
    tabContent.Visible = false
    tabContent.Parent = self.Scroll.Parent

    local list = Create("UIListLayout")
    list.Padding = UDim.new(0, 12)
    list.Parent = tabContent

    local contentPadding = Create("UIPadding")
    contentPadding.PaddingTop = UDim.new(0, 4)
    contentPadding.Parent = tabContent

    table.insert(self.Tabs, {
        Name = name,
        Button = tabBtn,
        Content = tabContent,
        Components = {}
    })

    tabBtn.MouseButton1Click:Connect(function()
        self:OpenTab(name)
    end)

    local tabObj = {
        Content = tabContent,
        Components = {}
    }

    function tabObj:Toggle(label, default, callback)
        default = default or false
        callback = callback or function() end

        local toggleFrame = Create("Frame")
        toggleFrame.Size = UDim2.new(1, 0, 0, 40)
        toggleFrame.BackgroundTransparency = 1
        toggleFrame.Parent = self.Content

        local labelTxt = CreateLabel(label, UDim2.new(1, -54, 0, 20), Theme.Text, toggleFrame)

        local toggle, circle = CreateToggleBg(toggleFrame)
        local currentState = default

        if currentState then
            toggle.BackgroundColor3 = Theme.Accent
            circle.Position = UDim2.new(1, -3, 0.5, 0)
            circle.AnchorPoint = Vector2.new(1, 0.5)
            circle.BackgroundColor3 = Theme.Text
        end

        local function UpdateToggle(state)
            currentState = state
            if state then
                Tween(toggle, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    BackgroundColor3 = Theme.Accent
                })
                Tween(circle, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                    Position = UDim2.new(1, -3, 0.5, 0),
                    AnchorPoint = Vector2.new(1, 0.5)
                })
                Tween(circle, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    BackgroundColor3 = Theme.Text
                })
            else
                Tween(toggle, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    BackgroundColor3 = Theme.Panel
                })
                Tween(circle, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                    Position = UDim2.new(0, 3, 0.5, 0),
                    AnchorPoint = Vector2.new(0, 0.5)
                })
                Tween(circle, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    BackgroundColor3 = Theme.TextSecondary
                })
            end
        end

        toggle.MouseButton1Click:Connect(function()
            UpdateToggle(not currentState)
            callback(currentState)
        end)

        local toggleObj = {
            Set = function(self, state)
                UpdateToggle(state)
                callback(state)
            end,
            Get = function()
                return currentState
            end
        }

        return toggleObj
    end

    function tabObj:Checkbox(label, default, callback)
        default = default or false
        callback = callback or function() end

        local checkboxFrame = Create("Frame")
        checkboxFrame.Size = UDim2.new(1, 0, 0, 32)
        checkboxFrame.BackgroundTransparency = 1
        checkboxFrame.Parent = self.Content

        local checkbox, check = CreateCheckboxBg(checkboxFrame)

        local labelTxt = CreateLabel(label, UDim2.new(1, -34, 0, 24), Theme.Text, checkboxFrame)
        labelTxt.Position = UDim2.new(0, 34, 0, 0)

        local currentState = default

        if currentState then
            check.Visible = true
            checkbox.BackgroundColor3 = Theme.Accent
        end

        local function UpdateCheckbox(state)
            currentState = state
            if state then
                check.Visible = true
                Tween(checkbox, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    BackgroundColor3 = Theme.Accent
                })
            else
                Tween(checkbox, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    BackgroundColor3 = Theme.Panel
                })
                check.Visible = false
            end
        end

        checkbox.MouseButton1Click:Connect(function()
            UpdateCheckbox(not currentState)
            callback(currentState)
        end)

        local checkboxObj = {
            Set = function(self, state)
                UpdateCheckbox(state)
                callback(state)
            end,
            Get = function()
                return currentState
            end
        }

        return checkboxObj
    end

    function tabObj:Button(text, callback, style)
        callback = callback or function() end
        style = style or "solid"

        local buttonFrame = Create("Frame")
        buttonFrame.Size = UDim2.new(1, 0, 0, 40)
        buttonFrame.BackgroundTransparency = 1
        buttonFrame.Parent = self.Content

        local btn = CreateButtonBg(buttonFrame)

        if style == "outline" then
            btn.BackgroundTransparency = 1
            local stroke = btn:FindFirstChild("UIStroke")
            if stroke then
                stroke.Color = Theme.Accent
            end
        end

        btn.Text = text

        local mouseIn = false
        btn.MouseEnter:Connect(function()
            mouseIn = true
            if style == "solid" then
                Tween(btn, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    BackgroundColor3 = Theme.AccentLight
                })
            else
                local stroke = btn:FindFirstChild("UIStroke")
                if stroke then
                    Tween(stroke, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                        Color = Theme.AccentLight
                    })
                end
            end
        end)

        btn.MouseLeave:Connect(function()
            mouseIn = false
            if style == "solid" then
                Tween(btn, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    BackgroundColor3 = Theme.Panel
                })
            else
                local stroke = btn:FindFirstChild("UIStroke")
                if stroke then
                    Tween(stroke, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                        Color = Theme.Accent
                    })
                end
            end
        end)

        btn.MouseButton1Down:Connect(function()
            if mouseIn then
                Tween(btn, TweenInfo.new(0.05, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Size = UDim2.new(1, -4, 0, 32)
                })
            end
        end)

        btn.MouseButton1Up:Connect(function()
            Tween(btn, TweenInfo.new(0.05, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Size = UDim2.new(1, 0, 0, 36)
            })
            if mouseIn then
                callback()
            end
        end)

        return btn
    end

    function tabObj:Input(label, placeholder, default, callback)
        placeholder = placeholder or ""
        default = default or ""
        callback = callback or function() end

        local inputFrame = Create("Frame")
        inputFrame.Size = UDim2.new(1, 0, 0, 60)
        inputFrame.BackgroundTransparency = 1
        inputFrame.Parent = self.Content

        local labelTxt = CreateLabel(label, UDim2.new(1, 0, 0, 20), Theme.Text, inputFrame)

        local input = CreateInputBg(inputFrame, UDim2.new(1, 0, 0, 36))
        input.Position = UDim2.new(0, 0, 0, 24)
        input.PlaceholderText = placeholder
        input.Text = default

        input.FocusLost:Connect(function()
            callback(input.Text)
        end)

        input.MouseEnter:Connect(function()
            local stroke = input:FindFirstChild("UIStroke")
            if stroke then
                Tween(stroke, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Color = Theme.Accent
                })
            end
        end)

        input.MouseLeave:Connect(function()
            local stroke = input:FindFirstChild("UIStroke")
            if stroke then
                Tween(stroke, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Color = Theme.Border
                })
            end
        end)

        return input
    end

    function tabObj:Slider(label, min, max, value, step, callback)
        min = min or 0
        max = max or 100
        value = value or 50
        step = step or 1
        callback = callback or function() end

        local sliderFrame = Create("Frame")
        sliderFrame.Size = UDim2.new(1, 0, 0, 56)
        sliderFrame.BackgroundTransparency = 1
        sliderFrame.Parent = self.Content

        local labelTxt = CreateLabel(label, UDim2.new(1, -40, 0, 20), Theme.Text, sliderFrame)

        local valueLabel = CreateLabel(tostring(value), UDim2.new(0, 40, 0, 20), Theme.TextSecondary, sliderLabel)
        valueLabel.Position = UDim2.new(1, -40, 0, 0)
        valueLabel.TextXAlignment = Enum.TextXAlignment.Right

        local sliderBg = Create("Frame")
        sliderBg.Size = UDim2.new(1, 0, 0, 8)
        sliderBg.Position = UDim2.new(0, 0, 0, 28)
        sliderBg.BackgroundColor3 = Theme.Panel
        sliderBg.BorderSizePixel = 0
        sliderBg.Parent = sliderFrame

        local sliderCorner = Create("UICorner")
        sliderCorner.CornerRadius = UDim.new(0, 4)
        sliderCorner.Parent = sliderBg

        local sliderFill = Create("Frame")
        local fillPercent = (value - min) / (max - min)
        sliderFill.Size = UDim2.new(fillPercent, 0, 1, 0)
        sliderFill.BackgroundColor3 = Theme.Accent
        sliderFill.BorderSizePixel = 0
        sliderFill.Parent = sliderBg

        local fillCorner = Create("UICorner")
        fillCorner.CornerRadius = UDim.new(0, 4)
        fillCorner.Parent = sliderFill

        local sliderBtn = Create("Frame")
        sliderBtn.Size = UDim2.new(0, 18, 0, 18)
        sliderBtn.Position = UDim2.new(fillPercent, 0, 0.5, 0)
        sliderBtn.AnchorPoint = Vector2.new(0.5, 0.5)
        sliderBtn.BackgroundColor3 = Theme.Text
        sliderBg.BorderSizePixel = 0
        sliderBtn.Parent = sliderBg

        local btnCorner = Create("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 9)
        btnCorner.Parent = sliderBtn

        local function UpdateSlider(percent)
            percent = math.clamp(percent, 0, 1)
            local newValue = math.round((min + (max - min) * percent) / step) * step
            
            Tween(sliderFill, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Size = UDim2.new(percent, 0, 1, 0)
            })
            Tween(sliderBtn, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Position = UDim2.new(percent, 0, 0.5, 0)
            })
            
            valueLabel.Text = tostring(newValue)
            callback(newValue)
        end

        local sliderActive = false
        sliderBg.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                sliderActive = true
            end
        end)

        sliderBg.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                sliderActive = false
            end
        end)

        sliderBg.InputChanged:Connect(function(input)
            if sliderActive then
                local relativeX = input.Position.X - sliderBg.AbsolutePosition.X
                local percent = relativeX / sliderBg.AbsoluteSize.X
                UpdateSlider(percent)
            end
        end)

        return {
            Set = function(self, val)
                local percent = (val - min) / (max - min)
                UpdateSlider(percent)
            end
        }
    end

    function tabObj:Dropdown(label, options, default, callback)
        default = default or 1
        callback = callback or function() end

        local dropdownFrame = Create("Frame")
        dropdownFrame.Size = UDim2.new(1, 0, 0, 60)
        dropdownFrame.BackgroundTransparency = 1
        dropdownFrame.Parent = self.Content

        local labelTxt = CreateLabel(label, UDim2.new(1, 0, 0, 20), Theme.Text, dropdownFrame)

        local dropdown = CreateButtonBg(dropdownFrame, UDim2.new(1, 0, 0, 36))
        dropdown.Position = UDim2.new(0, 0, 0, 24)
        dropdown.Text = options[default] or options[1]

        local arrow = Create("ImageLabel")
        arrow.Size = UDim2.new(0, 16, 0, 16)
        arrow.Position = UDim2.new(1, -12, 0.5, 0)
        arrow.AnchorPoint = Vector2.new(0.5, 0.5)
        arrow.BackgroundTransparency = 1
        arrow.Image = "http://www.roblox.com/asset/?id=7752724514"
        arrow.Rotation = 90
        arrow.ImageColor3 = Theme.TextSecondary
        arrow.Parent = dropdown

        local optionsFrame = Create("Frame")
        optionsFrame.Size = UDim2.new(1, 0, 0, 0)
        optionsFrame.Position = UDim2.new(0, 0, 0, 36)
        optionsFrame.BackgroundColor3 = Theme.PanelLight
        optionsFrame.BorderSizePixel = 0
        optionsFrame.Visible = false
        optionsFrame.ClipsDescendants = true
        optionsFrame.Parent = dropdown

        local corner = Create("UICorner")
        corner.CornerRadius = UDim.new(0, CornerRadius)
        corner.Parent = optionsFrame

        local optionsList = Create("UIListLayout")
        optionsList.Padding = UDim.new(0, 2)
        optionsList.Parent = optionsFrame

        local optionBtns = {}
        local selectedIndex = default

        for i, opt in ipairs(options) do
            local optBtn = Create("TextButton")
            optBtn.Size = UDim2.new(1, 0, 0, 32)
            optBtn.BackgroundTransparency = 1
            optBtn.BorderSizePixel = 0
            optBtn.Text = opt
            optBtn.TextColor3 = Theme.TextSecondary
            optBtn.TextXAlignment = Enum.TextXAlignment.Left
            optBtn.Font = Font
            optBtn.TextSize = 14
            optBtn.AutoButtonColor = false
            optBtn.Parent = optionsFrame

            optBtn.MouseButton1Click:Connect(function()
                selectedIndex = i
                dropdown.Text = opt
                optionsFrame.Visible = false
                callback(opt, i)
            end)

            optBtn.MouseEnter:Connect(function()
                optBtn.BackgroundColor3 = Theme.Panel
                optBtn.TextColor3 = Theme.Text
            end)

            optBtn.MouseLeave:Connect(function()
                optBtn.BackgroundTransparency = 1
                optBtn.TextColor3 = Theme.TextSecondary
            end)

            table.insert(optionBtns, optBtn)
        end

        local function UpdateDropdown()
            optionsFrame.Size = UDim2.new(1, 0, 0, #options * 34 - 2)
        end

        dropdown.MouseButton1Click:Connect(function()
            optionsFrame.Visible = not optionsFrame.Visible
            Tween(arrow, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Rotation = optionsFrame.Visible and -90 or 90
            })
        end)

        UpdateDropdown()

        return {
            Set = function(self, index)
                selectedIndex = index
                dropdown.Text = options[index]
                callback(options[index], index)
            end,
            Get = function()
                return options[selectedIndex], selectedIndex
            end
        }
    end

    function tabObj:ColorPicker(label, default, callback)
        default = default or Color3.new(1, 0, 0)
        callback = callback or function() end

        local pickerFrame = Create("Frame")
        pickerFrame.Size = UDim2.new(1, 0, 0, 60)
        pickerFrame.BackgroundTransparency = 1
        pickerFrame.Parent = self.Content

        local labelTxt = CreateLabel(label, UDim2.new(1, -54, 0, 20), Theme.Text, pickerFrame)

        local previewSize = UDim2.new(0, 40, 0, 40)
        local preview = Create("Frame")
        preview.Size = previewSize
        preview.Position = UDim2.new(1, -44, 0, 20)
        preview.BackgroundColor3 = default
        preview.BorderSizePixel = 0
        preview.Parent = pickerFrame

        local corner = Create("UICorner")
        corner.CornerRadius = UDim.new(0, CornerRadius)
        corner.Parent = preview

        local pickerUI, hueFrame, satFrame, previewFrame, saveBtn = CreateColorPickerUI(pickerFrame)

        local hue, sat = 0, 1
        local currentColor = default

        local function UpdateColor(h, s, v)
            local color = Color3.fromHSV(h, s, v)
            currentColor = color
            preview.BackgroundColor3 = color
            previewFrame.BackgroundColor3 = color
            callback(color)
        end

        preview.MouseButton1Click:Connect(function()
            pickerUI.Visible = not pickerUI.Visible
        end)

        saveBtn.MouseButton1Click:Connect(function()
            pickerUI.Visible = false
            callback(currentColor)
        end)

        local hueActive = false
        hueFrame.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                hueActive = true
            end
        end)

        hueFrame.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                hueActive = false
            end
        end)

        hueFrame.InputChanged:Connect(function(input)
            if hueActive then
                local relX = input.Position.X - hueFrame.AbsolutePosition.X
                local percent = math.clamp(relX / hueFrame.AbsoluteSize.X, 0, 1)
                hue = percent
                hueFrame.BackgroundColor3 = Color3.fromHSV(percent, 1, 1)
                satFrame.BackgroundColor3 = Color3.fromHSV(percent, 1, 1)
                UpdateColor(hue, sat, 1)
            end
        end)

        local satActive = false
        satFrame.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                satActive = true
            end
        end)

        satFrame.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                satActive = false
            end
        end)

        satFrame.InputChanged:Connect(function(input)
            if satActive then
                local relX = input.Position.X - satFrame.AbsolutePosition.X
                local percent = math.clamp(relX / satFrame.AbsoluteSize.X, 0, 1)
                sat = percent
                UpdateColor(hue, sat, 1)
            end
        end)

        UpdateColor(hue, sat, 1)
        hueFrame.BackgroundColor3 = Color3.fromHSV(hue, 1, 1)
        satFrame.BackgroundColor3 = Color3.fromHSV(0, 1, 1)

        return {
            Set = function(self, color)
                currentColor = color
                preview.BackgroundColor3 = color
                previewFrame.BackgroundColor3 = color
                callback(color)
            end,
            Get = function()
                return currentColor
            end
        }
    end

    function tabObj:ProgressBar(label, value)
        value = value or 0

        local progressFrame = Create("Frame")
        progressFrame.Size = UDim2.new(1, 0, 0, 40)
        progressFrame.BackgroundTransparency = 1
        progressFrame.Parent = self.Content

        local labelTxt = CreateLabel(label or "Progress", UDim2.new(1, -40, 0, 20), Theme.Text, progressFrame)

        local valueLabel = CreateLabel(tostring(value) .. "%", UDim2.new(0, 40, 0, 20), Theme.TextSecondary, progressFrame)
        valueLabel.Position = UDim2.new(1, -40, 0, 0)
        valueLabel.TextXAlignment = Enum.TextXAlignment.Right

        local barBg = Create("Frame")
        barBg.Size = UDim2.new(1, 0, 0, 8)
        barBg.Position = UDim2.new(0, 0, 0, 28)
        barBg.BackgroundColor3 = Theme.Panel
        barBg.BorderSizePixel = 0
        barBg.Parent = progressFrame

        local barCorner = Create("UICorner")
        barCorner.CornerRadius = UDim.new(0, 4)
        barCorner.Parent = barBg

        local barFill = Create("Frame")
        barFill.Size = UDim2.new(value / 100, 0, 1, 0)
        barFill.BackgroundColor3 = Theme.Accent
        barFill.BorderSizePixel = 0
        barFill.Parent = barBg

        local fillCorner = Create("UICorner")
        fillCorner.CornerRadius = UDim.new(0, 4)
        fillCorner.Parent = barFill

        return {
            Set = function(self, val)
                value = math.clamp(val, 0, 100)
                valueLabel.Text = tostring(value) .. "%"
                Tween(barFill, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Size = UDim2.new(value / 100, 0, 1, 0)
                })
            end,
            Get = function()
                return value
            end
        }
    end

    function tabObj:Label(text, size)
        size = size or 16

        local labelFrame = Create("Frame")
        labelFrame.Size = UDim2.new(1, 0, 0, size + 4)
        labelFrame.BackgroundTransparency = 1
        labelFrame.Parent = self.Content

        local label = CreateLabel(text, UDim2.new(1, 0, 0, size), Theme.TextSecondary, labelFrame)
        label.TextSize = size

        return label
    end

    function tabObj:Separator()
        local sep = Create("Frame")
        sep.Size = UDim2.new(1, 0, 0, 1)
        sep.BackgroundColor3 = Theme.Border
        sep.BorderSizePixel = 0
        sep.Parent = self.Content

        return sep
    end

    function tabObj:Title(text)
        local titleFrame = Create("Frame")
        titleFrame.Size = UDim2.new(1, 0, 0, 24)
        titleFrame.BackgroundTransparency = 1
        titleFrame.Parent = self.Content

        local title = CreateLabel(text, UDim2.new(1, 0, 0, 24), Theme.Text, titleFrame)
        title.TextSize = 18

        return title
    end

    return tabObj
end

function VoidUI:OpenTab(name)
    for _, tab in ipairs(self.Tabs) do
        if tab.Name == name then
            tab.Content.Visible = true
            tab.Button.BackgroundColor3 = Theme.Accent
            tab.Button.TextColor3 = Theme.Text
            self.CurrentTab = tab
        else
            tab.Content.Visible = false
            tab.Button.BackgroundColor3 = Theme.Panel
            tab.Button.TextColor3 = Theme.TextSecondary
        end
    end
end

function VoidUI:Notification(message, duration)
    duration = duration or 3

    local notif = Create("ScreenGui")
    notif.Name = "VoidUI_Notification"
    notif.DisplayOrder = 1000
    notif.IgnoreGuiInset = true
    notif.Parent = game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui")

    local notifFrame = Create("Frame")
    notifFrame.Size = UDim2.new(0, 300, 0, 50)
    notifFrame.Position = UDim2.new(1, -320, 0, 20)
    notifFrame.BackgroundColor3 = Theme.PanelLight
    notifFrame.BorderSizePixel = 0
    notifFrame.Parent = notifFrame

    local corner = Create("UICorner")
    corner.CornerRadius = UDim.new(0, CornerRadius)
    corner.Parent = notifFrame

    local padding = Create("UIPadding")
    padding.PaddingAll = UDim.new(0, Padding)
    padding.Parent = notifFrame

    local label = CreateLabel(message, UDim2.new(1, 0, 0, 26), Theme.Text, notifFrame)
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left

    local progress = Create("Frame")
    progress.Size = UDim2.new(1, 0, 0, 2)
    progress.Position = UDim2.new(0, 0, 1, -2)
    progress.BackgroundColor3 = Theme.Accent
    progress.BorderSizePixel = 0
    progress.Parent = notifFrame

    Tween(notifFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Position = UDim2.new(1, -320, 0, 20)
    })

    wait(0.3)

    Tween(progress, TweenInfo.new(duration, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 0, 0, 2)
    })

    wait(duration)

    Tween(notifFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        Position = UDim2.new(1, 20, 0, 20)
    })

    wait(0.3)
    notif:Destroy()
end

function VoidUI:CreateFree(config)
    config = config or {}
    local Parent = config.Parent

    local free = setmetatable({
        Parent = Parent
    }, VoidUI)

    return free
end

return function(config)
    return VoidUI:CreateWindow(config)
end