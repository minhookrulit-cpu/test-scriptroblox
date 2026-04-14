--[[
 _______ _______ __   __ _     _ _
 |_____/ |______ |  \_/ |     | |
 |    \_ |______ |   | |_____| |

    RbxUI v3.0 — True Fatality-style multi-column layout
    
    API:
        local Win   = UI:CreateWindow({ Title, Theme, Width, Height })
        local Page  = Win:AddPage("MISC")
        local Col   = Page:AddColumn()
        local Group = Col:AddGroup("MOVEMENT")
        
        Group:AddToggle("Bunny hop", false, cb)
        Group:AddSlider("Slowwalk", 0, 100, 100, cb, "%")
        Group:AddDropdown("Mode", {"opt1","opt2"}, "opt1", cb)
        Group:AddColorPicker("Color", Color3.fromRGB(200,45,95), cb)
        Group:AddButton("Click me", cb)
        Group:AddKeybind("Activate", Enum.KeyCode.F, cb)
        Group:AddTextBox("Label", "placeholder", cb)
        Group:AddLabel("Info text")
        
        Win:SetTheme("Purple")
        Win:Notify("Title", "Message", "info", 3)
        
    Themes: "Fatality" | "Dark" | "Purple" | "Green" | "Light"
--]]

local RbxUI = {}
RbxUI.__index = RbxUI

local Players          = game:GetService("Players")
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui          = game:GetService("CoreGui")
local LocalPlayer      = Players.LocalPlayer

-- ═══════════════════════════════════════════════════════════════════
--  THEMES
-- ═══════════════════════════════════════════════════════════════════
RbxUI.Themes = {
    Fatality = {
        Window=Color3.fromRGB(22,20,30), WindowBorder=Color3.fromRGB(185,42,88),
        TopBar=Color3.fromRGB(16,14,22), PageBar=Color3.fromRGB(18,16,26),
        PageText=Color3.fromRGB(200,42,88), PageInactive=Color3.fromRGB(115,108,145),
        Column=Color3.fromRGB(26,23,36), ColBorder=Color3.fromRGB(40,36,55),
        Group=Color3.fromRGB(30,27,42), GroupBorder=Color3.fromRGB(45,40,62),
        GroupTitle=Color3.fromRGB(185,42,88), Accent=Color3.fromRGB(200,45,92),
        AccentHover=Color3.fromRGB(225,68,115), Text=Color3.fromRGB(215,210,228),
        TextMuted=Color3.fromRGB(128,118,152), TextDim=Color3.fromRGB(75,68,98),
        ToggleOn=Color3.fromRGB(200,45,92), ToggleOff=Color3.fromRGB(50,45,66),
        SliderFill=Color3.fromRGB(200,45,92), SliderTrack=Color3.fromRGB(44,40,60),
        InputBg=Color3.fromRGB(20,18,28), InputBorder=Color3.fromRGB(48,44,66),
        DropBg=Color3.fromRGB(22,20,32), ScrollBar=Color3.fromRGB(175,38,82),
        StatusBar=Color3.fromRGB(14,12,20), StatusText=Color3.fromRGB(98,88,122),
    },
    Dark = {
        Window=Color3.fromRGB(18,18,24), WindowBorder=Color3.fromRGB(0,162,240),
        TopBar=Color3.fromRGB(13,13,18), PageBar=Color3.fromRGB(15,15,21),
        PageText=Color3.fromRGB(0,182,255), PageInactive=Color3.fromRGB(100,100,132),
        Column=Color3.fromRGB(22,22,32), ColBorder=Color3.fromRGB(38,38,54),
        Group=Color3.fromRGB(27,27,38), GroupBorder=Color3.fromRGB(42,42,60),
        GroupTitle=Color3.fromRGB(0,182,255), Accent=Color3.fromRGB(0,182,255),
        AccentHover=Color3.fromRGB(28,202,255), Text=Color3.fromRGB(218,218,235),
        TextMuted=Color3.fromRGB(118,118,152), TextDim=Color3.fromRGB(68,68,94),
        ToggleOn=Color3.fromRGB(0,182,255), ToggleOff=Color3.fromRGB(48,48,68),
        SliderFill=Color3.fromRGB(0,182,255), SliderTrack=Color3.fromRGB(42,42,60),
        InputBg=Color3.fromRGB(14,14,20), InputBorder=Color3.fromRGB(44,44,64),
        DropBg=Color3.fromRGB(18,18,26), ScrollBar=Color3.fromRGB(0,160,230),
        StatusBar=Color3.fromRGB(11,11,16), StatusText=Color3.fromRGB(88,88,118),
    },
    Purple = {
        Window=Color3.fromRGB(16,12,24), WindowBorder=Color3.fromRGB(140,72,255),
        TopBar=Color3.fromRGB(11,8,18), PageBar=Color3.fromRGB(13,10,20),
        PageText=Color3.fromRGB(158,90,255), PageInactive=Color3.fromRGB(108,98,142),
        Column=Color3.fromRGB(20,15,34), ColBorder=Color3.fromRGB(50,38,78),
        Group=Color3.fromRGB(24,18,40), GroupBorder=Color3.fromRGB(56,44,86),
        GroupTitle=Color3.fromRGB(152,82,255), Accent=Color3.fromRGB(152,82,255),
        AccentHover=Color3.fromRGB(178,112,255), Text=Color3.fromRGB(215,208,235),
        TextMuted=Color3.fromRGB(118,108,152), TextDim=Color3.fromRGB(74,64,104),
        ToggleOn=Color3.fromRGB(152,82,255), ToggleOff=Color3.fromRGB(52,42,78),
        SliderFill=Color3.fromRGB(152,82,255), SliderTrack=Color3.fromRGB(52,42,78),
        InputBg=Color3.fromRGB(13,10,20), InputBorder=Color3.fromRGB(54,44,82),
        DropBg=Color3.fromRGB(16,12,27), ScrollBar=Color3.fromRGB(128,65,228),
        StatusBar=Color3.fromRGB(9,7,15), StatusText=Color3.fromRGB(98,86,132),
    },
    Green = {
        Window=Color3.fromRGB(10,17,13), WindowBorder=Color3.fromRGB(32,202,112),
        TopBar=Color3.fromRGB(7,12,9), PageBar=Color3.fromRGB(9,15,11),
        PageText=Color3.fromRGB(40,218,122), PageInactive=Color3.fromRGB(94,124,106),
        Column=Color3.fromRGB(13,22,16), ColBorder=Color3.fromRGB(30,52,38),
        Group=Color3.fromRGB(15,26,19), GroupBorder=Color3.fromRGB(34,58,44),
        GroupTitle=Color3.fromRGB(36,212,122), Accent=Color3.fromRGB(36,212,122),
        AccentHover=Color3.fromRGB(58,232,142), Text=Color3.fromRGB(200,225,210),
        TextMuted=Color3.fromRGB(98,132,112), TextDim=Color3.fromRGB(54,78,63),
        ToggleOn=Color3.fromRGB(36,212,122), ToggleOff=Color3.fromRGB(32,55,42),
        SliderFill=Color3.fromRGB(36,212,122), SliderTrack=Color3.fromRGB(32,55,42),
        InputBg=Color3.fromRGB(8,14,10), InputBorder=Color3.fromRGB(34,58,44),
        DropBg=Color3.fromRGB(10,18,13), ScrollBar=Color3.fromRGB(28,186,102),
        StatusBar=Color3.fromRGB(5,10,7), StatusText=Color3.fromRGB(74,106,86),
    },
    Light = {
        Window=Color3.fromRGB(242,242,250), WindowBorder=Color3.fromRGB(88,108,234),
        TopBar=Color3.fromRGB(230,230,242), PageBar=Color3.fromRGB(234,234,246),
        PageText=Color3.fromRGB(78,98,232), PageInactive=Color3.fromRGB(138,138,174),
        Column=Color3.fromRGB(255,255,255), ColBorder=Color3.fromRGB(210,210,228),
        Group=Color3.fromRGB(248,248,255), GroupBorder=Color3.fromRGB(208,208,228),
        GroupTitle=Color3.fromRGB(78,98,232), Accent=Color3.fromRGB(78,98,232),
        AccentHover=Color3.fromRGB(58,78,210), Text=Color3.fromRGB(24,24,44),
        TextMuted=Color3.fromRGB(118,118,158), TextDim=Color3.fromRGB(168,168,198),
        ToggleOn=Color3.fromRGB(78,98,232), ToggleOff=Color3.fromRGB(194,194,214),
        SliderFill=Color3.fromRGB(78,98,232), SliderTrack=Color3.fromRGB(198,198,220),
        InputBg=Color3.fromRGB(238,238,250), InputBorder=Color3.fromRGB(198,198,220),
        DropBg=Color3.fromRGB(244,244,255), ScrollBar=Color3.fromRGB(78,98,232),
        StatusBar=Color3.fromRGB(220,220,234), StatusText=Color3.fromRGB(148,148,184),
    },
}

