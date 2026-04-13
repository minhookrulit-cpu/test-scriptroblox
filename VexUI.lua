--[[
    ██████╗ ██████╗ ██╗  ██╗██╗   ██╗██╗
    ██╔══██╗██╔══██╗╚██╗██╔╝██║   ██║██║
    ██████╔╝██████╔╝ ╚███╔╝ ██║   ██║██║
    ██╔══██╗██╔══██╗ ██╔██╗ ██║   ██║██║
    ██║  ██║██████╔╝██╔╝ ██╗╚██████╔╝██║
    ╚═╝  ╚═╝╚═════╝ ╚═╝  ╚═╝ ╚═════╝ ╚═╝
    
    RbxUI Library — Fatality-style UI for Roblox
    Version: 2.0.0
    
    Usage:
        local UI = loadstring(game:HttpGet("..."))()
        local Window = UI:CreateWindow({ Title = "My Menu", Theme = "Dark" })
        local Tab = Window:AddTab("Main")
        Tab:AddButton("Click me", function() print("clicked!") end)
        Tab:AddToggle("Enable Aimbot", false, function(v) print(v) end)
--]]

local RbxUI = {}
RbxUI.__index = RbxUI

-- ═══════════════════════════════════════════════════════
--  SERVICES
-- ═══════════════════════════════════════════════════════
local Players       = game:GetService("Players")
local TweenService  = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService    = game:GetService("RunService")
local CoreGui       = game:GetService("CoreGui")

local LocalPlayer   = Players.LocalPlayer
local Mouse         = LocalPlayer:GetMouse()

-- ═══════════════════════════════════════════════════════
--  THEMES
-- ═══════════════════════════════════════════════════════
RbxUI.Themes = {
    Dark = {
        Background      = Color3.fromRGB(15, 15, 20),
        Surface         = Color3.fromRGB(22, 22, 30),
        Surface2        = Color3.fromRGB(30, 30, 42),
        Border          = Color3.fromRGB(50, 50, 70),
        Accent          = Color3.fromRGB(0, 180, 255),
        AccentDark      = Color3.fromRGB(0, 100, 180),
        Text            = Color3.fromRGB(220, 220, 235),
        TextMuted       = Color3.fromRGB(110, 110, 140),
        Success         = Color3.fromRGB(30, 200, 120),
        Danger          = Color3.fromRGB(220, 50, 80),
        Warning         = Color3.fromRGB(230, 165, 30),
        ToggleOff       = Color3.fromRGB(55, 55, 75),
        ToggleOn        = Color3.fromRGB(0, 180, 255),
        TabActive       = Color3.fromRGB(0, 180, 255),
        TabInactive     = Color3.fromRGB(30, 30, 42),
        ScrollBar       = Color3.fromRGB(0, 180, 255),
        Overlay         = Color3.fromRGB(8, 8, 12),
    },
    Fatality = {
        Background      = Color3.fromRGB(12, 12, 16),
        Surface         = Color3.fromRGB(18, 18, 25),
        Surface2        = Color3.fromRGB(25, 25, 35),
        Border          = Color3.fromRGB(45, 45, 65),
        Accent          = Color3.fromRGB(200, 50, 90),
        AccentDark      = Color3.fromRGB(140, 30, 60),
        Text            = Color3.fromRGB(210, 210, 225),
        TextMuted       = Color3.fromRGB(100, 100, 130),
        Success         = Color3.fromRGB(30, 190, 110),
        Danger          = Color3.fromRGB(200, 50, 90),
        Warning         = Color3.fromRGB(220, 155, 30),
        ToggleOff       = Color3.fromRGB(50, 50, 68),
        ToggleOn        = Color3.fromRGB(200, 50, 90),
        TabActive       = Color3.fromRGB(200, 50, 90),
        TabInactive     = Color3.fromRGB(25, 25, 35),
        ScrollBar       = Color3.fromRGB(200, 50, 90),
        Overlay         = Color3.fromRGB(6, 6, 10),
    },
    Purple = {
        Background      = Color3.fromRGB(10, 8, 18),
        Surface         = Color3.fromRGB(16, 13, 28),
        Surface2        = Color3.fromRGB(22, 18, 40),
        Border          = Color3.fromRGB(55, 45, 80),
        Accent          = Color3.fromRGB(150, 80, 255),
        AccentDark      = Color3.fromRGB(90, 40, 180),
        Text            = Color3.fromRGB(215, 210, 235),
        TextMuted       = Color3.fromRGB(110, 100, 145),
        Success         = Color3.fromRGB(30, 200, 120),
        Danger          = Color3.fromRGB(220, 60, 80),
        Warning         = Color3.fromRGB(230, 165, 30),
        ToggleOff       = Color3.fromRGB(50, 45, 68),
        ToggleOn        = Color3.fromRGB(150, 80, 255),
        TabActive       = Color3.fromRGB(150, 80, 255),
        TabInactive     = Color3.fromRGB(22, 18, 40),
        ScrollBar       = Color3.fromRGB(150, 80, 255),
        Overlay         = Color3.fromRGB(5, 4, 12),
    },
    Green = {
        Background      = Color3.fromRGB(8, 14, 10),
        Surface         = Color3.fromRGB(12, 20, 15),
        Surface2        = Color3.fromRGB(18, 28, 22),
        Border          = Color3.fromRGB(40, 65, 50),
        Accent          = Color3.fromRGB(30, 210, 120),
        AccentDark      = Color3.fromRGB(15, 140, 70),
        Text            = Color3.fromRGB(200, 225, 210),
        TextMuted       = Color3.fromRGB(90, 120, 100),
        Success         = Color3.fromRGB(30, 210, 120),
        Danger          = Color3.fromRGB(220, 60, 80),
        Warning         = Color3.fromRGB(220, 165, 30),
        ToggleOff       = Color3.fromRGB(40, 60, 48),
        ToggleOn        = Color3.fromRGB(30, 210, 120),
        TabActive       = Color3.fromRGB(30, 210, 120),
        TabInactive     = Color3.fromRGB(18, 28, 22),
        ScrollBar       = Color3.fromRGB(30, 210, 120),
        Overlay         = Color3.fromRGB(4, 7, 5),
    },
    Light = {
        Background      = Color3.fromRGB(240, 240, 248),
        Surface         = Color3.fromRGB(255, 255, 255),
        Surface2        = Color3.fromRGB(230, 230, 242),
        Border          = Color3.fromRGB(200, 200, 220),
        Accent          = Color3.fromRGB(80, 100, 240),
        AccentDark      = Color3.fromRGB(50, 70, 200),
        Text            = Color3.fromRGB(20, 20, 40),
        TextMuted       = Color3.fromRGB(130, 130, 160),
        Success         = Color3.fromRGB(20, 160, 90),
        Danger          = Color3.fromRGB(200, 40, 65),
        Warning         = Color3.fromRGB(190, 130, 10),
        ToggleOff       = Color3.fromRGB(195, 195, 215),
        ToggleOn        = Color3.fromRGB(80, 100, 240),
        TabActive       = Color3.fromRGB(80, 100, 240),
        TabInactive     = Color3.fromRGB(230, 230, 242),
        ScrollBar       = Color3.fromRGB(80, 100, 240),
        Overlay         = Color3.fromRGB(220, 220, 235),
    },
}

