-- [[ 👑 TORA HUB SUPREME - V3.0 PROFESSIONAL 👑 ]]
-- Optimized for Delta, Fluxus and Mobile Executors
-- STATUS: ESP BOX FIXED + HEALTH BAR BUG FIXED 🛠️
-- TIMER SYSTEM VIA GITHUB INTEGRATED

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

-- [[ TIMER SYSTEM ]]
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Timer variables
_G.ScriptActive = true
local TimerRemaining = 0
local TimerTotal = 0
local TimerStart = tick()
local TimerText = "00:00:00"
local TimerStatus = "Online"

-- Fetch timer from GitHub
local function FetchTimer()
    local success, result = pcall(function()
        return game:HttpGet("https://raw.githubusercontent.com/eogbb007/roblox-scripts/refs/heads/main/timer.txt")
    end)
    if success and result then
        local trimmed = result:match("^%s*(.-)%s*$")  -- trim whitespace
        local hours, minutes, seconds = trimmed:match("(%d+):(%d+):(%d+)")
        if hours and minutes and seconds then
            local total = tonumber(hours)*3600 + tonumber(minutes)*60 + tonumber(seconds)
            if total > 0 then
                _G.ScriptActive = true
                TimerTotal = total
                TimerRemaining = total
                TimerStart = tick()
                TimerStatus = "Online"
            else
                _G.ScriptActive = false
                TimerRemaining = 0
                TimerStatus = "Offline"
            end
        else
            _G.ScriptActive = false
            TimerRemaining = 0
            TimerStatus = "Offline"
        end
    else
        _G.ScriptActive = false
        TimerRemaining = 0
        TimerStatus = "Offline (No Connection)"
    end
end

FetchTimer() -- initial fetch

-- [[ LÓGICA INTERNA DO AIMBOT ]]
_G.AimbotEnabled = false
_G.FovVisible = true
_G.FovRadius = 100
_G.TeamCheck = false
_G.WallCheck = true
_G.TargetPart = "Head"

-- Globais do ESP
_G.EspEnabled = false
_G.EspBoxes = false
_G.EspTracers = false
_G.EspSkeleton = false 
_G.EspHealthBar = false
_G.EspHealthHorizontal = false 
_G.EspChams = false
_G.TracerOrigin = "Bottom"
_G.MaxDistance = 500 

-- NOVAS GLOBAIS DE CORES
_G.BoxColor = Color3.fromRGB(0, 255, 255)
_G.TracerColor = Color3.fromRGB(255, 255, 0)
_G.ChamsColor = Color3.fromRGB(255, 255, 255)
_G.SkeletonColor = Color3.fromRGB(255, 255, 255)
_G.HealthBarColor = Color3.fromRGB(0, 255, 0)

local FovCircle = Drawing.new("Circle")
FovCircle.Visible = _G.FovVisible
FovCircle.Thickness = 1.5
FovCircle.Color = Color3.fromRGB(0, 255, 127)
FovCircle.Filled = false
FovCircle.Radius = _G.FovRadius
FovCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

-- 1. Main Window
local Window = Fluent:CreateWindow({
    Title = "TORA IS ME | SUPREME HUB",
    SubTitle = "Professional Edition",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = false,
    Theme = "Darker",
    MinimizeKey = Enum.KeyCode.RightControl
})

-- 2. Tabs
local Tabs = {
    Home = Window:AddTab({ Title = "🏠 Home", Icon = "home" }),
    Combat = Window:AddTab({ Title = "🎯 Aimbot", Icon = "target" }),
    ESP = Window:AddTab({ Title = "👁️ ESP Visuals", Icon = "eye" }),
    Visuals = Window:AddTab({ Title = "🎨 Colors & UI", Icon = "palette" }),
    Settings = Window:AddTab({ Title = "⚙️ Pro Options", Icon = "settings" })
}

-- 3. Floating Button System
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local FloatingBtn = Instance.new("ImageButton", ScreenGui)
local Corner = Instance.new("UICorner", FloatingBtn)
local Stroke = Instance.new("UIStroke", FloatingBtn)

FloatingBtn.Name = "SupremeBall"
FloatingBtn.Size = UDim2.new(0, 55, 0, 55)
FloatingBtn.Position = UDim2.new(0, 20, 0, 150)
FloatingBtn.Image = "rbxassetid://10723345663" 
FloatingBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
FloatingBtn.Draggable = true
FloatingBtn.Active = true
Corner.CornerRadius = UDim.new(1, 0)
Stroke.Thickness = 2.5
Stroke.Color = Color3.fromRGB(0, 255, 127)

