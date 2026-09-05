local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")

-- POTATO MODE
local function optimize(obj)
	if obj:IsA("ParticleEmitter")
	or obj:IsA("Trail")
	or obj:IsA("Beam")
	or obj:IsA("Smoke")
	or obj:IsA("Fire")
	or obj:IsA("Sparkles") then
		obj.Enabled = false

	elseif obj:IsA("PointLight")
	or obj:IsA("SpotLight")
	or obj:IsA("SurfaceLight") then
		obj.Enabled = false

	elseif obj:IsA("PostEffect") then
		obj.Enabled = false
	end
end

-- Xử lý những thứ đang tồn tại
for _, obj in ipairs(Workspace:GetDescendants()) do
	optimize(obj)
end

for _, obj in ipairs(Lighting:GetDescendants()) do
	optimize(obj)
end

-- VFX spawn thêm sau này cũng bị tắt
Workspace.DescendantAdded:Connect(function(obj)
	task.defer(optimize, obj)
end)

Lighting.DescendantAdded:Connect(function(obj)
	task.defer(optimize, obj)
end)

-- Giảm một số tải rendering
Lighting.GlobalShadows = false
Lighting.FogEnd = 100000000000000000000000000

-- Terrain
local terrain = Workspace:FindFirstChildOfClass("Terrain")
if terrain then
	terrain.Decoration = false
end

-- Giảm chất lượng texture/mesh phía client
for _, obj in ipairs(Workspace:GetDescendants()) do
	if obj:IsA("Decal") or obj:IsA("Texture") then
		obj.Transparency = 0
	end
end

print("POTATO MODE: ON")
