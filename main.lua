-- [[ 👑 ESTERNAL | HUBS - PROFESSIONAL EDITION 👑 ]]
-- [[ 🔥 GITHUB UNIVERSAL TIMER VERSION 🔥 ]]
-- [[ 📡 STATUS: 1H SESSION | UNIVERSAL COUNTDOWN | ALL FEATURES WORKING ]]

-- [[ 🛡️ ANTI-REEXECUTION SYSTEM ]]
if _G.EsternalLoaded then 
    game.Players.LocalPlayer:Kick("⚠️ ESTERNAL HUBS ⚠️\n\n❌ Script já está carregado!\n\n🔄 Aguarde para executar novamente.")
    return 
end
_G.EsternalLoaded = true
_G.ScriptActive = true
_G.TimerExpired = false

-- [[ 📚 GITHUB LIBRARIES ]]
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

-- [[ 🎮 GAME SERVICES ]]
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- [[ 🌐 GITHUB TIMER CONFIGURATION ]]
local GITHUB_TIMER_URL = "https://raw.githubusercontent.com/eogbb007/roblox-scripts/refs/heads/main/timer.txt"
local GITHUB_VERSION_URL = "https://raw.githubusercontent.com/eogbb007/roblox-scripts/refs/heads/main/version.txt"
local VERSION = "9.5.10"

-- [[ ⚙️ GLOBAL SETTINGS ]]
_G.Settings = {
    Aimbot = {
        Enabled = false,
        FOV = 100,
        FOVVisible = true,
        TeamCheck = false,
        WallCheck = true,
        TargetPart = "Head",
        Smoothness = 0.5,
        Prediction = 0.1,
        Keybind = Enum.UserInputType.MouseButton2
    },
    ESP = {
        Enabled = false,
        Boxes = false,
        Tracers = false,
        Skeleton = false,
        HealthBar = false,
        HealthBarHorizontal = false,
        Chams = false,
        Distance = false,
        Names = false,
        TracerOrigin = "Bottom",
        MaxDistance = 500,
        BoxColor = Color3.fromRGB(0, 255, 255),
        TracerColor = Color3.fromRGB(255, 255, 0),
        SkeletonColor = Color3.fromRGB(255, 255, 255),
        ChamsColor = Color3.fromRGB(255, 255, 255),
        HealthColor = Color3.fromRGB(0, 255, 0),
        NameColor = Color3.fromRGB(255, 255, 255)
    }
}

-- [[ 🎨 DRAWING OBJECTS ]]
local FOVCircle = Drawing.new("Circle")
FOVCircle.Visible = _G.Settings.Aimbot.FOVVisible
FOVCircle.Thickness = 1.5
FOVCircle.Color = Color3.fromRGB(0, 255, 127)
FOVCircle.Filled = false
FOVCircle.Radius = _G.Settings.Aimbot.FOV
FOVCircle.NumSides = 60
FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

-- [[ 🖼️ GUI CREATION ]]
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "EsternalHub"
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false

-- [[ 🎯 MAIN WINDOW ]]
local Window = Fluent:CreateWindow({
    Title = "Esternal | Hubs " .. VERSION,
    SubTitle = "Universal Timer Edition | 1H Session",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Darker",
    MinimizeKey = Enum.KeyCode.RightControl
})

-- [[ 📑 TABS ]]
local Tabs = {
    Home = Window:AddTab({ Title = "🏠 Home", Icon = "home" }),
    Combat = Window:AddTab({ Title = "🎯 Aimbot", Icon = "target" }),
    Visuals = Window:AddTab({ Title = "👁️ ESP", Icon = "eye" }),
    Colors = Window:AddTab({ Title = "🎨 Colors", Icon = "palette" }),
    Misc = Window:AddTab({ Title = "⚙️ Misc", Icon = "settings" })
}

-- ============================================
-- [[ ⏰ SISTEMA DE TIMER UNIVERSAL VIA GITHUB ]]
-- ============================================

local TimerText
local TimerStatus
local CurrentTimeLeft = 3600 -- 1 hora em segundos
local LastGitHubCheck = 0
local GitHubTimerValue = 3600

-- Função para buscar timer do GitHub
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

-- Função para verificar se expirou
local function CheckTimerExpired()
    if CurrentTimeLeft <= 0 and not _G.TimerExpired then
        _G.TimerExpired = true
        _G.ScriptActive = false
        
        _G.Settings.Aimbot.Enabled = false
        _G.Settings.ESP.Enabled = false
        FOVCircle.Visible = false
        
        if TimerStatus then
            TimerStatus:SetDesc("⏰ SESSÃO EXPIRADA - Aguarde atualização")
        end
        
        if TimerText then
            TimerText:SetTitle("🚫 SISTEMA BLOQUEADO")
            TimerText:SetContent("⏰ Tempo esgotado!\n\n🔄 Aguarde o desenvolvedor atualizar o timer no GitHub para continuar usando.\n\n📢 Fique atento às novidades!")
        end
        
        Fluent:Notify({
            Title = "⏰ TEMPO ESGOTADO",
            Content = "Sessão de 1 hora finalizada! Aguarde atualização do timer no GitHub.",
            Duration = 10
        })
    end