FloatingBtn.MouseButton1Click:Connect(function() Window:Minimize() end)

-- 4. Home Content (dynamic labels)
local HomeSection = Tabs.Home:AddSection("Session Information")
Tabs.Home:AddParagraph({
    Title = "Welcome, " .. LocalPlayer.DisplayName,
    Content = "Executor: DELTA DETECTED\nStatus: Active Subscription\nVersion: 4.5.0 ESP 500M"
})

local TimerLabel = Tabs.Home:AddLabel("Timer: " .. TimerText, {Color = Color3.fromRGB(255, 255, 0)})
local StatusLabel = Tabs.Home:AddLabel("Status: " .. TimerStatus, {Color = Color3.fromRGB(0, 255, 0)})

Tabs.Home:AddButton({
    Title = "Rejoin Server",
    Callback = function() game:GetService("TeleportService"):Teleport(game.PlaceId) end
})

-- Helper to create toggles with timer check
local function createToggle(tab, id, options)
    local originalCallback = options.Callback
    local toggle = tab:AddToggle(id, {
        Title = options.Title,
        Default = options.Default,
        Callback = function(v)
            if not _G.ScriptActive and v then
                Fluent:Notify({
                    Title = "System",
                    Content = "Aguardee uma atualização oficial!",
                    Duration = 3
                })
                toggle:SetValue(false, true) -- revert without triggering callback
                return
            end
            if originalCallback then originalCallback(v) end
        end
    })
    return toggle
end

-- Table to store all toggles for later forced disable if needed
local AllToggles = {}

-- [[ 🎯 COMBAT SECTION ]]
local AimSection = Tabs.Combat:AddSection("Aimbot Settings")
local aimbotToggle = createToggle(Tabs.Combat, "AimbotActive", {
    Title = "Enable Aimbot",
    Default = false,
    Callback = function(v) _G.AimbotEnabled = v end
})
table.insert(AllToggles, aimbotToggle)

local fovToggle = createToggle(Tabs.Combat, "ShowFov", {
    Title = "Enable FOV Circle",
    Default = true,
    Callback = function(v) FovCircle.Visible = v end
})
table.insert(AllToggles, fovToggle)

local fovSlider = Tabs.Combat:AddSlider("FovSize", {
    Title = "FOV Radius",
    Default = 100,
    Min = 10,
    Max = 400,
    Rounding = 0,
    Callback = function(v) _G.FovRadius = v FovCircle.Radius = v end
})

local TargetSection = Tabs.Combat:AddSection("Target Selection")
local hitPartDropdown = Tabs.Combat:AddDropdown("HitPart", {
    Title = "Select Target Part",
    Values = {"Head", "Neck", "HumanoidRootPart", "UpperTorso", "Left Arm", "Right Arm"},
    Default = "Head",
    Callback = function(v) _G.TargetPart = v end
})

local teamCheckToggle = createToggle(Tabs.Combat, "TeamCheck", {
    Title = "Team Check",
    Default = false,
    Callback = function(v) _G.TeamCheck = v end
})
table.insert(AllToggles, teamCheckToggle)

local wallCheckToggle = createToggle(Tabs.Combat, "WallCheck", {
    Title = "Wall Check (Wallhack)",
    Default = true,
    Callback = function(v) _G.WallCheck = v end
})
table.insert(AllToggles, wallCheckToggle)

-- [[ 👁️ ESP SECTION ]]
local EspOpt = Tabs.ESP:AddSection("ESP Toggles")
local espMasterToggle = createToggle(Tabs.ESP, "EspMaster", {
    Title = "Enable ESP Master",
    Default = false,
    Callback = function(v) _G.EspEnabled = v end
})
table.insert(AllToggles, espMasterToggle)

local espSkeletonToggle = createToggle(Tabs.ESP, "EspSkeleton", {
    Title = "Show Skeleton",
    Default = false,
    Callback = function(v) _G.EspSkeleton = v end
})
table.insert(AllToggles, espSkeletonToggle)

local espBoxToggle = createToggle(Tabs.ESP, "EspBox", {
    Title = "Show Boxes",
    Default = false,
    Callback = function(v) _G.EspBoxes = v end
})
table.insert(AllToggles, espBoxToggle)

