--[[
    Walkfling: olz hub
    Cores: #770000 (OFF) | #770000 (ON)
]]

local player = game.Players.LocalPlayer
local runService = game:GetService("RunService")
local walkflinging = false
local minimized = false

-- --- INTERFACE DE CONTROLE ---
local sg = Instance.new("ScreenGui", player.PlayerGui)
sg.Name = "olz_fling_hub"
sg.ResetOnSpawn = false

local frame = Instance.new("Frame", sg)
frame.Size = UDim2.new(0, 180, 0, 120)
frame.Position = UDim2.new(0.8, 0, 0.5, 0)
frame.BackgroundColor3 = Color3.new(0, 0, 0)
frame.BorderSizePixel = 2
frame.BorderColor3 = Color3.fromHex("770000")
frame.Active = true
frame.Draggable = true

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(0.6, 0, 0, 30)
title.BackgroundTransparency = 1
title.Text = "coder: olz"
title.Font = Enum.Font.Code
title.TextSize = 16
title.TextColor3 = Color3.new(1, 1, 1)

-- Botão de Fechar (X) - Posicionado no canto direito
local closeBtn = Instance.new("TextButton", frame)
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -30, 0, 0)
closeBtn.BackgroundColor3 = Color3.fromHex("770000")
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.BorderSizePixel = 0
closeBtn.MouseButton1Click:Connect(function() sg:Destroy() end)

-- Botão de Minimizar (-) - Posicionado ao lado do fechar
local minBtn = Instance.new("TextButton", frame)
minBtn.Size = UDim2.new(0, 30, 0, 30)
minBtn.Position = UDim2.new(1, -60, 0, 0)
minBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
minBtn.Text = "-"
minBtn.TextColor3 = Color3.new(1, 1, 1)
minBtn.BorderSizePixel = 0

local container = Instance.new("Frame", frame)
container.Size = UDim2.new(1, 0, 1, -30)
container.Position = UDim2.new(0, 0, 0, 30)
container.BackgroundTransparency = 1

local flingBtn = Instance.new("TextButton", container)
flingBtn.Size = UDim2.new(0.9, 0, 0, 40)
flingBtn.Position = UDim2.new(0.05, 0, 0.3, 0)
flingBtn.BackgroundColor3 = Color3.fromHex("770000")
flingBtn.Text = "walkfling: off"
flingBtn.Font = Enum.Font.Code
flingBtn.TextSize = 14
flingBtn.TextColor3 = Color3.new(1, 1, 1)
flingBtn.BorderSizePixel = 0

-- --- FUNÇÕES AUXILIARES ---
local function getRoot(char)
    return char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso"))
end

-- --- LÓGICA DO FLING ---
local function runFling()
    task.spawn(function()
        while walkflinging do
            local character = player.Character
            local root = getRoot(character)
            
            if character and root then
                local vel = root.Velocity
                local movel = 0.1
                
                root.Velocity = vel * 10000 + Vector3.new(0, 10000, 0)

                runService.RenderStepped:Wait()
                if root and root.Parent then
                    root.Velocity = vel
                end

                runService.Stepped:Wait()
                if root and root.Parent then
                    root.Velocity = vel + Vector3.new(0, movel, 0)
                    movel = movel * -1
                end
            end
            runService.Heartbeat:Wait()
        end
    end)
end

-- --- EVENTOS ---
minBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    frame:TweenSize(minimized and UDim2.new(0, 180, 0, 30) or UDim2.new(0, 180, 0, 120))
    container.Visible = not minimized
    minBtn.Text = minimized and "+" or "-"
end)

flingBtn.MouseButton1Click:Connect(function()
    walkflinging = not walkflinging
    
    if walkflinging then
        flingBtn.Text = "walkfling: on"
        flingBtn.BackgroundColor3 = Color3.fromHex("770000")
        runFling()
    else
        flingBtn.Text = "walkfling: off"
        flingBtn.BackgroundColor3 = Color3.fromHex("770000")
        
        local root = getRoot(player.Character)
        if root then root.Velocity = Vector3.new(0,0,0) end
    end
end)

-- Loop RGB no Título
runService.RenderStepped:Connect(function()
    title.TextColor3 = Color3.fromHSV(tick() % 3 / 3, 1, 1)
end)

