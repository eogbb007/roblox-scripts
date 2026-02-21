-- [[ 👑 TORA HUB SUPREME - V3.0 PROFESSIONAL 👑 ]]
-- STATUS: ESP BOX FIXED + 24H TIME LOCK + KILL-SWITCH

-- 1. SISTEMA DE SEGURANÇA E TEMPO REAL
if _G.ToraHubLoaded then return end
_G.ToraHubLoaded = true
_G.ScriptAtivo = true -- Variável que mantém o script rodando

local TempoInicial = os.time()
local TempoLimite = 86400 -- 24 Horas exatas

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

-- LÓGICA DE FECHAMENTO TOTAL (O SCRIPT "MORRE" AQUI)
local function FinalizarToraHub()
    _G.ScriptAtivo = false
    _G.AimbotEnabled = false
    _G.EspEnabled = false
    
    -- Deleta a interface e elementos visuais
    if _G.MainWindow then _G.MainWindow:Destroy() end
    if game.CoreGui:FindFirstChild("SupremeBall") then game.CoreGui.SupremeBall:Destroy() end
    if _G.FovCircleRef then _G.FovCircleRef:Remove() end

    -- Bloqueio de tela
    local ScreenBlock = Instance.new("ScreenGui", game.CoreGui)
    local Frame = Instance.new("Frame", ScreenBlock)
    Frame.Size = UDim2.new(1, 0, 1, 0)
    Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Frame.BackgroundTransparency = 0.5
    Frame.Active = true

    local Text = Instance.new("TextLabel", Frame)
    Text.Size = UDim2.new(0, 450, 0, 120)
    Text.Position = UDim2.new(0.5, -225, 0.5, -60)
    Text.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Text.Text = "❌ SESSÃO TORA HUB EXPIRADA!\nO tempo de 24 horas acabou.\nObtenha uma nova versão no GitHub."
    Text.TextColor3 = Color3.fromRGB(255, 50, 50)
    Text.Font = Enum.Font.GothamBold
    Text.TextSize = 22
    Instance.new("UICorner", Text)
end

-- [[ LÓGICA INTERNA DO AIMBOT ]]
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

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
_G.FovCircleRef = FovCircle

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
_G.MainWindow = Window

-- 2. Tabs
local Tabs = {
    Home = Window:AddTab({ Title = "🏠 Home", Icon = "home" }),
    Combat = Window:AddTab({ Title = "🎯 Aimbot", Icon = "target" }),
    ESP = Window:AddTab({ Title = "👁️ ESP Visuals", Icon = "eye" }),
    Visuals = Window:AddTab({ Title = "🎨 Colors & UI", Icon = "palette" }),
    Settings = Window:AddTab({ Title = "⚙️ Pro Options", Icon = "settings" })
}

-- [[ LÓGICA DO CRONÔMETRO NA HOME ]]
local TimerDisplay = Tabs.Home:AddParagraph({
    Title = "Sessão de Uso",
    Content = "Sincronizando com servidor..."
})

task.spawn(function()
    while _G.ScriptAtivo do
        local Decorrido = os.time() - TempoInicial
        local Restante = TempoLimite - Decorrido
        
        if Restante <= 0 then
            FinalizarToraHub()
            break
        end

        local h = math.floor(Restante / 3600)
        local m = math.floor((Restante % 3600) / 60)
        local s = math.floor(Restante % 60)
        
        TimerDisplay:SetDesc(string.format("Este script expira em: %02d:%02d:%02d", h, m, s))
        task.wait(1)
    end
end)

-- 3. Floating Button System
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "SupremeBall"
local FloatingBtn = Instance.new("ImageButton", ScreenGui)
local Corner = Instance.new("UICorner", FloatingBtn)
local Stroke = Instance.new("UIStroke", FloatingBtn)

FloatingBtn.Size = UDim2.new(0, 55, 0, 55)
FloatingBtn.Position = UDim2.new(0, 20, 0, 150)
FloatingBtn.Image = "rbxassetid://10723345663" 
FloatingBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
FloatingBtn.Draggable = true
FloatingBtn.Active = true
Corner.CornerRadius = UDim.new(1, 0)
Stroke.Thickness = 2.5
Stroke.Color = Color3.fromRGB(0, 255, 127)

FloatingBtn.MouseButton1Click:Connect(function() 
    if _G.ScriptAtivo then Window:Minimize() end 
end)