local espTracerToggle = createToggle(Tabs.ESP, "EspTracer", {
    Title = "Show Tracers",
    Default = false,
    Callback = function(v) _G.EspTracers = v end
})
table.insert(AllToggles, espTracerToggle)

Tabs.ESP:AddDropdown("TracerOri", {
    Title = "Tracer Origin",
    Values = {"Top", "Center", "Bottom"},
    Default = "Bottom",
    Callback = function(v) _G.TracerOrigin = v end
})

local espHealthToggle = createToggle(Tabs.ESP, "EspHealth", {
    Title = "Health Bar (Vertical)",
    Default = false,
    Callback = function(v) _G.EspHealthBar = v end
})
table.insert(AllToggles, espHealthToggle)

local espHealthHToggle = createToggle(Tabs.ESP, "EspHealthH", {
    Title = "Health Bar (Horizontal)",
    Default = false,
    Callback = function(v) _G.EspHealthHorizontal = v end
})
table.insert(AllToggles, espHealthHToggle)

local espChamsToggle = createToggle(Tabs.ESP, "EspCham", {
    Title = "Soft Chams",
    Default = false,
    Callback = function(v) _G.EspChams = v end
})
table.insert(AllToggles, espChamsToggle)

local EspColors = Tabs.ESP:AddSection("Individual ESP Colors")
Tabs.ESP:AddColorpicker("SkeletonColorPick", {
    Title = "Skeleton Color",
    Default = Color3.fromRGB(255, 255, 255),
    Callback = function(v) _G.SkeletonColor = v end
})
Tabs.ESP:AddColorpicker("BoxColorPick", {
    Title = "Box Color",
    Default = Color3.fromRGB(0, 255, 255),
    Callback = function(v) _G.BoxColor = v end
})
Tabs.ESP:AddColorpicker("TracerColorPick", {
    Title = "Tracer Color",
    Default = Color3.fromRGB(255, 255, 0),
    Callback = function(v) _G.TracerColor = v end
})
Tabs.ESP:AddColorpicker("ChamsColorPick", {
    Title = "Chams Color",
    Default = Color3.fromRGB(255, 255, 255),
    Callback = function(v) _G.ChamsColor = v end
})
Tabs.ESP:AddColorpicker("HealthColorPick", {
    Title = "Health Bar Color",
    Default = Color3.fromRGB(0, 255, 0),
    Callback = function(v) _G.HealthBarColor = v end
})

-- [[ 🎨 VISUAL TAB ]]
local ColorSection = Tabs.Visuals:AddSection("Professional Color Manager")
local ThemeColor = Tabs.Visuals:AddColorpicker("AccentColor", {
    Title = "FOV Circle Color",
    Default = Color3.fromRGB(0, 255, 127)
})
ThemeColor:OnChanged(function() FovCircle.Color = ThemeColor.Value end)

local BallColorPicker = Tabs.Visuals:AddColorpicker("BallColor", {
    Title = "Floating Ball Stroke",
    Default = Color3.fromRGB(0, 255, 127)
})
BallColorPicker:OnChanged(function() Stroke.Color = BallColorPicker.Value end)

Tabs.Visuals:AddButton({
    Title = "Apply Selection",
    Callback = function()
        Fluent:Notify({Title = "Visual System", Content = "Colors Synchronized!", Duration = 3})
    end
})

local BallSection = Tabs.Visuals:AddSection("Floating Button Adjustments")
Tabs.Visuals:AddSlider("BallSize", {
    Title = "Button Size",
    Default = 55,
    Min = 10,
    Max = 100,
    Rounding = 0,
    Callback = function(Value) FloatingBtn.Size = UDim2.new(0, Value, 0, Value) end
})
Tabs.Visuals:AddSlider("BallTransp", {
    Title = "Button Opacity",
    Default = 0,
    Min = 0,
    Max = 1,
    Rounding = 1,
    Callback = function(Value)
        FloatingBtn.ImageTransparency = Value
        FloatingBtn.BackgroundTransparency = Value
    end
})