-- ═══════════════════════════════════════════════════════════════════
--  UTILITIES
-- ═══════════════════════════════════════════════════════════════════
local function T(o,p,ti,st,di)
    TweenService:Create(o,TweenInfo.new(ti or 0.18,st or Enum.EasingStyle.Quad,di or Enum.EasingDirection.Out),p):Play()
end
local function Spr(o,p,ti)
    TweenService:Create(o,TweenInfo.new(ti or 0.3,Enum.EasingStyle.Back,Enum.EasingDirection.Out),p):Play()
end
local function N(cls,props,ch)
    local o=Instance.new(cls)
    for k,v in pairs(props or {}) do if k~="Parent" then o[k]=v end end
    for _,c in ipairs(ch or {}) do c.Parent=o end
    if props and props.Parent then o.Parent=props.Parent end
    return o
end
local function Crn(r,p) return N("UICorner",{CornerRadius=UDim.new(0,r or 4),Parent=p}) end
local function Str(c,th,p) return N("UIStroke",{Color=c,Thickness=th or 1,Parent=p}) end
local function Drag(frame,handle)
    handle=handle or frame
    local dr,ds,sp
    handle.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 then dr=true;ds=i.Position;sp=frame.Position end
    end)
    handle.InputEnded:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 then dr=false end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if dr and i.UserInputType==Enum.UserInputType.MouseMovement then
            local d=i.Position-ds
            frame.Position=UDim2.new(sp.X.Scale,sp.X.Offset+d.X,sp.Y.Scale,sp.Y.Offset+d.Y)
        end
    end)
end