end

-- Função para atualizar timer
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
                
                if CurrentTimeLeft < 0 then
                    CurrentTimeLeft = 0
                end
                
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
local HomeSection = Tabs.Home:AddSection("Informações do Hub")

local WelcomeText = Tabs.Home:AddParagraph({
    Title = "Bem-vindo, " .. LocalPlayer.DisplayName,
    Content = string.format("Status: ✅ Online\nVersão: %s\nTimer: Sincronizado via GitHub", VERSION)
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
    Content = "✅ Timer sincronizado online\n🔄 Atualiza automático a cada 5 minutos\n⏱️ 1 hora de sessão para todos"
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

-- [[ 🎯 COMBAT TAB ]]
local AimbotSection = Tabs.Combat:AddSection("Configurações do Aimbot")

local function CheckTimerAndExecute(callback)
    return function(value)
        if _G.TimerExpired then
            Fluent:Notify({Title = "⏰ TEMPO ESGOTADO", Content = "Funções bloqueadas. Aguarde atualização do timer no GitHub.", Duration = 5})
            return
        end
        callback(value)
    end
end

Tabs.Combat:AddToggle("AimbotToggle", {
    Title = "Ativar Aimbot", Description = "Mira automática em jogadores", Default = false,
    Callback = CheckTimerAndExecute(function(value) _G.Settings.Aimbot.Enabled = value end)
})

Tabs.Combat:AddToggle("FOVToggle", {
    Title = "Mostrar Círculo FOV", Default = true,
    Callback = CheckTimerAndExecute(function(value) _G.Settings.Aimbot.FOVVisible = value FOVCircle.Visible = value and not _G.TimerExpired end)
})

Tabs.Combat:AddSlider("FOVSlider", {
    Title = "Raio do FOV", Default = 100, Min = 10, Max = 400, Rounding = 0,
    Callback = CheckTimerAndExecute(function(value) _G.Settings.Aimbot.FOV = value FOVCircle.Radius = value end)
})

Tabs.Combat:AddSlider("SmoothSlider", {
    Title = "Suavidade da Mira", Default = 0.5, Min = 0, Max = 1, Rounding = 2,
    Callback = CheckTimerAndExecute(function(value) _G.Settings.Aimbot.Smoothness = value end)
})

Tabs.Combat:AddDropdown("TargetPart", {
    Title = "Parte do Corpo", Values = {"Head", "Neck", "HumanoidRootPart", "UpperTorso", "LowerTorso"}, Default = "Head",
    Callback = CheckTimerAndExecute(function(value) _G.Settings.Aimbot.TargetPart = value end)
})

Tabs.Combat:AddToggle("TeamCheck", {
    Title = "Ignorar Mesmo Time", Default = false,
    Callback = CheckTimerAndExecute(function(value) _G.Settings.Aimbot.TeamCheck = value end)
})

Tabs.Combat:AddToggle("WallCheck", {
    Title = "Verificar Paredes", Default = true,
    Callback = CheckTimerAndExecute(function(value) _G.Settings.Aimbot.WallCheck = value end)
})

Tabs.Combat:AddDropdown("AimbotKey", {
    Title = "Tecla de Ativação", Description = "Segure para ativar o aimbot",
    Values = {"Botão Direito", "Botão Esquerdo", "Shift", "Control", "Alt"}, Default = "Botão Direito",
    Callback = CheckTimerAndExecute(function(value)
        local keyMap = { ["Botão Direito"] = Enum.UserInputType.MouseButton2, ["Botão Esquerdo"] = Enum.UserInputType.MouseButton1, ["Shift"] = Enum.KeyCode.LeftShift, ["Control"] = Enum.KeyCode.LeftControl, ["Alt"] = Enum.KeyCode.LeftAlt }
        _G.Settings.Aimbot.Keybind = keyMap[value]
    end)
})

-- [[ 👁️ VISUALS TAB ]]
local ESPToggle = Tabs.Visuals:AddSection("Configurações ESP")

Tabs.Visuals:AddToggle("ESPMaster", {
    Title = "Ativar ESP", Default = false,
    Callback = CheckTimerAndExecute(function(value) _G.Settings.ESP.Enabled = value end)
})

Tabs.Visuals:AddToggle("ESPBox", {
    Title = "Caixas ESP", Default = false,
    Callback = CheckTimerAndExecute(function(value) _G.Settings.ESP.Boxes = value end)
})

Tabs.Visuals:AddToggle("ESPTracer", {
    Title = "Linhas (Tracers)", Default = false,
    Callback = CheckTimerAndExecute(function(value) _G.Settings.ESP.Tracers = value end)
})

Tabs.Visuals:AddToggle("ESPSkeleton", {
    Title = "Esqueleto", Default = false,
    Callback = CheckTimerAndExecute(function(value) _G.Settings.ESP.Skeleton = value end)
})

Tabs.Visuals:AddToggle("ESPHealth", {
    Title = "Barra de Vida (Vertical)", Default = false,
    Callback = CheckTimerAndExecute(function(value) _G.Settings.ESP.HealthBar = value end)
})

Tabs.Visuals:AddToggle("ESPHealthH", {
    Title = "Barra de Vida (Horizontal)", Default = false,
    Callback = CheckTimerAndExecute(function(value) _G.Settings.ESP.HealthBarHorizontal = value end)
})

Tabs.Visuals:AddToggle("ESPChams", {
    Title = "Chams (Destaque)", Default = false,
    Callback = CheckTimerAndExecute(function(value) _G.Settings.ESP.Chams = value end)
})

Tabs.Visuals:AddToggle("ESPDistance", {
    Title = "Mostrar Distância", Default = false,
    Callback = CheckTimerAndExecute(function(value) _G.Settings.ESP.Distance = value end)
})

Tabs.Visuals:AddToggle("ESPNames", {
    Title = "Mostrar Nomes", Default = false,
    Callback = CheckTimerAndExecute(function(value) _G.Settings.ESP.Names = value end)
})

Tabs.Visuals:AddDropdown("TracerOrigin", {
    Title = "Origem das Linhas", Values = {"Topo", "Centro", "Base"}, Default = "Base",
    Callback = CheckTimerAndExecute(function(value)
        local originMap = { ["Topo"] = "Top", ["Centro"] = "Center", ["Base"] = "Bottom" }
        _G.Settings.ESP.TracerOrigin = originMap[value]
    end)
})

Tabs.Visuals:AddSlider("MaxDistance", {
    Title = "Distância Máxima", Default = 500, Min = 100, Max = 2000, Rounding = 0,
    Callback = CheckTimerAndExecute(function(value) _G.Settings.ESP.MaxDistance = value end)
})

-- [[ 🎨 COLORS TAB ]]
local ColorsSection = Tabs.Colors:AddSection("Cores ESP")

Tabs.Colors:AddColorpicker("BoxColor", {
    Title = "Cor das Caixas", Default = Color3.fromRGB(0, 255, 255),
    Callback = CheckTimerAndExecute(function(value) _G.Settings.ESP.BoxColor = value end)
})

Tabs.Colors:AddColorpicker("TracerColor", {
    Title = "Cor das Linhas", Default = Color3.fromRGB(255, 255, 0),
    Callback = CheckTimerAndExecute(function(value) _G.Settings.ESP.TracerColor = value end)
})

Tabs.Colors:AddColorpicker("SkeletonColor", {
    Title = "Cor do Esqueleto", Default = Color3.fromRGB(255, 255, 255),
    Callback = CheckTimerAndExecute(function(value) _G.Settings.ESP.SkeletonColor = value end)
})

Tabs.Colors:AddColorpicker("ChamsColor", {
    Title = "Cor dos Chams", Default = Color3.fromRGB(255, 255, 255),
    Callback = CheckTimerAndExecute(function(value) _G.Settings.ESP.ChamsColor = value end)
})

Tabs.Colors:AddColorpicker("HealthColor", {
    Title = "Cor da Barra de Vida", Default = Color3.fromRGB(0, 255, 0),
    Callback = CheckTimerAndExecute(function(value) _G.Settings.ESP.HealthColor = value end)
})

Tabs.Colors:AddColorpicker("NameColor", {
    Title = "Cor dos Nomes", Default = Color3.fromRGB(255, 255, 255),
    Callback = CheckTimerAndExecute(function(value) _G.Settings.ESP.NameColor = value end)
})

local FOVColorPicker = Tabs.Colors:AddColorpicker("FOVColor", {
    Title = "Cor do Círculo FOV", Default = Color3.fromRGB(0, 255, 127)
})
FOVColorPicker:OnChanged(function()
    if not _G.TimerExpired then FOVCircle.Color = FOVColorPicker.Value end
end)

-- [[ ⚙️ MISC TAB ]]
local MiscSection = Tabs.Misc:AddSection("Utilitários")

Tabs.Misc:AddToggle("AntiAFK", {
    Title = "Anti AFK", Description = "Evita ser desconectado", Default = true,
    Callback = CheckTimerAndExecute(function(value) _G.Settings.Misc.AntiAFK = value end)
})

Tabs.Misc:AddButton({
    Title = "❌ Destruir Interface", Description = "Remove completamente o hub",
    Callback = function()
        _G.ScriptActive = false
        FOVCircle:Remove()
        Window:Destroy()
        ScreenGui:Destroy()
    end
})

-- ============================================
-- [[ 🔫 AIMBOT CORE FUNCTIONS ]]
-- ============================================

local function GetTargetPart(character)
    if not character then return nil end
    local partName = _G.Settings.Aimbot.TargetPart
    if partName == "Neck" then return character:FindFirstChild("Neck") or character:FindFirstChild("Head")
    elseif partName == "UpperTorso" then return character:FindFirstChild("UpperTorso") or character:FindFirstChild("Torso")
    else return character:FindFirstChild(partName) end
end

local function IsVisible(targetPart)
    if not _G.Settings.Aimbot.WallCheck then return true end
    local origin = Camera.CFrame.Position
    local ray = Ray.new(origin, (targetPart.Position - origin).Unit * 1000)
    local hit = workspace:FindPartOnRay(ray, LocalPlayer.Character)
    return hit == nil or hit:IsDescendantOf(targetPart.Parent)
end

local function GetClosestTarget()
    if _G.TimerExpired then return nil end
    local closest = nil
    local shortestDistance = _G.Settings.Aimbot.FOV
    local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            if humanoid and humanoid.Health > 0 then
                if _G.Settings.Aimbot.TeamCheck and player.Team == LocalPlayer.Team then continue end
                
                local targetPart = GetTargetPart(player.Character)
                if targetPart then
                    local screenPos, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
                    if onScreen then
                        local distance = (Vector2.new(screenPos.X, screenPos.Y) - center).Magnitude
                        if distance < shortestDistance then
                            if IsVisible(targetPart) then
                                closest = player
                                shortestDistance = distance
                            end
                        end
                    end
                end
            end
        end
    end
    return closest
end

-- [[ 🎯 AIMBOT LOOP ]]
local isAiming = false
UserInputService.InputBegan:Connect(function(input)
    if _G.TimerExpired then return end
    if input.UserInputType == _G.Settings.Aimbot.Keybind or input.KeyCode == _G.Settings.Aimbot.Keybind then
        isAiming = true
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == _G.Settings.Aimbot.Keybind or input.KeyCode == _G.Settings.Aimbot.Keybind then
        isAiming = false
    end
end)

RunService.RenderStepped:Connect(function()
    if not _G.ScriptActive or _G.TimerExpired then return end
    FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    
    if _G.Settings.Aimbot.Enabled and isAiming then
        local target = GetClosestTarget()
        if target and target.Character then
            local targetPart = GetTargetPart(target.Character)
            if targetPart then
                local targetPos = targetPart.Position
                local rootPart = target.Character:FindFirstChild("HumanoidRootPart")
                if rootPart then
                    targetPos = targetPos + rootPart.Velocity * _G.Settings.Aimbot.Prediction
                end
                
                local currentLook = Camera.CFrame.LookVector
                local targetLook = (targetPos - Camera.CFrame.Position).Unit
                local smoothLook = currentLook:Lerp(targetLook, _G.Settings.Aimbot.Smoothness)
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, Camera.CFrame.Position + smoothLook)
            end
        end
    end
end)

-- ============================================
-- [[ 👁️ ESP SYSTEM ]]
-- ============================================

local ESPCache = {}

local function CreateESP(player)
    if player == LocalPlayer then return end
    
    local espTable = {}
    
    espTable.Box = Drawing.new("Square")
    espTable.Box.Visible = false; espTable.Box.Thickness = 1.5; espTable.Box.Filled = false
    
    espTable.Tracer = Drawing.new("Line")
    espTable.Tracer.Visible = false; espTable.Tracer.Thickness = 1.5
    
    espTable.HealthBg = Drawing.new("Square")
    espTable.HealthBg.Visible = false; espTable.HealthBg.Filled = true; espTable.HealthBg.Color = Color3.new(0, 0, 0)
    
    espTable.HealthBar = Drawing.new("Square")
    espTable.HealthBar.Visible = false; espTable.HealthBar.Filled = true
    
    espTable.Name = Drawing.new("Text")
    espTable.Name.Visible = false; espTable.Name.Size = 13; espTable.Name.Center = true; espTable.Name.Outline = true; espTable.Name.Font = 3
    
    espTable.Distance = Drawin
