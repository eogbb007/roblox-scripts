-- [[ 👑 ESTERNAL | HUBS - PROFESSIONAL EDITION 👑 ]]
-- STATUS: GITHUB GLOBAL SYNC (Sincronizado via Servidor)
-- PROTEÇÃO: SESSÃO GLOBAL + AUTO-CANCELAMENTO + ANTI-BYPASS

-- [[ CONFIGURAÇÃO DO LINK DO GITHUB ]]
-- Substitua pelo link 'RAW' do seu arquivo timer.txt no GitHub
local LinkDoTempoGlobal = "https://raw.githubusercontent.com/SEU_USUARIO/SEU_REPOSITORIO/main/timer.txt"

-- [[ FUNÇÃO DE SINCRONIA DE TEMPO ]]
local function ObterTempoFinal()
    local sucesso, resultado = pcall(function()
        return game:HttpGet(LinkDoTempoGlobal)
    end)
    if sucesso and tonumber(resultado) then
        return tonumber(resultado)
    else
        -- Caso falhe a conexão, ele encerra por segurança
        return 0 
    end
end

local TempoFinalGlobal = ObterTempoFinal()

-- [[ 🛡️ SISTEMA ANTI-BULA & EXPIRAÇÃO GLOBAL ]]
if os.time() > TempoFinalGlobal or _G.TempoExpirado then 
    local MsgKick = "⚠️ 𝐄𝐒𝐓𝐄𝐑𝐍𝐀𝐋 | 𝐇𝐔𝐁𝐒 ⚠️\n\n❌ O script expirou globalmente no GitHub para todos os usuários!\n\n🔄 Aguarde a nova atualização para retornar. ⌛✨"
    game.Players.LocalPlayer:Kick(MsgKick)
    return 
end

if _G.EsternalLoaded then return end
_G.EsternalLoaded = true
_G.ScriptAtivo = true 
_G.TempoExpirado = false

-- [[ 📚 LIBS ORIGINAIS ]]
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

-- [[ 🛠️ FUNÇÃO DE CHECAGEM DE SEGURANÇA ]]
local function CheckAcesso()
    if _G.TempoExpirado then
        Fluent:Notify({Title = "SESSÃO EXPIRADA", Content = "As funções foram bloqueadas via GitHub.", Duration = 5})
        return false
    end
    return true
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

-- GLOBAIS DE CORES
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
    Title = "Esternal | Hubs",
    SubTitle = "Professional Global Edition",
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

-- 4. Home Content
local HomeSection = Tabs.Home:AddSection("Online Global Status")
local HomeParagraph = Tabs.Home:AddParagraph({
    Title = "Welcome, " .. LocalPlayer.DisplayName,
    Content = "Status: Online (Sincronizado)\nServer: GitHub Master\nVersion: 4.5.0 Final"
})

local TimerPara = Tabs.Home:AddParagraph({
    Title = "⏱️ Tempo Global Restante",
    Content = "Conectando ao GitHub..."
})

-- [[ LOOP DO TIMER GLOBAL SINCRONIZADO ]]
task.spawn(function()
    while _G.ScriptAtivo do
        local Agora = os.time()
        local Restante = TempoFinalGlobal - Agora
        
        if Restante <= 0 then 
            _G.ScriptAtivo = false
            _G.TempoExpirado = true 
            
            _G.AimbotEnabled = false
            _G.EspEnabled = false
            FovCircle.Visible = false
            
            HomeParagraph:SetTitle("📢 SESSÃO GLOBAL ENCERRADA")
            HomeParagraph:SetDesc("O script foi desativado via GitHub para todos.")
            TimerPara:SetDesc("Status: Expirado ❌")
            
            game.Players.LocalPlayer:Kick("⚠️ 𝐄𝐒𝐓𝐄𝐑𝐍𝐀𝐋 | 𝐇𝐔𝐁𝐒 ⚠️\n\nO tempo deste script acabou no GitHub!\n🔄 Pegue a nova versão no canal oficial.")
            break 
        end
        
        local h = math.floor(Restante / 3600)
        local m = math.floor((Restante % 3600) / 60)
        local s = math.floor(Restante % 60)
        
        TimerPara:SetDesc(string.format("Expira globalmente em: %02dh %02dm %02ds", h, m, s))
        task.wait(1)
    end
end)

-- (DAQUI PARA BAIXO O RESTANTE DO SEU CÓDIGO DE ESP E AIMBOT CONTINUA IGUAL)