-- 4. Home Content
local HomeSection = Tabs.Home:AddSection("Session Information")
Tabs.Home:AddParagraph({
    Title = "Welcome, " .. LocalPlayer.DisplayName,
    Content = "Executor: DELTA DETECTED\nStatus: Active Subscription\nVersion: 4.5.0 ESP 500M"
})

Tabs.Home:AddButton({
    Title = "Rejoin Server",
    Callback = function() game:GetService("TeleportService"):Teleport(game.PlaceId) end
})

-- [[ 🎯 COMBAT SECTION ]]
local AimSection = Tabs.Combat:AddSection("Aimbot Settings")
Tabs.Combat:AddToggle("AimbotActive", {Title = "Enable Aimbot", Default = false, Callback = function(v) _G.AimbotEnabled = v end})
Tabs.Combat:AddToggle("ShowFov", {Title = "Enable FOV Circle", Default = true, Callback = function(v) FovCircle.Visible = v end})
Tabs.Combat:AddSlider("FovSize", {Title = "FOV Radius", Default = 100, Min = 10, Max = 400, Rounding = 0, Callback = function(v) _G.FovRadius = v FovCircle.Radius = v end})

local TargetSection = Tabs.Combat:AddSection("Target Selection")
Tabs.Combat:AddDropdown("HitPart", {
    Title = "Select Target Part",
    Values = {"Head", "Neck", "HumanoidRootPart", "UpperTorso", "Left Arm", "Right Arm"},
    Default = "Head",
    Callback = function(v) _G.TargetPart = v end
})
Tabs.Combat:AddToggle("TeamCheck", {Title = "Team Check", Default = false, Callback = function(v) _G.TeamCheck = v end})
Tabs.Combat:AddToggle("WallCheck", {Title = "Wall Check (Wallhack)", Default = true, Callback = function(v) _G.WallCheck = v end})

-- [[ 👁️ ESP SECTION ]]
local EspOpt = Tabs.ESP:AddSection("ESP Toggles")
Tabs.ESP:AddToggle("EspMaster", {Title = "Enable ESP Master", Default = false, Callback = function(v) _G.EspEnabled = v end})
Tabs.ESP:AddToggle("EspSkeleton", {Title = "Show Skeleton", Default = false, Callback = function(v) _G.EspSkeleton = v end})
Tabs.ESP:AddToggle("EspBox", {Title = "Show Boxes", Default = false, Callback = function(v) _G.EspBoxes = v end})
Tabs.ESP:AddToggle("EspTracer", {Title = "Show Tracers", Default = false, Callback = function(v) _G.EspTracers = v end})
Tabs.ESP:AddDropdown("TracerOri", {Title = "Tracer Origin", Values = {"Top", "Center", "Bottom"}, Default = "Bottom", Callback = function(v) _G.TracerOrigin = v end})
Tabs.ESP:AddToggle("EspHealth", {Title = "Health Bar (Vertical)", Default = false, Callback = function(v) _G.EspHealthBar = v end})
Tabs.ESP:AddToggle("EspHealthH", {Title = "Health Bar (Horizontal)", Default = false, Callback = function(v) _G.EspHealthHorizontal = v end})
Tabs.ESP:AddToggle("EspCham", {Title = "Soft Chams", Default = false, Callback = function(v) _G.EspChams = v end})

local EspColors = Tabs.ESP:AddSection("Individual ESP Colors")
Tabs.ESP:AddColorpicker("SkeletonColorPick", {Title = "Skeleton Color", Default = Color3.fromRGB(255, 255, 255), Callback = function(v) _G.SkeletonColor = v end})
Tabs.ESP:AddColorpicker("BoxColorPick", {Title = "Box Color", Default = Color3.fromRGB(0, 255, 255), Callback = function(v) _G.BoxColor = v end})
Tabs.ESP:AddColorpicker("TracerColorPick", {Title = "Tracer Color", Default = Color3.fromRGB(255, 255, 0), Callback = function(v) _G.TracerColor = v end})
Tabs.ESP:AddColorpicker("ChamsColorPick", {Title = "Chams Color", Default = Color3.fromRGB(255, 255, 255), Callback = function(v) _G.ChamsColor = v end})
Tabs.ESP:AddColorpicker("HealthColorPick", {Title = "Health Bar Color", Default = Color3.fromRGB(0, 255, 0), Callback = function(v) _G.HealthBarColor = v end})

