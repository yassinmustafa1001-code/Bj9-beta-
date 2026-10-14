--[[
 LIQUID MOBILE UI | BJ98-SHYN | v2.2
 Roblox mobile UI / Delta
]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local MarketplaceService = game:GetService("MarketplaceService")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local old = PlayerGui:FindFirstChild("LiquidMobileUI")
if old then old:Destroy() end
old = Lighting:FindFirstChild("BJ98_LiquidBlur")
if old then old:Destroy() end

local CONFIG = {
    Name = "BJ98-SHYN", Version = "2.2", DefaultTheme = "Blue",
    WindowAnimationScale = 1, TransitionAnimationScale = 1,
    AnimationDurationScale = 1, FloatingShape = "Circle",
}
local Themes = {
    Blue = {Background=Color3.fromRGB(12,17,28),Panel=Color3.fromRGB(20,28,43),Surface=Color3.fromRGB(31,43,63),Accent=Color3.fromRGB(75,155,255),Text=Color3.fromRGB(245,248,255),Muted=Color3.fromRGB(150,165,185),Border=Color3.fromRGB(55,78,110)},
    Red = {Background=Color3.fromRGB(24,13,17),Panel=Color3.fromRGB(40,23,29),Surface=Color3.fromRGB(58,33,41),Accent=Color3.fromRGB(255,75,95),Text=Color3.fromRGB(255,245,247),Muted=Color3.fromRGB(185,145,155),Border=Color3.fromRGB(105,45,58)},
    Purple = {Background=Color3.fromRGB(20,14,30),Panel=Color3.fromRGB(34,24,48),Surface=Color3.fromRGB(49,35,68),Accent=Color3.fromRGB(180,115,255),Text=Color3.fromRGB(248,242,255),Muted=Color3.fromRGB(170,150,195),Border=Color3.fromRGB(85,60,120)},
    Pink = {Background=Color3.fromRGB(26,15,24),Panel=Color3.fromRGB(43,24,39),Surface=Color3.fromRGB(61,35,55),Accent=Color3.fromRGB(255,110,190),Text=Color3.fromRGB(255,245,251),Muted=Color3.fromRGB(190,150,175),Border=Color3.fromRGB(105,55,90)},
    Green = {Background=Color3.fromRGB(12,23,19),Panel=Color3.fromRGB(21,37,30),Surface=Color3.fromRGB(31,53,42),Accent=Color3.fromRGB(75,230,155),Text=Color3.fromRGB(240,255,247),Muted=Color3.fromRGB(145,180,160),Border=Color3.fromRGB(45,95,70)},
}
local Theme = Themes[CONFIG.DefaultTheme]
local function duration(t, category)
    local s = CONFIG.AnimationDurationScale
    if category == "Window" then s *= CONFIG.WindowAnimationScale
    elseif category == "Transition" then s *= CONFIG.TransitionAnimationScale end
    return math.max(0.01, t*s)
end
local function tween(obj, props, t, category, style, dir)
    if not obj or not obj.Parent then return nil end
    local tw = TweenService:Create(obj,TweenInfo.new(duration(t or .25,category),style or Enum.EasingStyle.Quart,dir or Enum.EasingDirection.Out),props)
    tw:Play()
    return tw
end
local function create(class, props, parent)
    local obj = Instance.new(class)
    for k,v in pairs(props or {}) do obj[k]=v end
    obj.Parent=parent
    return obj
end
local function corner(obj, radius)
    return create("UICorner",{CornerRadius=UDim.new(0,radius or 10)},obj)
end
local function stroke(obj,color,transparency)
    return create("UIStroke",{Color=color or Theme.Border,Transparency=transparency or .25,Thickness=1},obj)
end
local function label(parent,text,pos,size,fontSize,color)
    return create("TextLabel",{Position=pos,Size=size,BackgroundTransparency=1,Text=tostring(text),TextColor3=color or Theme.Text,TextSize=fontSize or 12,Font=Enum.Font.GothamMedium,TextWrapped=true,TextXAlignment=Enum.TextXAlignment.Left,TextYAlignment=Enum.TextYAlignment.Center},parent)
end
local function button(parent,text,height)
    local b=create("TextButton",{Size=UDim2.new(1,0,0,height or 38),BackgroundColor3=Theme.Surface,BorderSizePixel=0,Text=text,TextColor3=Theme.Text,TextSize=12,Font=Enum.Font.GothamMedium,AutoButtonColor=false},parent)
    corner(b,9)
    b.Activated:Connect(function()
        local restoreColor = b:GetAttribute("IsTabButton") and
            (b:GetAttribute("IsSelectedTab") and Theme.Accent:Lerp(Theme.Panel, 0.38) or Theme.Surface:Lerp(Theme.Background, 0.42))
            or Theme.Surface
        tween(b,{BackgroundColor3=Theme.Accent:Lerp(Theme.Panel,0.28)},.10,"Transition")
        task.delay(duration(.16,"Transition"),function()
            if b.Parent then
                if b:GetAttribute("IsTabButton") then
                    restoreColor = b:GetAttribute("IsSelectedTab") and Theme.Accent:Lerp(Theme.Panel,0.38) or Theme.Surface:Lerp(Theme.Background,0.42)
                else
                    restoreColor = Theme.Surface
                end
                tween(b,{BackgroundColor3=restoreColor},.18,"Transition")
            end
        end)
    end)
    return b
end
local function section(parent,title)
    local s=create("Frame",{Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundColor3=Theme.Panel,BorderSizePixel=0},parent)
    corner(s,12)
    create("UIPadding",{PaddingTop=UDim.new(0,10),PaddingBottom=UDim.new(0,10),PaddingLeft=UDim.new(0,10),PaddingRight=UDim.new(0,10)},s)
    create("UIListLayout",{Padding=UDim.new(0,7),SortOrder=Enum.SortOrder.LayoutOrder},s)
    local l=label(s,title,UDim2.new(),UDim2.new(1,0,0,25),13,Theme.Accent); l.LayoutOrder=0
    return s
end
local function infoRow(parent,title,value)
    local r=create("Frame",{Size=UDim2.new(1,0,0,32),BackgroundColor3=Theme.Surface,BorderSizePixel=0},parent); corner(r,7)
    label(r,title,UDim2.fromOffset(8,0),UDim2.new(.42,-8,1,0),10,Theme.Muted)
    local v=label(r,value,UDim2.new(.42,0,0,0),UDim2.new(.58,-8,1,0),10,Theme.Text)
    return r,v
end

local Blur=create("BlurEffect",{Name="BJ98_LiquidBlur",Size=0,Enabled=true},Lighting)
local Screen=create("ScreenGui",{Name="LiquidMobileUI",ResetOnSpawn=false,ZIndexBehavior=Enum.ZIndexBehavior.Sibling,DisplayOrder=999},PlayerGui)

-- Startup splash
local Intro=create("Frame",{Name="StartupScreen",Size=UDim2.fromScale(1,1),BackgroundColor3=Color3.fromRGB(7,10,18),BackgroundTransparency=.12,BorderSizePixel=0,ZIndex=100},Screen)
local IntroScale=create("UIScale",{Scale=.94},Intro)
local IntroCard=create("Frame",{AnchorPoint=Vector2.new(.5,.5),Position=UDim2.fromScale(.5,.5),Size=UDim2.new(.78,0,0,205),BackgroundColor3=Theme.Panel,BorderSizePixel=0,ZIndex=101},Intro)
corner(IntroCard,22); stroke(IntroCard,Theme.Accent,.25)
create("UISizeConstraint",{MaxSize=Vector2.new(360,230),MinSize=Vector2.new(250,190)},IntroCard)
local logo=create("Frame",{AnchorPoint=Vector2.new(.5,0),Position=UDim2.new(.5,0,0,18),Size=UDim2.fromOffset(48,48),BackgroundColor3=Theme.Accent,BorderSizePixel=0,ZIndex=102},IntroCard); corner(logo,16)
local logoText=label(logo,"O",UDim2.new(),UDim2.fromScale(1,1),27,Color3.new(1,1,1)); logoText.TextXAlignment=Enum.TextXAlignment.Center; logoText.ZIndex=103
local introTitle=label(IntroCard,"Hellow Burble",UDim2.new(0,10,0,76),UDim2.new(1,-20,0,32),19,Theme.Text); introTitle.TextXAlignment=Enum.TextXAlignment.Center; introTitle.ZIndex=102
local introSub=label(IntroCard,"LIQUID MOBILE INTERFACE",UDim2.new(0,10,0,109),UDim2.new(1,-20,0,20),9,Theme.Muted); introSub.TextXAlignment=Enum.TextXAlignment.Center; introSub.ZIndex=102
local progressBack=create("Frame",{Position=UDim2.new(0,25,1,-35),Size=UDim2.new(1,-50,0,5),BackgroundColor3=Theme.Surface,BorderSizePixel=0,ZIndex=102},IntroCard); corner(progressBack,5)
local progressFill=create("Frame",{Size=UDim2.new(0,0,1,0),BackgroundColor3=Theme.Accent,BorderSizePixel=0,ZIndex=103},progressBack); corner(progressFill,5)

-- Floating O button
local Floating=create("TextButton",{Name="LiquidToggle",AnchorPoint=Vector2.new(1,.5),Position=UDim2.new(1,-12,.5,0),Size=UDim2.fromOffset(46,46),BackgroundColor3=Color3.new(0,0,0),Text="O",TextColor3=Color3.new(1,1,1),TextSize=22,Font=Enum.Font.GothamBold,AutoButtonColor=false,ZIndex=20},Screen)
local FloatingCorner=corner(Floating,23)
local FloatingStroke=stroke(Floating,Theme.Accent,.2)
local function applyFloatingShape(shape)
    CONFIG.FloatingShape=shape
    if FloatingCorner then FloatingCorner:Destroy(); FloatingCorner=nil end
    Floating.Rotation=0; Floating.Size=UDim2.fromOffset(46,46)
    Floating.BackgroundTransparency=0; Floating.BackgroundColor3=Color3.new(0,0,0)
    Floating.Text="O"; Floating.TextSize=22; Floating.TextColor3=Color3.new(1,1,1)
    FloatingStroke.Enabled=true
    if shape=="Circle" then FloatingCorner=corner(Floating,23)
    elseif shape=="Square" then FloatingCorner=corner(Floating,5)
    elseif shape=="Triangle" then Floating.Text="▲"; Floating.TextSize=25; FloatingCorner=corner(Floating,5)
    elseif shape=="Diamond" then Floating.Rotation=45; FloatingCorner=corner(Floating,5); Floating.Text="O"
    elseif shape=="Hide" then Floating.BackgroundTransparency=1; Floating.TextColor3=Theme.Accent; FloatingStroke.Enabled=false end
end

-- Main window. UICorner rounds all corners; header overlays the top edge.
local Main=create("Frame",{Name="MainWindow",AnchorPoint=Vector2.new(.5,.5),Position=UDim2.fromScale(.5,.5),Size=UDim2.fromScale(.86,.64),BackgroundColor3=Theme.Background,BorderSizePixel=0,Visible=false,ClipsDescendants=true,ZIndex=2},Screen)
create("UISizeConstraint",{MinSize=Vector2.new(290,320),MaxSize=Vector2.new(620,560)},Main)
corner(Main,23); stroke(Main,Theme.Border,.2)
local MainScale=create("UIScale",{Scale=.9},Main)
local Header=create("Frame",{Name="Header",Size=UDim2.new(1,0,0,50),BackgroundColor3=Theme.Panel,BorderSizePixel=0,ZIndex=3},Main)
corner(Header,19)
local HeaderTitle=label(Header,"BJ98-SHYN",UDim2.fromOffset(14,4),UDim2.new(1,-125,0,23),15,Theme.Text)
local HeaderSubtitle=label(Header,"LIQUID MOBILE INTERFACE",UDim2.fromOffset(14,27),UDim2.new(1,-125,0,14),8,Theme.Muted)
local CloseButton=create("TextButton",{AnchorPoint=Vector2.new(1,.5),Position=UDim2.new(1,-9,.5,0),Size=UDim2.fromOffset(30,30),BackgroundColor3=Theme.Surface,Text="×",TextColor3=Theme.Text,TextSize=20,Font=Enum.Font.Gotham,AutoButtonColor=false,ZIndex=4},Header); corner(CloseButton,10)
local MinimizeButton=create("TextButton",{AnchorPoint=Vector2.new(1,.5),Position=UDim2.new(1,-45,.5,0),Size=UDim2.fromOffset(30,30),BackgroundColor3=Theme.Surface,Text="−",TextColor3=Theme.Text,TextSize=20,Font=Enum.Font.Gotham,AutoButtonColor=false,ZIndex=4},Header); corner(MinimizeButton,10)

local Sidebar=create("ScrollingFrame",{Position=UDim2.fromOffset(0,50),Size=UDim2.new(0,105,1,-83),BackgroundColor3=Theme.Panel,BorderSizePixel=0,ScrollBarThickness=2,ScrollBarImageColor3=Theme.Accent,CanvasSize=UDim2.new(),AutomaticCanvasSize=Enum.AutomaticSize.Y,ZIndex=3},Main)
corner(Sidebar,14)
create("UIPadding",{PaddingTop=UDim.new(0,8),PaddingBottom=UDim.new(0,8),PaddingLeft=UDim.new(0,6),PaddingRight=UDim.new(0,6)},Sidebar)
create("UIListLayout",{Padding=UDim.new(0,6),SortOrder=Enum.SortOrder.LayoutOrder},Sidebar)
local Content=create("Frame",{Position=UDim2.new(0,105,0,50),Size=UDim2.new(1,-105,1,-83),BackgroundTransparency=1,ClipsDescendants=true,ZIndex=3},Main)
local PageTitle=label(Content,"Home",UDim2.fromOffset(12,5),UDim2.new(1,-24,0,27),16,Theme.Text)
local PageHolder=create("Frame",{Position=UDim2.fromOffset(10,37),Size=UDim2.new(1,-20,1,-47),BackgroundTransparency=1,ClipsDescendants=true},Content)
-- Separate iPhone-style home bar: it sits outside the window and follows its position.
local HomeBarArea=create("Frame",{Name="HomeBarArea",AnchorPoint=Vector2.new(.5,0),Position=UDim2.fromOffset(0,0),Size=UDim2.fromOffset(150,25),BackgroundTransparency=1,ZIndex=30,Visible=false},Screen)
local HomeBar=create("TextButton",{Name="HomeBar",AnchorPoint=Vector2.new(.5,.5),Position=UDim2.fromScale(.5,.5),Size=UDim2.fromOffset(76,5),BackgroundColor3=Theme.Muted,BackgroundTransparency=.12,BorderSizePixel=0,Text="",AutoButtonColor=false,ZIndex=16},HomeBarArea); corner(HomeBar,5)
local HomeBarHint=create("TextLabel",{AnchorPoint=Vector2.new(.5,.5),Position=UDim2.fromScale(.5,.5),Size=UDim2.fromOffset(150,20),BackgroundTransparency=1,Text="DRAG TO MOVE",TextColor3=Theme.Muted,TextTransparency=1,TextSize=8,Font=Enum.Font.GothamMedium,ZIndex=31},HomeBarArea)
local function syncHomeBar()
    if not Main.Parent then return end
    local pos, size = Main.AbsolutePosition, Main.AbsoluteSize
    HomeBarArea.Position = UDim2.fromOffset(pos.X + size.X/2, pos.Y + size.Y + 5)
    HomeBarArea.Visible = Main.Visible
end
Main:GetPropertyChangedSignal("AbsolutePosition"):Connect(syncHomeBar)
Main:GetPropertyChangedSignal("AbsoluteSize"):Connect(syncHomeBar)
Main:GetPropertyChangedSignal("Visible"):Connect(syncHomeBar)

local function Notify(message,seconds)
    if not Screen.Parent then return end
    local toast=create("Frame",{Name="LiquidToast",AnchorPoint=Vector2.new(.5,1),Position=UDim2.new(.5,0,1,85),Size=UDim2.new(.82,0,0,58),BackgroundColor3=Theme.Panel,BorderSizePixel=0,ZIndex=80},Screen)
    create("UISizeConstraint",{MaxSize=Vector2.new(380,65),MinSize=Vector2.new(220,58)},toast); corner(toast,15); stroke(toast,Theme.Accent,.2)
    local line=create("Frame",{Position=UDim2.fromOffset(0,10),Size=UDim2.new(0,3,1,-20),BackgroundColor3=Theme.Accent,BorderSizePixel=0,ZIndex=81},toast); corner(line,3)
    local txt=label(toast,message,UDim2.fromOffset(13,5),UDim2.new(1,-25,1,-10),11,Theme.Text); txt.ZIndex=81
    tween(toast,{Position=UDim2.new(.5,0,1,-18)},.38,"Transition")
    task.delay(seconds or 3.5,function()
        if toast.Parent then
            local tw=tween(toast,{Position=UDim2.new(.5,0,1,85)},.25,"Transition")
            if tw then tw.Completed:Wait() end
            if toast.Parent then toast:Destroy() end
        end
    end)
    return toast
end

-- Drag helper: one global input listener per handle; supports touch and mouse.
local function makeDraggable(handle,target,onStart,onEnd)
    local dragging,dragStart,startPos,activeTouch=false,nil,nil,nil
    handle.InputBegan:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
            dragging=true; dragStart=input.Position; startPos=target.Position
            activeTouch=input.UserInputType==Enum.UserInputType.Touch and input or nil
            if onStart then onStart() end
        end
    end)
    local changedConn
    changedConn=UserInputService.InputChanged:Connect(function(input)
        if not dragging or not target.Parent then return end
        if input.UserInputType==Enum.UserInputType.MouseMovement or (activeTouch and input==activeTouch) then
            local delta=input.Position-dragStart
            target.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+delta.X,startPos.Y.Scale,startPos.Y.Offset+delta.Y)
        end
    end)
    local endedConn
    endedConn=UserInputService.InputEnded:Connect(function(input)
        if dragging and (input.UserInputType==Enum.UserInputType.MouseButton1 or (activeTouch and input==activeTouch)) then
            dragging=false; activeTouch=nil
            if onEnd then onEnd() end
        end
    end)
    handle.Destroying:Connect(function()
        if changedConn then changedConn:Disconnect() end
        if endedConn then endedConn:Disconnect() end
    end)
