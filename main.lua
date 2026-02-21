-- [[ 👑 TORA HUB SUPREME - V4.0 UNIVERSAL TIMER 👑 ]]
-- Integrado com sistema de timer via GitHub
-- Status: ✅ Online / ⚠️ Offline | Anti-AFK funcional | FPS Boost

-- [[ 🛡️ ANTI-REEXECUTION ]]
if _G.ToraLoaded then 
    game.Players.LocalPlayer:Kick("⚠️ TORA HUB ⚠️\n\n❌ Script já está carregado!")
    return 
end
_G.ToraLoaded = true
_G.ScriptActive = true
_G.TimerExpired = false

-- [[ 📚 BIBLIOTECAS ]]
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

-- [[ 🎮 SERVIÇOS ]]
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- [[ 🌐 CONFIGURAÇÃO DO TIMER GITHUB ]]
local GITHUB_TIMER_URL = "https://raw.githubusercontent.com/eogbb007/roblox-scripts/refs/heads/main/timer.txt"
local GITHUB_VERSION_URL = "https://raw.githubusercontent.com/eogbb007/roblox-scripts/refs/heads/main/version.txt"
local VERSION = "9.5.10"

-- [[ ⚙️ CONFIGURAÇÕES GLOBAIS ]]
_G.AimbotEnabled = false
_G.FovVisible = true
_G.FovRadius = 100
_G.TeamCheck = false
_G.WallCheck = true
_G.TargetPart = "Head"
_G.AimbotSmoothness = 0.5 -- Suavidade da mira (0 = instantâneo, 1 = muito suave)

_G.EspEnabled = false
_G.EspBoxes = false
_G.EspTracers = false
_G.EspSkeleton = false 
_G.EspHealthBar = false
_G.EspHealthHorizontal = false 
_G.EspChams = false
_G.TracerOrigin = "Bottom"
_G.MaxDistance = 500 

_G.BoxColor = Color3.fromRGB(0, 255, 255)
_G.TracerColor = Color3.fromRGB(255, 255, 0)
_G.ChamsColor = Color3.fromRGB(255, 255, 255)
_G.SkeletonColor = Color3.fromRGB(255, 255, 255)
_G.HealthBarColor = Color3.fromRGB(0, 255, 0)

_G.AntiAFK = true
_G.FPSBoost = false

-- [[ 🎨 DESENHOS ]]
local FovCircle = Drawing.new("Circle")
FovCircle.Visible = _G.FovVisible
FovCircle.Thickness = 1.5
FovCircle.Color = Color3.fromRGB(0, 255, 127)
FovCircle.Filled = false
FovCircle.Radius = _G.FovRadius
FovCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

-- [[ 🖼️ GUI ]]
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ToraHub"
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false

local Window = Fluent:CreateWindow({
    Title = "TORA IS ME | SUPREME HUB " .. VERSION,
    SubTitle = "Universal Timer Edition",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = false,
    Theme = "Darker",
    MinimizeKey = Enum.KeyCode.RightControl
})

local Tabs = {
    Home = Window:AddTab({ Title = "🏠 Home", Icon = "home" }),
    Combat = Window:AddTab({ Title = "🎯 Aimbot", Icon = "target" }),
    ESP = Window:AddTab({ Title = "👁️ ESP Visuals", Icon = "eye" }),
    Visuals = Window:AddTab({ Title = "🎨 Colors & UI", Icon = "palette" }),
    Settings = Window:AddTab({ Title = "⚙️ Pro Options", Icon = "settings" })
}

-- [[ 🔘 BOTÃO FLUTUANTE ]]
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

-- ============================================
-- [[ ⏰ SISTEMA DE TIMER UNIVERSAL ]]
-- ============================================

local TimerText
local TimerStatus
local CurrentTimeLeft = 3600
local LastGitHubCheck = 0
local GitHubTimerValue = 3600

local function GetGitHubTimer()
    local success, result = pcall(function()
        return HttpService:GetAsync(GITHUB_TIMER_URL)
    end)
    if success and result then
        local timerValue = tonumber(result:match("%d+"))
        if timerValue and timerValue > 0 then
            GitHubTimerValue = timerValue
            return timerValue
        end
    end
    return GitHubTimerValue