-- [[ 🎨 VISUAL TAB ]]
local ColorSection = Tabs.Visuals:AddSection("Professional Color Manager")
local ThemeColor = Tabs.Visuals:AddColorpicker("AccentColor", {Title = "FOV Circle Color", Default = Color3.fromRGB(0, 255, 127)})
ThemeColor:OnChanged(function() FovCircle.Color = ThemeColor.Value end)
local BallColorPicker = Tabs.Visuals:AddColorpicker("BallColor", {Title = "Floating Ball Stroke", Default = Color3.fromRGB(0, 255, 127)})
BallColorPicker:OnChanged(function() Stroke.Color = BallColorPicker.Value end)

Tabs.Visuals:AddButton({Title = "Apply Selection", Callback = function() Fluent:Notify({Title = "Visual System", Content = "Colors Synchronized!", Duration = 3}) end})

local BallSection = Tabs.Visuals:AddSection("Floating Button Adjustments")
Tabs.Visuals:AddSlider("BallSize", {Title = "Button Size", Default = 55, Min = 10, Max = 100, Rounding = 0, Callback = function(Value) FloatingBtn.Size = UDim2.new(0, Value, 0, Value) end})
Tabs.Visuals:AddSlider("BallTransp", {Title = "Button Opacity", Default = 0, Min = 0, Max = 1, Rounding = 1, Callback = function(Value) FloatingBtn.ImageTransparency = Value FloatingBtn.BackgroundTransparency = Value end})

-- [[ ⚙️ SETTINGS TAB ]]
local HardwareSection = Tabs.Settings:AddSection("Performance & Hardware")
Tabs.Settings:AddToggle("AntiAFK", {Title = "Anti-AFK System (No Kick)", Default = true})
Tabs.Settings:AddToggle("FPSBoost", {Title = "Anti-Lag / FPS Boost", Default = false})
local UISection = Tabs.Settings:AddSection("Panel Size")
Tabs.Settings:AddButton({Title = "Minimize Menu (Mobile View)", Callback = function() Window:SetSize(UDim2.fromOffset(400, 300)) end})
Tabs.Settings:AddButton({Title = "Expand Menu (Full View)", Callback = function() Window:SetSize(UDim2.fromOffset(580, 460)) end})
local ClipSection = Tabs.Settings:AddSection("Utilities")
Tabs.Settings:AddButton({Title = "Copy Script Link/Key", Callback = function() setclipboard("https://tora-hub.com") Fluent:Notify({Title = "Copied", Content = "Link saved to clipboard!", Duration = 2}) end})
Tabs.Settings:AddButton({Title = "Unload Entire Script", Callback = function() FovCircle:Remove() Window:Destroy() ScreenGui:Destroy() _G.ScriptAtivo = false end})

