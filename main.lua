--// EXTREME FPS BOOST v2
--// KEEP GUI + PLAYER + NPC + WALL
--// REMOVE MAP PROPS + VFX

local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

--------------------------------------------------
-- WALL KEYWORDS
--------------------------------------------------

local WALL_KEYWORDS = {
    "wall",
    "walls",
    "barrier",
    "boundary",
    "fence"
}

--------------------------------------------------
-- VFX
--------------------------------------------------

local VFX_CLASSES = {
    ParticleEmitter = true,
    Trail = true,
    Beam = true,
    Smoke = true,
    Fire = true,
    Sparkles = true,
    Explosion = true
}

--------------------------------------------------
-- CHECK NPC
--------------------------------------------------

local function IsNPC(obj)

    -- Nếu nằm trong Model có Humanoid
    local model = obj:FindFirstAncestorOfClass("Model")

    if model then
        local humanoid = model:FindFirstChildOfClass("Humanoid")

        if humanoid then
            return true
        end
    end

    return false
end

--------------------------------------------------
-- PROTECTED
--------------------------------------------------

local function Protected(obj)

    -- GUI
    if obj:IsDescendantOf(PlayerGui) then
        return true
    end

    -- Player
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr.Character and obj:IsDescendantOf(plr.Character) then
            return true
        end
    end

    -- NPC / Monster
    if IsNPC(obj) then
        return true
    end

    -- Camera
    if Workspace.CurrentCamera
        and obj:IsDescendantOf(Workspace.CurrentCamera) then
        return true
    end

    return false
end

--------------------------------------------------
-- WALL
--------------------------------------------------

local function IsWall(obj)

    local name = string.lower(obj.Name)

    for _, keyword in ipairs(WALL_KEYWORDS) do
        if string.find(name, keyword, 1, true) then
            return true
        end
    end

    return false
end

--------------------------------------------------
-- PROCESS
--------------------------------------------------

local function Process(obj)

    if Protected(obj) then
        return
    end

    -- VFX
    if VFX_CLASSES[obj.ClassName] then

        pcall(function()
            obj.Enabled = false
        end)

        if obj:IsA("Explosion") then
            pcall(function()
                obj.BlastPressure = 0
                obj.BlastRadius = 0
            end)
        end

        return
    end

    -- Wall
    if IsWall(obj) then
        return
    end

    -- Map geometry
    if obj:IsA("BasePart") then

        pcall(function()
            obj.LocalTransparencyModifier = 1
            obj.CastShadow = false
        end)

        return
    end

    -- Texture
    if obj:IsA("Decal")
        or obj:IsA("Texture")
        or obj:IsA("SurfaceAppearance") then

        pcall(function()
            obj.Transparency = 1
        end)

    end
end

--------------------------------------------------
-- INITIAL MAP CLEAN
--------------------------------------------------

for _, obj in ipairs(Workspace:GetDescendants()) do
    pcall(Process, obj)
end

--------------------------------------------------
-- NEW OBJECTS
--------------------------------------------------

Workspace.DescendantAdded:Connect(function(obj)

    -- Không bao giờ xử lý GUI
    if obj:IsDescendantOf(PlayerGui) then
        return
    end

    task.defer(function()
        pcall(Process, obj)
    end)

end)

print("[EXTREME FPS BOOST v2] GUI + PLAYER + NPC PROTECTED")
