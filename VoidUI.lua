local function CreateWindow(config)
    local TweenService = game:GetService("TweenService")
    local Players = game:GetService("Players")

    local Theme = {
        Background = Color3.fromRGB(13, 13, 13),
        Panel = Color3.fromRGB(26, 26, 26),
        PanelLight = Color3.fromRGB(37, 37, 37),
        Accent = Color3.fromRGB(139, 92, 246),
        Text = Color3.fromRGB(255, 255, 255),
        TextSecondary = Color3.fromRGB(160, 160, 160),
        Border = Color3.fromRGB(51, 51, 51),
    }

    local PADDING = 12
    local CORNER = 8

    config = config or {}
    local title = config.Title or "VoidUI"
    local size = config.Size or UDim2.new(0, 500, 0, 400)

    local gui = Instance.new("ScreenGui")
    gui.Name = "VoidUI"
    gui.DisplayOrder = 999
    gui.IgnoreGuiInset = true
    gui.Parent = Players.LocalPlayer.PlayerGui

    local frame = Instance.new("Frame")
    frame.Size = size
    frame.Position = UDim2.new(0.5, -size.X.Offset/2, 0.5, -size.Y.Offset/2)
    frame.BackgroundColor3 = Theme.Background
    frame.BorderSizePixel = 0
    frame.ClipsDescendants = true
    frame.Parent = gui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, CORNER + 2)
    corner.Parent = frame

    local top = Instance.new("Frame")
    top.Size = UDim2.new(1, 0, 0, 50)
    top.BackgroundColor3 = Theme.PanelLight
    top.BorderSizePixel = 0
    top.Parent = frame

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -80, 0, 50)
    titleLabel.Position = UDim2.new(0, PADDING, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = Theme.Text
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 16
    titleLabel.Parent = top

    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 32, 0, 32)
    closeBtn.Position = UDim2.new(1, -42, 0.5, 0)
    closeBtn.AnchorPoint = Vector2.new(0.5, 0.5)
    closeBtn.BackgroundColor3 = Theme.Panel
    closeBtn.BorderSizePixel = 0
    closeBtn.Text = "X"
    closeBtn.TextColor3 = Theme.TextSecondary
    closeBtn.AutoButtonColor = false
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 14
    closeBtn.Parent = top

    local tabFrame = Instance.new("Frame")
    tabFrame.Size = UDim2.new(1, 0, 0, 44)
    tabFrame.Position = UDim2.new(0, 0, 0, 50)
    tabFrame.BackgroundColor3 = Theme.Background
    tabFrame.BorderSizePixel = 0
    tabFrame.Parent = frame

    local tabList = Instance.new("UIListLayout")
    tabList.FillDirection = Enum.FillDirection.Horizontal
    tabList.Padding = UDim.new(0, 4)
    tabList.PaddingLeft = UDim.new(0, PADDING)
    tabList.PaddingTop = UDim.new(0, 8)
    tabList.Parent = tabFrame

    local content = Instance.new("ScrollingFrame")
    content.Size = UDim2.new(1, -PADDING*2, 1, -130)
    content.Position = UDim2.new(0, PADDING, 0, 94)
    content.BackgroundTransparency = 1
    content.BorderSizePixel = 0
    content.ScrollBarThickness = 0
    content.Parent = frame

    local contentList = Instance.new("UIListLayout")
    contentList.Padding = UDim.new(0, PADDING)
    contentList.Parent = content

    closeBtn.MouseButton1Click:Connect(function()
        gui:Destroy()
    end)

    local tabs = {}
    local window = {}

    function window:Tab(name)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 0, 0, 28)
        btn.AutomaticSize = Enum.AutomaticSize.X
        btn.BackgroundColor3 = Theme.Panel
        btn.BorderSizePixel = 0
        btn.Text = "  " .. name .. "  "
        btn.TextColor3 = Theme.TextSecondary
        btn.AutoButtonColor = false
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 12
        btn.Parent = tabFrame

        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 6)
        btnCorner.Parent = btn

        local tabContent = Instance.new("Frame")
        tabContent.Size = UDim2.new(1, 0, 1, 0)
        tabContent.BackgroundTransparency = 1
        tabContent.BorderSizePixel = 0
        tabContent.Visible = false
        tabContent.Parent = content

        local list = Instance.new("UIListLayout")
        list.Padding = UDim.new(0, 12)
        list.Parent = tabContent

        table.insert(tabs, {Name = name, Button = btn, Content = tabContent})

        local function openTab(tname)
            for _, t in ipairs(tabs) do
                t.Content.Visible = (t.Name == tname)
                t.Button.BackgroundColor3 = (t.Name == tname) and Theme.Accent or Theme.Panel
                t.Button.TextColor3 = (t.Name == tname) and Theme.Text or Theme.TextSecondary
            end
        end

        btn.MouseButton1Click:Connect(function() openTab(name) end)
        openTab(name)

        local tab = {}

        function tab:Toggle(label, default, callback)
            default = default or false
            callback = callback or function() end

            local container = Instance.new("Frame")
            container.Size = UDim2.new(1, 0, 0, 40)
            container.BackgroundTransparency = 1
            container.Parent = tabContent

            local label_ = Instance.new("TextLabel")
            label_.Size = UDim2.new(1, -54, 0, 20)
            label_.BackgroundTransparency = 1
            label_.Text = label
            label_.TextColor3 = Theme.Text
            label_.TextXAlignment = Enum.TextXAlignment.Left
            label_.Font = Enum.Font.GothamBold
            label_.TextSize = 14
            label_.Parent = container

            local toggle = Instance.new("TextButton")
            toggle.Size = UDim2.new(0, 44, 0, 24)
            toggle.Position = UDim2.new(1, -48, 0.5, 0)
            toggle.AnchorPoint = Vector2.new(0, 0.5)
            toggle.BackgroundColor3 = default and Theme.Accent or Theme.Panel
            toggle.BorderSizePixel = 0
            toggle.Text = ""
            toggle.AutoButtonColor = false
            toggle.Parent = container

            local toggleCorner = Instance.new("UICorner")
            toggleCorner.CornerRadius = UDim.new(0, 12)
            toggleCorner.Parent = toggle

            local circle = Instance.new("Frame")
            circle.Size = UDim2.new(0, 18, 0, 18)
            circle.Position = default and UDim2.new(1, -3, 0.5, 0) or UDim2.new(0, 3, 0.5, 0)
            circle.AnchorPoint = default and Vector2.new(1, 0.5) or Vector2.new(0, 0.5)
            circle.BackgroundColor3 = Theme.Text
            circle.BorderSizePixel = 0
            circle.Parent = toggle

            local circleCorner = Instance.new("UICorner")
            circleCorner.CornerRadius = UDim.new(0, 9)
            circleCorner.Parent = circle

            local state = default
            toggle.MouseButton1Click:Connect(function()
                state = not state
                toggle.BackgroundColor3 = state and Theme.Accent or Theme.Panel
                circle.Position = state and UDim2.new(1, -3, 0.5, 0) or UDim2.new(0, 3, 0.5, 0)
                circle.AnchorPoint = state and Vector2.new(1, 0.5) or Vector2.new(0, 0.5)
                callback(state)
            end)
        end

        function tab:Button(text, callback, style)
            callback = callback or function() end
            style = style or "solid"

            local container = Instance.new("Frame")
            container.Size = UDim2.new(1, 0, 0, 40)
            container.BackgroundTransparency = 1
            container.Parent = tabContent

            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, 0, 0, 36)
            btn.BackgroundColor3 = Theme.Panel
            btn.BorderSizePixel = 0
            btn.Text = text
            btn.TextColor3 = Theme.Text
            btn.AutoButtonColor = false
            btn.Font = Enum.Font.GothamBold
            btn.TextSize = 14
            btn.Parent = container

            local btnCorner = Instance.new("UICorner")
            btnCorner.CornerRadius = UDim.new(0, CORNER)
            btnCorner.Parent = btn

            if style == "outline" then
                btn.BackgroundTransparency = 1
                local stroke = Instance.new("UIStroke")
                stroke.Thickness = 1
                stroke.Color = Theme.Accent
                stroke.Parent = btn
            end

            btn.MouseButton1Click:Connect(callback)
        end

        function tab:Label(text, size)
            size = size or 16
            local container = Instance.new("Frame")
            container.Size = UDim2.new(1, 0, 0, size + 4)
            container.BackgroundTransparency = 1
            container.Parent = tabContent

            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, 0, 0, size)
            label.BackgroundTransparency = 1
            label.Text = text
            label.TextColor3 = Theme.TextSecondary
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Font = Enum.Font.Gotham
            label.TextSize = size
            label.Parent = container
        end

        function tab:Separator()
            local sep = Instance.new("Frame")
            sep.Size = UDim2.new(1, 0, 0, 1)
            sep.BackgroundColor3 = Theme.Border
            sep.BorderSizePixel = 0
            sep.Parent = tabContent
        end

        function tab:Title(text)
            local container = Instance.new("Frame")
            container.Size = UDim2.new(1, 0, 0, 24)
            container.BackgroundTransparency = 1
            container.Parent = tabContent

            local title = Instance.new("TextLabel")
            title.Size = UDim2.new(1, 0, 0, 24)
            title.BackgroundTransparency = 1
            title.Text = text
            title.TextColor3 = Theme.Text
            title.TextXAlignment = Enum.TextXAlignment.Left
            title.Font = Enum.Font.GothamBold
            title.TextSize = 18
            title.Parent = container
        end

        return tab
    end

    return window
end

return CreateWindow