end
makeDraggable(HomeBarArea,Main,function()
    tween(HomeBar,{Size=UDim2.fromOffset(92,5),BackgroundColor3=Theme.Accent},.15,"Transition")
end,function()
    tween(HomeBar,{Size=UDim2.fromOffset(76,5),BackgroundColor3=Theme.Muted},.18,"Transition")
end)
makeDraggable(Header,Main)

-- Floating button drag/tap
local floatStart,floatPosition,floatMoved,floatInput=nil,nil,false,nil
Floating.InputBegan:Connect(function(input)
    if input.UserInputType==Enum.UserInputType.Touch or input.UserInputType==Enum.UserInputType.MouseButton1 then
        floatStart=input.Position; floatPosition=Floating.Position; floatMoved=false; floatInput=input
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if not floatStart then return end
    if input.UserInputType==Enum.UserInputType.MouseMovement or (floatInput and input==floatInput) then
        local delta=input.Position-floatStart
        if math.abs(delta.X)>5 or math.abs(delta.Y)>5 then floatMoved=true end
        if floatMoved then
            Floating.Position=UDim2.new(floatPosition.X.Scale,floatPosition.X.Offset+delta.X,floatPosition.Y.Scale,floatPosition.Y.Offset+delta.Y)
        end
    end
end)
local suppressFloatClick=false
UserInputService.InputEnded:Connect(function(input)
    if floatStart and (input.UserInputType==Enum.UserInputType.MouseButton1 or (floatInput and input==floatInput)) then
        suppressFloatClick=floatMoved
        floatStart=nil; floatPosition=nil; floatInput=nil
        if suppressFloatClick then task.delay(.12,function() suppressFloatClick=false end) end
    end
end)

