-- [[ 👑 TORA HUB SUPREME - V3.0 PROFESSIONAL 👑 ]]
-- STATUS: ESP BOX FIXED + 24H PERMANENT LOCK (FIXED)

if _G.ToraHubLoaded then return end
_G.ToraHubLoaded = true
_G.ScriptAtivo = true 

-- [[ SISTEMA DE TEMPO QUE NÃO RESETA ]]
local HttpService = game:GetService("HttpService")
local FileName = "tora_timer.txt"
local TempoLimite = 86400 -- 24 Horas
local TempoFinal

if isfile(FileName) then
    local conteudo = readfile(FileName)
    TempoFinal = tonumber(conteudo)
else
    TempoFinal = os.time() + TempoLimite
    writefile(FileName, tostring(TempoFinal))
end

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

-- LÓGICA DE FECHAMENTO TOTAL
local function FinalizarToraHub()
    _G.ScriptAtivo = false
    _G.AimbotEnabled = false
    _G.EspEnabled = false
    
    if _G.MainWindow then _G.MainWindow:Destroy() end
    if game.CoreGui:FindFirstChild("SupremeBall") then game.CoreGui.SupremeBall:Destroy() end
    if _G.FovCircleRef then _G.FovCircleRef:Remove() end

    local ScreenBlock = Instance.new("ScreenGui", game.CoreGui)
    local Frame = Instance.new("Frame", ScreenBlock)
    Frame.Size = UDim2.new(1, 0, 1, 0)
    Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
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

-- CORES
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

local Tabs = {
    Home = Window:AddTab({ Title = "🏠 Home", Icon = "home" }),
    Combat = Window:AddTab({ Title = "🎯 Aimbot", Icon = "target" }),
    ESP = Window:AddTab({ Title = "👁️ ESP Visuals", Icon = "eye" }),
    Visuals = Window:AddTab({ Title = "🎨 Colors & UI", Icon = "palette" }),
    Settings = Window:AddTab({ Title = "⚙️ Pro Options", Icon = "settings" })
}

local TimerDisplay = Tabs.Home:AddParagraph({
    Title = "Sessão de Uso",
    Content = "Calculando tempo restante..."
})

-- LOOP DO CRONÔMETRO (CORRIGIDO)
task.spawn(function()
    while _G.ScriptAtivo do
        local Restante = TempoFinal - os.time()
        
        if Restante <= 0 then
            FinalizarToraHub()
            break
        end

        local h = math.floor(Restante / 3600)
        local m = math.floor((Restante % 3600) / 60)
        local s = math.floor(Restante % 60)
        
        TimerDisplay:SetDesc(string.format("Este acesso expira em: %02d:%02d:%02d\nO tempo não reseta ao sair.", h, m, s))
        task.wait(1)
    end
end)

-- Botão flutuante
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

-- Home Content
Tabs.Home:AddParagraph({
    Title = "Welcome, " .. LocalPlayer.DisplayName,
    Content = "Executor: DELTA DETECTED\nStatus: Ativo\nVersion: 4.5.0"
})

-- Aimbot Section
Tabs.Combat:AddToggle("AimbotActive", {Title = "Enable Aimbot", Default = false, Callback = function(v) _G.AimbotEnabled = v end})
Tabs.Combat:AddToggle("ShowFov", {Title = "Enable FOV Circle", Default = true, Callback = function(v) FovCircle.Visible = v end})
Tabs.Combat:AddSlider("FovSize", {Title = "FOV Radius", Default = 100, Min = 10, Max = 400, Rounding = 0, Callback = function(v) _G.FovRadius = v FovCircle.Radius = v end})

-- ESP Master
Tabs.ESP:AddToggle("EspMaster", {Title = "Enable ESP Master", Default = false, Callback = function(v) _G.EspEnabled = v end})
Tabs.ESP:AddToggle("EspBox", {Title = "Show Boxes", Default = false, Callback = function(v) _G.EspBoxes = v end})

-- MOTOR DE ESP (Simplificado para o exemplo, mantendo sua lógica original de cores)
local function CreateESP(Player)
    local Box = Drawing.new("Square")
    Box.Visible = false
    Box.Thickness = 1.5

    RunService.RenderStepped:Connect(function()
        if _G.ScriptAtivo and _G.EspEnabled and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") and Player ~= LocalPlayer then
            local Root = Player.Character.HumanoidRootPart
            local Hum = Player.Character:FindFirstChildOfClass("Humanoid")
            if Hum and Hum.Health > 0 then
                local RootPos, OnScreen = Camera:WorldToViewportPoint(Root.Position)
                if OnScreen then
                    Box.Visible = _G.EspBoxes
                    Box.Size = Vector2.new(40, 50) -- Ajuste dinâmico se preferir
                    Box.Position = Vector2.new(RootPos.X - 20, RootPos.Y - 25)
                    Box.Color = _G.BoxColor
                else Box.Visible = false end
            else Box.Visible = false end
        else Box.Visible = false end
    end)
end

for _, v in pairs(Players:GetPlayers()) do CreateESP(v) end
Players.PlayerAdded:Connect(CreateESP)

-- MOTOR DE COMBATE
RunService.RenderStepped:Connect(function()
    if not _G.ScriptAtivo then FovCircle.Visible = false return end
    FovCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    if _G.AimbotEnabled then
        -- Sua lógica de busca de alvo aqui...
    end
end)

Window:SelectTab(1)
Fluent:Notify({Title = "TORA SUPREME", Content = "Sistema 24H Permanente Carregado!", Duration = 5})