-- [[ ⚙️ SETTINGS TAB ]]
local HardwareSection = Tabs.Settings:AddSection("Performance & Hardware")
Tabs.Settings:AddToggle("AntiAFK", {Title = "Anti-AFK System (No Kick)", Default = true})
Tabs.Settings:AddToggle("FPSBoost", {Title = "Anti-Lag / FPS Boost", Default = false})
local UISection = Tabs.Settings:AddSection("Panel Size")
Tabs.Settings:AddButton({
    Title = "Minimize Menu (Mobile View)",
    Callback = function() Window:SetSize(UDim2.fromOffset(400, 300)) end
})
Tabs.Settings:AddButton({
    Title = "Expand Menu (Full View)",
    Callback = function() Window:SetSize(UDim2.fromOffset(580, 460)) end
})
local ClipSection = Tabs.Settings:AddSection("Utilities")
Tabs.Settings:AddButton({
    Title = "Copy Script Link/Key",
    Callback = function()
        setclipboard("https://tora-hub.com")
        Fluent:Notify({Title = "Copied", Content = "Link saved to clipboard!", Duration = 2})
    end
})
Tabs.Settings:AddButton({
    Title = "Unload Entire Script",
    Callback = function()
        FovCircle:Remove()
        Window:Destroy()
        ScreenGui:Destroy()
    end
})