end

local function CheckTimerExpired()
    if CurrentTimeLeft <= 0 and not _G.TimerExpired then
        _G.TimerExpired = true
        _G.ScriptActive = false
        _G.AimbotEnabled = false
        _G.EspEnabled = false
        FovCircle.Visible = false
        if TimerStatus then
            TimerStatus:SetDesc("⏰ SESSÃO EXPIRADA - Aguarde atualização")
        end
        if TimerText then
            TimerText:SetTitle("🚫 SISTEMA BLOQUEADO")
            TimerText:SetContent("⏰ Tempo esgotado!\n\n🔄 Aguarde o desenvolvedor atualizar o timer no GitHub.")
        end
        Fluent:Notify({
            Title = "⏰ TEMPO ESGOTADO",
            Content = "Sessão finalizada! Aguarde atualização do timer.",
            Duration = 10
        })
    end
end

local function UpdateTimer()
    task.spawn(function()
        while _G.ScriptActive do
            if os.time() - LastGitHubCheck >= 300 then
                GitHubTimerValue = GetGitHubTimer()
                LastGitHubCheck = os.time()
                if GitHubTimerValue ~= CurrentTimeLeft and GitHubTimerValue > 0 then
                    CurrentTimeLeft = GitHubTimerValue
                end
            end
            if not _G.TimerExpired then
                CurrentTimeLeft = CurrentTimeLeft - 1
                if CurrentTimeLeft < 0 then CurrentTimeLeft = 0 end
                CheckTimerExpired()
                local hours = math.floor(CurrentTimeLeft / 3600)
                local minutes = math.floor((CurrentTimeLeft % 3600) / 60)
                local seconds = CurrentTimeLeft % 60
                local timeString = string.format("%02d:%02d:%02d", hours, minutes, seconds)
                if TimerStatus and not _G.TimerExpired then
                    TimerStatus:SetDesc("⏰ Tempo restante: " .. timeString)
                end
            end
            task.wait(1)
        end
    end)
end

GitHubTimerValue = GetGitHubTimer()
CurrentTimeLeft = GitHubTimerValue

-- [[ 🏠 HOME TAB ]]
local HomeSection = Tabs.Home:AddSection("Informações da Sessão")

local WelcomeText = Tabs.Home:AddParagraph({
    Title = "Bem-vindo, " .. LocalPlayer.DisplayName,
    Content = string.format("Status: %s\nVersão: %s\nTimer: Sincronizado via GitHub", 
        (_G.TimerExpired and "⚠️ Offline" or "✅ Online"), VERSION)
})

TimerText = Tabs.Home:AddParagraph({
    Title = "⏰ SESSÃO TEMPORIZADA",
    Content = "Carregando timer do GitHub..."
})

TimerStatus = Tabs.Home:AddParagraph({
    Title = "📊 Status da Sessão",
    Content = "⏰ Conectando ao GitHub..."
})

Tabs.Home:AddParagraph({
    Title = "🌐 GitHub Sync",
    Content = "✅ Timer sincronizado online\n🔄 Atualiza a cada 5 minutos\n⏱️ 1 hora de sessão para todos"
})

Tabs.Home:AddButton({
    Title = "📋 Copiar Link do GitHub",
    Callback = function()
        setclipboard("https://github.com/eogbb007/roblox-scripts")
        Fluent:Notify({Title = "Copiado!", Content = "Link do GitHub salvo!", Duration = 3})
    end
})

Tabs.Home:AddButton({
    Title = "🔄 Verificar Timer GitHub",
    Callback = function()
        local newTimer = GetGitHubTimer()
        if newTimer and newTimer > 0 then
            CurrentTimeLeft = newTimer
            Fluent:Notify({Title = "Timer Atualizado", Content = "Timer sincronizado: " .. newTimer .. " segundos", Duration = 3})
        else
            Fluent:Notify({Title = "Erro", Content = "Não foi possível sincronizar com GitHub", Duration = 3})
        end
    end
})

Tabs.Home:AddButton({
    Title = "🔄 Rejoin Server",
    Callback = function() game:GetService("TeleportService"):Teleport(game.PlaceId) end
})