-- ═══════════════════════════════════════════════════════════════════
--  CREATE WINDOW
-- ═══════════════════════════════════════════════════════════════════
function RbxUI:CreateWindow(cfg)
    cfg=cfg or {}
    local title   = cfg.Title    or "MENU"
    local tn      = cfg.Theme    or "Fatality"
    local W       = cfg.Width    or 720
    local H       = cfg.Height   or 450
    local pos     = cfg.Position or UDim2.new(0.5,-W/2,0.5,-H/2)
    local t       = RbxUI.Themes[tn] or RbxUI.Themes.Fatality

    -- ── ScreenGui ──────────────────────────────────────────────────
    local SG=N("ScreenGui",{Name="RbxUI_"..title,ResetOnSpawn=false,ZIndexBehavior=Enum.ZIndexBehavior.Sibling})
    pcall(function() SG.Parent=CoreGui end)
    if not SG.Parent then SG.Parent=LocalPlayer:WaitForChild("PlayerGui") end

    -- Shadow
    N("ImageLabel",{
        AnchorPoint=Vector2.new(0.5,0.5),Size=UDim2.new(0,W+70,0,H+70),
        Position=UDim2.new(0.5,0,0.5,10),BackgroundTransparency=1,
        Image="rbxassetid://6014261993",ImageColor3=Color3.new(0,0,0),
        ImageTransparency=0.4,ScaleType=Enum.ScaleType.Slice,
        SliceCenter=Rect.new(49,49,450,450),ZIndex=0,Parent=SG,
    })

    -- Main window
    local Main=N("Frame",{
        Name="Main",Size=UDim2.new(0,W,0,H),Position=pos,
        BackgroundColor3=t.Window,BorderSizePixel=0,ClipsDescendants=true,ZIndex=1,Parent=SG,
    })
    Crn(8,Main)
    local WStr=Str(t.WindowBorder,1.5,Main)

    -- ── TOP BAR ─────────────────────────────────────────────────────
    local TopBar=N("Frame",{
        Size=UDim2.new(1,0,0,36),BackgroundColor3=t.TopBar,BorderSizePixel=0,ZIndex=3,Parent=Main,
    })
    -- logo area
    N("TextLabel",{
        Size=UDim2.new(0,160,1,0),Position=UDim2.new(0,12,0,0),
        BackgroundTransparency=1,Font=Enum.Font.GothamBold,
        Text=title,TextColor3=t.PageText,TextSize=14,
        TextXAlignment=Enum.TextXAlignment.Left,ZIndex=4,Parent=TopBar,
    })
    -- top-right buttons
    local MinBtn=N("TextButton",{
        Size=UDim2.new(0,22,0,22),Position=UDim2.new(1,-52,0.5,-11),
        BackgroundColor3=t.ColBorder,BorderSizePixel=0,
        Font=Enum.Font.GothamBold,Text="−",TextColor3=t.TextMuted,TextSize=13,ZIndex=5,Parent=TopBar,
    })
    Crn(4,MinBtn)
    local ClsBtn=N("TextButton",{
        Size=UDim2.new(0,22,0,22),Position=UDim2.new(1,-26,0.5,-11),
        BackgroundColor3=t.ColBorder,BorderSizePixel=0,
        Font=Enum.Font.GothamBold,Text="×",TextColor3=t.TextMuted,TextSize=15,ZIndex=5,Parent=TopBar,
    })
    Crn(4,ClsBtn)
    -- divider
    N("Frame",{Size=UDim2.new(1,0,0,1),Position=UDim2.new(0,0,1,-1),BackgroundColor3=t.ColBorder,BorderSizePixel=0,ZIndex=3,Parent=TopBar})

    -- ── PAGE TAB BAR ────────────────────────────────────────────────
    local PageBar=N("Frame",{
        Size=UDim2.new(1,0,0,30),Position=UDim2.new(0,0,0,35),
        BackgroundColor3=t.PageBar,BorderSizePixel=0,ZIndex=3,Parent=Main,
    })
    local PageList=N("Frame",{
        Size=UDim2.new(1,-10,1,0),Position=UDim2.new(0,6,0,0),
        BackgroundTransparency=1,ZIndex=3,Parent=PageBar,
    })
    N("UIListLayout",{
        FillDirection=Enum.FillDirection.Horizontal,
        VerticalAlignment=Enum.VerticalAlignment.Center,
        Padding=UDim.new(0,2),Parent=PageList,
    })
    -- active tab underline
    local TabLine=N("Frame",{
        Size=UDim2.new(0,0,0,2),Position=UDim2.new(0,0,1,-2),
        BackgroundColor3=t.Accent,BorderSizePixel=0,ZIndex=5,Parent=PageBar,
    })
    -- divider
    N("Frame",{Size=UDim2.new(1,0,0,1),Position=UDim2.new(0,0,1,-1),BackgroundColor3=t.ColBorder,BorderSizePixel=0,ZIndex=3,Parent=PageBar})

    -- ── CONTENT ─────────────────────────────────────────────────────
    local Content=N("Frame",{
        Size=UDim2.new(1,0,1,-(35+30+20)),Position=UDim2.new(0,0,0,35+30),
        BackgroundColor3=t.Window,BorderSizePixel=0,ZIndex=2,Parent=Main,
    })

    -- ── STATUS BAR ──────────────────────────────────────────────────
    local SBFrame=N("Frame",{
        Size=UDim2.new(1,0,0,20),Position=UDim2.new(0,0,1,-20),
        BackgroundColor3=t.StatusBar,BorderSizePixel=0,ZIndex=3,Parent=Main,
    })
    N("Frame",{Size=UDim2.new(1,0,0,1),BackgroundColor3=t.ColBorder,BorderSizePixel=0,ZIndex=3,Parent=SBFrame})
    local SBLabel=N("TextLabel",{
        Size=UDim2.new(1,-8,1,0),Position=UDim2.new(0,8,0,0),
        BackgroundTransparency=1,Font=Enum.Font.Gotham,
        Text="RbxUI v3.0  ·  "..tn,TextColor3=t.StatusText,TextSize=10,
        TextXAlignment=Enum.TextXAlignment.Left,ZIndex=4,Parent=SBFrame,
    })

    -- drag + controls
    Drag(Main,TopBar)
    local minimized=false
    MinBtn.MouseButton1Click:Connect(function()
        minimized=not minimized
        T(Main,{Size=minimized and UDim2.new(0,W,0,36) or UDim2.new(0,W,0,H)},0.2)
    end)
    ClsBtn.MouseButton1Click:Connect(function()
        T(Main,{Size=UDim2.new(0,W,0,0),BackgroundTransparency=1},0.18)
        task.delay(0.2,function() SG:Destroy() end)
    end)
    for _,b in ipairs({MinBtn,ClsBtn}) do
        b.MouseEnter:Connect(function() T(b,{BackgroundColor3=b==ClsBtn and Color3.fromRGB(178,36,55) or t.GroupBorder}) end)
        b.MouseLeave:Connect(function() T(b,{BackgroundColor3=t.ColBorder}) end)
    end

    -- entry animation
    Main.BackgroundTransparency=1; Main.Size=UDim2.new(0,W,0,0)
    T(Main,{BackgroundTransparency=0,Size=UDim2.new(0,W,0,H)},0.26,Enum.EasingStyle.Quint)

    -- ══════════════════════════════════════════════════════════════════
    local Window={Pages={},ActivePage=nil,_t=t,_tn=tn,_sg=SG,_main=Main}

    function Window:SetTheme(name)
        local nt=RbxUI.Themes[name]; if not nt then return end
        t=nt; self._t=nt; self._tn=name
        T(Main,{BackgroundColor3=nt.Window}); T(TopBar,{BackgroundColor3=nt.TopBar})
        T(PageBar,{BackgroundColor3=nt.PageBar}); T(Content,{BackgroundColor3=nt.Window})
        T(SBFrame,{BackgroundColor3=nt.StatusBar}); T(SBLabel,{TextColor3=nt.StatusText})
        T(WStr,{Color=nt.WindowBorder}); T(TabLine,{BackgroundColor3=nt.Accent})
        SBLabel.Text="RbxUI v3.0  ·  "..name
    end

    -- ════════════════════════════════════════════════════════════════
    --  ADD PAGE
    -- ════════════════════════════════════════════════════════════════
    function Window:AddPage(name, icon)
        local Page={Columns={},Name=name}
        local lbl=(icon and icon.." " or "")..name

        -- Tab button
        local PBtn=N("TextButton",{
            Name=name,Size=UDim2.new(0,0,1,0),AutomaticSize=Enum.AutomaticSize.X,
            BackgroundTransparency=1,Font=Enum.Font.GothamSemibold,
            Text=lbl,TextColor3=t.PageInactive,TextSize=11,ZIndex=4,Parent=PageList,
        })
        N("UIPadding",{PaddingLeft=UDim.new(0,11),PaddingRight=UDim.new(0,11),Parent=PBtn})

        -- Page frame
        local PFrame=N("Frame",{
            Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Visible=false,ZIndex=2,Parent=Content,
        })
        -- Column row
        local ColRow=N("Frame",{
            Size=UDim2.new(1,-12,1,-10),Position=UDim2.new(0,6,0,6),
            BackgroundTransparency=1,ZIndex=2,Parent=PFrame,
        })
        local ColLayout=N("UIListLayout",{
            FillDirection=Enum.FillDirection.Horizontal,
            VerticalAlignment=Enum.VerticalAlignment.Top,
            Padding=UDim.new(0,5),Parent=ColRow,
        })

        Page.Frame=PFrame; Page.ColRow=ColRow; Page.ColLayout=ColLayout; Page.Button=PBtn; Page.Window=self
        table.insert(self.Pages,Page)
        if #self.Pages==1 then self:SelectPage(Page) end

        PBtn.MouseButton1Click:Connect(function() self:SelectPage(Page) end)
        PBtn.MouseEnter:Connect(function() if self.ActivePage~=Page then T(PBtn,{TextColor3=t.Text}) end end)
        PBtn.MouseLeave:Connect(function() if self.ActivePage~=Page then T(PBtn,{TextColor3=t.PageInactive}) end end)

        -- ══════════════════════════════════════════════════════════
        --  ADD COLUMN
        -- ══════════════════════════════════════════════════════════
        function Page:AddColumn()
            local Col={Groups={}}

            local ColFrame=N("Frame",{
                Size=UDim2.new(0,100,1,0), -- resized dynamically
                BackgroundColor3=t.Column,BorderSizePixel=0,ZIndex=3,Parent=ColRow,
            })
            Crn(6,ColFrame)
            Str(t.ColBorder,1,ColFrame)

            local CScroll=N("ScrollingFrame",{
                Size=UDim2.new(1,0,1,-6),Position=UDim2.new(0,0,0,3),
                BackgroundTransparency=1,BorderSizePixel=0,
                ScrollBarThickness=2,ScrollBarImageColor3=t.ScrollBar,ScrollBarImageTransparency=0.4,
                CanvasSize=UDim2.new(0,0,0,0),AutomaticCanvasSize=Enum.AutomaticSize.Y,
                ZIndex=3,Parent=ColFrame,
            })
            N("UIListLayout",{Padding=UDim.new(0,5),SortOrder=Enum.SortOrder.LayoutOrder,Parent=CScroll})
            N("UIPadding",{
                PaddingTop=UDim.new(0,5),PaddingBottom=UDim.new(0,5),
                PaddingLeft=UDim.new(0,5),PaddingRight=UDim.new(0,5),
                Parent=CScroll,
            })

            Col.Frame=ColFrame; Col.Scroll=CScroll
            table.insert(self.Columns,Col)

            -- redistribute widths
            local function Redistribute()
                local n=#self.Columns
                if n==0 then return end
                local totalW=ColRow.AbsoluteSize.X
                local colW=math.floor((totalW-(n-1)*5)/n)
                for _,c in ipairs(self.Columns) do
                    c.Frame.Size=UDim2.new(0,colW,1,0)
                end
            end
            ColRow:GetPropertyChangedSignal("AbsoluteSize"):Connect(Redistribute)
            task.defer(Redistribute)

            -- ════════════════════════════════════════════════════════
            --  ADD GROUP
            -- ════════════════════════════════════════════════════════
            function Col:AddGroup(name)
                local G={}
                local GFrame=N("Frame",{
                    Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,
                    BackgroundColor3=t.Group,BorderSizePixel=0,ZIndex=4,Parent=CScroll,
                })
                Crn(5,GFrame)
                Str(t.GroupBorder,1,GFrame)

                local GList=N("Frame",{
                    Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,
                    BackgroundTransparency=1,ZIndex=4,Parent=GFrame,
                })
                N("UIListLayout",{Padding=UDim.new(0,0),SortOrder=Enum.SortOrder.LayoutOrder,Parent=GList})

                -- group title row
                local GTRow=N("Frame",{Size=UDim2.new(1,0,0,24),LayoutOrder=0,BackgroundTransparency=1,ZIndex=5,Parent=GList})
                N("TextLabel",{
                    Size=UDim2.new(1,-12,1,0),Position=UDim2.new(0,10,0,0),
                    BackgroundTransparency=1,Font=Enum.Font.GothamBold,
                    Text=name:upper(),TextColor3=t.GroupTitle,TextSize=9,
                    TextXAlignment=Enum.TextXAlignment.Left,ZIndex=5,Parent=GTRow,
                })
                N("Frame",{
                    Size=UDim2.new(1,-16,0,1),Position=UDim2.new(0,8,1,-1),
                    BackgroundColor3=t.GroupBorder,BorderSizePixel=0,ZIndex=5,Parent=GTRow,
                })

                local order=0
                local function LO() order=order+1; return order end

                local function Row(h)
                    local r=N("Frame",{
                        Size=UDim2.new(1,0,0,h or 26),BackgroundTransparency=1,
                        LayoutOrder=LO(),ZIndex=5,Parent=GList,
                    })
                    N("UIPadding",{PaddingLeft=UDim.new(0,9),PaddingRight=UDim.new(0,9),Parent=r})
                    return r
                end

                -- ─────────────────────────────────────────────────
                --  TOGGLE
                -- ─────────────────────────────────────────────────
                function G:AddToggle(text,default,callback)
                    local val=default or false
                    local R=Row(26)
                    N("TextLabel",{
                        Size=UDim2.new(1,-42,1,0),BackgroundTransparency=1,
                        Font=Enum.Font.Gotham,Text=text,TextColor3=t.Text,
                        TextSize=11,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=6,Parent=R,
                    })
                    local Track=N("Frame",{
                        Size=UDim2.new(0,30,0,16),Position=UDim2.new(1,-30,0.5,-8),
                        BackgroundColor3=val and t.ToggleOn or t.ToggleOff,BorderSizePixel=0,ZIndex=6,Parent=R,
                    })
                    Crn(8,Track)
                    local Thumb=N("Frame",{
                        Size=UDim2.new(0,11,0,11),
                        Position=val and UDim2.new(0,16,0.5,-5) or UDim2.new(0,3,0.5,-5),
                        BackgroundColor3=Color3.fromRGB(255,255,255),BorderSizePixel=0,ZIndex=7,Parent=Track,
                    })
                    Crn(6,Thumb)
                    local Tog={}
                    function Tog:SetValue(v)
                        val=v
                        T(Track,{BackgroundColor3=v and t.ToggleOn or t.ToggleOff})
                        Spr(Thumb,{Position=v and UDim2.new(0,16,0.5,-5) or UDim2.new(0,3,0.5,-5)})
                        if callback then pcall(callback,v) end
                    end
                    function Tog:GetValue() return val end
                    local B=N("TextButton",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Text="",ZIndex=8,Parent=R})
                    B.MouseButton1Click:Connect(function() Tog:SetValue(not val) end)
                    return Tog
                end

                -- ─────────────────────────────────────────────────
                --  SLIDER
                -- ─────────────────────────────────────────────────
                function G:AddSlider(text,min,max,default,callback,suffix)
                    min=min or 0; max=max or 100; default=math.clamp(default or min,min,max); suffix=suffix or ""
                    local val=default
                    local R=Row(34)
                    R.Size=UDim2.new(1,0,0,34)

                    local TopR=N("Frame",{Size=UDim2.new(1,0,0,16),BackgroundTransparency=1,ZIndex=6,Parent=R})
                    N("TextLabel",{
                        Size=UDim2.new(0.68,0,1,0),BackgroundTransparency=1,
                        Font=Enum.Font.Gotham,Text=text,TextColor3=t.Text,
                        TextSize=11,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=6,Parent=TopR,
                    })
                    local VLbl=N("TextLabel",{
                        Size=UDim2.new(0.32,0,1,0),Position=UDim2.new(0.68,0,0,0),
                        BackgroundTransparency=1,Font=Enum.Font.GothamBold,
                        Text=tostring(default)..suffix,TextColor3=t.Accent,
                        TextSize=10,TextXAlignment=Enum.TextXAlignment.Right,ZIndex=6,Parent=TopR,
                    })

                    local TBg=N("Frame",{
                        Size=UDim2.new(1,0,0,4),Position=UDim2.new(0,0,0,21),
                        BackgroundColor3=t.SliderTrack,BorderSizePixel=0,ZIndex=6,Parent=R,
                    })
                    Crn(2,TBg)
                    local pct=(default-min)/(max-min)
                    local Fill=N("Frame",{Size=UDim2.new(pct,0,1,0),BackgroundColor3=t.SliderFill,BorderSizePixel=0,ZIndex=7,Parent=TBg})
                    Crn(2,Fill)
                    local Thumb=N("Frame",{
                        Size=UDim2.new(0,10,0,10),AnchorPoint=Vector2.new(0.5,0.5),
                        Position=UDim2.new(pct,0,0.5,0),
                        BackgroundColor3=Color3.fromRGB(255,255,255),BorderSizePixel=0,ZIndex=8,Parent=TBg,
                    })
                    Crn(5,Thumb)

                    local Sld={}
                    function Sld:SetValue(v)
                        v=math.clamp(math.round(v),min,max); val=v
                        local p=(v-min)/(max-min)
                        T(Fill,{Size=UDim2.new(p,0,1,0)},0.07)
                        T(Thumb,{Position=UDim2.new(p,0,0.5,0)},0.07)
                        VLbl.Text=tostring(v)..suffix
                        if callback then pcall(callback,v) end
                    end
                    function Sld:GetValue() return val end

                    local dr=false
                    local SB=N("TextButton",{Size=UDim2.new(1,0,4,0),Position=UDim2.new(0,0,-1.5,0),BackgroundTransparency=1,Text="",ZIndex=9,Parent=TBg})
                    SB.MouseButton1Down:Connect(function() dr=true; Spr(Thumb,{Size=UDim2.new(0,13,0,13)}) end)
                    UserInputService.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 and dr then dr=false; Spr(Thumb,{Size=UDim2.new(0,10,0,10)}) end end)
                    UserInputService.InputChanged:Connect(function(i)
                        if dr and i.UserInputType==Enum.UserInputType.MouseMovement then
                            local rx=math.clamp(i.Position.X-TBg.AbsolutePosition.X,0,TBg.AbsoluteSize.X)
                            Sld:SetValue(min+(max-min)*(rx/TBg.AbsoluteSize.X))
                        end
                    end)
                    return Sld
                end

                -- ─────────────────────────────────────────────────
                --  BUTTON
                -- ─────────────────────────────────────────────────
                function G:AddButton(text,callback)
                    local R=Row(26)
                    local BF=N("Frame",{
                        Size=UDim2.new(1,0,0,21),Position=UDim2.new(0,0,0.5,-10),
                        BackgroundColor3=t.InputBg,BorderSizePixel=0,ZIndex=6,Parent=R,
                    })
                    Crn(4,BF)
                    Str(t.InputBorder,1,BF)
                    N("TextLabel",{
                        Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,
                        Font=Enum.Font.GothamSemibold,Text=text,TextColor3=t.Text,
                        TextSize=11,ZIndex=7,Parent=BF,
                    })
                    local B=N("TextButton",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Text="",ZIndex=8,Parent=BF})
                    B.MouseEnter:Connect(function() T(BF,{BackgroundColor3=t.Accent}) end)
                    B.MouseLeave:Connect(function() T(BF,{BackgroundColor3=t.InputBg}) end)
                    B.MouseButton1Down:Connect(function() T(BF,{BackgroundColor3=t.ColBorder}) end)
                    B.MouseButton1Up:Connect(function() T(BF,{BackgroundColor3=t.Accent}) end)
                    B.MouseButton1Click:Connect(function() if callback then pcall(callback) end end)
                    return BF
                end

                -- ─────────────────────────────────────────────────
                --  DROPDOWN
                -- ─────────────────────────────────────────────────
                function G:AddDropdown(text,options,default,callback)
                    local sel=default or options[1]; local open=false
                    -- Use separate frame outside GList layout so dropdown can overflow
                    local Wrap=N("Frame",{
                        Size=UDim2.new(1,0,0,26),BackgroundTransparency=1,
                        LayoutOrder=LO(),ClipsDescendants=false,ZIndex=5,Parent=GList,
                    })
                    N("UIPadding",{PaddingLeft=UDim.new(0,9),PaddingRight=UDim.new(0,9),Parent=Wrap})

                    N("TextLabel",{
                        Size=UDim2.new(0.5,0,0,26),BackgroundTransparency=1,
                        Font=Enum.Font.Gotham,Text=text,TextColor3=t.Text,
                        TextSize=11,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=6,Parent=Wrap,
                    })
                    local DB=N("Frame",{
                        Size=UDim2.new(0.48,0,0,20),Position=UDim2.new(0.52,0,0,3),
                        BackgroundColor3=t.InputBg,BorderSizePixel=0,ZIndex=6,Parent=Wrap,
                    })
                    Crn(4,DB)
                    Str(t.InputBorder,1,DB)
                    local SelL=N("TextLabel",{
                        Size=UDim2.new(1,-16,1,0),Position=UDim2.new(0,5,0,0),
                        BackgroundTransparency=1,Font=Enum.Font.Gotham,
                        Text=sel,TextColor3=t.Accent,TextSize=10,
                        TextXAlignment=Enum.TextXAlignment.Left,ZIndex=7,Parent=DB,
                    })
                    N("TextLabel",{
                        Size=UDim2.new(0,12,1,0),Position=UDim2.new(1,-13,0,0),
                        BackgroundTransparency=1,Font=Enum.Font.GothamBold,
                        Text="▾",TextColor3=t.TextMuted,TextSize=9,ZIndex=7,Parent=DB,
                    })

                    local List=N("Frame",{
                        Size=UDim2.new(1,0,0,0),Position=UDim2.new(0,0,1,2),
                        BackgroundColor3=t.DropBg,BorderSizePixel=0,ClipsDescendants=true,
                        ZIndex=20,Visible=false,Parent=DB,
                    })
                    Crn(4,List)
                    Str(t.InputBorder,1,List)
                    N("UIListLayout",{SortOrder=Enum.SortOrder.LayoutOrder,Parent=List})
                    N("UIPadding",{PaddingTop=UDim.new(0,3),PaddingBottom=UDim.new(0,3),Parent=List})

                    local DD={}
                    function DD:SetValue(v) sel=v; SelL.Text=v; if callback then pcall(callback,v) end end
                    function DD:GetValue() return sel end

                    for _,opt in ipairs(options) do
                        local It=N("TextButton",{
                            Size=UDim2.new(1,0,0,20),BackgroundTransparency=1,
                            Font=Enum.Font.Gotham,Text="  "..opt,
                            TextColor3=opt==sel and t.Accent or t.Text,TextSize=10,
                            TextXAlignment=Enum.TextXAlignment.Left,ZIndex=21,Parent=List,
                        })
                        It.MouseEnter:Connect(function() T(It,{BackgroundTransparency=0,BackgroundColor3=t.ColBorder}) end)
                        It.MouseLeave:Connect(function() T(It,{BackgroundTransparency=1}) end)
                        It.MouseButton1Click:Connect(function()
                            DD:SetValue(opt)
                            for _,c in ipairs(List:GetChildren()) do
                                if c:IsA("TextButton") then T(c,{TextColor3=c.Text:find(opt,1,true) and t.Accent or t.Text}) end
                            end
                            open=false
                            T(List,{Size=UDim2.new(1,0,0,0)},0.13)
                            task.delay(0.14,function() List.Visible=false; Wrap.Size=UDim2.new(1,0,0,26) end)
                        end)
                    end

                    local itemH=#options*20+8
                    local BC=N("TextButton",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Text="",ZIndex=8,Parent=DB})
                    BC.MouseButton1Click:Connect(function()
                        open=not open
                        if open then
                            List.Visible=true; List.Size=UDim2.new(1,0,0,0)
                            T(List,{Size=UDim2.new(1,0,0,itemH)},0.16)
                            Wrap.Size=UDim2.new(1,0,0,26+itemH+4)
                        else
                            T(List,{Size=UDim2.new(1,0,0,0)},0.13)
                            task.delay(0.14,function() List.Visible=false; Wrap.Size=UDim2.new(1,0,0,26) end)
                        end
                    end)
                    return DD
                end

                -- ─────────────────────────────────────────────────
                --  COLOR PICKER
                -- ─────────────────────────────────────────────────
                function G:AddColorPicker(text,default,callback)
                    default=default or Color3.fromRGB(200,45,92)
                    local function C2HSV(c)
                        local r,g,b=c.R,c.G,c.B
                        local M=math.max(r,g,b); local m=math.min(r,g,b); local d=M-m
                        local h2=0; local s2=M==0 and 0 or d/M; local v2=M
                        if d>0 then
                            if M==r then h2=(g-b)/d%6 elseif M==g then h2=(b-r)/d+2 else h2=(r-g)/d+4 end
                            h2=h2/6
                        end
                        return h2,s2,v2
                    end
                    local h,s,v=C2HSV(default)
                    local open=false

                    local Wrap=N("Frame",{
                        Size=UDim2.new(1,0,0,26),BackgroundTransparency=1,
                        LayoutOrder=LO(),ClipsDescendants=false,ZIndex=5,Parent=GList,
                    })
                    N("UIPadding",{PaddingLeft=UDim.new(0,9),PaddingRight=UDim.new(0,9),Parent=Wrap})
                    N("TextLabel",{
                        Size=UDim2.new(0.58,0,0,26),BackgroundTransparency=1,
                        Font=Enum.Font.Gotham,Text=text,TextColor3=t.Text,
                        TextSize=11,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=6,Parent=Wrap,
                    })
                    local Sw=N("Frame",{
                        Size=UDim2.new(0.40,0,0,18),Position=UDim2.new(0.60,0,0,4),
                        BackgroundColor3=default,BorderSizePixel=0,ZIndex=6,Parent=Wrap,
                    })
                    Crn(4,Sw)
                    Str(t.InputBorder,1,Sw)

                    local Panel=N("Frame",{
                        Size=UDim2.new(1,0,0,0),Position=UDim2.new(0,0,1,2),
                        BackgroundColor3=t.DropBg,BorderSizePixel=0,ClipsDescendants=true,
                        ZIndex=20,Visible=false,Parent=Wrap,
                    })
                    Crn(5,Panel)
                    Str(t.InputBorder,1,Panel)
                    N("UIPadding",{PaddingTop=UDim.new(0,7),PaddingBottom=UDim.new(0,7),PaddingLeft=UDim.new(0,7),PaddingRight=UDim.new(0,7),Parent=Panel})

                    local SV=N("ImageLabel",{
                        Size=UDim2.new(1,0,0,86),BackgroundColor3=Color3.fromHSV(h,1,1),
                        BorderSizePixel=0,Image="rbxassetid://4155801252",ZIndex=21,Parent=Panel,
                    })
                    Crn(4,SV)
                    N("ImageLabel",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Image="rbxassetid://4155800584",ZIndex=22,Parent=SV})
                    local SVCur=N("Frame",{
                        Size=UDim2.new(0,8,0,8),AnchorPoint=Vector2.new(0.5,0.5),
                        Position=UDim2.new(s,0,1-v,0),
                        BackgroundColor3=Color3.fromRGB(255,255,255),BorderSizePixel=0,ZIndex=23,Parent=SV,
                    })
                    Crn(4,SVCur); Str(Color3.new(0,0,0),1.5,SVCur)

                    local HBar=N("ImageLabel",{
                        Size=UDim2.new(1,0,0,11),Position=UDim2.new(0,0,0,92),
                        BorderSizePixel=0,Image="rbxassetid://3641079629",ZIndex=21,Parent=Panel,
                    })
                    Crn(3,HBar)
                    local HCur=N("Frame",{
                        Size=UDim2.new(0,5,1,4),AnchorPoint=Vector2.new(0.5,0.5),
                        Position=UDim2.new(h,0,0.5,0),
                        BackgroundColor3=Color3.fromRGB(255,255,255),BorderSizePixel=0,ZIndex=22,Parent=HBar,
                    })
                    Crn(3,HCur)

                    local function Hex(c) return string.format("#%02X%02X%02X",math.round(c.R*255),math.round(c.G*255),math.round(c.B*255)) end
                    local HLbl=N("TextLabel",{
                        Size=UDim2.new(1,0,0,15),Position=UDim2.new(0,0,0,108),
                        BackgroundTransparency=1,Font=Enum.Font.GothamBold,
                        Text=Hex(default),TextColor3=t.TextMuted,TextSize=9,ZIndex=21,Parent=Panel,
                    })
                    local PH=128

                    local CP={}
                    local function Upd()
                        local c=Color3.fromHSV(h,s,v)
                        Sw.BackgroundColor3=c; SV.BackgroundColor3=Color3.fromHSV(h,1,1); HLbl.Text=Hex(c)
                        if callback then pcall(callback,c) end
                    end
                    function CP:SetColor(c) h,s,v=C2HSV(c); SVCur.Position=UDim2.new(s,0,1-v,0); HCur.Position=UDim2.new(h,0,0.5,0); Upd() end
                    function CP:GetColor() return Color3.fromHSV(h,s,v) end

                    local svD=false
                    local SVB=N("TextButton",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Text="",ZIndex=24,Parent=SV})
                    SVB.MouseButton1Down:Connect(function() svD=true end)
                    UserInputService.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then svD=false end end)
                    UserInputService.InputChanged:Connect(function(i)
                        if svD and i.UserInputType==Enum.UserInputType.MouseMovement then
                            local rx=math.clamp(i.Position.X-SV.AbsolutePosition.X,0,SV.AbsoluteSize.X)
                            local ry=math.clamp(i.Position.Y-SV.AbsolutePosition.Y,0,SV.AbsoluteSize.Y)
                            s=rx/SV.AbsoluteSize.X; v=1-ry/SV.AbsoluteSize.Y
                            SVCur.Position=UDim2.new(s,0,1-v,0); Upd()
                        end
                    end)
                    local hD=false
                    local HB=N("TextButton",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Text="",ZIndex=23,Parent=HBar})
                    HB.MouseButton1Down:Connect(function() hD=true end)
                    UserInputService.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then hD=false end end)
                    UserInputService.InputChanged:Connect(function(i)
                        if hD and i.UserInputType==Enum.UserInputType.MouseMovement then
                            local rx=math.clamp(i.Position.X-HBar.AbsolutePosition.X,0,HBar.AbsoluteSize.X)
                            h=rx/HBar.AbsoluteSize.X; HCur.Position=UDim2.new(h,0,0.5,0); Upd()
                        end
                    end)

                    local TB=N("TextButton",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Text="",ZIndex=8,Parent=Sw})
                    TB.MouseButton1Click:Connect(function()
                        open=not open
                        if open then
                            Panel.Visible=true; Panel.Size=UDim2.new(1,0,0,0)
                            T(Panel,{Size=UDim2.new(1,0,0,PH)},0.18)
                            Wrap.Size=UDim2.new(1,0,0,26+PH+4)
                        else
                            T(Panel,{Size=UDim2.new(1,0,0,0)},0.14)
                            task.delay(0.15,function() Panel.Visible=false; Wrap.Size=UDim2.new(1,0,0,26) end)
                        end
                    end)
                    return CP
                end

                -- ─────────────────────────────────────────────────
                --  KEYBIND
                -- ─────────────────────────────────────────────────
                function G:AddKeybind(text,default,callback)
                    local key=default or Enum.KeyCode.Unknown; local listening=false
                    local R=Row(26)
                    N("TextLabel",{
                        Size=UDim2.new(0.55,0,1,0),BackgroundTransparency=1,Font=Enum.Font.Gotham,
                        Text=text,TextColor3=t.Text,TextSize=11,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=6,Parent=R,
                    })
                    local KBox=N("TextButton",{
                        Size=UDim2.new(0.43,0,0,19),Position=UDim2.new(0.57,0,0.5,-9),
                        BackgroundColor3=t.InputBg,BorderSizePixel=0,
                        Font=Enum.Font.GothamBold,Text="["..key.Name.."]",
                        TextColor3=t.Accent,TextSize=9,ZIndex=6,Parent=R,
                    })
                    Crn(4,KBox); Str(t.InputBorder,1,KBox)
                    local KB={}
                    function KB:GetKey() return key end
                    KBox.MouseButton1Click:Connect(function()
                        listening=true; KBox.Text="[...]"
                        T(KBox,{BackgroundColor3=t.Accent,TextColor3=Color3.new(0,0,0)})
                    end)
                    UserInputService.InputBegan:Connect(function(i,gp)
                        if not gp and listening and i.UserInputType==Enum.UserInputType.Keyboard then
                            listening=false; key=i.KeyCode; KBox.Text="["..key.Name.."]"
                            T(KBox,{BackgroundColor3=t.InputBg,TextColor3=t.Accent})
                            if callback then pcall(callback,key) end
                        elseif not listening and i.KeyCode==key then
                            if callback then pcall(callback,key) end
                        end
                    end)
                    return KB
                end

                -- ─────────────────────────────────────────────────
                --  TEXTBOX
                -- ─────────────────────────────────────────────────
                function G:AddTextBox(text,placeholder,callback)
                    local R=Row(26)
                    N("TextLabel",{
                        Size=UDim2.new(0.46,0,1,0),BackgroundTransparency=1,Font=Enum.Font.Gotham,
                        Text=text,TextColor3=t.Text,TextSize=11,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=6,Parent=R,
                    })
                    local Box=N("TextBox",{
                        Size=UDim2.new(0.52,0,0,19),Position=UDim2.new(0.48,0,0.5,-9),
                        BackgroundColor3=t.InputBg,BorderSizePixel=0,Font=Enum.Font.Gotham,
                        Text="",PlaceholderText=placeholder or "...",PlaceholderColor3=t.TextDim,
                        TextColor3=t.Text,TextSize=10,ZIndex=6,ClearTextOnFocus=false,Parent=R,
                    })
                    Crn(4,Box)
                    local BS=Str(t.InputBorder,1,Box)
                    Box.Focused:Connect(function() T(BS,{Color=t.Accent,Thickness=1.5}) end)
                    Box.FocusLost:Connect(function()
                        T(BS,{Color=t.InputBorder,Thickness=1})
                        if callback then pcall(callback,Box.Text) end
                    end)
                    return Box
                end

                -- ─────────────────────────────────────────────────
                --  LABEL
                -- ─────────────────────────────────────────────────
                function G:AddLabel(text)
                    local R=Row(19)
                    N("TextLabel",{
                        Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Font=Enum.Font.Gotham,
                        Text=text,TextColor3=t.TextMuted,TextSize=10,
                        TextXAlignment=Enum.TextXAlignment.Left,ZIndex=6,Parent=R,
                    })
                end

                return G
            end -- AddGroup

            return Col
        end -- AddColumn

        return Page
    end -- AddPage

    -- ════════════════════════════════════════════════════════════════
    --  SELECT PAGE
    -- ════════════════════════════════════════════════════════════════
    function Window:SelectPage(page)
        for _,p in ipairs(self.Pages) do
            p.Frame.Visible=false
            T(p.Button,{TextColor3=t.PageInactive})
        end
        page.Frame.Visible=true
        T(page.Button,{TextColor3=t.PageText})
        local bx=page.Button.AbsolutePosition.X-PageList.AbsolutePosition.X
        local bw=page.Button.AbsoluteSize.X
        T(TabLine,{Position=UDim2.new(0,bx,1,-2),Size=UDim2.new(0,bw,0,2)},0.16)
        self.ActivePage=page
    end

    -- ════════════════════════════════════════════════════════════════
    --  NOTIFY
    -- ════════════════════════════════════════════════════════════════
    function Window:Notify(title2,msg,ntype,dur)
        ntype=ntype or "info"; dur=dur or 3
        local ac={info=t.Accent,success=t.ToggleOn,danger=Color3.fromRGB(198,48,68),warning=Color3.fromRGB(208,148,28)}
        local col=ac[ntype] or t.Accent

        local H=SG:FindFirstChild("_NH") or (function()
            local h=N("Frame",{Name="_NH",Size=UDim2.new(0,230,1,0),Position=UDim2.new(1,-245,0,0),BackgroundTransparency=1,ZIndex=100,Parent=SG})
            N("UIListLayout",{VerticalAlignment=Enum.VerticalAlignment.Bottom,SortOrder=Enum.SortOrder.LayoutOrder,Padding=UDim.new(0,5),Parent=h})
            N("UIPadding",{PaddingBottom=UDim.new(0,16),Parent=h})
            return h
        end)()

        local C=N("Frame",{Size=UDim2.new(1,0,0,0),BackgroundColor3=t.Group,BorderSizePixel=0,ClipsDescendants=true,ZIndex=101,Parent=H})
        Crn(6,C); Str(col,1,C)
        N("Frame",{Size=UDim2.new(0,3,1,-10),Position=UDim2.new(0,0,0,5),BackgroundColor3=col,BorderSizePixel=0,ZIndex=102,Parent=C})
        N("TextLabel",{Size=UDim2.new(1,-14,0,16),Position=UDim2.new(0,12,0,7),BackgroundTransparency=1,Font=Enum.Font.GothamBold,Text=title2,TextColor3=t.Text,TextSize=11,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=102,Parent=C})
        N("TextLabel",{Size=UDim2.new(1,-14,0,24),Position=UDim2.new(0,12,0,22),BackgroundTransparency=1,Font=Enum.Font.Gotham,Text=msg,TextColor3=t.TextMuted,TextSize=10,TextWrapped=true,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=102,Parent=C})
        local PF=N("Frame",{Size=UDim2.new(1,0,1,0),BackgroundColor3=col,BorderSizePixel=0,ZIndex=103,Parent=N("Frame",{Size=UDim2.new(1,0,0,2),Position=UDim2.new(0,0,1,-2),BackgroundColor3=t.ColBorder,BorderSizePixel=0,ZIndex=102,Parent=C})})

        T(C,{Size=UDim2.new(1,0,0,56)},0.2)
        task.wait(0.2)
        T(PF,{Size=UDim2.new(0,0,1,0)},dur,Enum.EasingStyle.Linear)
        task.wait(dur)
        T(C,{Size=UDim2.new(1,0,0,0),BackgroundTransparency=1},0.16)
        task.delay(0.18,function() C:Destroy() end)
    end

    return Window
end

return RbxUI