-- Tabs
local Tabs,TabOrder,ActiveTab={},{},nil
local function createTab(name,icon)
    local page=create("ScrollingFrame",{Name=name:gsub("%W","").."Page",Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,BorderSizePixel=0,ScrollBarThickness=2,ScrollBarImageColor3=Theme.Accent,CanvasSize=UDim2.new(),AutomaticCanvasSize=Enum.AutomaticSize.Y,Visible=false},PageHolder)
    create("UIListLayout",{Padding=UDim.new(0,8),SortOrder=Enum.SortOrder.LayoutOrder},page)
    local b=button(Sidebar,icon.."\n"..name,39); b.TextSize=9; b.TextWrapped=true
    b:SetAttribute("IsTabButton", true)
    b:SetAttribute("IsSelectedTab", false)
    b.BackgroundColor3 = Theme.Surface:Lerp(Theme.Background, 0.42)
    Tabs[name]={Page=page,Button=b}; table.insert(TabOrder,name)
    b.Activated:Connect(function()
        if ActiveTab==name then return end
        ActiveTab=name
        for n,tab in pairs(Tabs) do
            if n==name then
                tab.Page.Visible=true; tab.Page.Position=UDim2.fromOffset(0,6)
                tween(tab.Page,{Position=UDim2.fromOffset(0,0)},.22,"Transition")
                tab.Button:SetAttribute("IsSelectedTab", true)
                tween(tab.Button,{BackgroundColor3=Theme.Accent:Lerp(Theme.Panel,0.38)},.18,"Transition")
            else
                tab.Page.Visible=false
                tab.Button:SetAttribute("IsSelectedTab", false)
                tween(tab.Button,{BackgroundColor3=Theme.Surface:Lerp(Theme.Background,0.42)},.18,"Transition")
            end
        end
        PageTitle.Text=name
    end)
    return page