-- [[ 🎯 COMBAT TAB ]]
local AimSection = Tabs.Combat:AddSection("Configurações do Aimbot")

local function CheckTimerAndExecute(callback)
    return function(value)
        if _G.TimerExpired then
            Fluent:Notify({Title = "⏰ TEMPO ESGOTADO", Content = "Funções bloqueadas. Aguarde atualização.", Duration = 5})
            return
        end
        callback(value)
    end
end

Tabs.Combat:AddToggle("AimbotActive", {
    Title = "Ativar Aimbot", Default = false,
    Callback = CheckTimerAndExecute(function(v) _G.AimbotEnabled = v end)
})

Tabs.Combat:AddToggle("ShowFov", {
    Title = "Mostrar Círculo FOV", Default = true,
    Callback = CheckTimerAndExecute(function(v) 
        _G.FovVisible = v 
        FovCircle.Visible = v and not _G.TimerExpired
    end)
})

Tabs.Combat:AddSlider("FovSize", {
    Title = "Raio do FOV", Default = 100, Min = 10, Max = 400, Rounding = 0,
    Callback = CheckTimerAndExecute(function(v) _G.FovRadius = v FovCircle.Radius = v end)
})

Tabs.Combat:AddSlider("Smoothness", {
    Title = "Suavidade da Mira", Default = 0.5, Min = 0, Max = 1, Rounding = 2,
    Callback = CheckTimerAndExecute(function(v) _G.AimbotSmoothness = v end)
})

local TargetSection = Tabs.Combat:AddSection("Seleção de Alvo")
Tabs.Combat:AddDropdown("HitPart", {
    Title = "Parte do Corpo",
    Values = {"Head", "Neck", "HumanoidRootPart", "UpperTorso", "Left Arm", "Right Arm"},
    Default = "Head",
    Callback = CheckTimerAndExecute(function(v) _G.TargetPart = v end)
})

Tabs.Combat:AddToggle("TeamCheck", {
    Title = "Ignorar Mesmo Time", Default = false,
    Callback = CheckTimerAndExecute(function(v) _G.TeamCheck = v end)
})

Tabs.Combat:AddToggle("WallCheck", {
    Title = "Verificar Paredes", Default = true,
    Callback = CheckTimerAndExecute(function(v) _G.WallCheck = v end)
})

-- [[ 👁️ ESP TAB ]]
local EspOpt = Tabs.ESP:AddSection("Ativar ESP")
Tabs.ESP:AddToggle("EspMaster", {
    Title = "Ativar ESP", Default = false,
    Callback = CheckTimerAndExecute(function(v) _G.EspEnabled = v end)
})

Tabs.ESP:AddToggle("EspBox", {
    Title = "Caixas", Default = false,
    Callback = CheckTimerAndExecute(function(v) _G.EspBoxes = v end)
})

Tabs.ESP:AddToggle("EspTracer", {
    Title = "Linhas (Tracers)", Default = false,
    Callback = CheckTimerAndExecute(function(v) _G.EspTracers = v end)
})

Tabs.ESP:AddToggle("EspSkeleton", {
    Title = "Esqueleto", Default = false,
    Callback = CheckTimerAndExecute(function(v) _G.EspSkeleton = v end)
})

Tabs.ESP:AddToggle("EspHealth", {
    Title = "Barra de Vida (Vertical)", Default = false,
    Callback = CheckTimerAndExecute(function(v) _G.EspHealthBar = v end)
})

Tabs.ESP:AddToggle("EspHealthH", {
    Title = "Barra de Vida (Horizontal)", Default = false,
    Callback = CheckTimerAndExecute(function(v) _G.EspHealthHorizontal = v end)
})

Tabs.ESP:AddToggle("EspCham", {
    Title = "Chams", Default = false,
    Callback = CheckTimerAndExecute(function(v) _G.EspChams = v end)
})

Tabs.ESP:AddDropdown("TracerOri", {
    Title = "Origem das Linhas", Values = {"Top", "Center", "Bottom"}, Default = "Bottom",
    Callback = CheckTimerAndExecute(function(v) _G.TracerOrigin = v end)
})