-- [[ MOTOR DE ESP ]]
local function CreateESP(Player)
    local Box = Drawing.new("Square"); Box.Visible = false; Box.Filled = false; Box.Thickness = 1.5
    local HealthOutline = Drawing.new("Square"); HealthOutline.Filled = true; local HealthBar = Drawing.new("Square"); HealthBar.Filled = true
    local H_HealthOutline = Drawing.new("Square"); H_HealthOutline.Filled = true; local H_HealthBar = Drawing.new("Square"); H_HealthBar.Filled = true
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
        if _G.ScriptAtivo and _G.EspEnabled and not _G.TempoExpirado and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") and Player ~= LocalPlayer then
            local Root = Player.Character.HumanoidRootPart; local Hum = Player.Character:FindFirstChildOfClass("Humanoid"); local Head = Player.Character:FindFirstChild("Head")
            if Hum and Hum.Health > 0 and Head then
                local RootPos, OnScreen = Camera:WorldToViewportPoint(Root.Position); local HeadPos = Camera:WorldToViewportPoint(Head.Position + Vector3.new(0, 0.5, 0)); local LegPos = Camera:WorldToViewportPoint(Root.Position - Vector3.new(0, 3, 0))
                local MyRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                local Distance = MyRoot and (Root.Position - MyRoot.Position).Magnitude or 0
                if OnScreen and Distance <= _G.MaxDistance then
                    local Height = math.abs(HeadPos.Y - LegPos.Y); local Width = Height * 0.55; local PosX = RootPos.X - Width / 2; local PosY = HeadPos.Y
                    Box.Visible = _G.EspBoxes; Box.Size = Vector2.new(Width, Height); Box.Position = Vector2.new(PosX, PosY); Box.Color = _G.BoxColor
                    HealthOutline.Visible = _G.EspHealthBar; HealthBar.Visible = _G.EspHealthBar
                    if _G.EspHealthBar then
                        local HealthPercent = Hum.Health / Hum.MaxHealth
                        HealthOutline.Size = Vector2.new(4, Height); HealthOutline.Position = Vector2.new(PosX - 6, PosY); HealthOutline.Color = Color3.new(0,0,0)
                        HealthBar.Size = Vector2.new(2, Height * HealthPercent); HealthBar.Position = Vector2.new(PosX - 5, PosY + (Height * (1 - HealthPercent))); HealthBar.Color = _G.HealthBarColor
                    end
                    H_HealthOutline.Visible = _G.EspHealthHorizontal; H_HealthBar.Visible = _G.EspHealthHorizontal
                    if _G.EspHealthHorizontal then
                        local HealthPercent = Hum.Health / Hum.MaxHealth
                        H_HealthOutline.Size = Vector2.new(Width, 4); H_HealthOutline.Position = Vector2.new(PosX, PosY - 8); H_HealthOutline.Color = Color3.new(0,0,0)
                        H_HealthBar.Size = Vector2.new(Width * HealthPercent, 2); H_HealthBar.Position = Vector2.new(PosX, PosY - 7); H_HealthBar.Color = _G.HealthBarColor
                    end
                    Tracer.Visible = _G.EspTracers
                    if _G.EspTracers then
                        Tracer.Color = _G.TracerColor; Tracer.To = Vector2.new(RootPos.X, RootPos.Y)
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
                        local High = Player.Character:FindFirstChild("EsternalVisual") or Instance.new("Highlight", Player.Character)
                        High.Name = "EsternalVisual"; High.FillTransparency = 0.8; High.OutlineColor = _G.ChamsColor; High.FillColor = _G.ChamsColor; High.Enabled = true
                    elseif Player.Character:FindFirstChild("EsternalVisual") then Player.Character.EsternalVisual.Enabled = false end
                else Box.Visible = false; HealthOutline.Visible = false; HealthBar.Visible = false; H_HealthOutline.Visible = false; H_HealthBar.Visible = false; Tracer.Visible = false; for _, v in pairs(Bones) do v.Visible = false end end
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
    else return Char:FindFirstChild(_G.TargetPart) end
end

local function GetClosestPlayer()
    local Target = nil; local Dist = _G.FovRadius
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
                        Target = v; Dist = Magnitude
                    end
                end
            end
        end
    end
    return Target
end

RunService.RenderStepped:Connect(function()
    if not _G.ScriptAtivo or _G.TempoExpirado then return end
    FovCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    if _G.AimbotEnabled then
        local Target = GetClosestPlayer()
        if Target and Target.Character then
            local Part = GetTargetPart(Target.Character)
            if Part then Camera.CFrame = CFrame.new(Camera.CFrame.Position, Part.Position) end
        end
    end
end)

SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)
SaveManager:IgnoreThemeSettings()
InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