-- ═══════════════════════════════════════════════════════
--  UTILITIES
-- ═══════════════════════════════════════════════════════
local function Tween(obj, props, t, style, dir)
    local info = TweenInfo.new(t or 0.2, style or Enum.EasingStyle.Quad, dir or Enum.EasingDirection.Out)
    TweenService:Create(obj, info, props):Play()
end

local function SpringTween(obj, props, t)
    local info = TweenInfo.new(t or 0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    TweenService:Create(obj, info, props):Play()
end

local function Create(class, props, children)
    local obj = Instance.new(class)
    for k, v in pairs(props or {}) do
        if k ~= "Parent" then obj[k] = v end
    end
    for _, child in ipairs(children or {}) do
        child.Parent = obj
    end
    if props and props.Parent then obj.Parent = props.Parent end
    return obj
end

local function MakeDraggable(frame, handle)
    handle = handle or frame
    local dragging, dragInput, dragStart, startPos

    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
        end
    end)

    handle.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    handle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
end

local function HSVtoRGB(h, s, v)
    if s == 0 then return v, v, v end
    local i = math.floor(h * 6)
    local f = h * 6 - i
    local p, q, t2 = v*(1-s), v*(1-f*s), v*(1-(1-f)*s)
    i = i % 6
    if i==0 then return v,t2,p elseif i==1 then return q,v,p
    elseif i==2 then return p,v,t2 elseif i==3 then return p,q,v
    elseif i==4 then return t2,p,v else return v,p,q end
end

local function RGBtoHSV(r, g, b)
    local maxC = math.max(r,g,b)
    local minC = math.min(r,g,b)
    local v = maxC
    local s = maxC == 0 and 0 or (maxC-minC)/maxC
    if maxC == minC then return 0, s, v end
    local h
    local d = maxC - minC
    if maxC == r then h = (g-b)/d + (g < b and 6 or 0)
    elseif maxC == g then h = (b-r)/d + 2
    else h = (r-g)/d + 4 end
    return h/6, s, v
end