end
local function addAction(parent,title,description,callback)
    local b=create("TextButton",{Size=UDim2.new(1,0,0,54),BackgroundColor3=Theme.Surface,BorderSizePixel=0,Text="",AutoButtonColor=false},parent); corner(b,10)
    label(b,title,UDim2.fromOffset(10,4),UDim2.new(1,-65,0,22),11,Theme.Text)
    label(b,description or "",UDim2.fromOffset(10,27),UDim2.new(1,-65,0,17),8,Theme.Muted)
    local tag=create("TextLabel",{AnchorPoint=Vector2.new(1,.5),Position=UDim2.new(1,-8,.5,0),Size=UDim2.fromOffset(42,25),BackgroundColor3=Theme.Accent,Text="Open",TextColor3=Color3.new(1,1,1),TextSize=9,Font=Enum.Font.GothamBold},b); corner(tag,7)
    b.Activated:Connect(function()
        tween(b,{BackgroundColor3=Theme.Panel},.1,"Transition")
        task.delay(.12,function() if b.Parent then tween(b,{BackgroundColor3=Theme.Surface},.15,"Transition") end end)
        if callback then task.spawn(function() local ok,err=pcall(callback); if not ok then warn("[BJ98-SHYN] "..tostring(err)) end end) end
    end)
    return b