Window:SelectTab(1)
Fluent:Notify({Title = "Esternal | Hubs", Content = "Global Sync Ativado!", Duration = 5})
-- [[ 👑 ESTERNAL | HUBS - PROFESSIONAL EDITION 👑 ]]
-- STATUS: GITHUB GLOBAL SYNC (Sincronizado via Servidor)
-- PROTEÇÃO: SESSÃO GLOBAL + AUTO-CANCELAMENTO + ANTI-BYPASS

-- [[ CONFIGURAÇÃO DO LINK DO GITHUB ]]
-- Substitua pelo link 'RAW' do seu arquivo timer.txt no GitHub
local LinkDoTempoGlobal = "https://raw.githubusercontent.com/SEU_USUARIO/SEU_REPOSITORIO/main/timer.txt"

-- [[ FUNÇÃO DE SINCRONIA DE TEMPO ]]
local function ObterTempoFinal()
    local sucesso, resultado = pcall(function()
        return game:HttpGet(LinkDoTempoGlobal)
    end)
    if sucesso and tonumber(resultado) then
        return tonumber(resultado)
    else
        -- Caso falhe a conexão, ele encerra por segurança
        return 0 
    end
end

local TempoFinalGlobal = ObterTempoFinal()

-- [[ 🛡️ SISTEMA ANTI-BULA & EXPIRAÇÃO GLOBAL ]]
if os.time() > TempoFinalGlobal or _G.TempoExpirado then 
    local MsgKick = "⚠️ 𝐄𝐒𝐓𝐄𝐑𝐍𝐀𝐋 | 𝐇𝐔𝐁𝐒 ⚠️\n\n❌ O script expirou globalmente no GitHub para todos os usuários!\n\n🔄 Aguarde a nova atualização para retornar. ⌛✨"
    game.Players.LocalPlayer:Kick(MsgKick)
    return 
end

if _G.EsternalLoaded then return end
_G.EsternalLoaded = true
_G.ScriptAtivo = true 
_G.TempoExpirado = false

-- [[ 📚 LIBS ORIGINAIS ]]
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

-- [[ 🛠️ FUNÇÃO DE CHECAGEM DE SEGURANÇA ]]
local function CheckAcesso()
    if _G.TempoExpirado then
        Fluent:Notify({Title = "SESSÃO EXPIRADA", Content = "As funções foram bloqueadas via GitHub.", Duration = 5})
        return false
    end
    return true
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

-- GLOBAIS DE CORES
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
    Title = "Esternal | Hubs",
    SubTitle = "Professional Global Edition",
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

-- 4. Home Content
local HomeSection = Tabs.Home:AddSection("Online Global Status")
local HomeParagraph = Tabs.Home:AddParagraph({
    Title = "Welcome, " .. LocalPlayer.DisplayName,
    Content = "Status: Online (Sincronizado)\nServer: GitHub Master\nVersion: 4.5.0 Final"
})

local TimerPara = Tabs.Home:AddParagraph({
    Title = "⏱️ Tempo Global Restante",
    Content = "Conectando ao GitHub..."
})

-- [[ LOOP DO TIMER GLOBAL SINCRONIZADO ]]
task.spawn(function()
    while _G.ScriptAtivo do
        local Agora = os.time()
        local Restante = TempoFinalGlobal - Agora
        
        if Restante <= 0 then 
            _G.ScriptAtivo = false
            _G.TempoExpirado = true 
            
            _G.AimbotEnabled = false
            _G.EspEnabled = false
            FovCircle.Visible = false
            
            HomeParagraph:SetTitle("📢 SESSÃO GLOBAL ENCERRADA")
            HomeParagraph:SetDesc("O script foi desativado via GitHub para todos.")
            TimerPara:SetDesc("Status: Expirado ❌")
            
            game.Players.LocalPlayer:Kick("⚠️ 𝐄𝐒𝐓𝐄𝐑𝐍𝐀𝐋 | 𝐇𝐔𝐁𝐒 ⚠️\n\nO tempo deste script acabou no GitHub!\n🔄 Pegue a nova versão no canal oficial.")
            break 
        end
        
        local h = math.floor(Restante / 3600)
        local m = math.floor((Restante % 3600) / 60)
        local s = math.floor(Restante % 60)
        
        TimerPara:SetDesc(string.format("Expira globalmente em: %02dh %02dm %02ds", h, m, s))
        task.wait(1)
    end
end)

-- (DAQUI PARA BAIXO O RESTANTE DO SEU CÓDIGO DE ESP E AIMBOT CONTINUA IGUAL)

