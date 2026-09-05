--// EFFECT NUKE - DISABLE ONLY

local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")

local EFFECTS = {
	ParticleEmitter = true,
	Trail = true,
	Beam = true,
	Smoke = true,
	Fire = true,
	Sparkles = true,
}

local LIGHTS = {
	PointLight = true,
	SpotLight = true,
	SurfaceLight = true,
}

local function DisableEffect(obj)
	if EFFECTS[obj.ClassName] or LIGHTS[obj.ClassName] then
		pcall(function()
			obj.Enabled = false
		end)
	end
end

-- Tắt effect hiện có
for _, obj in ipairs(Workspace:GetDescendants()) do
	DisableEffect(obj)
end

for _, obj in ipairs(Lighting:GetDescendants()) do
	DisableEffect(obj)
end

-- Effect mới xuất hiện -> tắt ngay
Workspace.DescendantAdded:Connect(function(obj)
	task.defer(DisableEffect, obj)
end)

Lighting.DescendantAdded:Connect(function(obj)
	task.defer(DisableEffect, obj)
end)

print("☢️ EFFECT NUKE: DISABLED")
