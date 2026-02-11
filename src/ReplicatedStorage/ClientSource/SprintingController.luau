local SprintController = {}
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer
local connections = {}
local running = false
local humanoid
local animator
local runningTrack
local normalSpeed = 18
local sprintSpeed = 26

-- ===== CORE =====
local function startSprint()
	if running then
		return
	end
	running = true
	if humanoid and humanoid.MoveDirection.Magnitude > 0 then
		humanoid.WalkSpeed = sprintSpeed
		if runningTrack and not runningTrack.IsPlaying then
			runningTrack:Play()
		end
	end
end

local function stopSprint()
	if not running then
		return
	end
	running = false
	if humanoid then
		humanoid.WalkSpeed = normalSpeed
	end
	if runningTrack and runningTrack.IsPlaying then
		runningTrack:Stop()
	end
end

-- ===== PUBLIC API =====
function SprintController.Start(config)
	config = config or {}
	local character = player.Character or player.CharacterAdded:Wait()
	humanoid = character:WaitForChild("Humanoid")
	animator = humanoid:FindFirstChildOfClass("Animator")

	if not animator then
		animator = Instance.new("Animator")
		animator.Parent = humanoid
	end

	normalSpeed = config.WalkSpeed or normalSpeed
	sprintSpeed = config.SprintSpeed or sprintSpeed

	runningTrack = animator:LoadAnimation(ReplicatedStorage.Animations.Running)
	runningTrack.Looped = true
	runningTrack.Priority = Enum.AnimationPriority.Action4

	-- ===== PC (teclado) =====
	connections.InputBegan = UserInputService.InputBegan:Connect(function(input, gp)
		if gp then
			return
		end
		if input.KeyCode == Enum.KeyCode.LeftShift or input.KeyCode == Enum.KeyCode.RightShift then
			startSprint()
		end
	end)

	connections.InputEnded = UserInputService.InputEnded:Connect(function(input)
		if input.KeyCode == Enum.KeyCode.LeftShift or input.KeyCode == Enum.KeyCode.RightShift then
			stopSprint()
		end
	end)
end

-- Funções públicas para botões
function SprintController.StartSprint()
	startSprint()
end

function SprintController.StopSprint()
	stopSprint()
end

function SprintController.Stop()
	for _, conn in pairs(connections) do
		conn:Disconnect()
	end
	connections = {}
	stopSprint()
end

return SprintController