Tabs.ESP:AddSlider("MaxDistance", {
    Title = "Distância Máxima", Default = 500, Min = 100, Max = 2000, Rounding = 0,
    Callback = CheckTimerAndExecute(function(v) _G.MaxDistance = v end)
})

local EspColors = Tabs.ESP:AddSection("Cores Individuais")
Tabs.ESP:AddColorpicker("BoxColorPick", {
    Title = "Cor das Caixas", Default = Color3.fromRGB(0, 255, 255),
    Callback = CheckTimerAndExecute(function(v) _G.BoxColor = v end)
})
Tabs.ESP:AddColorpicker("TracerColorPick", {
    Title = "Cor das Linhas", Default = Color3.fromRGB(255, 255, 0),
    Callback = CheckTimerAndExecute(function(v) _G.TracerColor = v end)
})
Tabs.ESP:AddColorpicker("SkeletonColorPick", {
    Title = "Cor do Esqueleto", Default = Color3.fromRGB(255, 255, 255),
    Callback = CheckTimerAndExecute(function(v) _G.SkeletonColor = v end)
})
Tabs.ESP:AddColorpicker("ChamsColorPick", {
    Title = "Cor dos Chams", Default = Color3.fromRGB(255, 255, 255),
    Callback = CheckTimerAndExecute(function(v) _G.ChamsColor = v end)
})
Tabs.ESP:AddColorpicker("HealthColorPick", {
    Title = "Cor da Barra de Vida", Default = Color3.fromRGB(0, 255, 0),
    Callback = CheckTimerAndExecute(function(v) _G.HealthBarColor = v end)
})

-- [[ 🎨 VISUALS TAB ]]
local ColorSection = Tabs.Visuals:AddSection("Gerenciador de Cores")
local ThemeColor = Tabs.Visuals:AddColorpicker("AccentColor", {
    Title = "Cor do Círculo FOV", Default = Color3.fromRGB(0, 255, 127)
})
ThemeColor:OnChanged(function() if not _G.TimerExpired then FovCircle.Color = ThemeColor.Value end end)

local BallColorPicker = Tabs.Visuals:AddColorpicker("BallColor", {
    Title = "Cor da Borda do Botão", Default = Color3.fromRGB(0, 255, 127)
})
BallColorPicker:OnChanged(function() Stroke.Color = BallColorPicker.Value end)

Tabs.Visuals:AddButton({Title = "Aplicar Cores", Callback = function() Fluent:Notify({Title = "Visual", Content = "Cores sincronizadas!", Duration = 3}) end})

local BallSection = Tabs.Visuals:AddSection("Ajustes do Botão Flutuante")
Tabs.Visuals:AddSlider("BallSize", {
    Title = "Tamanho do Botão", Default = 55, Min = 10, Max = 100, Rounding = 0,
    Callback = function(Value) FloatingBtn.Size = UDim2.new(0, Value, 0, Value) end
})
Tabs.Visuals:AddSlider("BallTransp", {
    Title = "Transparência", Default = 0, Min = 0, Max = 1, Rounding = 1,
    Callback = function(Value) FloatingBtn.ImageTransparency = Value; FloatingBtn.BackgroundTransparency = Value end
})

-- [[ ⚙️ SETTINGS TAB ]]
local HardwareSection = Tabs.Settings:AddSection("Performance e Hardware")
Tabs.Settings:AddToggle("AntiAFK", {
    Title = "Anti-AFK", Default = true,
    Callback = function(v) _G.AntiAFK = v end
})
Tabs.Settings:AddToggle("FPSBoost", {
    Title = "FPS Boost", Default = false,
    Callback = function(v)
        _G.FPSBoost = v
        if v then
            settings().Rendering.QualityLevel = 1
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("Decal") or obj:IsA("Texture") then obj.Transparency = 1 end
            end
        else
            settings().Rendering.QualityLevel = 21
        end
    end
})