-- ═══════════════════════════════════════════════════════
--  WINDOW CONSTRUCTOR
-- ═══════════════════════════════════════════════════════
function RbxUI:CreateWindow(config)
    config = config or {}
    local title    = config.Title   or "RbxUI Menu"
    local subtitle = config.Subtitle or "v2.0"
    local themeName = config.Theme  or "Dark"
    local width    = config.Width   or 560
    local height   = config.Height  or 420
    local position = config.Position or UDim2.new(0.5, -width/2, 0.5, -height/2)

    local theme = RbxUI.Themes[themeName] or RbxUI.Themes.Dark

    local Window = { Tabs = {}, ActiveTab = nil, Theme = theme, ThemeName = themeName }

    -- ── ScreenGui ─────────────────────────────────────
    local ScreenGui = Create("ScreenGui", {
        Name = "RbxUI_" .. title,
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    })
    pcall(function() ScreenGui.Parent = CoreGui end)
    if not ScreenGui.Parent then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

    -- ── Main Frame ────────────────────────────────────
    local Main = Create("Frame", {
        Name = "Main",
        Size = UDim2.new(0, width, 0, height),
        Position = position,
        BackgroundColor3 = theme.Background,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Parent = ScreenGui,
    })
    Create("UICorner", { CornerRadius = UDim.new(0,8), Parent = Main })

    -- Drop shadow via ImageLabel
    local Shadow = Create("ImageLabel", {
        Name = "Shadow",
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, 6),
        Size = UDim2.new(1, 40, 1, 40),
        BackgroundTransparency = 1,
        Image = "rbxassetid://6014261993",
        ImageColor3 = Color3.fromRGB(0,0,0),
        ImageTransparency = 0.55,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(49,49,450,450),
        ZIndex = 0,
        Parent = Main,
    })

    -- Accent top stripe
    local AccentBar = Create("Frame", {
        Name = "AccentBar",
        Size = UDim2.new(1, 0, 0, 2),
        Position = UDim2.new(0,0,0,0),
        BackgroundColor3 = theme.Accent,
        BorderSizePixel = 0,
        ZIndex = 5,
        Parent = Main,
    })

    -- ── Title Bar ─────────────────────────────────────
    local TitleBar = Create("Frame", {
        Name = "TitleBar",
        Size = UDim2.new(1, 0, 0, 42),
        Position = UDim2.new(0,0,0,2),
        BackgroundColor3 = theme.Surface,
        BorderSizePixel = 0,
        ZIndex = 3,
        Parent = Main,
    })

    -- Title text
    Create("TextLabel", {
        Name = "Title",
        Size = UDim2.new(1, -100, 1, 0),
        Position = UDim2.new(0, 14, 0, 0),
        BackgroundTransparency = 1,
        Font = Font.new("rbxassetid://12289867853", Enum.FontWeight.Bold),
        Text = title,
        TextColor3 = theme.Text,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 4,
        Parent = TitleBar,
    })

    -- Subtitle
    Create("TextLabel", {
        Name = "Subtitle",
        Size = UDim2.new(0, 60, 1, 0),
        Position = UDim2.new(0, 14 + #title * 8, 0, 0),
        BackgroundTransparency = 1,
        Font = Font.new("rbxassetid://12289867853", Enum.FontWeight.Regular),
        Text = subtitle,
        TextColor3 = theme.TextMuted,
        TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 4,
        Parent = TitleBar,
    })

    -- Close button
    local CloseBtn = Create("TextButton", {
        Name = "Close",
        Size = UDim2.new(0, 28, 0, 28),
        Position = UDim2.new(1, -36, 0, 7),
        BackgroundColor3 = theme.Surface2,
        BorderSizePixel = 0,
        Font = Font.new("rbxassetid://12289867853", Enum.FontWeight.Bold),
        Text = "×",
        TextColor3 = theme.TextMuted,
        TextSize = 18,
        ZIndex = 4,
        Parent = TitleBar,
    })
    Create("UICorner", { CornerRadius = UDim.new(0,6), Parent = CloseBtn })

    CloseBtn.MouseEnter:Connect(function()
        Tween(CloseBtn, { BackgroundColor3 = theme.Danger, TextColor3 = Color3.fromRGB(255,255,255) })
    end)
    CloseBtn.MouseLeave:Connect(function()
        Tween(CloseBtn, { BackgroundColor3 = theme.Surface2, TextColor3 = theme.TextMuted })
    end)
    CloseBtn.MouseButton1Click:Connect(function()
        Tween(Main, { Size = UDim2.new(0, width, 0, 0), Position = UDim2.new(position.X.Scale, position.X.Offset, position.Y.Scale, position.Y.Offset + height/2) }, 0.3)
        task.wait(0.3)
        ScreenGui:Destroy()
    end)

    -- Minimize button
    local MinBtn = Create("TextButton", {
        Name = "Minimize",
        Size = UDim2.new(0, 28, 0, 28),
        Position = UDim2.new(1, -68, 0, 7),
        BackgroundColor3 = theme.Surface2,
        BorderSizePixel = 0,
        Font = Font.new("rbxassetid://12289867853", Enum.FontWeight.Bold),
        Text = "−",
        TextColor3 = theme.TextMuted,
        TextSize = 16,
        ZIndex = 4,
        Parent = TitleBar,
    })
    Create("UICorner", { CornerRadius = UDim.new(0,6), Parent = MinBtn })

    local minimized = false
    MinBtn.MouseEnter:Connect(function() Tween(MinBtn, { BackgroundColor3 = theme.Border }) end)
    MinBtn.MouseLeave:Connect(function() Tween(MinBtn, { BackgroundColor3 = theme.Surface2 }) end)
    MinBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            Tween(Main, { Size = UDim2.new(0, width, 0, 44) }, 0.25)
        else
            Tween(Main, { Size = UDim2.new(0, width, 0, height) }, 0.25)
        end
    end)

    MakeDraggable(Main, TitleBar)

    -- ── Tab Bar ───────────────────────────────────────
    local TabBar = Create("Frame", {
        Name = "TabBar",
        Size = UDim2.new(1, 0, 0, 34),
        Position = UDim2.new(0, 0, 0, 44),
        BackgroundColor3 = theme.Surface,
        BorderSizePixel = 0,
        ZIndex = 3,
        Parent = Main,
    })

    -- Bottom border on tab bar
    Create("Frame", {
        Size = UDim2.new(1, 0, 0, 1),
        Position = UDim2.new(0, 0, 1, -1),
        BackgroundColor3 = theme.Border,
        BorderSizePixel = 0,
        ZIndex = 3,
        Parent = TabBar,
    })

    local TabList = Create("Frame", {
        Name = "TabList",
        Size = UDim2.new(1, -10, 1, 0),
        Position = UDim2.new(0, 8, 0, 0),
        BackgroundTransparency = 1,
        ZIndex = 3,
        Parent = TabBar,
    })
    Create("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        SortOrder = Enum.SortOrder.LayoutOrder,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        Padding = UDim.new(0, 2),
        Parent = TabList,
    })

    -- Accent indicator line for active tab
    local TabIndicator = Create("Frame", {
        Name = "TabIndicator",
        Size = UDim2.new(0, 0, 0, 2),
        Position = UDim2.new(0, 0, 1, -1),
        BackgroundColor3 = theme.Accent,
        BorderSizePixel = 0,
        ZIndex = 5,
        Parent = TabBar,
    })

    -- ── Content Area ──────────────────────────────────
    local ContentArea = Create("Frame", {
        Name = "ContentArea",
        Size = UDim2.new(1, 0, 1, -78),
        Position = UDim2.new(0, 0, 0, 78),
        BackgroundColor3 = theme.Background,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        ZIndex = 2,
        Parent = Main,
    })

    -- ── Entry animation ───────────────────────────────
    Main.Size = UDim2.new(0, width, 0, 0)
    Main.Position = UDim2.new(position.X.Scale, position.X.Offset, position.Y.Scale, position.Y.Offset + 30)
    SpringTween(Main, {
        Size = UDim2.new(0, width, 0, height),
        Position = position,
    }, 0.5)

    -- ══════════════════════════════════════════════════
    --  THEME SWITCHER (Runtime)
    -- ══════════════════════════════════════════════════
    function Window:SetTheme(name)
        local t = RbxUI.Themes[name]
        if not t then return end
        self.Theme = t
        self.ThemeName = name
        theme = t

        Tween(Main,      { BackgroundColor3 = t.Background })
        Tween(TitleBar,  { BackgroundColor3 = t.Surface })
        Tween(TabBar,    { BackgroundColor3 = t.Surface })
        Tween(AccentBar, { BackgroundColor3 = t.Accent })
        Tween(TabIndicator, { BackgroundColor3 = t.Accent })
        Tween(ContentArea, { BackgroundColor3 = t.Background })
    end

    -- ══════════════════════════════════════════════════
    --  ADD TAB
    -- ══════════════════════════════════════════════════
    function Window:AddTab(tabName, icon)
        local Tab = { Elements = {}, Name = tabName }

        -- Tab button
        local TabBtn = Create("TextButton", {
            Name = tabName,
            Size = UDim2.new(0, 0, 1, -4),
            AutomaticSize = Enum.AutomaticSize.X,
            BackgroundColor3 = theme.TabInactive,
            BorderSizePixel = 0,
            Font = Font.new("rbxassetid://12289867853", Enum.FontWeight.Medium),
            Text = (icon and icon.." " or "") .. tabName,
            TextColor3 = theme.TextMuted,
            TextSize = 12,
            ZIndex = 4,
            Parent = TabList,
        })
        Create("UICorner",  { CornerRadius = UDim.new(0,6),    Parent = TabBtn })
        Create("UIPadding", { PaddingLeft = UDim.new(0,12), PaddingRight = UDim.new(0,12), Parent = TabBtn })

        -- Tab content scroll frame
        local ScrollFrame = Create("ScrollingFrame", {
            Name = tabName .. "_Content",
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ScrollBarThickness = 3,
            ScrollBarImageColor3 = theme.ScrollBar,
            ScrollBarImageTransparency = 0.4,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            Visible = false,
            ZIndex = 2,
            Parent = ContentArea,
        })
        Create("UIListLayout", {
            Padding = UDim.new(0, 6),
            SortOrder = Enum.SortOrder.LayoutOrder,
            Parent = ScrollFrame,
        })
        Create("UIPadding", {
            PaddingTop    = UDim.new(0, 10),
            PaddingBottom = UDim.new(0, 10),
            PaddingLeft   = UDim.new(0, 12),
            PaddingRight  = UDim.new(0, 12),
            Parent = ScrollFrame,
        })

        Tab.Button      = TabBtn
        Tab.Content     = ScrollFrame
        Tab.Window      = Window

        table.insert(Window.Tabs, Tab)

        -- Activate this tab if first
        if #Window.Tabs == 1 then
            Window:SelectTab(Tab)
        end

        -- Tab click
        TabBtn.MouseButton1Click:Connect(function()
            Window:SelectTab(Tab)
        end)
        TabBtn.MouseEnter:Connect(function()
            if Window.ActiveTab ~= Tab then
                Tween(TabBtn, { TextColor3 = theme.Text })
            end
        end)
        TabBtn.MouseLeave:Connect(function()
            if Window.ActiveTab ~= Tab then
                Tween(TabBtn, { TextColor3 = theme.TextMuted })
            end
        end)

        -- ══════════════════════════════════════════════
        --  SECTION (visual separator + label)
        -- ══════════════════════════════════════════════
        function Tab:AddSection(sectionName)
            local Container = Create("Frame", {
                Size = UDim2.new(1, 0, 0, 28),
                BackgroundTransparency = 1,
                ZIndex = 2,
                Parent = ScrollFrame,
            })
            local Line = Create("Frame", {
                Size = UDim2.new(1, 0, 0, 1),
                Position = UDim2.new(0,0,0.5,0),
                BackgroundColor3 = theme.Border,
                BorderSizePixel = 0,
                ZIndex = 2,
                Parent = Container,
            })
            Create("TextLabel", {
                Size = UDim2.new(0, #sectionName*7+16, 1, 0),
                Position = UDim2.new(0, 0, 0, 0),
                BackgroundColor3 = theme.Background,
                BorderSizePixel = 0,
                Font = Font.new("rbxassetid://12289867853", Enum.FontWeight.Bold),
                Text = "  " .. sectionName:upper() .. "  ",
                TextColor3 = theme.Accent,
                TextSize = 10,
                ZIndex = 3,
                Parent = Container,
            })
        end

        -- ══════════════════════════════════════════════
        --  BUTTON
        -- ══════════════════════════════════════════════
        function Tab:AddButton(text, callback, desc)
            local Row = Create("Frame", {
                Size = UDim2.new(1, 0, 0, 36),
                BackgroundColor3 = theme.Surface,
                BorderSizePixel = 0,
                ZIndex = 2,
                Parent = ScrollFrame,
            })
            Create("UICorner", { CornerRadius = UDim.new(0,6), Parent = Row })

            -- Left accent strip (hidden by default)
            local Strip = Create("Frame", {
                Size = UDim2.new(0, 3, 1, -8),
                Position = UDim2.new(0, 0, 0, 4),
                BackgroundColor3 = theme.Accent,
                BorderSizePixel = 0,
                ZIndex = 3,
                Parent = Row,
            })
            Create("UICorner", { CornerRadius = UDim.new(0,2), Parent = Strip })
            Strip.Size = UDim2.new(0, 0, 1, -8)

            Create("TextLabel", {
                Size = UDim2.new(1, -20, 1, 0),
                Position = UDim2.new(0, 14, 0, 0),
                BackgroundTransparency = 1,
                Font = Font.new("rbxassetid://12289867853", Enum.FontWeight.Regular),
                Text = text,
                TextColor3 = theme.Text,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 3,
                Parent = Row,
            })

            local Btn = Create("TextButton", {
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                Text = "",
                ZIndex = 4,
                Parent = Row,
            })

            local ripplePool = {}
            local function Ripple(x, y)
                local rip = Create("Frame", {
                    Size = UDim2.new(0, 0, 0, 0),
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Position = UDim2.new(0, x - Row.AbsolutePosition.X, 0, y - Row.AbsolutePosition.Y),
                    BackgroundColor3 = theme.Accent,
                    BackgroundTransparency = 0.75,
                    BorderSizePixel = 0,
                    ZIndex = 5,
                    Parent = Row,
                })
                Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = rip })
                Tween(rip, { Size = UDim2.new(0, 120, 0, 120), BackgroundTransparency = 1 }, 0.5)
                task.delay(0.5, function() rip:Destroy() end)
            end

            Btn.MouseEnter:Connect(function()
                Tween(Row, { BackgroundColor3 = theme.Surface2 })
                Tween(Strip, { Size = UDim2.new(0, 3, 1, -8) })
            end)
            Btn.MouseLeave:Connect(function()
                Tween(Row, { BackgroundColor3 = theme.Surface })
                Tween(Strip, { Size = UDim2.new(0, 0, 1, -8) })
            end)
            Btn.MouseButton1Down:Connect(function()
                Tween(Row, { BackgroundColor3 = theme.Border })
            end)
            Btn.MouseButton1Up:Connect(function()
                Tween(Row, { BackgroundColor3 = theme.Surface2 })
            end)
            Btn.MouseButton1Click:Connect(function()
                local mp = UserInputService:GetMouseLocation()
                Ripple(mp.X, mp.Y)
                if callback then
                    local ok, err = pcall(callback)
                    if not ok then warn("[RbxUI] Button callback error:", err) end
                end
            end)

            return Row
        end

        -- ══════════════════════════════════════════════
        --  TOGGLE
        -- ══════════════════════════════════════════════
        function Tab:AddToggle(text, default, callback, desc)
            local value = default or false

            local Row = Create("Frame", {
                Size = UDim2.new(1, 0, 0, 36),
                BackgroundColor3 = theme.Surface,
                BorderSizePixel = 0,
                ZIndex = 2,
                Parent = ScrollFrame,
            })
            Create("UICorner", { CornerRadius = UDim.new(0,6), Parent = Row })

            Create("TextLabel", {
                Size = UDim2.new(1, -60, 1, 0),
                Position = UDim2.new(0, 14, 0, 0),
                BackgroundTransparency = 1,
                Font = Font.new("rbxassetid://12289867853", Enum.FontWeight.Regular),
                Text = text,
                TextColor3 = theme.Text,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 3,
                Parent = Row,
            })

            -- Toggle track
            local Track = Create("Frame", {
                Size = UDim2.new(0, 42, 0, 22),
                Position = UDim2.new(1, -52, 0.5, -11),
                BackgroundColor3 = value and theme.ToggleOn or theme.ToggleOff,
                BorderSizePixel = 0,
                ZIndex = 3,
                Parent = Row,
            })
            Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = Track })

            -- Toggle thumb
            local Thumb = Create("Frame", {
                Size = UDim2.new(0, 16, 0, 16),
                Position = value and UDim2.new(0, 23, 0.5, -8) or UDim2.new(0, 3, 0.5, -8),
                BackgroundColor3 = Color3.fromRGB(255,255,255),
                BorderSizePixel = 0,
                ZIndex = 4,
                Parent = Track,
            })
            Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = Thumb })

            -- Glow under thumb when on
            local Glow = Create("ImageLabel", {
                Size = UDim2.new(0, 26, 0, 26),
                Position = UDim2.new(0.5, -13, 0.5, -13),
                BackgroundTransparency = 1,
                Image = "rbxassetid://6014261993",
                ImageColor3 = theme.Accent,
                ImageTransparency = 1,
                ScaleType = Enum.ScaleType.Slice,
                SliceCenter = Rect.new(49,49,450,450),
                ZIndex = 3,
                Parent = Thumb,
            })

            local Btn = Create("TextButton", {
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                Text = "",
                ZIndex = 5,
                Parent = Row,
            })

            local Toggle = {}
            function Toggle:SetValue(v)
                value = v
                if v then
                    SpringTween(Thumb, { Position = UDim2.new(0, 23, 0.5, -8), Size = UDim2.new(0, 16, 0, 16) })
                    Tween(Track, { BackgroundColor3 = theme.ToggleOn })
                    Tween(Glow, { ImageTransparency = 0.7 })
                else
                    SpringTween(Thumb, { Position = UDim2.new(0, 3, 0.5, -8), Size = UDim2.new(0, 16, 0, 16) })
                    Tween(Track, { BackgroundColor3 = theme.ToggleOff })
                    Tween(Glow, { ImageTransparency = 1 })
                end
                if callback then pcall(callback, value) end
            end
            function Toggle:GetValue() return value end

            Btn.MouseEnter:Connect(function() Tween(Row, { BackgroundColor3 = theme.Surface2 }) end)
            Btn.MouseLeave:Connect(function() Tween(Row, { BackgroundColor3 = theme.Surface }) end)
            Btn.MouseButton1Click:Connect(function()
                Toggle:SetValue(not value)
            end)

            Toggle:SetValue(value) -- apply initial state silently
            if callback and default then pcall(callback, value) end

            return Toggle
        end

        -- ══════════════════════════════════════════════
        --  SLIDER
        -- ══════════════════════════════════════════════
        function Tab:AddSlider(text, min, max, default, callback, suffix)
            min     = min or 0
            max     = max or 100
            default = math.clamp(default or min, min, max)
            suffix  = suffix or ""
            local value = default

            local Row = Create("Frame", {
                Size = UDim2.new(1, 0, 0, 52),
                BackgroundColor3 = theme.Surface,
                BorderSizePixel = 0,
                ZIndex = 2,
                Parent = ScrollFrame,
            })
            Create("UICorner", { CornerRadius = UDim.new(0,6), Parent = Row })

            -- Label + value
            local LabelFrame = Create("Frame", {
                Size = UDim2.new(1, -20, 0, 22),
                Position = UDim2.new(0, 14, 0, 7),
                BackgroundTransparency = 1,
                ZIndex = 3,
                Parent = Row,
            })
            Create("TextLabel", {
                Size = UDim2.new(1, -60, 1, 0),
                BackgroundTransparency = 1,
                Font = Font.new("rbxassetid://12289867853", Enum.FontWeight.Regular),
                Text = text,
                TextColor3 = theme.Text,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 3,
                Parent = LabelFrame,
            })
            local ValLabel = Create("TextLabel", {
                Size = UDim2.new(0, 55, 1, 0),
                Position = UDim2.new(1, -55, 0, 0),
                BackgroundTransparency = 1,
                Font = Font.new("rbxassetid://12289867853", Enum.FontWeight.Bold),
                Text = tostring(default) .. suffix,
                TextColor3 = theme.Accent,
                TextSize = 12,
                TextXAlignment = Enum.TextXAlignment.Right,
                ZIndex = 3,
                Parent = LabelFrame,
            })

            -- Track
            local TrackBg = Create("Frame", {
                Size = UDim2.new(1, -28, 0, 4),
                Position = UDim2.new(0, 14, 0, 36),
                BackgroundColor3 = theme.Surface2,
                BorderSizePixel = 0,
                ZIndex = 3,
                Parent = Row,
            })
            Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = TrackBg })

            -- Fill
            local pct = (default - min) / (max - min)
            local Fill = Create("Frame", {
                Size = UDim2.new(pct, 0, 1, 0),
                BackgroundColor3 = theme.Accent,
                BorderSizePixel = 0,
                ZIndex = 4,
                Parent = TrackBg,
            })
            Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = Fill })

            -- Thumb
            local Thumb = Create("Frame", {
                Size = UDim2.new(0, 14, 0, 14),
                Position = UDim2.new(pct, -7, 0.5, -7),
                BackgroundColor3 = Color3.fromRGB(255,255,255),
                BorderSizePixel = 0,
                ZIndex = 5,
                Parent = TrackBg,
            })
            Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = Thumb })

            -- Drag logic
            local dragging = false
            local SliderBtn = Create("TextButton", {
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                Text = "",
                ZIndex = 6,
                Parent = TrackBg,
            })

            local Slider = {}
            function Slider:SetValue(v)
                v = math.clamp(math.round(v), min, max)
                value = v
                local p = (v - min) / (max - min)
                Tween(Fill,  { Size = UDim2.new(p, 0, 1, 0) })
                Tween(Thumb, { Position = UDim2.new(p, -7, 0.5, -7) })
                ValLabel.Text = tostring(v) .. suffix
                if callback then pcall(callback, v) end
            end
            function Slider:GetValue() return value end

            local function updateFromMouse(input)
                local relX = math.clamp(input.Position.X - TrackBg.AbsolutePosition.X, 0, TrackBg.AbsoluteSize.X)
                local p = relX / TrackBg.AbsoluteSize.X
                local newVal = min + (max - min) * p
                Slider:SetValue(newVal)
            end

            SliderBtn.MouseButton1Down:Connect(function()
                dragging = true
                SpringTween(Thumb, { Size = UDim2.new(0, 18, 0, 18), Position = UDim2.new((value-min)/(max-min), -9, 0.5, -9) })
                Tween(Row, { BackgroundColor3 = theme.Surface2 })
            end)
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 and dragging then
                    dragging = false
                    SpringTween(Thumb, { Size = UDim2.new(0, 14, 0, 14), Position = UDim2.new((value-min)/(max-min), -7, 0.5, -7) })
                    Tween(Row, { BackgroundColor3 = theme.Surface })
                end
            end)
            UserInputService.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    updateFromMouse(input)
                end
            end)

            Row.MouseEnter:Connect(function() Tween(Row, { BackgroundColor3 = theme.Surface2 }) end)
            Row.MouseLeave:Connect(function()
                if not dragging then Tween(Row, { BackgroundColor3 = theme.Surface }) end
            end)

            Slider:SetValue(default)

            return Slider
        end

        -- ══════════════════════════════════════════════
        --  DROPDOWN
        -- ══════════════════════════════════════════════
        function Tab:AddDropdown(text, options, default, callback)
            local selected = default or options[1]
            local open = false

            local Wrapper = Create("Frame", {
                Size = UDim2.new(1, 0, 0, 36),
                BackgroundTransparency = 1,
                ZIndex = 2,
                ClipsDescendants = false,
                Parent = ScrollFrame,
            })

            local Row = Create("Frame", {
                Size = UDim2.new(1, 0, 0, 36),
                BackgroundColor3 = theme.Surface,
                BorderSizePixel = 0,
                ZIndex = 3,
                Parent = Wrapper,
            })
            Create("UICorner", { CornerRadius = UDim.new(0,6), Parent = Row })

            Create("TextLabel", {
                Size = UDim2.new(0.6, 0, 1, 0),
                Position = UDim2.new(0, 14, 0, 0),
                BackgroundTransparency = 1,
                Font = Font.new("rbxassetid://12289867853", Enum.FontWeight.Regular),
                Text = text,
                TextColor3 = theme.Text,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 4,
                Parent = Row,
            })

            local SelLabel = Create("TextLabel", {
                Size = UDim2.new(0.38, 0, 1, 0),
                Position = UDim2.new(0.6, 0, 0, 0),
                BackgroundTransparency = 1,
                Font = Font.new("rbxassetid://12289867853", Enum.FontWeight.Medium),
                Text = selected,
                TextColor3 = theme.Accent,
                TextSize = 12,
                TextXAlignment = Enum.TextXAlignment.Right,
                ZIndex = 4,
                Parent = Row,
            })

            local Arrow = Create("TextLabel", {
                Size = UDim2.new(0, 20, 1, 0),
                Position = UDim2.new(1, -22, 0, 0),
                BackgroundTransparency = 1,
                Font = Font.new("rbxassetid://12289867853", Enum.FontWeight.Bold),
                Text = "▾",
                TextColor3 = theme.TextMuted,
                TextSize = 12,
                ZIndex = 4,
                Parent = Row,
            })

            -- Dropdown list
            local ListFrame = Create("Frame", {
                Size = UDim2.new(1, 0, 0, 0),
                Position = UDim2.new(0, 0, 1, 4),
                BackgroundColor3 = theme.Surface2,
                BorderSizePixel = 0,
                ClipsDescendants = true,
                ZIndex = 10,
                Visible = false,
                Parent = Wrapper,
            })
            Create("UICorner", { CornerRadius = UDim.new(0,6), Parent = ListFrame })
            Create("UIStroke", {
                Color = theme.Border,
                Thickness = 1,
                Parent = ListFrame,
            })

            local ListLayout = Create("UIListLayout", {
                SortOrder = Enum.SortOrder.LayoutOrder,
                Parent = ListFrame,
            })
            Create("UIPadding", {
                PaddingTop = UDim.new(0,4), PaddingBottom = UDim.new(0,4),
                Parent = ListFrame,
            })

            local Dropdown = {}
            function Dropdown:SetValue(v)
                selected = v
                SelLabel.Text = v
                if callback then pcall(callback, v) end
            end
            function Dropdown:GetValue() return selected end

            -- Populate options
            for _, opt in ipairs(options) do
                local Item = Create("TextButton", {
                    Size = UDim2.new(1, 0, 0, 30),
                    BackgroundTransparency = 1,
                    Font = Font.new("rbxassetid://12289867853", Enum.FontWeight.Regular),
                    Text = "  " .. opt,
                    TextColor3 = opt == selected and theme.Accent or theme.Text,
                    TextSize = 12,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ZIndex = 11,
                    Parent = ListFrame,
                })
                Item.MouseEnter:Connect(function()
                    Tween(Item, { BackgroundTransparency = 0, BackgroundColor3 = theme.Surface })
                end)
                Item.MouseLeave:Connect(function()
                    Tween(Item, { BackgroundTransparency = 1 })
                end)
                Item.MouseButton1Click:Connect(function()
                    Dropdown:SetValue(opt)
                    -- Update all items color
                    for _, child in ipairs(ListFrame:GetChildren()) do
                        if child:IsA("TextButton") then
                            Tween(child, { TextColor3 = child.Text:find(opt) and theme.Accent or theme.Text })
                        end
                    end
                    -- Close
                    open = false
                    Tween(ListFrame, { Size = UDim2.new(1, 0, 0, 0) }, 0.2)
                    task.wait(0.2)
                    ListFrame.Visible = false
                    Wrapper.Size = UDim2.new(1, 0, 0, 36)
                    Tween(Arrow, { Rotation = 0 })
                end)
            end

            local itemH = #options * 30 + 8

            local Btn = Create("TextButton", {
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                Text = "",
                ZIndex = 5,
                Parent = Row,
            })
            Btn.MouseButton1Click:Connect(function()
                open = not open
                if open then
                    ListFrame.Visible = true
                    ListFrame.Size = UDim2.new(1, 0, 0, 0)
                    Tween(ListFrame, { Size = UDim2.new(1, 0, 0, itemH) }, 0.2)
                    Wrapper.Size = UDim2.new(1, 0, 0, 36 + itemH + 4)
                    Tween(Arrow, { Rotation = 180 })
                else
                    Tween(ListFrame, { Size = UDim2.new(1, 0, 0, 0) }, 0.2)
                    task.wait(0.2)
                    ListFrame.Visible = false
                    Wrapper.Size = UDim2.new(1, 0, 0, 36)
                    Tween(Arrow, { Rotation = 0 })
                end
            end)

            Btn.MouseEnter:Connect(function() Tween(Row, { BackgroundColor3 = theme.Surface2 }) end)
            Btn.MouseLeave:Connect(function() Tween(Row, { BackgroundColor3 = theme.Surface }) end)

            return Dropdown
        end

        -- ══════════════════════════════════════════════
        --  COLOR PICKER
        -- ══════════════════════════════════════════════
        function Tab:AddColorPicker(text, defaultColor, callback)
            defaultColor = defaultColor or Color3.fromRGB(255, 80, 80)
            local r,g,b = defaultColor.R, defaultColor.G, defaultColor.B
            local h,s,v = RGBtoHSV(r,g,b)
            local open = false

            local Wrapper = Create("Frame", {
                Size = UDim2.new(1, 0, 0, 36),
                BackgroundTransparency = 1,
                ClipsDescendants = false,
                ZIndex = 2,
                Parent = ScrollFrame,
            })

            local Row = Create("Frame", {
                Size = UDim2.new(1, 0, 0, 36),
                BackgroundColor3 = theme.Surface,
                BorderSizePixel = 0,
                ZIndex = 3,
                Parent = Wrapper,
            })
            Create("UICorner", { CornerRadius = UDim.new(0,6), Parent = Row })

            Create("TextLabel", {
                Size = UDim2.new(1, -60, 1, 0),
                Position = UDim2.new(0, 14, 0, 0),
                BackgroundTransparency = 1,
                Font = Font.new("rbxassetid://12289867853", Enum.FontWeight.Regular),
                Text = text,
                TextColor3 = theme.Text,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 4,
                Parent = Row,
            })

            local Preview = Create("Frame", {
                Size = UDim2.new(0, 22, 0, 22),
                Position = UDim2.new(1, -36, 0.5, -11),
                BackgroundColor3 = defaultColor,
                BorderSizePixel = 0,
                ZIndex = 4,
                Parent = Row,
            })
            Create("UICorner", { CornerRadius = UDim.new(0,5), Parent = Preview })
            Create("UIStroke", { Color = theme.Border, Thickness = 1, Parent = Preview })

            -- Picker panel
            local Panel = Create("Frame", {
                Size = UDim2.new(1, 0, 0, 0),
                Position = UDim2.new(0, 0, 1, 4),
                BackgroundColor3 = theme.Surface2,
                BorderSizePixel = 0,
                ClipsDescendants = true,
                Visible = false,
                ZIndex = 10,
                Parent = Wrapper,
            })
            Create("UICorner", { CornerRadius = UDim.new(0,6), Parent = Panel })
            Create("UIStroke", { Color = theme.Border, Thickness = 1, Parent = Panel })
            Create("UIPadding", {
                PaddingTop=UDim.new(0,10), PaddingBottom=UDim.new(0,10),
                PaddingLeft=UDim.new(0,12), PaddingRight=UDim.new(0,12),
                Parent=Panel,
            })

            -- SV square (hue-colored background)
            local SVSquare = Create("ImageLabel", {
                Size = UDim2.new(1, 0, 0, 130),
                BackgroundColor3 = Color3.fromHSV(h, 1, 1),
                BorderSizePixel = 0,
                Image = "rbxassetid://4155801252", -- white-to-transparent gradient
                ZIndex = 11,
                Parent = Panel,
            })
            Create("UICorner", { CornerRadius = UDim.new(0,4), Parent = SVSquare })

            -- Black overlay
            local SV_BlackOverlay = Create("ImageLabel", {
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                Image = "rbxassetid://4155800584", -- black-to-transparent gradient
                ZIndex = 12,
                Parent = SVSquare,
            })
            Create("UICorner", { CornerRadius = UDim.new(0,4), Parent = SV_BlackOverlay })

            -- SV cursor
            local SVCursor = Create("Frame", {
                Size = UDim2.new(0, 12, 0, 12),
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.new(s, 0, 1-v, 0),
                BackgroundColor3 = Color3.fromRGB(255,255,255),
                BorderSizePixel = 0,
                ZIndex = 13,
                Parent = SVSquare,
            })
            Create("UICorner", { CornerRadius = UDim.new(1,0), Parent = SVCursor })
            Create("UIStroke", { Color = Color3.fromRGB(0,0,0), Thickness = 1.5, Parent = SVCursor })

            -- Hue bar
            local HueBar = Create("ImageLabel", {
                Size = UDim2.new(1, 0, 0, 16),
                Position = UDim2.new(0, 0, 0, 140),
                BorderSizePixel = 0,
                Image = "rbxassetid://3641079629", -- rainbow hue gradient
                ZIndex = 11,
                Parent = Panel,
            })
            Create("UICorner", { CornerRadius = UDim.new(0,4), Parent = HueBar })

            local HueCursor = Create("Frame", {
                Size = UDim2.new(0, 8, 1, 4),
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.new(h, 0, 0.5, 0),
                BackgroundColor3 = Color3.fromRGB(255,255,255),
                BorderSizePixel = 0,
                ZIndex = 12,
                Parent = HueBar,
            })
            Create("UICorner", { CornerRadius = UDim.new(0,3), Parent = HueCursor })
            Create("UIStroke", { Color = Color3.fromRGB(0,0,0), Thickness = 1.5, Parent = HueCursor })

            -- Hex display
            local HexLabel = Create("TextLabel", {
                Size = UDim2.new(1, 0, 0, 22),
                Position = UDim2.new(0, 0, 0, 164),
                BackgroundTransparency = 1,
                Font = Font.new("rbxassetid://12289867853", Enum.FontWeight.Bold),
                Text = string.format("#%02X%02X%02X", math.round(r*255), math.round(g*255), math.round(b*255)),
                TextColor3 = theme.TextMuted,
                TextSize = 11,
                ZIndex = 11,
                Parent = Panel,
            })

            local PANEL_H = 196

            local ColorPicker = {}
            function ColorPicker:SetColor(color)
                r,g,b = color.R, color.G, color.B
                h,s,v = RGBtoHSV(r,g,b)
                Preview.BackgroundColor3 = color
                SVSquare.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
                SVCursor.Position = UDim2.new(s, 0, 1-v, 0)
                HueCursor.Position = UDim2.new(h, 0, 0.5, 0)
                HexLabel.Text = string.format("#%02X%02X%02X", math.round(r*255), math.round(g*255), math.round(b*255))
                if callback then pcall(callback, color) end
            end
            function ColorPicker:GetColor()
                return Color3.fromHSV(h, s, v)
            end

            local function updateColor()
                local c = Color3.fromHSV(h, s, v)
                Preview.BackgroundColor3 = c
                SVSquare.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
                HexLabel.Text = string.format("#%02X%02X%02X", math.round(c.R*255), math.round(c.G*255), math.round(c.B*255))
                if callback then pcall(callback, c) end
            end

            -- SV drag
            local svDragging = false
            local SVBtn = Create("TextButton", { Size=UDim2.new(1,0,1,0), BackgroundTransparency=1, Text="", ZIndex=14, Parent=SVSquare })
            SVBtn.MouseButton1Down:Connect(function() svDragging = true end)
            UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then svDragging = false end end)
            UserInputService.InputChanged:Connect(function(i)
                if svDragging and i.UserInputType == Enum.UserInputType.MouseMovement then
                    local relX = math.clamp(i.Position.X - SVSquare.AbsolutePosition.X, 0, SVSquare.AbsoluteSize.X)
                    local relY = math.clamp(i.Position.Y - SVSquare.AbsolutePosition.Y, 0, SVSquare.AbsoluteSize.Y)
                    s = relX / SVSquare.AbsoluteSize.X
                    v = 1 - (relY / SVSquare.AbsoluteSize.Y)
                    SVCursor.Position = UDim2.new(s, 0, 1-v, 0)
                    updateColor()
                end
            end)

            -- Hue drag
            local hueDragging = false
            local HueBtn = Create("TextButton", { Size=UDim2.new(1,0,1,0), BackgroundTransparency=1, Text="", ZIndex=13, Parent=HueBar })
            HueBtn.MouseButton1Down:Connect(function() hueDragging = true end)
            UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then hueDragging = false end end)
            UserInputService.InputChanged:Connect(function(i)
                if hueDragging and i.UserInputType == Enum.UserInputType.MouseMovement then
                    local relX = math.clamp(i.Position.X - HueBar.AbsolutePosition.X, 0, HueBar.AbsoluteSize.X)
                    h = relX / HueBar.AbsoluteSize.X
                    HueCursor.Position = UDim2.new(h, 0, 0.5, 0)
                    SVSquare.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
                    updateColor()
                end
            end)

            -- Toggle open
            local ToggleBtn = Create("TextButton", {
                Size=UDim2.new(1,0,1,0), BackgroundTransparency=1, Text="", ZIndex=5, Parent=Row
            })
            ToggleBtn.MouseButton1Click:Connect(function()
                open = not open
                if open then
                    Panel.Visible = true
                    Panel.Size = UDim2.new(1, 0, 0, 0)
                    Tween(Panel, { Size = UDim2.new(1, 0, 0, PANEL_H) }, 0.25)
                    Wrapper.Size = UDim2.new(1, 0, 0, 36 + PANEL_H + 4)
                else
                    Tween(Panel, { Size = UDim2.new(1, 0, 0, 0) }, 0.2)
                    task.wait(0.2)
                    Panel.Visible = false
                    Wrapper.Size = UDim2.new(1, 0, 0, 36)
                end
            end)
            ToggleBtn.MouseEnter:Connect(function() Tween(Row, { BackgroundColor3 = theme.Surface2 }) end)
            ToggleBtn.MouseLeave:Connect(function() Tween(Row, { BackgroundColor3 = theme.Surface }) end)

            return ColorPicker
        end

        -- ══════════════════════════════════════════════
        --  TEXT INPUT
        -- ══════════════════════════════════════════════
        function Tab:AddTextBox(text, placeholder, callback)
            local Row = Create("Frame", {
                Size = UDim2.new(1, 0, 0, 36),
                BackgroundColor3 = theme.Surface,
                BorderSizePixel = 0,
                ZIndex = 2,
                Parent = ScrollFrame,
            })
            Create("UICorner", { CornerRadius = UDim.new(0,6), Parent = Row })

            Create("TextLabel", {
                Size = UDim2.new(0.45, 0, 1, 0),
                Position = UDim2.new(0, 14, 0, 0),
                BackgroundTransparency = 1,
                Font = Font.new("rbxassetid://12289867853", Enum.FontWeight.Regular),
                Text = text,
                TextColor3 = theme.Text,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 3,
                Parent = Row,
            })

            local Box = Create("TextBox", {
                Size = UDim2.new(0.48, 0, 0, 24),
                Position = UDim2.new(0.5, 0, 0.5, -12),
                BackgroundColor3 = theme.Surface2,
                BorderSizePixel = 0,
                Font = Font.new("rbxassetid://12289867853", Enum.FontWeight.Regular),
                Text = "",
                PlaceholderText = placeholder or "Enter value...",
                PlaceholderColor3 = theme.TextMuted,
                TextColor3 = theme.Text,
                TextSize = 12,
                ZIndex = 4,
                ClearTextOnFocus = false,
                Parent = Row,
            })
            Create("UICorner", { CornerRadius = UDim.new(0,4), Parent = Box })
            local Stroke = Create("UIStroke", { Color = theme.Border, Thickness = 1, Parent = Box })

            Box.Focused:Connect(function()
                Tween(Stroke, { Color = theme.Accent, Thickness = 1.5 })
            end)
            Box.FocusLost:Connect(function(entered)
                Tween(Stroke, { Color = theme.Border, Thickness = 1 })
                if callback then pcall(callback, Box.Text) end
            end)

            Row.MouseEnter:Connect(function() Tween(Row, { BackgroundColor3 = theme.Surface2 }) end)
            Row.MouseLeave:Connect(function() Tween(Row, { BackgroundColor3 = theme.Surface }) end)

            return Box
        end

        -- ══════════════════════════════════════════════
        --  KEYBIND
        -- ══════════════════════════════════════════════
        function Tab:AddKeybind(text, default, callback)
            local key = default or Enum.KeyCode.Unknown
            local listening = false

            local Row = Create("Frame", {
                Size = UDim2.new(1, 0, 0, 36),
                BackgroundColor3 = theme.Surface,
                BorderSizePixel = 0,
                ZIndex = 2,
                Parent = ScrollFrame,
            })
            Create("UICorner", { CornerRadius = UDim.new(0,6), Parent = Row })

            Create("TextLabel", {
                Size = UDim2.new(1, -80, 1, 0),
                Position = UDim2.new(0, 14, 0, 0),
                BackgroundTransparency = 1,
                Font = Font.new("rbxassetid://12289867853", Enum.FontWeight.Regular),
                Text = text,
                TextColor3 = theme.Text,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 3,
                Parent = Row,
            })

            local KeyDisplay = Create("TextButton", {
                Size = UDim2.new(0, 64, 0, 24),
                Position = UDim2.new(1, -74, 0.5, -12),
                BackgroundColor3 = theme.Surface2,
                BorderSizePixel = 0,
                Font = Font.new("rbxassetid://12289867853", Enum.FontWeight.Bold),
                Text = key.Name,
                TextColor3 = theme.Accent,
                TextSize = 11,
                ZIndex = 4,
                Parent = Row,
            })
            Create("UICorner", { CornerRadius = UDim.new(0,4), Parent = KeyDisplay })
            Create("UIStroke", { Color = theme.Border, Thickness = 1, Parent = KeyDisplay })

            local Keybind = {}
            function Keybind:GetKey() return key end

            KeyDisplay.MouseButton1Click:Connect(function()
                listening = true
                KeyDisplay.Text = "..."
                Tween(KeyDisplay, { BackgroundColor3 = theme.Accent, TextColor3 = Color3.fromRGB(0,0,0) })
            end)

            UserInputService.InputBegan:Connect(function(input, gp)
                if not gp and listening and input.UserInputType == Enum.UserInputType.Keyboard then
                    listening = false
                    key = input.KeyCode
                    KeyDisplay.Text = key.Name
                    Tween(KeyDisplay, { BackgroundColor3 = theme.Surface2, TextColor3 = theme.Accent })
                    if callback then pcall(callback, key) end
                elseif not listening and input.KeyCode == key then
                    if callback then pcall(callback, key) end
                end
            end)

            Row.MouseEnter:Connect(function() Tween(Row, { BackgroundColor3 = theme.Surface2 }) end)
            Row.MouseLeave:Connect(function() Tween(Row, { BackgroundColor3 = theme.Surface }) end)

            return Keybind
        end

        -- ══════════════════════════════════════════════
        --  LABEL
        -- ══════════════════════════════════════════════
        function Tab:AddLabel(text)
            local Lbl = Create("TextLabel", {
                Size = UDim2.new(1, 0, 0, 24),
                BackgroundTransparency = 1,
                Font = Font.new("rbxassetid://12289867853", Enum.FontWeight.Regular),
                Text = text,
                TextColor3 = theme.TextMuted,
                TextSize = 12,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 2,
                Parent = ScrollFrame,
            })
            Create("UIPadding", { PaddingLeft = UDim.new(0,14), Parent = Lbl })
            return Lbl
        end

        return Tab
    end

    -- ═══════════════════════════════════════════════════
    --  SELECT TAB (internal)
    -- ═══════════════════════════════════════════════════
    function Window:SelectTab(tab)
        for _, t in ipairs(self.Tabs) do
            t.Content.Visible = false
            Tween(t.Button, {
                BackgroundColor3 = theme.TabInactive,
                TextColor3 = theme.TextMuted,
            })
        end
        tab.Content.Visible = true
        Tween(tab.Button, {
            BackgroundColor3 = theme.TabActive,
            TextColor3 = Color3.fromRGB(255,255,255),
        })
        -- Move indicator
        local btnPos = tab.Button.AbsolutePosition.X - TabList.AbsolutePosition.X
        local btnW   = tab.Button.AbsoluteSize.X
        Tween(TabIndicator, {
            Position = UDim2.new(0, btnPos, 1, -2),
            Size     = UDim2.new(0, btnW, 0, 2),
        }, 0.2)
        self.ActiveTab = tab
    end

    -- ═══════════════════════════════════════════════════
    --  NOTIFICATION (static, not attached to window)
    -- ═══════════════════════════════════════════════════
    function Window:Notify(title, message, notifType, duration)
        notifType = notifType or "info"
        duration = duration or 3

        local colors = {
            info    = theme.Accent,
            success = theme.Success,
            danger  = theme.Danger,
            warning = theme.Warning,
        }
        local accentColor = colors[notifType] or theme.Accent

        -- Find or create notification holder
        local Holder = ScreenGui:FindFirstChild("NotifHolder")
        if not Holder then
            Holder = Create("Frame", {
                Name = "NotifHolder",
                Size = UDim2.new(0, 280, 1, 0),
                Position = UDim2.new(1, -295, 0, 0),
                BackgroundTransparency = 1,
                ZIndex = 100,
                Parent = ScreenGui,
            })
            Create("UIListLayout", {
                VerticalAlignment = Enum.VerticalAlignment.Bottom,
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding = UDim.new(0,8),
                Parent = Holder,
            })
            Create("UIPadding", { PaddingBottom = UDim.new(0,20), Parent = Holder })
        end

        local Card = Create("Frame", {
            Size = UDim2.new(1, 0, 0, 0),
            BackgroundColor3 = theme.Surface,
            BorderSizePixel = 0,
            ClipsDescendants = true,
            ZIndex = 101,
            Parent = Holder,
        })
        Create("UICorner", { CornerRadius = UDim.new(0,8), Parent = Card })

        -- Left color strip
        local Strip = Create("Frame", {
            Size = UDim2.new(0, 3, 1, -16),
            Position = UDim2.new(0, 0, 0, 8),
            BackgroundColor3 = accentColor,
            BorderSizePixel = 0,
            ZIndex = 102,
            Parent = Card,
        })
        Create("UICorner", { CornerRadius = UDim.new(0,2), Parent = Strip })

        Create("TextLabel", {
            Size = UDim2.new(1, -20, 0, 20),
            Position = UDim2.new(0, 14, 0, 10),
            BackgroundTransparency = 1,
            Font = Font.new("rbxassetid://12289867853", Enum.FontWeight.Bold),
            Text = title,
            TextColor3 = theme.Text,
            TextSize = 13,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 102,
            Parent = Card,
        })
        Create("TextLabel", {
            Size = UDim2.new(1, -20, 0, 30),
            Position = UDim2.new(0, 14, 0, 30),
            BackgroundTransparency = 1,
            Font = Font.new("rbxassetid://12289867853", Enum.FontWeight.Regular),
            Text = message,
            TextColor3 = theme.TextMuted,
            TextSize = 12,
            TextWrapped = true,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 102,
            Parent = Card,
        })

        -- Progress bar for duration
        local ProgressBg = Create("Frame", {
            Size = UDim2.new(1, 0, 0, 2),
            Position = UDim2.new(0, 0, 1, -2),
            BackgroundColor3 = theme.Surface2,
            BorderSizePixel = 0,
            ZIndex = 102,
            Parent = Card,
        })
        local ProgressFill = Create("Frame", {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundColor3 = accentColor,
            BorderSizePixel = 0,
            ZIndex = 103,
            Parent = ProgressBg,
        })
        Create("UICorner", { CornerRadius = UDim.new(0,1), Parent = ProgressBg })

        -- Animate in
        Tween(Card, { Size = UDim2.new(1, 0, 0, 70) }, 0.25)
        task.wait(0.25)
        Tween(ProgressFill, { Size = UDim2.new(0, 0, 1, 0) }, duration, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
        task.wait(duration)
        Tween(Card, { Size = UDim2.new(1, 0, 0, 0), BackgroundTransparency = 1 }, 0.2)
        task.wait(0.25)
        Card:Destroy()
    end

    return Window
end

-- ═══════════════════════════════════════════════════════
--  RETURN
-- ═══════════════════════════════════════════════════════
return RbxUI