-- [[ 👁️ MOTOR DE ESP CORRIGIDO ]]
local function CreateESP(Player)
    local Box = Drawing.new("Square")
    Box.Visible = false
    Box.Filled = false
    Box.Thickness = 1.5

    local HealthOutline = Drawing.new("Square")
    HealthOutline.Filled = true
    local HealthBar = Drawing.new("Square")
    HealthBar.Filled = true

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
        if _G.ScriptAtivo and _G.EspEnabled and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") and Player ~= LocalPlayer then
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

                    Box.Visible = _G.EspBoxes
                    if _G.EspBoxes then
                        Box.Size = Vector2.new(Width, Height)
                        Box.Position = Vector2.new(PosX, PosY)
                        Box.Color = _G.BoxColor
                    end

                    HealthOutline.Visible = _G.EspHealthBar
                    HealthBar.Visible = _G.EspHealthBar
                    if _G.EspHealthBar then
                        local HealthPercent = Hum.Health / Hum.MaxHealth
                        HealthOutline.Size = Vector2.new(4, Height); HealthOutline.Position = Vector2.new(PosX - 6, PosY); HealthOutline.Color = Color3.new(0,0,0)
                        HealthBar.Size = Vector2.new(2, Height * HealthPercent); HealthBar.Position = Vector2.new(PosX - 5, PosY + (Height * (1 - HealthPercent))); HealthBar.Color = _G.HealthBarColor
                    end

                    H_HealthOutline.Visible = _G.EspHealthHorizontal
                    H_HealthBar.Visible = _G.EspHealthHorizontal
                    if _G.EspHealthHorizontal then
                        local HealthPercent = Hum.Health / Hum.MaxHealth
                        H_HealthOutline.Size = Vector2.new(Width, 4); H_HealthOutline.Position = Vector2.new(PosX, PosY - 8); H_HealthOutline.Color = Color3.new(0,0,0)
                        H_HealthBar.Size = Vector2.new(Width * HealthPercent, 2); H_HealthBar.Position = Vector2.new(PosX, PosY - 7); H_HealthBar.Color = _G.HealthBarColor
                    end

                    Tracer.Visible = _G.EspTracers
                    if _G.EspTracers then
                        Tracer.Color = _G.TracerColor
                        Tracer.To = Vector2.new(RootPos.X, RootPos.Y)
                        Tracer.From = (_G.TracerOrigin == "Bottom" and Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y) or _G.TracerOrigin == "Center" and Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2) or Vector2.new(Camera.ViewportSize.X/2, 0))
                    end

                    if _G.EspSkeleton then
                        local function GetP(n) local p = Player.Character:FindFirstChild(n); return p and Camera:WorldToViewportPoint(p.Position) end
                        local T = GetP("UpperTorso") or GetP("Torso"); local LA = GetP("LeftUpperArm") or GetP("Left Arm"); local RA = GetP("RightUpperArm") or GetP("Right Arm"); local LL = GetP("LeftUpperLeg") or GetP("Left Leg"); local RL = GetP("RightUpperLeg") or GetP("Right Leg"); local HP = HeadPos
                        if T and HP and LA and RA and LL and RL then
                            local function L(i, f, t) Bones[i].Visible = true; Bones[i].From = Vector2.new(f.X, f.Y); Bones[i].To = Vector2.new(t.X, t.Y); Bones[i].Color = _G.SkeletonColor end
                            L(1, HP, T); L(2, T, LA); L(3, T, RA); L(4, T, LL); L(5, T, RL)
                        else for _, v in pairs(Bones) do v.Visible = false end end
                    else for _, v in pairs(Bones) do v.Visible = false end end

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
            if not Player.Parent or not _G.ScriptAtivo then RemoveESP(); Connection:Disconnect() end
        end
    end)
end

for _, v in pairs(Players:GetPlayers()) do CreateESP(v) end
Players.PlayerAdded:Connect(CreateESP)

-- [[ MOTOR DE COMBATE CORE ]]
local function GetTargetPart(Char)
    if _G.TargetPart == "UpperTorso" then return Char:FindFirstChild("UpperTorso") or Char:FindFirstChild("Torso")
    elseif _G.TargetPart == "Neck" then return Char:FindFirstChild("Neck") or Char:FindFirstChild("Head")
    else return Char:FindFirstChild(_G.TargetPart) end
end

local function GetClosestPlayer()
    local Target = nil
    local Dist = _G.FovRadius
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character then
            local Part = GetTargetPart(v.Character)
            if Part then
                if _G.TeamCheck and v.Team == LocalPlayer.Team then continue end
                local hum = v.Character:FindFirstChildOfClass("Humanoid")
                if not hum or hum.Health <= 0 then continue end
                local Pos, OnScreen = Camera:WorldToViewportPoint(Part.Position)
                if OnScreen then
                    local Magnitude = (Vector2.new(Pos.X, Pos.Y) - Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)).Magnitude
                    if Magnitude < Dist then
                        if _G.WallCheck then
                            local obs = Camera:GetPartsObscuringTarget({Part.Position}, {LocalPlayer.Character, v.Character})
                            if #obs > 0 then continue end
                        end
                        Target = v
                        Dist = Magnitude
                    end
                end
            end
        end
    end
    return Target
end

RunService.RenderStepped:Connect(function()
    if not _G.ScriptAtivo then FovCircle.Visible = false return end
    FovCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    if _G.AimbotEnabled then
        local Target = GetClosestPlayer()
        if Target and Target.Character then
            local Part = GetTargetPart(Target.Character)
            if Part then
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, Part.Position)
            end
        end
    end
end)

SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)
SaveManager:IgnoreThemeSettings()
InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

Window:SelectTab(1)
Fluent:Notify({Title = "TORA SUPREME", Content = "Script 100% Carregado com Bloqueio 24H!", Duration = 5})