end

-- Home
local HomePage=createTab("Home","⌂")
local ProfileSection=section(HomePage,"User Profile")
local Avatar=create("ImageLabel",{Name="ProfileAvatar",Size=UDim2.fromOffset(68,68),BackgroundColor3=Theme.Surface,Image="",ScaleType=Enum.ScaleType.Crop,LayoutOrder=1},ProfileSection); corner(Avatar,34)
task.spawn(function()
    local ok,image=pcall(function() return Players:GetUserThumbnailAsync(LocalPlayer.UserId,Enum.ThumbnailType.HeadShot,Enum.ThumbnailSize.Size150x150) end)
    if ok and Avatar.Parent then Avatar.Image=image end
end)
infoRow(ProfileSection,"Username",LocalPlayer.Name)
infoRow(ProfileSection,"Display Name",LocalPlayer.DisplayName)
infoRow(ProfileSection,"User ID",LocalPlayer.UserId)

local ServerSection=section(HomePage,"Server Information")
local _,GameValue=infoRow(ServerSection,"Game","Loading...")
infoRow(ServerSection,"Place ID",game.PlaceId)
infoRow(ServerSection,"Server ID",game.JobId~="" and game.JobId or "Unavailable")
local PlayerCountRow,PlayerCountValue=infoRow(ServerSection,"Players",#Players:GetPlayers())
PlayerCountRow.Name="PlayerCountRow"; PlayerCountValue.Name="PlayerCountValue"
local function updatePlayerCount()
    if PlayerCountValue and PlayerCountValue.Parent then PlayerCountValue.Text=tostring(#Players:GetPlayers()) end
end
task.spawn(function()
    local ok,info=pcall(function() return MarketplaceService:GetProductInfo(game.PlaceId) end)
    if GameValue.Parent then GameValue.Text=(ok and info and info.Name) or "Unavailable" end
end)
Players.PlayerAdded:Connect(updatePlayerCount); Players.PlayerRemoving:Connect(updatePlayerCount)
addAction(ServerSection,"Refresh Server Information","Update the current player count",function()
    updatePlayerCount(); Notify("Server information refreshed.",2.5)
end)
local ScriptSection=section(HomePage,"Script Information")
infoRow(ScriptSection,"Script",CONFIG.Name); infoRow(ScriptSection,"UI Model","BJ98-SHYN"); infoRow(ScriptSection,"Version",CONFIG.Version)

-- Game tabs
local function comingSoon(name,icon)
    local p=createTab(name,icon); local s=section(p,name)
    label(s,"This feature is currently under development.",UDim2.new(),UDim2.new(1,0,0,42),11,Theme.Muted)
    addAction(s,"Feature Status","Development in progress",function() Notify(name.." is currently under development.",3) end)
end
comingSoon("BLOX FRUITS","⚔")
comingSoon("Steal a Eggs","E")
comingSoon("Steal a Brainrot","B")
comingSoon("King Legacy","K")
comingSoon("Ride a Pet","P")
comingSoon("Fly","F")

-- Players
local PlayersPage=createTab("Players","♙")
local PlayerSection=section(PlayersPage,"Player Explorer")
local SelectedPlayer=nil
local PlayerEntries={}
local PlayerCountLabel=label(PlayerSection,"Players Online: "..#Players:GetPlayers(),UDim2.new(),UDim2.new(1,0,0,24),11,Theme.Accent)
local PlayerList=create("Frame",{Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1},PlayerSection)
create("UIListLayout",{Padding=UDim.new(0,5),SortOrder=Enum.SortOrder.LayoutOrder},PlayerList)
local function refreshPlayers()
    for _,child in ipairs(PlayerList:GetChildren()) do if child:IsA("GuiObject") then child:Destroy() end end
    table.clear(PlayerEntries)
    PlayerCountLabel.Text="Players Online: "..#Players:GetPlayers()
    for _,target in ipairs(Players:GetPlayers()) do
        if target~=LocalPlayer then
            local b=button(PlayerList,target.DisplayName.."  @"..target.Name,38); b.TextSize=10
            b.Activated:Connect(function()
                SelectedPlayer=target; Notify("Selected: "..target.Name,2)
                for _,entry in ipairs(PlayerEntries) do tween(entry,{BackgroundColor3=Theme.Surface},.15,"Transition") end
                tween(b,{BackgroundColor3=Theme.Accent},.15,"Transition")
            end)
            table.insert(PlayerEntries,b)
        end
    end
end
refreshPlayers()
Players.PlayerAdded:Connect(refreshPlayers)
Players.PlayerRemoving:Connect(function(p) if SelectedPlayer==p then SelectedPlayer=nil end; refreshPlayers() end)
addAction(PlayerSection,"Refresh Player List","Find current players",refreshPlayers)
local ViewSection=section(PlayersPage,"Player Actions")
addAction(ViewSection,"View Selected Player","Follow their character with your camera",function()
    local target=SelectedPlayer
    if not target or not target.Parent then Notify("Select a player first.",2.5); return end
    local hum=target.Character and target.Character:FindFirstChildOfClass("Humanoid")
    if not hum then Notify("The selected player has no available character.",3); return end
    local camera=workspace.CurrentCamera
    if camera then camera.CameraSubject=hum end
    Notify("VIEW ENABLED: "..target.Name,3)
end)
addAction(ViewSection,"Stop Viewing","Return camera to your character",function()
    local hum=LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    local camera=workspace.CurrentCamera
    if hum and camera then camera.CameraSubject=hum; Notify("Camera returned to your character.",2.5)
    else Notify("Your character is not available.",2.5) end
end)
addAction(ViewSection,"Teleport to Selected Player","Attempts a local character reposition",function()
    local target=SelectedPlayer
    if not target or not target.Parent then Notify("Select a player first.",2.5); return end
    local root=LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    local targetRoot=target.Character and target.Character:FindFirstChild("HumanoidRootPart")
    if root and targetRoot then root.CFrame=targetRoot.CFrame*CFrame.new(0,0,3); Notify("Local reposition attempted.",2.5)
    else Notify("A character is unavailable.",2.5) end
end)
local ESPObjects={}
addAction(ViewSection,"Toggle ESP","Highlight the selected player's character",function()
    local target=SelectedPlayer
    if not target or not target.Parent then Notify("Select a player first.",2.5); return end
    local character=target.Character
    if not character then Notify("The player's character is unavailable.",2.5); return end
    local existing=ESPObjects[target]
    if existing and existing.Parent then existing:Destroy(); ESPObjects[target]=nil; Notify("ESP disabled for "..target.Name,2.5); return end
    local h=Instance.new("Highlight"); h.Name="BJ98_SHYN_ESP"; h.Adornee=character
    h.FillColor=Theme.Accent; h.OutlineColor=Color3.new(1,1,1); h.FillTransparency=.65; h.OutlineTransparency=0
    h.DepthMode=Enum.HighlightDepthMode.Occluded; h.Parent=character; ESPObjects[target]=h
    Notify("ESP enabled for "..target.Name,2.5)
end)

-- Settings and themes
local SettingsPage=createTab("Settings","⚙")
local ThemeSection=section(SettingsPage,"Appearance")
local function applyTheme(name)
    local newTheme=Themes[name]; if not newTheme then return end
    Theme=newTheme
    Main.BackgroundColor3=Theme.Background
    Header.BackgroundColor3=Theme.Panel; Sidebar.BackgroundColor3=Theme.Panel
    HeaderTitle.TextColor3=Theme.Text; HeaderSubtitle.TextColor3=Theme.Muted; PageTitle.TextColor3=Theme.Text
    Floating.BackgroundColor3=CONFIG.FloatingShape=="Hide" and Color3.new(0,0,0) or Color3.new(0,0,0)
    Floating.TextColor3=CONFIG.FloatingShape=="Hide" and Theme.Accent or Color3.new(1,1,1)
    if FloatingStroke then FloatingStroke.Color=Theme.Accent end
    CloseButton.BackgroundColor3=Theme.Surface; CloseButton.TextColor3=Theme.Text
    MinimizeButton.BackgroundColor3=Theme.Surface; MinimizeButton.TextColor3=Theme.Text
    HomeBar.BackgroundColor3=Theme.Muted; HomeBarHint.TextColor3=Theme.Muted
    progressFill.BackgroundColor3=Theme.Accent; logo.BackgroundColor3=Theme.Accent
    introTitle.TextColor3=Theme.Text; introSub.TextColor3=Theme.Muted
    for _,tab in pairs(Tabs) do
        local selected = (tab==Tabs[ActiveTab])
        tab.Button:SetAttribute("IsSelectedTab", selected)
        tab.Button.BackgroundColor3 = selected and Theme.Accent:Lerp(Theme.Panel,0.38) or Theme.Surface:Lerp(Theme.Background,0.42)
        tab.Button.TextColor3=Theme.Text; tab.Page.ScrollBarImageColor3=Theme.Accent
        for _,o in ipairs(tab.Page:GetDescendants()) do
            if o:IsA("Frame") then
                if o.Name=="PlayerCountRow" then o.BackgroundColor3=Theme.Surface
                elseif o.BackgroundTransparency<1 then o.BackgroundColor3=Theme.Panel end
            elseif o:IsA("TextLabel") then
                -- Preserve semantic accent/muted colors when possible.
                if o.TextColor3==Themes.Blue.Accent or o.TextColor3==Themes.Red.Accent or o.TextColor3==Themes.Purple.Accent or o.TextColor3==Themes.Pink.Accent or o.TextColor3==Themes.Green.Accent then
                    o.TextColor3=Theme.Accent
                elseif o.TextColor3==Themes.Blue.Muted or o.TextColor3==Themes.Red.Muted or o.TextColor3==Themes.Purple.Muted or o.TextColor3==Themes.Pink.Muted or o.TextColor3==Themes.Green.Muted then
                    o.TextColor3=Theme.Muted
                else o.TextColor3=Theme.Text end
            elseif o:IsA("TextButton") then
                o.BackgroundColor3=Theme.Surface; o.TextColor3=Theme.Text
            elseif o:IsA("ScrollingFrame") then o.ScrollBarImageColor3=Theme.Accent
            elseif o:IsA("UIStroke") then o.Color=Theme.Border end
        end
    end
    for _,o in ipairs(Screen:GetDescendants()) do
        if o:IsA("UIStroke") then o.Color=Theme.Border end
    end
    applyFloatingShape(CONFIG.FloatingShape)
    Notify("Theme changed to "..name,2.5)
end
for name in pairs(Themes) do
    local themeName=name
    addAction(ThemeSection,themeName.." Theme","Apply "..themeName.." colors",function() applyTheme(themeName) end)
end
local ShapeSection=section(SettingsPage,"Floating Button")
label(ShapeSection,"Choose the shape of the draggable black O button.",UDim2.new(),UDim2.new(1,0,0,30),10,Theme.Muted)
for _,shapeName in ipairs({"Circle","Square","Triangle","Diamond","Hide"}) do
    local shape=shapeName
    addAction(ShapeSection,shape,"Set floating button shape",function()
        applyFloatingShape(shape); Notify("Floating button: "..shape,2)
    end)
end

local AnimationSection=section(SettingsPage,"Animation Settings")
local function addScaleControl(parent,title,key)
    local row=create("Frame",{Size=UDim2.new(1,0,0,43),BackgroundColor3=Theme.Surface,BorderSizePixel=0},parent); corner(row,9)
    label(row,title,UDim2.fromOffset(9,0),UDim2.new(1,-120,1,0),10,Theme.Text)
    local val=label(row,tostring(CONFIG[key]).."x",UDim2.new(1,-111,0,0),UDim2.fromOffset(42,43),10,Theme.Accent); val.TextXAlignment=Enum.TextXAlignment.Center
    local b=button(row,"Change",27); b.AnchorPoint=Vector2.new(1,.5); b.Position=UDim2.new(1,-5,.5,0); b.Size=UDim2.fromOffset(62,27)
    local values={.5,.75,1,1.25,1.5,2}; local index=3
    b.Activated:Connect(function()
        index=index%#values+1; CONFIG[key]=values[index]; val.Text=tostring(values[index]).."x"
        tween(row,{BackgroundColor3=Theme.Accent},.12,"Transition")
        task.delay(.15,function() if row.Parent then tween(row,{BackgroundColor3=Theme.Surface},.18,"Transition") end end)
    end)
end
addScaleControl(AnimationSection,"Window Animation Scale","WindowAnimationScale")
addScaleControl(AnimationSection,"Transition Animation Scale","TransitionAnimationScale")
addScaleControl(AnimationSection,"Animation Duration Scale","AnimationDurationScale")
label(AnimationSection,"Default: 1x  |  Lower values are faster.",UDim2.new(),UDim2.new(1,0,0,22),9,Theme.Muted)

-- Tab layout editor
local LayoutSection=section(SettingsPage,"Tab Layout")
label(LayoutSection,"Use arrows to rearrange tabs.",UDim2.new(),UDim2.new(1,0,0,25),10,Theme.Muted)
local LayoutEditor
local SavedOrder=table.clone(TabOrder)
local function applyTabOrder()
    for i,name in ipairs(TabOrder) do if Tabs[name] then Tabs[name].Button.LayoutOrder=i end end
end
local renderLayoutEditor
renderLayoutEditor=function()
    if LayoutEditor then LayoutEditor:Destroy() end
    LayoutEditor=create("Frame",{Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1},LayoutSection)
    create("UIListLayout",{Padding=UDim.new(0,5),SortOrder=Enum.SortOrder.LayoutOrder},LayoutEditor)
    for i,name in ipairs(TabOrder) do
        local index=i
        local row=create("Frame",{Size=UDim2.new(1,0,0,36),BackgroundColor3=Theme.Surface,BorderSizePixel=0},LayoutEditor); corner(row,8)
        label(row,name,UDim2.fromOffset(8,0),UDim2.new(1,-92,1,0),10,Theme.Text)
        local up=button(row,"↑",26); up.AnchorPoint=Vector2.new(1,.5); up.Position=UDim2.new(1,-58,.5,0); up.Size=UDim2.fromOffset(24,26)
        local down=button(row,"↓",26); down.AnchorPoint=Vector2.new(1,.5); down.Position=UDim2.new(1,-5,.5,0); down.Size=UDim2.fromOffset(24,26)
        up.Activated:Connect(function()
            if index>1 then TabOrder[index],TabOrder[index-1]=TabOrder[index-1],TabOrder[index]; renderLayoutEditor() end
        end)
        down.Activated:Connect(function()
            if index<#TabOrder then TabOrder[index],TabOrder[index+1]=TabOrder[index+1],TabOrder[index]; renderLayoutEditor() end
        end)
    end
end
local edit=button(LayoutSection,"Edit Tab Layout",38)
edit.Activated:Connect(function() if LayoutEditor then LayoutEditor:Destroy(); LayoutEditor=nil else renderLayoutEditor() end end)
local done=button(LayoutSection,"Done",38); done.BackgroundColor3=Theme.Accent
local cancel=button(LayoutSection,"Cancel",38)
done.Activated:Connect(function()
    applyTabOrder(); SavedOrder=table.clone(TabOrder)
    if LayoutEditor then LayoutEditor:Destroy(); LayoutEditor=nil end
    Notify("Tab order saved.",2)
end)
cancel.Activated:Connect(function()
    TabOrder=table.clone(SavedOrder); applyTabOrder()
    if LayoutEditor then LayoutEditor:Destroy(); LayoutEditor=nil end
    Notify("Tab order restored.",2)
end)
addAction(SettingsPage,"Refresh Player List","Update the Players page",refreshPlayers)

-- Window controls
local IsOpen,IsMinimized,Closing=false,false,false
local NormalSize=UDim2.fromScale(.86,.64)
local function openWindow()
    if IsOpen or Closing then return end
    IsOpen=true; Main.Visible=true; MainScale.Scale=.84
    Main.BackgroundTransparency=0
    tween(Blur,{Size=12},.3,"Window")
    syncHomeBar()
    tween(MainScale,{Scale=1},.32,"Window",Enum.EasingStyle.Back)
    tween(HomeBar,{Size=UDim2.fromOffset(76,5)},.25,"Transition")
end
local function closeWindow()
    if not IsOpen or Closing then return end
    Closing=true; IsOpen=false
    local scaleTween=tween(MainScale,{Scale=.72},.3,"Window",Enum.EasingStyle.Quart,Enum.EasingDirection.In)
    tween(Main,{BackgroundTransparency=1},.28,"Window",Enum.EasingStyle.Quart,Enum.EasingDirection.In)
    tween(Blur,{Size=0},.3,"Window")
    for _,obj in ipairs(Main:GetDescendants()) do
        if obj:IsA("TextLabel") or obj:IsA("TextButton") then
            tween(obj,{TextTransparency=1,BackgroundTransparency=1},.22,"Window",Enum.EasingStyle.Quad,Enum.EasingDirection.In)
        elseif obj:IsA("Frame") and obj~=Main then
            tween(obj,{BackgroundTransparency=1},.22,"Window",Enum.EasingStyle.Quad,Enum.EasingDirection.In)
        elseif obj:IsA("ImageLabel") then
            tween(obj,{ImageTransparency=1,BackgroundTransparency=1},.22,"Window",Enum.EasingStyle.Quad,Enum.EasingDirection.In)
        elseif obj:IsA("UIStroke") then tween(obj,{Transparency=1},.22,"Window") end
    end
    task.delay(duration(.33,"Window"),function()
        if Main.Parent then
            Main.Visible=false
            -- Restore visuals for the next opening.
            Main.BackgroundTransparency=0
            MainScale.Scale=.72
            for _,obj in ipairs(Main:GetDescendants()) do
                if obj:IsA("TextLabel") then obj.TextTransparency=0
                elseif obj:IsA("TextButton") then obj.TextTransparency=0; if obj==Floating then obj.BackgroundTransparency=0 end
                elseif obj:IsA("ImageLabel") then obj.ImageTransparency=0; obj.BackgroundTransparency=0
                elseif obj:IsA("Frame") then
                    if obj==HomeBarArea or obj==Content or obj==PageHolder then obj.BackgroundTransparency=1
                    else obj.BackgroundTransparency=0 end
                elseif obj:IsA("UIStroke") then obj.Transparency=.2 end
            end
        end
        Closing=false
    end)
end
Floating.Activated:Connect(function()
    if suppressFloatClick then return end
    if IsOpen then closeWindow() else openWindow() end
end)
CloseButton.Activated:Connect(closeWindow)
MinimizeButton.Activated:Connect(function()
    IsMinimized=not IsMinimized
    if IsMinimized then
        Sidebar.Visible=false; Content.Visible=false
        tween(Main,{Size=UDim2.fromScale(.7,.12)},.22,"Window")
        MinimizeButton.Text="□"
    else
        Sidebar.Visible=true; Content.Visible=true
        tween(Main,{Size=NormalSize},.25,"Window")
        MinimizeButton.Text="−"
    end
end)
HomeBar.Activated:Connect(function()
    tween(HomeBar,{Size=UDim2.fromOffset(105,5),BackgroundColor3=Theme.Accent},.15,"Transition")
    task.delay(.2,function() if HomeBar.Parent then tween(HomeBar,{Size=UDim2.fromOffset(76,5),BackgroundColor3=Theme.Muted},.2,"Transition") end end)
end)
HomeBar.MouseEnter:Connect(function() HomeBarHint.TextTransparency=0; tween(HomeBar,{BackgroundColor3=Theme.Accent},.15,"Transition") end)
HomeBar.MouseLeave:Connect(function() HomeBarHint.TextTransparency=1; tween(HomeBar,{BackgroundColor3=Theme.Muted},.15,"Transition") end)

-- Initial tab
applyTabOrder()
if Tabs.Home then Tabs.Home.Page.Visible=true; Tabs.Home.Button.BackgroundColor3=Theme.Accent; ActiveTab="Home"; PageTitle.Text="Home" end
applyFloatingShape(CONFIG.FloatingShape)

-- Startup animation
task.spawn(function()
    tween(Blur,{Size=18},.35,"Window")
    tween(IntroScale,{Scale=1},.35,"Window")
    tween(progressFill,{Size=UDim2.new(.35,0,1,0)},.35,"Transition")
    task.wait(.35)
    tween(progressFill,{Size=UDim2.new(.72,0,1,0)},.45,"Transition")
    task.wait(.45)
    tween(progressFill,{Size=UDim2.new(1,0,1,0)},.3,"Transition")
    task.wait(.35)
    tween(IntroScale,{Scale=1.04},.2,"Window")
    tween(Intro,{BackgroundTransparency=1},.25,"Window")
    for _,obj in ipairs(Intro:GetDescendants()) do
        if obj:IsA("TextLabel") then tween(obj,{TextTransparency=1},.2,"Window")
        elseif obj:IsA("Frame") then tween(obj,{BackgroundTransparency=1},.2,"Window")
        elseif obj:IsA("UIStroke") then tween(obj,{Transparency=1},.2,"Window") end
    end
    task.wait(.28)
    if Intro.Parent then Intro:Destroy() end
    openWindow()
    Notify("BJ98-SHYN is ready.",2.5)
end)

-- Periodic suggestion
task.spawn(function()
    while Screen.Parent do
        task.wait(300)
        if not Screen.Parent then break end
        Notify("Bored? You can switch to another server!",5)
    end
end)

Screen.Destroying:Connect(function()
    if Blur and Blur.Parent then Blur:Destroy() end
    for _,h in pairs(ESPObjects) do if h and h.Parent then h:Destroy() end end
end)

print("BJ98-SHYN | LIQUID MOBILE UI v2.2 loaded successfully.")
return Screen