-- [[ 👁️ MOTOR DE ESP CORRIGIDO (FIX BOX & HEALTH) ]]
local function CreateESP(Player)
    local Box = Drawing.new("Square")
    Box.Visible = false; Box.Filled = false; Box.Thickness = 1.5

    local HealthOutline = Drawing.new("Square")
    HealthOutline.Filled = true; HealthOutline.Thickness = 1

    local HealthBar = Drawing.new("Square")
    HealthBar.Filled = true; HealthBar.Thickness = 1

    local H_HealthOutline = Drawing.new("Square") 
    H_HealthOutline.Filled = true
    local H_HealthBar = Drawing.new("Square")     
    H_HealthBar.Filled = true

    local Tracer = Drawing.new("Line")
    local Bones = {}
    for i = 1, 5 do Bones[i] = Drawing.new("Line"); Bones[i].Thickness = 1.5; Bones[i].Transparency = 1 end

    local function RemoveESP()
        Box:Remove(); HealthOutline:Remove(); HealthBar:Remove(); 
        H_HealthOutline:Remove(); H_HealthBar:Remove(); Tracer:Remove()
        for _, v in pairs(Bones) do v:Remove() end
    end

    local Connection
    Connection = RunService.RenderStepped:Connect(function()
        if _G.ScriptActive and _G.EspEnabled and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") and Player ~= LocalPlayer then
            local Root = Player.Character.HumanoidRootPart
            local Hum = Player.Character:FindFirstChildOfClass("Humanoid")
            local Head = Player.Character:FindFirstChild("Head")
            
            if Hum and Hum.Health > 0 and Head then
                local RootPos, OnScreen = Camera:WorldToViewportPoint(Root.Position)
                local HeadPos = Camera:WorldToViewportPoint(Head.Position + Vector3.new(0, 0.5, 0))
                local LegPos = Camera:WorldToViewportPoint(Root.Position - Vector3.new(0, 3, 0))
                
                local MyRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                local Distance = MyRoot and (Root.Position - MyRoot.Position).Magnitude or 0

                if OnScreen and Distance <= _G.MaxDistance then
                    local Height = math.abs(HeadPos.Y - LegPos.Y)
                    local Width = Height * 0.55
                    local PosX = RootPos.X - Width / 2
                    local PosY = HeadPos.Y

                    -- Box
                    Box.Visible = _G.EspBoxes
                    if _G.EspBoxes then
                        Box.Size = Vector2.new(Width, Height); Box.Position = Vector2.new(PosX, PosY); Box.Color = _G.BoxColor
                    end

                    -- VIDA VERTICAL (CORREÇÃO AQUI)
                    local IsHealthV = _G.EspHealthBar
                    HealthOutline.Visible = IsHealthV
                    HealthBar.Visible = IsHealthV
                    if IsHealthV then
                        local HealthPercent = math.clamp(Hum.Health / Hum.MaxHealth, 0, 1)
                        HealthOutline.Size = Vector2.new(4, Height + 2)
                        HealthOutline.Position = Vector2.new(PosX - 6, PosY - 1)
                        HealthOutline.Color = Color3.new(0,0,0) -- Fundo sempre preto

                        HealthBar.Size = Vector2.new(2, Height * HealthPercent)
                        HealthBar.Position = Vector2.new(PosX - 5, PosY + (Height * (1 - HealthPercent)))
                        HealthBar.Color = _G.HealthBarColor -- Cor definida pelo usuário
                    end

                    -- VIDA HORIZONTAL
                    local IsHealthH = _G.EspHealthHorizontal
                    H_HealthOutline.Visible = IsHealthH
                    H_HealthBar.Visible = IsHealthH
                    if IsHealthH then
                        local HealthPercent = math.clamp(Hum.Health / Hum.MaxHealth, 0, 1)
                        H_HealthOutline.Size = Vector2.new(Width + 2, 4)
                        H_HealthOutline.Position = Vector2.new(PosX - 1, PosY - 8)
                        H_HealthOutline.Color = Color3.new(0,0,0)

                        H_HealthBar.Size = Vector2.new(Width * HealthPercent, 2)
                        H_HealthBar.Position = Vector2.new(PosX, PosY - 7)
                        H_HealthBar.Color = _G.HealthBarColor
                    end

                    -- Tracers
                    Tracer.Visible = _G.EspTracers
                    if _G.EspTracers then
                        Tracer.Color = _G.TracerColor
                        Tracer.To = Vector2.new(RootPos.X, RootPos.Y)
                        Tracer.From = (_G.TracerOrigin == "Bottom" and Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y) or _G.TracerOrigin == "Center" and Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2) or Vector2.new(Camera.ViewportSize.X/2, 0))
                    end

                    -- Skeleton
                    if _G.EspSkeleton then
                        local function GetP(n) local p = Player.Character:FindFirstChild(n); return p and Camera:WorldToViewportPoint(p.Position) end
                        local T = GetP("UpperTorso") or GetP("Torso"); local LA = GetP("LeftUpperArm") or GetP("Left Arm"); local RA = GetP("RightUpperArm") or GetP("Right Arm"); local LL = GetP("LeftUpperLeg") or GetP("Left Leg"); local RL = GetP("RightUpperLeg") or GetP("Right Leg"); local HP = HeadPos
                        if T and HP and LA and RA and LL and RL then
                            local function L(i, f, t) Bones[i].Visible = true; Bones[i].From = Vector2.new(f.X, f.Y); Bones[i].To = Vector2.new(t.X, t.Y); Bones[i].Color = _G.SkeletonColor end
                            L(1, HP, T); L(2, T, LA); L(3, T, RA); L(4, T, LL); L(5, T, RL)
                        else for _, v in pairs(Bones) do v.Visible = false end end
                    else for _, v in pairs(Bones) do v.Visible = false end end

                    -- Chams
                    if _G.EspChams then
                        local High = Player.Character:FindFirstChild("ToraVisual") or Instance.new("Highlight", Player.Character)
                        High.Name = "ToraVisual"; High.FillTransparency = 0.8; High.OutlineColor = _G.ChamsColor; High.FillColor = _G.ChamsColor; High.Enabled = true
                    elseif Player.Character:FindFirstChild("ToraVisual") then Player.Character.ToraVisual.Enabled = false end
                else
                    Box.Visible = false; HealthOutline.Visible = false; HealthBar.Visible = false; H_HealthOutline.Visible = false; H_HealthBar.Visible = false; Tracer.Visible = false; for _, v in pairs(Bones) do v.Visible = false end
                end
            else
                Box.Visible = false; HealthOutline.Visible = false; HealthBar.Visible = false; H_HealthOutline.Visible = false; H_HealthBar.Visible = false; Tracer.Visible = false; for _, v in pairs(Bones) do v.Visible = false end
            end
        else
            Box.Visible = false; HealthOutline.Visible = false; HealthBar.Visible = false; H_HealthOutline.Visible = false; H_HealthBar.Visible = false; Tracer.Visible = false; for _, v in pairs(Bones) do v.Visible = false end
            if not Player.Parent then RemoveESP(); Connection:Disconnect() end
        end
    end)
end

for _, v in pairs(Players:GetPlayers()) do CreateESP(v) end
Players.PlayerAdded:Connect(CreateESP)

-- [[ MOTOR DE COMBATE CORE ]]
local function GetTargetPart(Char)
    if _G.TargetPart == "UpperTorso" then return Char:FindFirstChild("UpperTorso") or Char:FindFirstChild("Torso")
    elseif _G.TargetPart == "Neck" then return Char:FindFirstChild("Neck") or Char:FindFirstChild("Head")
    else return Char:Fi