-- [[ MOTOR DE ESP ]]
local function CreateESP(Player)
    local Box = Drawing.new("Square"); Box.Visible = false; Box.Filled = false; Box.Thickness = 1.5
    local HealthOutline = Drawing.new("Square"); HealthOutline.Filled = true; local HealthBar = Drawing.new("Square"); HealthBar.Filled = true
    local H_HealthOutline = Drawing.new("Square"); H_HealthOutline.Filled = true; local H_HealthBar = Drawing.new("Square"); H_HealthBar.Filled = true
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
        if _G.ScriptAtivo and _G.EspEnabled and not _G.TempoExpirado and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") and Player ~= LocalPlayer then
            local Root = Player.Character.HumanoidRootPart; local Hum = Player.Character:FindFirstChildOfClass("Humanoid"); local Head = Player.Character:FindFirstChild("Head")
            if Hum and Hum.Health > 0 and Head then
                local RootPos, OnScreen = Camera:WorldToViewportPoint(Root.Position); local HeadPos = Camera:WorldToViewportPoint(Head.Position + Vector3.new(0, 0.5, 0)); local LegPos = Camera:WorldToViewportPoint(Root.Position - Vector3.new(0, 3, 0))
                local MyRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                local Distance = MyRoot and (Root.Position - MyRoot.Position).Magnitude or 0
                if OnScreen and Distance <= _G.MaxDistance then
                    local Height = math.abs(HeadPos.Y - LegPos.Y); local Width = Height * 0.55; local PosX = RootPos.X - Width / 2; local PosY = HeadPos.Y
                    Box.Visible = _G.EspBoxes; Box.Size = Vector2.new(Width, Height); Box.Position = Vector2.new(PosX, PosY); Box.Color = _G.BoxColor
                    HealthOutline.Visible = _G.EspHealthBar; HealthBar.Visible = _G.EspHealthBar
                    if _G.EspHealthBar then
                        local HealthPercent = Hum.Health / Hum.MaxHealth
                        HealthOutline.Size = Vector2.new(4, Height); HealthOutline.Position = Vector2.new(PosX - 6, PosY); HealthOutline.Color = Color3.new(0,0,0)
                        HealthBar.Size = Vector2.new(2, Height * HealthPercent); HealthBar.Position = Vector2.new(PosX - 5, PosY + (Height * (1 - HealthPercent))); HealthBar.Color = _G.HealthBarColor
                    end
                    H_HealthOutline.Visible = _G.EspHealthHorizontal; H_HealthBar.Visible = _G.EspHealthHorizontal
                    if _G.EspHealthHorizontal then
                        local HealthPercent = Hum.Health / Hum.MaxHealth
                        H_HealthOutline.Size = Vector2.new(Width, 4); H_HealthOutline.Position = Vector2.new(PosX, PosY - 8); H_HealthOutline.Color = Color3.new(0,0,0)
                        H_HealthBar.Size = Vector2.new(Width * HealthPercent, 2); H_HealthBar.Position = Vector2.new(PosX, PosY - 7); H_HealthBar.Color = _G.HealthBarColor
                    end
                    Tracer.Visible = _G.EspTracers
                    if _G.EspTracers then
                        Tracer.Color = _G.TracerColor; Tracer.To = Vector2.new(RootPos.X, RootPos.Y)
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
                        local High = Player.Character:FindFirstChild("EsternalVisual") or Instance.new("Highlight", Player.Character)
                        High.Name = "EsternalVisual"; High.FillTransparency = 0.8; High.OutlineColor = _G.ChamsColor; High.FillColor = _G.ChamsColor; High.Enabled = true
                    elseif Player.Character:FindFirstChild("EsternalVisual") then Player.Character.EsternalVisual.Enabled = false end
                else Box.Visible = false; HealthOutline.Visible = false; HealthBar.Visible = false; H_HealthOutline.Visible = false; H_HealthBar.Visible = false; Tracer.Visible = false; for _, v in pairs(Bones) do v.Visible = false end end
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
    else return Char:FindFirstChild(_G.TargetPart) end
end

local function GetClosestPlayer()
    local Target = nil; local Dist = _G.FovRadius
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
                        Target = v; Dist = Magnitude
                    end
                end
            end
        end
    end
    return Target
end

RunService.RenderStepped:Connect(function()
    if not _G.ScriptAtivo or _G.TempoExpirado then return end
    FovCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    if _G.AimbotEnabled then
        local Target = GetClosestPlayer()
        if Target and Target.Character then
            local Part = GetTargetPart(Target.Character)
            if Part then Camera.CFrame = CFrame.new(Camera.CFrame.Position, Part.Position) end
        end
    end
end)

SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)
SaveManager:IgnoreThemeSettings()
InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

Window:SelectTab(1)
Fluent:Notify({Title = "Esternal | Hubs", Content = "Global Sync Ativado!", Duration = 5})