local UISection = Tabs.Settings:AddSection("Tamanho do Painel")
Tabs.Settings:AddButton({Title = "Modo Mobile (400x300)", Callback = function() Window:SetSize(UDim2.fromOffset(400, 300)) end})
Tabs.Settings:AddButton({Title = "Modo Completo (580x460)", Callback = function() Window:SetSize(UDim2.fromOffset(580, 460)) end})

local ClipSection = Tabs.Settings:AddSection("Utilitários")
Tabs.Settings:AddButton({Title = "Copiar Link do GitHub", Callback = function() setclipboard("https://github.com/eogbb007/roblox-scripts") Fluent:Notify({Title = "Copiado!", Content = "Link salvo!", Duration = 2}) end})
Tabs.Settings:AddButton({Title = "Descarregar Script", Callback = function() _G.ScriptActive = false; FovCircle:Remove(); Window:Destroy(); ScreenGui:Destroy() end})

-- ============================================
-- [[ 👁️ MOTOR ESP (CORRIGIDO) ]]
-- ============================================
local function CreateESP(Player)
    if Player == LocalPlayer then return end
    local Box = Drawing.new("Square"); Box.Visible = false; Box.Filled = false; Box.Thickness = 1.5
    local HealthOutline = Drawing.new("Square"); HealthOutline.Filled = true
    local HealthBar = Drawing.new("Square"); HealthBar.Filled = true
    local H_HealthOutline = Drawing.new("Square"); H_HealthOutline.Filled = true
    local H_HealthBar = Drawing.new("Square"); H_HealthBar.Filled = true
    local Tracer = Drawing.new("Line")
    local Bones = {}
    for i = 1, 5 do Bones[i] = Drawing.new("Line"); Bones[i].Thickness = 1.5; Bones[i].Transparency = 1 end

    local function RemoveESP()
        Box:Remove(); HealthOutline:Remove(); HealthBar:Remove()
        H_HealthOutline:Remove(); H_HealthBar:Remove(); Tracer:Remove()
        for _, v in pairs(Bones) do v:Remove() end
    end

    local Connection
    Connection = RunService.RenderStepped:Connect(function()
        if not _G.ScriptActive or _G.TimerExpired or not _G.EspEnabled or not Player.Character or not Player.Character:FindFirstChild("HumanoidRootPart") then
            Box.Visible = false; HealthOutline.Visible = false; HealthBar.Visible = false
            H_HealthOutline.Visible = false; H_HealthBar.Visible = false; Tracer.Visible = false
            for _, v in pairs(Bones) do v.Visible = false end
            if not Player.Parent then RemoveESP(); Connection:Disconnect() end
            return
        end

        local Root = Player.Character.HumanoidRootPart
        local Hum = Player.Character:FindFirstChildOfClass("Humanoid")
        local Head = Player.Character:FindFirstChild("Head")
        if not Hum or Hum.Health <= 0 or not Head then return end

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
                Box.Size = Vector2.new(Width, Height)
                Box.Position = Vector2.new(PosX, PosY)
                Box.Color = _G.BoxColor
            end

            -- Vida Vertical
            local IsHealthV = _G.EspHealthBar
            HealthOutline.Visible = IsHealthV
            HealthBar.Visible = IsHealthV
            if IsHealthV then
                local HealthPercent = math.max(0, math.min(1, Hum.Health / Hum.MaxHealth))
                HealthOutline.Size = Vector2.new(4, Height + 2)
                HealthOutline.Position = Vector2.new(PosX - 6, PosY - 1)
                HealthOutline.Color = Color3.new(0,0,0)
                HealthBar.Size = Vector2.new(2, Height * HealthPercent)
                HealthBar.Position = Vector2.new(PosX - 5, PosY + (Height * (1 - HealthPercent)))
                HealthBar.Color = _G.HealthBarColor
            end

            -- Vida Horizontal
            local IsHealthH = _G.EspHealthHorizontal
            H_HealthOutline.Visible = IsHealthH
            H_HealthBar.Visible = IsHealthH
            if IsHealthH then
                local HealthPercent = math.max(0, math.min(1, Hum.Health / Hum.MaxHealth))
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
                if _G.TracerOrigin == "Bottom" then
                    Tracer.From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y)
                elseif _G.TracerOrigin == "Center" then
                    Tracer.From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
 
